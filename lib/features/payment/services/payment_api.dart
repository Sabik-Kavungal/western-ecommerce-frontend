// Payment API: GET /payment/info. Public. Returns GPay, PhonePe, WhatsApp numbers.

import 'package:e/core/api/api_exception.dart';
import 'package:e/core/api/api_service.dart';

import '../../auth/services/auth_api.dart' show AuthApiException;

class PaymentInfo {
  PaymentInfo({
    required this.gpayNumber,
    required this.phonepeNumber,
    required this.whatsappNumber,
    required this.orderWhatsAppNumber,
  });
  final String gpayNumber;
  final String phonepeNumber;
  final String whatsappNumber;
  final String orderWhatsAppNumber;

  factory PaymentInfo.fromJson(Map<String, dynamic> j) => PaymentInfo(
    gpayNumber: j['gpayNumber'] as String? ?? '',
    phonepeNumber: j['phonepeNumber'] as String? ?? '',
    whatsappNumber: j['whatsappNumber'] as String? ?? '',
    orderWhatsAppNumber: j['orderWhatsAppNumber'] as String? ?? '',
  );
}

class PaymentApi {
  PaymentApi({required ApiService apiService}) : _api = apiService;
  final ApiService _api;

  /// GET /payment/info. Public, no auth.
  Future<PaymentInfo> getPaymentInfo() async {
    try {
      final decoded = await _api.request('/payment/info', method: 'GET');
      final data = (decoded as Map?)?['data'] as Map<String, dynamic>?;
      if (data == null)
        throw AuthApiException(
          statusCode: 0,
          message: 'No data',
          code: null,
          details: null,
        );
      return PaymentInfo.fromJson(data);
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
