// Cart API: GET/POST/PUT/DELETE /cart. Auth required. Uses [ApiService].

import 'package:e/core/api/api_exception.dart';
import 'package:e/core/api/api_service.dart';

import '../models/cart_item_model.dart';
import '../../products/models/product_model.dart';
import '../../auth/services/auth_api.dart' show AuthApiException;

ProductModel _productFromApi(Map<String, dynamic> j) {
  // Use a more robust mapping similar to AdminApi to handle common API variations
  final m = Map<String, dynamic>.from(j);

  if (m['id'] == null && m['_id'] != null) {
    m['id'] = m['_id'].toString();
  }
  m['id'] = m['id']?.toString() ?? '';
  m['name'] = m['name']?.toString() ?? 'Unnamed Product';
  m['description'] = m['description']?.toString() ?? '';

  // Images normalization
  if (m['images'] is List) {
    m['images'] = (m['images'] as List)
        .map((e) {
          if (e is Map && e['url'] != null) return e['url'].toString();
          if (e is String) return e;
          return '';
        })
        .where((s) => s.isNotEmpty)
        .toList();
  } else {
    m['images'] = <String>[];
  }

  // Price normalization
  m['price'] = (m['price'] as num?)?.toDouble() ?? 0.0;

  // Variant normalization
  if (m['variants'] is List) {
    m['variants'] = (m['variants'] as List)
        .map((v) {
          if (v is Map) {
            final vm = Map<String, dynamic>.from(v);
            if (vm.containsKey('sizes') && vm['sizes'] is List) {
              vm['sizes'] = (vm['sizes'] as List).map((s) {
                if (s is Map) {
                  final sc = Map<String, dynamic>.from(s);
                  if (sc['id'] == null && sc['_id'] != null)
                    sc['id'] = sc['_id'].toString();
                  if (sc['price'] != null)
                    sc['price'] = (sc['price'] as num).toDouble();
                  return sc;
                }
                return s;
              }).toList();
              return vm;
            }
          }
          return null; // Ignore incompatible variants in cart
        })
        .where((v) => v != null)
        .toList();
  }

  return ProductModel.fromJson(m);
}

/// Cart API. All methods require JWT.
class CartApi {
  CartApi({required ApiService apiService}) : _api = apiService;
  final ApiService _api;

  /// GET /cart. Returns { items, totalPrice, itemCount }.
  Future<CartResponse> getCart(String token) async {
    try {
      final decoded = await _api.request('/cart', method: 'GET', token: token);
      final map = decoded as Map<String, dynamic>?;
      if (map == null)
        return CartResponse(items: [], totalPrice: 0, itemCount: 0);

      final data = map['data'] as Map<String, dynamic>?;
      if (data == null)
        return CartResponse(items: [], totalPrice: 0, itemCount: 0);

      final rawItems = (data['items'] as List?) ?? [];
      final items = rawItems.map<CartItemWithId>((e) {
        final m = Map<String, dynamic>.from(e as Map);
        final prod = m['product'] as Map<String, dynamic>?;
        final product = prod != null
            ? _productFromApi(prod)
            : _productFromApi(m);
        final cm = CartItemModel(
          product: product,
          selectedSize: m['selectedSize'] as String? ?? 'Free Size',
          selectedColor: m['selectedColor'] as String?,
          quantity: (m['quantity'] as num?)?.toInt() ?? 1,
        );
        final id = (m['id'] ?? m['_id'] ?? '').toString();
        return CartItemWithId(id: id, item: cm);
      }).toList();
      final totalPrice = (data['totalPrice'] as num?)?.toDouble() ?? 0;
      final itemCount = (data['itemCount'] as num?)?.toInt() ?? items.length;
      return CartResponse(
        items: items,
        totalPrice: totalPrice.toDouble(),
        itemCount: itemCount,
      );
    } on ApiException catch (e) {
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  /// POST /cart/items. Body: { productId, selectedSize?, quantity }. Returns full CartResponse in data.
  Future<CartResponse> addItem(
    String token,
    String productId, {
    String selectedSize = 'Free Size',
    String? selectedColor,
    int quantity = 1,
  }) async {
    try {
      final body = <String, dynamic>{
        'productId': productId,
        'selectedSize': selectedSize,
        'quantity': quantity,
      };
      if (selectedColor != null) body['selectedColor'] = selectedColor;

      final decoded = await _api.request(
        '/cart/items',
        method: 'POST',
        token: token,
        body: body,
      );
      final data = (decoded as Map?)?['data'];
      if (data is! Map)
        return CartResponse(items: [], totalPrice: 0, itemCount: 0);
      return _parseCartData(Map<String, dynamic>.from(data));
    } on ApiException catch (e) {
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  /// PUT /cart/items/:itemId. Body: { quantity }.
  Future<CartResponse> updateItem(
    String token,
    String itemId,
    int quantity,
  ) async {
    try {
      final decoded = await _api.request(
        '/cart/items/$itemId',
        method: 'PUT',
        token: token,
        body: {'quantity': quantity},
      );
      final data = (decoded as Map?)?['data'];
      if (data is! Map)
        return CartResponse(items: [], totalPrice: 0, itemCount: 0);
      return _parseCartData(Map<String, dynamic>.from(data));
    } on ApiException catch (e) {
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  /// DELETE /cart/items/:itemId.
  Future<CartResponse> removeItem(String token, String itemId) async {
    try {
      final decoded = await _api.request(
        '/cart/items/$itemId',
        method: 'DELETE',
        token: token,
      );
      final data = (decoded as Map?)?['data'];
      if (data is! Map)
        return CartResponse(items: [], totalPrice: 0, itemCount: 0);
      return _parseCartData(Map<String, dynamic>.from(data));
    } on ApiException catch (e) {
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  /// DELETE /cart. Clear all.
  Future<void> clearCart(String token) async {
    try {
      await _api.request('/cart', method: 'DELETE', token: token);
    } on ApiException catch (e) {
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  CartResponse _parseCartData(Map<String, dynamic> data) {
    final rawItems = (data['items'] as List?) ?? [];
    final items = rawItems.map<CartItemWithId>((e) {
      final m = Map<String, dynamic>.from(e as Map);
      final prod = m['product'] as Map<String, dynamic>?;
      final product = prod != null ? _productFromApi(prod) : _productFromApi(m);
      final cm = CartItemModel(
        product: product,
        selectedSize: m['selectedSize'] as String? ?? 'Free Size',
        selectedColor: m['selectedColor'] as String?,
        quantity: (m['quantity'] as num?)?.toInt() ?? 1,
      );
      final id = (m['id'] ?? m['_id'] ?? '').toString();
      return CartItemWithId(id: id, item: cm);
    }).toList();
    final totalPrice = (data['totalPrice'] as num?)?.toDouble() ?? 0;
    final itemCount = (data['itemCount'] as num?)?.toInt() ?? items.length;
    return CartResponse(
      items: items,
      totalPrice: totalPrice.toDouble(),
      itemCount: itemCount,
    );
  }
}

class CartResponse {
  CartResponse({
    required this.items,
    required this.totalPrice,
    required this.itemCount,
  });
  final List<CartItemWithId> items;
  final double totalPrice;
  final int itemCount;
}
