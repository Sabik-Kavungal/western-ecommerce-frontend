// feature-first: Order. Freezed, immutable. Depends on CartItemModel and CustomerInfoModel.

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cart/models/cart_item_model.dart';
import '../../checkout/models/customer_info_model.dart';
import '../../products/models/product_model.dart';

part 'gen/order_model.freezed.dart';
part 'gen/order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required List<CartItemModel> items,
    required DateTime orderDate,
    @Default('pending') String status,
    required double totalAmount,
    CustomerInfoModel? customerInfo,
    @Default(50.0) double commission,
  }) = _OrderModel;

  factory OrderModel.fromCartItems({
    required String id,
    required List<CartItemModel> items,
    CustomerInfoModel? customerInfo,
  }) {
    final total = items.fold(0.0, (sum, i) => sum + i.totalPrice);
    return OrderModel(
      id: id,
      items: items,
      orderDate: DateTime.now(),
      totalAmount: total,
      customerInfo: customerInfo,
      commission: 50.0,
    );
  }

  /// Parse from API: GET /orders, GET /orders/:id, POST /orders response (data).
  /// API items: { productId, productName, quantity, size, price, totalPrice, color }.
  factory OrderModel.fromApiJson(Map<String, dynamic> j) {
    final rawItems = (j['items'] as List?) ?? [];
    final items = rawItems.map<CartItemModel>((e) {
      final m = e as Map<String, dynamic>;
      final productId = m['productId'] as String? ?? '';
      final productName = m['productName'] as String? ?? '';
      final quantity = (m['quantity'] as num?)?.toInt() ?? 1;
      final size = m['size'] as String? ?? 'Free Size';
      final price = (m['price'] as num?)?.toDouble() ?? 0;
      final shopPrice = (m['shopPrice'] as num?)?.toDouble() ?? 0;
      final websiteCommission =
          (m['websiteCommission'] as num?)?.toDouble() ?? 0;
      final color = m['color'] as String? ?? '';
      final imageUrl = m['image'] as String? ?? '';
      final images = m['images'] != null
          ? List<String>.from(m['images'] as List)
          : <String>[];

      final p = ProductModel(
        id: productId,
        name: productName,
        description: '',
        image: imageUrl,
        images: images,
        price: price,
        shopPrice: shopPrice,
        websiteCommission: websiteCommission,
        color: color,
        quantity: 0,
        availableSizes: [size],
        isFeatured: false,
        isAvailable: true,
        parentId: m['parentId'] as String?,
      );
      return CartItemModel(
        product: p,
        selectedSize: size,
        selectedColor: color.isNotEmpty ? color : null,
        quantity: quantity,
      );
    }).toList();
    final raw = j['orderDate'];
    DateTime od = DateTime.now();
    if (raw is String) od = DateTime.tryParse(raw) ?? od;
    CustomerInfoModel? ci;
    final c = j['customerInfo'] as Map<String, dynamic>?;
    if (c != null) {
      try {
        ci = CustomerInfoModel.fromJson(c);
      } catch (_) {}
    }
    return OrderModel(
      id: j['id'] as String? ?? '',
      items: items,
      orderDate: od,
      status: j['status'] as String? ?? 'pending',
      totalAmount: (j['totalAmount'] as num?)?.toDouble() ?? 0,
      customerInfo: ci,
      commission: (j['commission'] as num?)?.toDouble() ?? 50,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
