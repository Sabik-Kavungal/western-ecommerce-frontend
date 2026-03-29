// feature-first: WhatsApp launch for checkout. Uses CartItemModel and CustomerInfoModel.

import 'package:url_launcher/url_launcher.dart';

import '../models/customer_info_model.dart';
import '../../cart/models/cart_item_model.dart';
import '../../../utils/constants.dart';

class CheckoutWhatsApp {
  static Future<void> launchWithCustomerInfo({
    required List<CartItemModel> items,
    required CustomerInfoModel customerInfo,
    required String orderId,
  }) async {
    final msg = _messageCart(items, customerInfo, orderId);
    final url =
        'https://wa.me/${Constants.orderWhatsAppNumber}?text=${Uri.encodeComponent(msg)}';
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (e) {
      throw 'Could not launch WhatsApp: $e';
    }
  }

  static Future<void> launchForSingleProduct({
    required String productName,
    required String productId,
    required String size,
    required double price,
    required int quantity,
    required CustomerInfoModel customerInfo,
    required String orderId,
    String? productColor,
  }) async {
    final msg = _messageSingle(
      productName,
      productId,
      size,
      price,
      quantity,
      customerInfo,
      orderId,
      productColor,
    );
    final url =
        'https://wa.me/${Constants.orderWhatsAppNumber}?text=${Uri.encodeComponent(msg)}';
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (e) {
      throw 'Could not launch WhatsApp: $e';
    }
  }

  static String _messageCart(
    List<CartItemModel> items,
    CustomerInfoModel c,
    String orderId,
  ) {
    final b = StringBuffer();
    b.writeln('\nNEW ORDER RECEIVED');
    b.writeln('Westergram Fashion Store');
    b.writeln('--------------------------------');
    b.writeln('Order ID: #$orderId\n');

    b.writeln('Customer Details');
    b.writeln('* Name: ${c.name}');
    b.writeln('* Mobile: ${c.contactNo}');
    b.writeln('* Address: ${c.address}');
    b.writeln('* City: ${c.city}');
    b.writeln('* District: ${c.district}');
    b.writeln('* State: ${c.state}');
    b.writeln('* Pincode: ${c.pincode}');
    b.writeln('* Courier: ${c.courierService}\n');

    b.writeln('--------------------------------');
    b.writeln('ITEMS ORDERED');
    int count = 1;
    for (var i in items) {
      final color = i.product.color != 'Default' ? i.product.color : 'N/A';
      b.writeln(
        '$count. ${i.product.name} | Color: $color | Size: ${i.selectedSize} | Qty: ${i.quantity} | ₹${i.totalPrice.toStringAsFixed(0)}',
      );
      count++;
    }
    b.writeln('--------------------------------');

    final total = items.fold(0.0, (s, i) => s + i.totalPrice);
    b.writeln('Total Amount: ₹${total.toStringAsFixed(0)}\n');

    b.writeln('Payment Options');
    b.writeln('Google Pay: ${Constants.gpayNumber}');
    b.writeln('PhonePe: ${Constants.phonepeNumber}');

    b.writeln('\nSend payment screenshot here to confirm order.');
    b.writeln('Thank you for shopping with Westergram');
    return b.toString();
  }

  static String _messageSingle(
    String name,
    String id,
    String size,
    double price,
    int qty,
    CustomerInfoModel c,
    String orderId,
    String? color,
  ) {
    final b = StringBuffer();
    b.writeln('\nNEW ORDER RECEIVED');
    b.writeln('Westergram Fashion Store');
    b.writeln('--------------------------------');
    b.writeln('Order ID: #$orderId\n');

    b.writeln('Customer Details');
    b.writeln('* Name: ${c.name}');
    b.writeln('* Mobile: ${c.contactNo}');
    b.writeln('* Address: ${c.address}');
    b.writeln('* City: ${c.city}');
    b.writeln('* District: ${c.district}');
    b.writeln('* State: ${c.state}');
    b.writeln('* Pincode: ${c.pincode}');
    b.writeln('* Courier: ${c.courierService}\n');

    b.writeln('--------------------------------');
    b.writeln('ITEMS ORDERED');
    final clr = color != null && color != 'Default' ? color : 'N/A';
    b.writeln(
      '1. $name | Color: $clr | Size: $size | Qty: $qty | ₹${(price * qty).toStringAsFixed(0)}',
    );
    b.writeln('--------------------------------');

    b.writeln('Total Amount: ₹${(price * qty).toStringAsFixed(0)}\n');

    b.writeln('Payment Options');
    b.writeln('Google Pay: ${Constants.gpayNumber}');
    b.writeln('PhonePe: ${Constants.phonepeNumber}');

    b.writeln('\nSend payment screenshot here to confirm order.');
    b.writeln('Thank you for shopping with Westergram');
    return b.toString();
  }
}
