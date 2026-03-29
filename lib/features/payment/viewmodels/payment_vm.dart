import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:e/core/constants/app_constants.dart';
import '../../orders/models/order_model.dart';
import '../services/payment_api.dart';

class PaymentViewModel extends ChangeNotifier {
  PaymentViewModel({
    required GlobalKey<NavigatorState> navigatorKey,
    required PaymentApi paymentApi,
  }) : _navigatorKey = navigatorKey,
       _paymentApi = paymentApi;

  final GlobalKey<NavigatorState> _navigatorKey;
  final PaymentApi _paymentApi;

  String _gpayNumber = Constants.gpayNumber;
  String _phonepeNumber = Constants.phonepeNumber;
  String _whatsappNumber = Constants.whatsappNumber;
  String _orderWhatsAppNumber = Constants.orderWhatsAppNumber;
  bool _isLoading = false;
  String? _error;
  OrderModel? _currentOrder;

  String get gpayNumber => _gpayNumber;
  String get phonepeNumber => _phonepeNumber;
  String get whatsappNumber => _whatsappNumber;
  String get orderWhatsAppNumber => _orderWhatsAppNumber;
  bool get isLoading => _isLoading;
  String? get error => _error;
  OrderModel? get currentOrder => _currentOrder;

  void setOrder(OrderModel? order) {
    _currentOrder = order;
    notifyListeners();
  }

  void goBack() {
    _navigatorKey.currentState?.pop();
  }

  /// Finalize payment: Send WhatsApp message and navigate to confirmation
  Future<void> confirmPayment() async {
    if (_currentOrder == null) {
      goBack();
      return;
    }

    final order = _currentOrder!;
    final message = _buildWhatsAppMessage(order);
    final whatsappUrl =
        'https://wa.me/$_orderWhatsAppNumber?text=${Uri.encodeComponent(message)}';

    try {
      final uri = Uri.tryParse(whatsappUrl);
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      // Ignore launch errors, proceed to confirmation
    }

    // Navigate to confirmation page
    _navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/order-confirmation',
      (route) => route.settings.name == '/home',
      arguments: order.id,
    );
  }

  String _buildWhatsAppMessage(OrderModel order) {
    final buffer = StringBuffer();
    final safeId = order.id.length > 6
        ? order.id.substring(order.id.length - 6).toUpperCase()
        : order.id.toUpperCase();

    buffer.writeln('\nNEW ORDER RECEIVED');
    buffer.writeln('Westergram Fashion Store');
    buffer.writeln('--------------------------------');
    buffer.writeln('Order ID: #$safeId\n');

    if (order.customerInfo != null) {
      final ci = order.customerInfo!;
      buffer.writeln('Customer Details');
      buffer.writeln('* Name: ${ci.name}');
      buffer.writeln('* Mobile: ${ci.contactNo}');
      buffer.writeln('* Address: ${ci.address}');
      buffer.writeln('* City: ${ci.city}');
      buffer.writeln('* District: ${ci.district}');
      buffer.writeln('* State: ${ci.state}');
      buffer.writeln('* Pincode: ${ci.pincode}');
      buffer.writeln('* Courier: ${ci.courierService.toUpperCase()}');
    }

    buffer.writeln('\n--------------------------------');
    buffer.writeln('ITEMS ORDERED');

    for (var i = 0; i < order.items.length; i++) {
      final item = order.items[i];
      final color = item.selectedColor ?? "N/A";
      buffer.writeln(
        '${i + 1}. ${item.product.name} | Color: $color | Size: ${item.selectedSize} | Qty: ${item.quantity} | ₹${item.totalPrice.toInt()}',
      );
    }

    buffer.writeln('--------------------------------');
    buffer.writeln('Total Amount: ₹${order.totalAmount.toInt()}\n');
    buffer.writeln('Payment Options');
    buffer.writeln('Google Pay: $_gpayNumber');
    buffer.writeln('PhonePe: $_phonepeNumber');
    buffer.writeln('\nSend payment screenshot here to confirm order.');
    buffer.writeln('Thank you for shopping with Westergram');

    return buffer.toString();
  }

  /// Load payment info from API. Call when PaymentPage opens.
  Future<void> loadPaymentInfo() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final info = await _paymentApi.getPaymentInfo();
      _gpayNumber = info.gpayNumber.isNotEmpty
          ? info.gpayNumber
          : Constants.gpayNumber;
      _phonepeNumber = info.phonepeNumber.isNotEmpty
          ? info.phonepeNumber
          : Constants.phonepeNumber;
      _whatsappNumber = info.whatsappNumber.isNotEmpty
          ? info.whatsappNumber
          : Constants.whatsappNumber;
      _orderWhatsAppNumber = info.orderWhatsAppNumber.isNotEmpty
          ? info.orderWhatsAppNumber
          : Constants.orderWhatsAppNumber;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
