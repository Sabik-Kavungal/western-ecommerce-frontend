// Admin analytics: dashboard, orders stats, products. Uses GET /analytics/...

import 'package:flutter/material.dart';

import 'package:e/core/api/api_exception.dart';

import '../models/analytics_models.dart';
import '../services/admin_api.dart';

class AdminAnalyticsViewModel extends ChangeNotifier {
  AdminAnalyticsViewModel({
    required AdminApi api,
    required String? Function() getToken,
  }) : _api = api,
       _getToken = getToken;

  final AdminApi _api;
  final String? Function() _getToken;

  AnalyticsDashboard? _dashboard;
  AnalyticsOrders? _orderStats;
  AnalyticsProducts? _productStats;
  bool _isLoading = false;
  String? _error;
  String? _startDate;
  String? _endDate;

  AnalyticsDashboard? get dashboard => _dashboard;
  AnalyticsOrders? get orderStats => _orderStats;
  AnalyticsProducts? get productStats => _productStats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get startDate => _startDate;
  String? get endDate => _endDate;

  void setDateRange(String? start, String? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  Future<void> loadDashboard() async {
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
      _dashboard = await _api.getAnalyticsDashboard(
        startDate: _startDate,
        endDate: _endDate,
        token: t,
      );
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadOrderStats() async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _orderStats = await _api.getAnalyticsOrders(
        startDate: _startDate,
        endDate: _endDate,
        token: t,
      );
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadProductStats() async {
    final t = _getToken();
    if (t == null || t.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _productStats = await _api.getAnalyticsProducts(
        startDate: _startDate,
        endDate: _endDate,
        token: t,
      );
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
