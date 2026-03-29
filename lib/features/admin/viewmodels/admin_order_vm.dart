// Admin orders: list (API), get, update status, verify payment, delete.

import 'package:flutter/material.dart';

import 'package:e/core/api/api_exception.dart';

import '../models/api_order_model.dart';
import '../services/admin_api.dart';

class AdminOrderViewModel extends ChangeNotifier {
  AdminOrderViewModel({
    required AdminApi api,
    required String? Function() getToken,
  }) : _api = api,
       _getToken = getToken;

  final AdminApi _api;
  final String? Function() _getToken;

  List<ApiOrderModel> _orders = [];
  int _page = 1, _limit = 20, _total = 0, _totalPages = 1;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;
  ApiOrderModel? _selectedOrder;
  String _statusFilter = '';

  List<ApiOrderModel> get orders => _orders;
  int get page => _page;
  int get total => _total;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  ApiOrderModel? get selectedOrder => _selectedOrder;
  String get statusFilter => _statusFilter;

  Future<void> loadOrders({
    int? page,
    String? status,
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    final t = _getToken();
    if (t == null || t.isEmpty) {
      _error = 'Not logged in';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final r = await _api.listOrders(
        token: t,
        page: page ?? _page,
        limit: _limit,
        status: status ?? (_statusFilter.isEmpty ? null : _statusFilter),
        startDate: startDate,
        endDate: endDate,
        search: search,
      );
      _orders = r.orders;
      _page = r.page;
      _total = r.total;
      _totalPages = r.totalPages;
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadOrder(String id) async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _selectedOrder = await _api.getOrder(id, t);
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
      _selectedOrder = null;
    } catch (e) {
      _error = e.toString();
      _selectedOrder = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  void setStatusFilter(String v) {
    _statusFilter = v;
    notifyListeners();
  }

  void clearSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }

  Future<void> updateStatus(String orderId, String status) async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final updated = await _api.updateOrderStatus(orderId, status, t);
      final i = _orders.indexWhere((o) => o.id == orderId);
      if (i >= 0) _orders = [..._orders]..[i] = updated;
      if (_selectedOrder?.id == orderId) _selectedOrder = updated;
      _successMessage = 'Status updated';
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyPayment(
    String orderId,
    String paymentStatus, {
    String? paymentScreenshot,
  }) async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final updated = await _api.verifyPayment(
        orderId,
        paymentStatus,
        paymentScreenshot: paymentScreenshot,
        token: t,
      );
      final i = _orders.indexWhere((o) => o.id == orderId);
      if (i >= 0) _orders = [..._orders]..[i] = updated;
      if (_selectedOrder?.id == orderId) _selectedOrder = updated;
      _successMessage = 'Payment updated';
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteOrder(String orderId) async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;
    _isLoading = true;
    _error = null;
    if (_selectedOrder?.id == orderId) _selectedOrder = null;
    notifyListeners();
    try {
      await _api.deleteOrder(orderId, t);
      _orders = _orders.where((o) => o.id != orderId).toList();
      _total = (_total - 1).clamp(0, _total);
      _successMessage = 'Order deleted';
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }
}
