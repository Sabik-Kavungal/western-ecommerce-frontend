// Business Admin API: upload, products CRUD, orders CRUD, analytics.
// Uses ApiService. All methods require [token]. Throws ApiException.

import 'package:e/core/api/api_exception.dart';
import 'package:e/core/api/api_service.dart';
import 'package:e/core/constants/app_constants.dart';

import '../../products/models/product_model.dart';
import '../models/api_order_model.dart';
import '../models/analytics_models.dart';
import '../models/category_model.dart';

class AdminApi {
  AdminApi({required ApiService apiService}) : _api = apiService;
  final ApiService _api;

  /// Resolve image path to full URL for display.
  static String imageUrl(dynamic path) {
    if (path == null) return '';
    String p = path.toString().trim();

    // Handle nested format if backend returns objects instead of strings
    if (p.startsWith('{url:')) {
      final match = RegExp(r"url:\s*([^}\s]+)").firstMatch(p);
      if (match != null) p = match.group(1)!;
    }

    if (p.isEmpty) return '';
    if (p.startsWith('http')) return p;
    return '${Constants.apiOrigin}$p';
  }

  // ----- Upload -----
  /// POST /upload/images. [files] as MultipartFileDesc. Returns data.urls as List<String>.
  Future<List<String>> uploadImages(
    List<MultipartFileDesc> files,
    String token,
  ) async {
    final List<String> allUrls = [];
    // UPLOAD ONE-BY-ONE FOR STABILITY (Fixed 20+ image issue)
    for (var i = 0; i < files.length; i++) {
      final res = await _api.uploadMultipart(
        '/upload/images',
        files: [files[i]], // Send only ONE image at a time
        token: token,
      );
      final map = res as Map<String, dynamic>?;
      final data = map?['data'] as Map<String, dynamic>?;
      final urls = data?['urls'] as List<dynamic>?;
      if (urls != null && urls.isNotEmpty) {
        allUrls.add(urls.first.toString());
      }
    }
    return allUrls;
  }

