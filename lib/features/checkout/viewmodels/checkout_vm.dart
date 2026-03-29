// feature-first: Checkout ViewModel. Form state, validation, submit via OrderApi + WhatsApp URL.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/constants.dart';
import '../../orders/models/order_model.dart';

import '../models/customer_info_model.dart';
import '../../cart/models/cart_item_model.dart';
import '../../cart/viewmodels/cart_vm.dart';
import '../../orders/services/order_api.dart';
import '../../auth/viewmodels/auth_vm.dart';
import '../../auth/services/customer_api.dart';
import '../../auth/services/auth_api.dart' show AuthApiException;
import 'package:e/core/api/api_exception.dart';
import '../services/shipping_service.dart';

class CheckoutViewModel extends ChangeNotifier {
  CheckoutViewModel({
    required OrderApi orderApi,
    required CustomerApi customerApi,
    required CartViewModel cartVm,
    required AuthViewModel authVm,
    required GlobalKey<NavigatorState> navigatorKey,
  }) : _orderApi = orderApi,
       _customerApi = customerApi,
       _cartVm = cartVm,
       _authVm = authVm,
       _navigatorKey = navigatorKey;

  final OrderApi _orderApi;
  final CustomerApi _customerApi;
  final CartViewModel _cartVm;
  final AuthViewModel _authVm;
  final GlobalKey<NavigatorState> _navigatorKey;

  String _name = '';
  String _address = '';
  String _city = '';
  String _district = '';
  String _state = '';
  String _pincode = '';
  String _contactNo = '';
  String _selectedCourier = 'DTDC';
  bool _isSubmitting = false;
  String? _error;

  String get name => _name;
  String get address => _address;
  String get city => _city;
  String get district => _district;
  String get state => _state;
  String get pincode => _pincode;
  String get contactNo => _contactNo;
  String get selectedCourier => _selectedCourier;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  void updateName(String v) {
    _name = v;
    notifyListeners();
  }

  void updateAddress(String v) {
    _address = v;
    notifyListeners();
  }

  void updateCity(String v) {
    _city = v;
    notifyListeners();
  }

  void updateDistrict(String v) {
    _district = v;
    notifyListeners();
  }

  void updateState(String v) {
    _state = v;
    notifyListeners();
  }

  void updatePincode(String v) {
    _pincode = v;
    notifyListeners();
  }

  void updateContactNo(String v) {
    _contactNo = v;
    notifyListeners();
  }

  void updateCourier(String v) {
    _selectedCourier = v;
    notifyListeners();
  }

