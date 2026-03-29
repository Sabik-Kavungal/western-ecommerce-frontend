// Customer Order API: POST /orders, GET /orders, GET /orders/:id, POST /orders/:id/whatsapp-message. Auth required.

import 'package:e/core/api/api_exception.dart';
import 'package:e/core/api/api_service.dart';

import '../../checkout/models/customer_info_model.dart';
import '../models/order_model.dart';
import '../../auth/services/auth_api.dart' show AuthApiException;

/// Customer Order API. All methods require JWT.
class OrderApi {
  OrderApi({required ApiService apiService}) : _api = apiService;
  final ApiService _api;

  /// POST /orders. items: [{ productId, selectedSize?, quantity }]. customerInfo optional (uses saved if omitted).
  /// Returns 201 { data: Order }.
  Future<OrderModel> createOrder(
    String token, {
    required List<Map<String, dynamic>> items,
    CustomerInfoModel? customerInfo,
  }) async {
    try {
      final body = <String, dynamic>{
        'items': items
            .map(
              (i) => {
                'productId': i['productId'],
                'selectedSize': i['selectedSize'] ?? 'Free Size',
                'selectedColor': i['selectedColor'],
                'quantity': i['quantity'],
              },
            )
            .toList(),
      };
      if (customerInfo != null) body['customerInfo'] = customerInfo.toJson();

      final decoded = await _api.request(
        '/orders',
        method: 'POST',
        token: token,
        body: body,
      );
      final data = (decoded as Map?)?['data'] as Map<String, dynamic>?;
      if (data == null)
        throw AuthApiException(
          statusCode: 0,
          message: 'No data',
          code: null,
          details: null,
        );
      return OrderModel.fromApiJson(data);
    } on ApiException catch (e) {
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  /// GET /orders?page=&limit=&status=&startDate=&endDate=
  Future<OrdersListResult> listOrders(
    String token, {
    int page = 1,
    int limit = 20,
    String? status,
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    try {
      final q = <String>['page=$page', 'limit=$limit'];
      if (status != null && status.isNotEmpty) q.add('status=$status');
      if (startDate != null) q.add('startDate=$startDate');
      if (endDate != null) q.add('endDate=$endDate');
      if (search != null && search.isNotEmpty)
        q.add('search=${Uri.encodeComponent(search)}');

      final decoded = await _api.request(
        '/orders?${q.join('&')}',
        method: 'GET',
        token: token,
      );
      final data = (decoded as Map?)?['data'] as Map<String, dynamic>?;
      if (data == null)
        return OrdersListResult(
          orders: [],
          page: 1,
          limit: 20,
          total: 0,
          totalPages: 0,
        );

      final raw = (data['orders'] as List?) ?? [];
      final orders = raw
          .map(
            (e) => OrderModel.fromApiJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
      final pg = (data['pagination'] as Map?);
      final pageNum = (pg?['page'] as num?)?.toInt() ?? 1;
      final limitNum = (pg?['limit'] as num?)?.toInt() ?? 20;
      final total = (pg?['total'] as num?)?.toInt() ?? 0;
      final totalPages = (pg?['totalPages'] as num?)?.toInt() ?? 0;
      return OrdersListResult(
        orders: orders,
        page: pageNum,
        limit: limitNum,
        total: total,
        totalPages: totalPages,
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

  /// GET /orders/:orderId
  Future<OrderModel> getOrder(String token, String orderId) async {
    try {
      final decoded = await _api.request(
        '/orders/$orderId',
        method: 'GET',
        token: token,
      );
      final data = (decoded as Map?)?['data'] as Map<String, dynamic>?;
      if (data == null)
        throw AuthApiException(
          statusCode: 0,
          message: 'No data',
          code: null,
          details: null,
        );
      return OrderModel.fromApiJson(data);
    } on ApiException catch (e) {
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  /// POST /orders/:orderId/whatsapp-message. Returns { message, whatsappUrl }.
  Future<WhatsAppMessageResult> getWhatsAppMessage(
    String token,
    String orderId,
  ) async {
    try {
      final decoded = await _api.request(
        '/orders/$orderId/whatsapp-message',
        method: 'POST',
        token: token,
      );
      final data = (decoded as Map?)?['data'] as Map<String, dynamic>?;
      if (data == null)
        throw AuthApiException(
          statusCode: 0,
          message: 'No data',
          code: null,
          details: null,
        );
      return WhatsAppMessageResult(
        message: data['message'] as String? ?? '',
        whatsappUrl: data['whatsappUrl'] as String? ?? '',
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
}

class OrdersListResult {
  OrdersListResult({
    required this.orders,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
  final List<OrderModel> orders;
  final int page, limit, total, totalPages;
}

class WhatsAppMessageResult {
  WhatsAppMessageResult({required this.message, required this.whatsappUrl});
  final String message;
  final String whatsappUrl;
}
