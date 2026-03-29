import 'cart_item.dart';
import 'customer_info.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final DateTime orderDate;
  final String status; // pending, confirmed, shipped, delivered, cancelled
  final double totalAmount;
  final CustomerInfo? customerInfo;
  final double commission; // Commission to abi bro (₹50 per order)

  Order({
    required this.id,
    required this.items,
    required this.orderDate,
    this.status = 'pending',
    required this.totalAmount,
    this.customerInfo,
    this.commission = 50.0,
  });

  factory Order.fromCartItems({
    required String id,
    required List<CartItem> items,
    CustomerInfo? customerInfo,
  }) {
    double total = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    return Order(
      id: id,
      items: items,
      orderDate: DateTime.now(),
      totalAmount: total,
      customerInfo: customerInfo,
      commission: 50.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items
          .map(
            (item) => {
              'productId': item.product.id,
              'productName': item.product.name,
              'quantity': item.quantity,
              'size': item.selectedSize,
              'price': item.product.price,
              'totalPrice': item.totalPrice,
            },
          )
          .toList(),
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'totalAmount': totalAmount,
      'customerInfo': customerInfo != null
          ? {
              'name': customerInfo!.name,
              'address': customerInfo!.address,
              'city': customerInfo!.city,
              'district': customerInfo!.district,
              'state': customerInfo!.state,
              'pincode': customerInfo!.pincode,
              'contactNo': customerInfo!.contactNo,
              'courierService': customerInfo!.courierService,
            }
          : null,
      'commission': commission,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    // Note: This is a simplified version. For full implementation, you'd need to reconstruct CartItems
    return Order(
      id: json['id'] as String,
      items: [], // Would need to reconstruct from product IDs
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String? ?? 'pending',
      totalAmount: (json['totalAmount'] as num).toDouble(),
      commission: (json['commission'] as num?)?.toDouble() ?? 50.0,
    );
  }

  Order copyWith({
    String? id,
    List<CartItem>? items,
    DateTime? orderDate,
    String? status,
    double? totalAmount,
    CustomerInfo? customerInfo,
    double? commission,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      customerInfo: customerInfo ?? this.customerInfo,
      commission: commission ?? this.commission,
    );
  }
}
