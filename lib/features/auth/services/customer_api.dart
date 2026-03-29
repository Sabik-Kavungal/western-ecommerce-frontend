// Customer API: GET/PUT /customers/me, GET/PUT /customers/me/address. Uses [ApiService].

import 'package:e/core/api/api_exception.dart';
import 'package:e/core/api/api_service.dart';

import '../../checkout/models/customer_info_model.dart';
import '../models/user_model.dart';
import 'auth_api.dart' show AuthApiException;

/// Customer API: profile and saved address. Uses Bearer token.
class CustomerApi {
  CustomerApi({required ApiService apiService}) : _api = apiService;
  final ApiService _api;

  /// GET /customers/me. Returns current user. Same as GET /auth/me.
  Future<UserModel> getMe(String token) async {
    try {
      final decoded = await _api.request(
        '/customers/me',
        method: 'GET',
        token: token,
      );
      final map = decoded as Map<String, dynamic>?;
      if (map == null)
        throw AuthApiException(
          statusCode: 0,
          message: 'No data',
          code: null,
          details: null,
        );

      final data = map['data'] as Map<String, dynamic>?;
      if (data == null)
        throw AuthApiException(
          statusCode: 0,
          message: 'No data',
          code: null,
          details: null,
        );

      return UserModel.fromJson(data);
    } on ApiException catch (e) {
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  /// PUT /customers/me. Update name and/or email. At least one required.
  Future<UserModel> updateProfile(
    String token, {
    String? name,
    String? email,
  }) async {
    if (name == null && email == null) {
      throw ArgumentError('At least one of name or email is required');
    }
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;

    try {
      final decoded = await _api.request(
        '/customers/me',
        method: 'PUT',
        token: token,
        body: body,
      );
      final map = decoded as Map<String, dynamic>?;
      if (map == null)
        throw AuthApiException(
          statusCode: 0,
          message: 'No data',
          code: null,
          details: null,
        );

      final data = map['data'] as Map<String, dynamic>?;
      if (data == null)
        throw AuthApiException(
          statusCode: 0,
          message: 'No data',
          code: null,
          details: null,
        );

      return UserModel.fromJson(data);
    } on ApiException catch (e) {
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  /// GET /customers/me/address. Returns saved address or null.
  Future<CustomerInfoModel?> getAddress(String token) async {
    try {
      final decoded = await _api.request(
        '/customers/me/address',
        method: 'GET',
        token: token,
      );
      final map = decoded as Map<String, dynamic>?;
      if (map == null) return null;

      final data = map['data'];
      if (data == null) return null;
      return CustomerInfoModel.fromJson(data as Map<String, dynamic>);
    } on ApiException catch (e) {
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  /// PUT /customers/me/address. Upsert saved address.
  Future<void> saveAddress(String token, CustomerInfoModel address) async {
    try {
      await _api.request(
        '/customers/me/address',
        method: 'PUT',
        token: token,
        body: address.toJson(),
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