  // ----- Products -----
  static List<String> _parseImages(dynamic raw) {
    if (raw == null) return [];
    if (raw is! List) return [];
    return raw
        .map((e) {
          if (e is String) return e;
          if (e is Map && e['url'] != null) return e['url'] as String;
          return '';
        })
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static Map<String, dynamic> _productMap(dynamic d) {
    if (d is! Map) return {};
    final m = Map<String, dynamic>.from(d);

    // 1. Remap _id to id if needed (Common for MongoDB backends)
    if (m['id'] == null && m['_id'] != null) {
      m['id'] = m['_id'].toString();
    }

    // 2. Ensure required String fields are never null (avoids TypeError: Null is not subtype of String)
    m['id'] = m['id']?.toString() ?? '';
    m['name'] = m['name']?.toString() ?? 'Unnamed Product';
    m['description'] = m['description']?.toString() ?? '';

    // 3. Robust Image Normalization
    m['images'] = _parseImages(m['images']);
    if (m['image'] != null) {
      m['image'] = imageUrl(m['image']);
    }

    // 4. Normalize Visibility Fields (isActive/is_active)
    if (m['isActive'] == null && m['is_active'] != null) {
      m['isActive'] = m['is_active'];
    }
    m['status'] = m['status']?.toString() ?? 'Available';
    m['isAvailable'] = m['isAvailable'] == true;
    m['isActive'] = m['isActive'] ?? true;
    m['isSoldOut'] = m['status'] == 'Sold Out' || m['isSoldOut'] == true;

    // 5. Handle variants (Group flat variants by color if needed)
    if (m['variants'] is List) {
      final List rawVariants = m['variants'];

      // Check if this is a flat list or already grouped
      bool isFlat =
          rawVariants.isNotEmpty &&
          rawVariants.first is Map &&
          !(rawVariants.first as Map).containsKey('sizes') &&
          (rawVariants.first as Map).containsKey('color');

      if (isFlat) {
        // Group by color
        final Map<String, Map<String, dynamic>> grouped = {};
        for (final v in rawVariants) {
          if (v is! Map) continue;
          final vm = Map<String, dynamic>.from(v);
          final color = vm['color']?.toString() ?? 'Default';

          if (!grouped.containsKey(color)) {
            grouped[color] = {
              'id':
                  vm['parentId']?.toString() ??
                  vm['id']?.toString(), // Use parent/first id
              'color': color,
              'image': '',
              'images': <String>[],
              'sizes': <Map<String, dynamic>>[],
            };
          }

          final g = grouped[color]!;
          // If this variant has images and the group header doesn't yet, take them
          if ((g['images'] as List).isEmpty &&
              vm['images'] is List &&
              (vm['images'] as List).isNotEmpty) {
            g['images'] = (vm['images'] as List)
                .map((e) => imageUrl(e.toString()))
                .toList();
            g['image'] = g['images'].first;
          } else if (g['image'].toString().isEmpty && vm['image'] != null) {
            g['image'] = imageUrl(vm['image'].toString());
            if ((g['images'] as List).isEmpty) g['images'] = [g['image']];
          }

          // Add this variant as a size entry
          (grouped[color]!['sizes'] as List).add({
            'id': vm['id']?.toString() ?? '',
            'name': vm['name']?.toString() ?? '',
            'size': vm['size']?.toString() ?? 'Free Size',
            'price': (vm['price'] as num?)?.toDouble() ?? 0.0,
            'shopPrice': (vm['shopPrice'] as num?)?.toDouble() ?? 0.0,
            'websiteCommission':
                (vm['websiteCommission'] as num?)?.toDouble() ?? 0.0,
            'stock':
                (vm['stock'] as num?)?.toInt() ??
                (vm['quantity'] as num?)?.toInt() ??
                0,
            'status': vm['status']?.toString() ?? 'Available',
            'isAvailable': vm['isAvailable'] ?? true,
            'isActive': vm['isActive'] ?? true,
          });
        }
        m['variants'] = grouped.values.toList();
      } else {
        // Already grouped OR recursive (old style) - just normalize images and types
        m['variants'] = rawVariants.map((v) {
          if (v is Map) {
            final vm = Map<String, dynamic>.from(v);
            // Normalize ColorVariant
            if (vm['id'] == null && vm['_id'] != null)
              vm['id'] = vm['_id'].toString();

            // Normalize images
            if (vm['images'] is List) {
              vm['images'] = (vm['images'] as List)
                  .map((e) => imageUrl(e.toString()))
                  .toList();
              if (vm['image'] == null && (vm['images'] as List).isNotEmpty)
                vm['image'] = vm['images'].first;
            }
            if (vm['image'] != null && vm['image'].toString().isNotEmpty) {
              vm['image'] = imageUrl(vm['image'].toString());
            } else {
              vm['image'] = '';
            }
            vm['images'] = vm['images'] ?? [];

            if (vm.containsKey('sizes') && vm['sizes'] is List) {
              vm['sizes'] = (vm['sizes'] as List).map((s) {
                if (s is Map) {
                  final sc = Map<String, dynamic>.from(s);
                  if (sc['id'] == null && sc['_id'] != null)
                    sc['id'] = sc['_id'].toString();
                  if (sc['price'] != null)
                    sc['price'] = (sc['price'] as num).toDouble();
                  if (sc['shopPrice'] != null)
                    sc['shopPrice'] = (sc['shopPrice'] as num).toDouble();
                  if (sc['websiteCommission'] != null)
                    sc['websiteCommission'] = (sc['websiteCommission'] as num)
                        .toDouble();
                  sc['status'] = sc['status']?.toString() ?? 'Available';
                  sc['isAvailable'] = sc['isAvailable'] == true;
                  return sc;
                }
                return s;
              }).toList();
            }
            return vm;
          }
          return v;
        }).toList();
      }
    }

    // 5. Cast optional string fields safely to avoid type mismatch
    if (m['categoryId'] != null) m['categoryId'] = m['categoryId'].toString();
    if (m['categoryName'] != null) {
      m['categoryName'] = m['categoryName'].toString();
    }
    if (m['parentId'] != null) m['parentId'] = m['parentId'].toString();
    if (m['color'] != null) m['color'] = m['color'].toString();

    // Ensure price is double
    if (m['price'] != null) m['price'] = (m['price'] as num).toDouble();
    if (m['shopPrice'] != null)
      m['shopPrice'] = (m['shopPrice'] as num).toDouble();
    if (m['websiteCommission'] != null)
      m['websiteCommission'] = (m['websiteCommission'] as num).toDouble();

    // 6. Handle Boolean Availability/Stock fields
    m['isSoldOut'] = m['isSoldOut'] == true;
    m['isActive'] =
        m['is_active'] == true ||
        m['isActive'] == true; // Support both snake_case and camelCase

    // Logic: Final isAvailable in model is TRUE only if API explicitly says so
    m['isAvailable'] = m['isAvailable'] == true;

    return m;
  }

  static Map<String, dynamic> _categoryMap(dynamic d) {
    if (d is! Map) return {};
    final m = Map<String, dynamic>.from(d);
    if (m['id'] == null && m['_id'] != null) m['id'] = m['_id'].toString();
    m['id'] = m['id']?.toString() ?? '';
    m['name'] = m['name']?.toString() ?? 'Unnamed Category';

    // Dates must be valid Strings for DateTime.parse in fromJson
    m['createdAt'] =
        m['createdAt']?.toString() ?? DateTime.now().toIso8601String();
    m['updatedAt'] =
        m['updatedAt']?.toString() ?? DateTime.now().toIso8601String();
    return m;
  }

  /// GET /products. Returns list and pagination.
  Future<ProductsListResult> listProducts({
    required String token,
    int page = 1,
    int limit = 20,
    bool? featured,
    bool? available,
    String? color,
    String? search,
    String? categoryId,
  }) async {
    final q = <String>['page=$page', 'limit=$limit'];
    if (featured != null) q.add('featured=$featured');
    if (available != null) q.add('available=$available');
    if (color != null && color.isNotEmpty)
      q.add('color=${Uri.encodeComponent(color)}');
    if (search != null && search.isNotEmpty)
      q.add('search=${Uri.encodeComponent(search)}');
    if (categoryId != null && categoryId.isNotEmpty)
      q.add('categoryId=${Uri.encodeComponent(categoryId)}');
    final res = await _api.request(
      '/products?${q.join('&')}',
      method: 'GET',
      token: token,
    );
    final data = (res as Map?)?['data'] as Map?;
    final list =
        (data?['products'] as List?)
            ?.map((e) => ProductModel.fromJson(_productMap(e)))
            .toList() ??
        [];
    final pag = data?['pagination'] as Map?;
    return ProductsListResult(
      products: list,
      page: (pag?['page'] as num?)?.toInt() ?? 1,
      limit: (pag?['limit'] as num?)?.toInt() ?? 20,
      total: (pag?['total'] as num?)?.toInt() ?? 0,
      totalPages: (pag?['totalPages'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> asStringMap(Map map) => Map<String, dynamic>.from(map);

  /// GET /products/:id
  Future<ProductModel> getProduct(String id, String token) async {
    final res = await _api.request(
      '/products/$id',
      method: 'GET',
      token: token,
    );
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return ProductModel.fromJson(_productMap(data));
  }

  /// POST /products. [images] from upload.
  Future<ProductModel> createProduct({
    required String name,
    required String description,
    required List<String> images,
    required double price,
    double shopPrice = 0,
    double websiteCommission = 0,
    String? color,
    int? quantity,
    bool isFeatured = false,
    bool isAvailable = true,
    bool isActive = true,
    String? categoryId,
    List<Map<String, dynamic>>? variants,
    required String token,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'description': description,
      'images': images,
      'price': price,
      'shopPrice': shopPrice,
      'websiteCommission': websiteCommission,
      if (color != null) 'color': color,
      if (quantity != null) 'quantity': quantity,
      'isFeatured': isFeatured,
      'isAvailable': isAvailable,
      'isActive': isActive,
    };
    if (categoryId != null && categoryId.isNotEmpty) {
      body['categoryId'] = categoryId;
    }
    if (variants != null && variants.isNotEmpty) {
      body['variants'] = variants;
    }
    final res = await _api.request(
      '/products',
      method: 'POST',
      token: token,
      body: body,
    );
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return ProductModel.fromJson(_productMap(data));
  }

  /// Updates a product. Use method='PUT' for full edits and method='PATCH' for status toggles.
  Future<ProductModel> updateProduct(
    String id,
    Map<String, dynamic> body,
    String token, {
    String method = 'PUT',
  }) async {
    final res = await _api.request(
      '/products/$id',
      method: method,
      token: token,
      body: body,
    );
    final data = (res as Map?)?['data'] as Map?;
    print(data);
    if (data == null) throw _err('No data');
    return ProductModel.fromJson(_productMap(data));
  }

  /// DELETE /products/:id
  Future<dynamic> deleteProduct(String id, String token) async {
    return await _api.request('/products/$id', method: 'DELETE', token: token);
  }

  // ----- Orders -----
  /// GET /orders. Admin sees all.
  Future<OrdersListResult> listOrders({
    required String token,
    int page = 1,
    int limit = 20,
    String? status,
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    final q = <String>['page=$page', 'limit=$limit'];
    if (status != null && status.isNotEmpty) q.add('status=$status');
    if (startDate != null && startDate.isNotEmpty)
      q.add('startDate=$startDate');
    if (endDate != null && endDate.isNotEmpty) q.add('endDate=$endDate');
    if (search != null && search.isNotEmpty)
      q.add('search=${Uri.encodeComponent(search)}');
    final res = await _api.request(
      '/orders?${q.join('&')}',
      method: 'GET',
      token: token,
    );
    final data = (res as Map?)?['data'] as Map?;
    final list =
        (data?['orders'] as List?)
            ?.map((e) => ApiOrderModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final pag = data?['pagination'] as Map?;
    return OrdersListResult(
      orders: list,
      page: (pag?['page'] as num?)?.toInt() ?? 1,
      limit: (pag?['limit'] as num?)?.toInt() ?? 20,
      total: (pag?['total'] as num?)?.toInt() ?? 0,
      totalPages: (pag?['totalPages'] as num?)?.toInt() ?? 1,
    );
  }

  /// GET /orders/:id
  Future<ApiOrderModel> getOrder(String id, String token) async {
    final res = await _api.request('/orders/$id', method: 'GET', token: token);
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return ApiOrderModel.fromJson(asStringMap(data));
  }

  /// PUT /orders/:id/status. [status]: pending|confirmed|shipped|delivered|cancelled
  Future<ApiOrderModel> updateOrderStatus(
    String id,
    String status,
    String token,
  ) async {
    final res = await _api.request(
      '/orders/$id/status',
      method: 'PUT',
      token: token,
      body: {'status': status},
    );
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return ApiOrderModel.fromJson(asStringMap(data));
  }

  /// PUT /orders/:id/payment. paymentStatus: pending|verified|failed. paymentScreenshot optional.
  Future<ApiOrderModel> verifyPayment(
    String id,
    String paymentStatus, {
    String? paymentScreenshot,
    required String token,
  }) async {
    final body = <String, dynamic>{'paymentStatus': paymentStatus};
    if (paymentScreenshot != null && paymentScreenshot.isNotEmpty)
      body['paymentScreenshot'] = paymentScreenshot;
    final res = await _api.request(
      '/orders/$id/payment',
      method: 'PUT',
      token: token,
      body: body,
    );
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return ApiOrderModel.fromJson(asStringMap(data));
  }

  /// DELETE /orders/:id
  Future<void> deleteOrder(String id, String token) async {
    await _api.request('/orders/$id', method: 'DELETE', token: token);
  }

  // ----- Analytics -----
  Future<AnalyticsDashboard> getAnalyticsDashboard({
    String? startDate,
    String? endDate,
    required String token,
  }) async {
    final q = <String>[];
    if (startDate != null && startDate.isNotEmpty)
      q.add('startDate=$startDate');
    if (endDate != null && endDate.isNotEmpty) q.add('endDate=$endDate');
    final path = q.isEmpty
        ? '/analytics/dashboard'
        : '/analytics/dashboard?${q.join('&')}';
    final res = await _api.request(path, method: 'GET', token: token);
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return AnalyticsDashboard.fromJson(asStringMap(data));
  }

  Future<AnalyticsOrders> getAnalyticsOrders({
    String? startDate,
    String? endDate,
    required String token,
  }) async {
    final q = <String>[];
    if (startDate != null && startDate.isNotEmpty)
      q.add('startDate=$startDate');
    if (endDate != null && endDate.isNotEmpty) q.add('endDate=$endDate');
    final path = q.isEmpty
        ? '/analytics/orders'
        : '/analytics/orders?${q.join('&')}';
    final res = await _api.request(path, method: 'GET', token: token);
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return AnalyticsOrders.fromJson(asStringMap(data));
  }

  Future<AnalyticsProducts> getAnalyticsProducts({
    String? startDate,
    String? endDate,
    required String token,
  }) async {
    final q = <String>[];
    if (startDate != null && startDate.isNotEmpty)
      q.add('startDate=$startDate');
    if (endDate != null && endDate.isNotEmpty) q.add('endDate=$endDate');
    final path = q.isEmpty
        ? '/analytics/products'
        : '/analytics/products?${q.join('&')}';
    final res = await _api.request(path, method: 'GET', token: token);
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return AnalyticsProducts.fromJson(asStringMap(data));
  }

  ApiException _err(String m) =>
      ApiException(statusCode: 0, message: m, code: null, details: null);
}

// ----- Categories -----
extension CategoryApi on AdminApi {
  /// GET /categories. Returns list of all categories.
  Future<List<CategoryModel>> listCategories({String? token}) async {
    final res = await _api.request('/categories', method: 'GET', token: token);
    final data = (res as Map?)?['data'] as Map?;
    final list =
        (data?['categories'] as List?)
            ?.map((e) => CategoryModel.fromJson(AdminApi._categoryMap(e)))
            .toList() ??
        [];
    return list;
  }

  /// GET /categories/:categoryId
  Future<CategoryModel> getCategory(String categoryId, {String? token}) async {
    final res = await _api.request(
      '/categories/$categoryId',
      method: 'GET',
      token: token,
    );
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return CategoryModel.fromJson(AdminApi._categoryMap(data));
  }

  /// POST /categories. Create category (admin only).
  Future<CategoryModel> createCategory({
    required String name,
    required String token,
  }) async {
    final res = await _api.request(
      '/categories',
      method: 'POST',
      token: token,
      body: {'name': name},
    );
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return CategoryModel.fromJson(AdminApi._categoryMap(data));
  }

  /// PUT /categories/:categoryId. Update category (admin only).
  Future<CategoryModel> updateCategory({
    required String categoryId,
    String? name,
    required String token,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    final res = await _api.request(
      '/categories/$categoryId',
      method: 'PUT',
      token: token,
      body: body,
    );
    final data = (res as Map?)?['data'] as Map?;
    if (data == null) throw _err('No data');
    return CategoryModel.fromJson(AdminApi._categoryMap(data));
  }

  /// DELETE /categories/:categoryId. Delete category (admin only).
  Future<void> deleteCategory(String categoryId, String token) async {
    await _api.request(
      '/categories/$categoryId',
      method: 'DELETE',
      token: token,
    );
  }
}

class ProductsListResult {
  ProductsListResult({
    required this.products,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
  final List<ProductModel> products;
  final int page, limit, total, totalPages;
}

class OrdersListResult {
  OrdersListResult({
    required this.orders,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
  final List<ApiOrderModel> orders;
  final int page, limit, total, totalPages;
}
