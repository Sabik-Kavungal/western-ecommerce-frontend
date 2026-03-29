// feature-first: Order ViewModel. loadOrders from OrderApi (customer). Keeps createOrderFromCart for legacy.

import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_api.dart';
import '../../auth/viewmodels/auth_vm.dart';
import '../../cart/models/cart_item_model.dart';
import '../../checkout/models/customer_info_model.dart';

class OrderViewModel extends ChangeNotifier {
  OrderViewModel({OrderApi? orderApi, AuthViewModel? authVm})
    : _orderApi = orderApi,
      _authVm = authVm;

  final OrderApi? _orderApi;
  final AuthViewModel? _authVm;

  final List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<OrderModel> getOrdersByStatus(String status) =>
      _orders.where((o) => o.status == status).toList();

  List<OrderModel> getTodayOrders() {
    final t = DateTime.now();
    return _orders
        .where(
          (o) =>
              o.orderDate.year == t.year &&
              o.orderDate.month == t.month &&
              o.orderDate.day == t.day,
        )
        .toList();
  }

  List<OrderModel> getThisMonthOrders() {
    final n = DateTime.now();
    return _orders
        .where(
          (o) => o.orderDate.year == n.year && o.orderDate.month == n.month,
        )
        .toList();
  }

  double get totalRevenue => _orders.fold(0.0, (s, o) => s + o.totalAmount);
  double get totalCommission => _orders.fold(0.0, (s, o) => s + o.commission);
  double get netProfit => totalRevenue - totalCommission;
  double get todayRevenue =>
      getTodayOrders().fold(0.0, (s, o) => s + o.totalAmount);
  double get thisMonthRevenue =>
      getThisMonthOrders().fold(0.0, (s, o) => s + o.totalAmount);
  int get totalOrdersCount => _orders.length;
  int get pendingOrdersCount => getOrdersByStatus('pending').length;

  void addOrder(OrderModel o) {
    _orders.insert(0, o);
    notifyListeners();
  }

  String _generateOrderId() {
    final n = DateTime.now().millisecondsSinceEpoch % 10000;
    return 'WG${n.toString().padLeft(4, '0')}';
  }

  String createOrderFromCart({
    required List<CartItemModel> items,
    CustomerInfoModel? customerInfo,
  }) {
    final id = _generateOrderId();
    final order = OrderModel.fromCartItems(
      id: id,
      items: items,
      customerInfo: customerInfo,
    );
    addOrder(order);
    return id;
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final i = _orders.indexWhere((o) => o.id == orderId);
    if (i >= 0) {
      _orders[i] = _orders[i].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void deleteOrder(String orderId) {
    _orders.removeWhere((o) => o.id == orderId);
    notifyListeners();
  }

  String _selectedOrderFilter = 'all';
  String get selectedOrderFilter => _selectedOrderFilter;
  void updateOrderFilter(String v) {
    _selectedOrderFilter = v;
    notifyListeners();
  }

  List<OrderModel> get filteredOrders => _selectedOrderFilter == 'all'
      ? _orders
      : getOrdersByStatus(_selectedOrderFilter);

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Load orders from API (GET /orders). Customer: own orders only.
  Future<void> loadOrders({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    if (_orderApi == null || _authVm == null) return;
    final token = _authVm!.token;
    if (token == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _orderApi!.listOrders(
        token,
        page: page,
        limit: limit,
        status: status,
      );
      _orders.clear();
      _orders.addAll(res.orders);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Fetch single order from API. Use when not in list (e.g. deep link).
  Future<OrderModel?> fetchOrderById(String id) async {
    if (_orderApi == null || _authVm == null) return null;
    final token = _authVm!.token;
    if (token == null) return null;
    try {
      return await _orderApi!.getOrder(token, id);
    } catch (_) {
      return null;
    }
  }

  Map<String, int> getPopularProducts() {
    final m = <String, int>{};
    for (var o in _orders) {
      for (var i in o.items) {
        m[i.product.name] = (m[i.product.name] ?? 0) + i.quantity;
      }
    }
    return m;
  }

  List<MapEntry<String, int>> getTopSellingProducts({int limit = 5}) {
    final entries = getPopularProducts().entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }
}