  /// Load saved address into form. Call when opening the form.
  Future<void> loadSavedAddress() async {
    final token = _authVm.token;
    if (token == null) return;
    try {
      final a = await _customerApi.getAddress(token);
      if (a != null) {
        _name = a.name;
        _address = a.address;
        _city = a.city;
        _district = a.district;
        _state = a.state;
        _pincode = a.pincode;
        _contactNo = a.contactNo;
        _selectedCourier = a.courierService;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> submitCheckout({
    List<CartItemModel>? cartItems,
    bool isSingleProduct = false,
    String? productId,
    String? productName,
    String? productColor,
    String? size,
    double? price,
    int? quantity,
  }) async {
    _error = null;
    final n = _name.trim(), a = _address.trim(), c = _city.trim();
    final d = _district.trim(),
        s = _state.trim(),
        p = _pincode.trim(),
        ph = _contactNo.trim();
    if (n.length < 2 || n.length > 100) {
      _error = 'Name must be 2–100 characters';
      notifyListeners();
      return;
    }
    if (a.isEmpty) {
      _error = 'Address is required';
      notifyListeners();
      return;
    }
    if (c.length < 2 || c.length > 50) {
      _error = 'City must be 2–50 characters';
      notifyListeners();
      return;
    }
    if (d.length < 2 || d.length > 50) {
      _error = 'District must be 2–50 characters';
      notifyListeners();
      return;
    }
    if (s.length < 2 || s.length > 50) {
      _error = 'State must be 2–50 characters';
      notifyListeners();
      return;
    }
    if (p.length != 6 || !RegExp(r'^\d+$').hasMatch(p)) {
      _error = 'Pincode must be 6 digits';
      notifyListeners();
      return;
    }
    if (ph.length != 10 || !RegExp(r'^\d+$').hasMatch(ph)) {
      _error = 'Contact must be 10 digits';
      notifyListeners();
      return;
    }

    final info = CustomerInfoModel(
      name: n,
      address: a,
      city: c,
      district: d,
      state: s,
      pincode: p,
      contactNo: ph,
      courierService: _selectedCourier,
    );

    final token = _authVm.token;
    if (token == null || token.isEmpty) {
      _error = 'Please sign in to place an order';
      notifyListeners();
      return;
    }

    List<Map<String, dynamic>> orderItems = [];
    if (isSingleProduct && productId != null) {
      orderItems = [
        {
          'productId': productId,
          'selectedSize': size ?? 'Free Size',
          'selectedColor': productColor,
          'quantity': quantity ?? 1,
        },
      ];
    } else if (cartItems != null && cartItems.isNotEmpty) {
      orderItems = cartItems
          .map(
            (i) => {
              'productId': i.product.id,
              'selectedSize': i.selectedSize,
              'selectedColor': i.selectedColor,
              'quantity': i.quantity,
            },
          )
          .toList();
    } else {
      _error = 'No items to order';
      notifyListeners();
      return;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      // Save address to API first to ensure latest address is stored
      await _customerApi.saveAddress(token, info);

      // Reload address from API to get the latest saved address
      final savedAddress = await _customerApi.getAddress(token);
      final finalInfo = savedAddress ?? info;

      final order = await _orderApi.createOrder(
        token,
        items: orderItems,
        customerInfo: finalInfo,
      );

      await _cartVm.loadCart();
      _isSubmitting = false;
      _error = null;
      notifyListeners();
      
      final String whatsappMessage = _buildWhatsAppMessage(order);
      final String whatsappUrl = 'https://wa.me/${Constants.orderWhatsAppNumber}?text=${Uri.encodeComponent(whatsappMessage)}';
      
      try {
        final uri = Uri.tryParse(whatsappUrl);
        if (uri != null) {
          // Changed to platformDefault for better mobile/iPhone browser compatibility
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } catch (_) {
        // Fallback for some browsers that might block the initial launch
      }

      _navigatorKey.currentState?.pushReplacementNamed(
        '/order-confirmation',
        arguments: order,
      );
    } catch (e) {
      if (e is AuthApiException) {
        _error = e.message;
      } else if (e is ApiException) {
        _error = e.message;
      } else {
        _error = e.toString();
      }
      _isSubmitting = false;
      notifyListeners();
    }
  }

  String _buildWhatsAppMessage(OrderModel order) {
    final buffer = StringBuffer();
    final safeId = order.id.length > 6
        ? order.id.substring(order.id.length - 6).toUpperCase()
        : order.id.toUpperCase();

    double shippingCharge = 0;
    String courierName = "N/A";
    if (order.customerInfo != null) {
      final ci = order.customerInfo!;
      final rates = ShippingService.getShippingOptions(ci.state, ci.city);
      shippingCharge = rates[ci.courierService] ?? 0;
      courierName = ci.courierService;
    }
    double totalOrderAmount = order.totalAmount + shippingCharge;

    buffer.writeln('\n*NEW ORDER RECEIVED*');
    buffer.writeln('Westergram Fashion Store');
    buffer.writeln('--------------------------------');
    buffer.writeln('Order ID: #$safeId\n');

    if (order.customerInfo != null) {
      final ci = order.customerInfo!;
      buffer.writeln('*Customer Details*');
      buffer.writeln('• Name: ${ci.name}');
      buffer.writeln('• Mobile: ${ci.contactNo}');
      buffer.writeln('• Address: ${ci.address}');
      buffer.writeln('• City: ${ci.city}');
      buffer.writeln('• District: ${ci.district}');
      buffer.writeln('• State: ${ci.state}');
      buffer.writeln('• Pincode: ${ci.pincode}');
      buffer.writeln('• Courier: ${courierName.toUpperCase()}');
    }

    buffer.writeln('\n--------------------------------');
    buffer.writeln('*ITEMS ORDERED*');

    for (var i = 0; i < order.items.length; i++) {
      final item = order.items[i];
      final color = item.selectedColor ?? "N/A";
      buffer.writeln('${i + 1}. ${item.product.name}');
      buffer.writeln('   Color: $color | Size: ${item.selectedSize} | Qty: ${item.quantity} | ₹${item.totalPrice.toInt()}');
    }

    buffer.writeln('--------------------------------');
    buffer.writeln('Subtotal: ₹${order.totalAmount.toInt()}');
    buffer.writeln('Shipping ($courierName): ₹${shippingCharge.toInt()}');
    buffer.writeln('Total Amount: *₹${totalOrderAmount.toInt()}*\n');
    
    buffer.writeln('*Payment Options*');
    buffer.writeln('• Google Pay: ${Constants.gpayNumber}');
    buffer.writeln('• PhonePe: ${Constants.phonepeNumber}');
    buffer.writeln('\n_Please send the payment screenshot here to confirm your order._');
    buffer.writeln('Thank you for shopping with Westergram');

    return buffer.toString();
  }
}
