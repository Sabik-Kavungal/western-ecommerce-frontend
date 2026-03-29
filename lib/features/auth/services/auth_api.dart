// feature-first auth: API layer. Uses [ApiService]. UI/ViewModel must NOT call services directly.

import 'package:e/core/api/api_exception.dart';
import 'package:e/core/api/api_service.dart';

import '../models/token_model.dart';
import '../models/user_model.dart';

/// Result of POST /auth/login. Immutable.
class AuthLoginResult {
  const AuthLoginResult({required this.user, required this.tokenModel});
  final UserModel user;
  final TokenModel tokenModel;
}

/// Auth API: register, login, getMe, logout. Matches backend (Go + Kong).
class AuthApi {
  AuthApi({required ApiService apiService}) : _api = apiService;
  final ApiService _api;

  /// POST /auth/register. Request: { name, phone, password, email? }. Response: 201, { success, data: { user, token, expiresIn } }
  /// Throws [AuthApiException] on non-2xx or parse error. 409 with [ALREADY_REGISTERED] if phone exists.
  Future<AuthLoginResult> register(
    String name,
    String phone,
    String password, {
    String? email,
  }) async {
    try {
      final body = <String, dynamic>{
        'name': name,
        'phone': phone,
        'password': password,
      };
      if (email != null && email.isNotEmpty) body['email'] = email;

      final decoded = await _api.request(
        '/auth/register',
        method: 'POST',
        body: body,
      );
      print('[AuthApi] register response: $decoded');
      final map = decoded as Map<String, dynamic>?;
      if (map == null)
        throw AuthApiException(
          statusCode: 0,
          message: 'No data',
          code: null,
          details: null,
        );
      return _parseAuthResponse(map, fallbackError: 'Registration failed');
    } on ApiException catch (e) {
      print(
        '[AuthApi] register error: statusCode=${e.statusCode}, message=${e.message}, code=${e.code}, details=${e.details}',
      );
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  /// POST /auth/login. Request: { name, phone }. Response: { success, data: { user, token, expiresIn } }
  /// Login for registered users only. 404 [NOT_REGISTERED] if phone not registered; 401 [ACCOUNT_DEACTIVATED].
  /// Throws [AuthApiException] on non-2xx or parse error.
  Future<AuthLoginResult> login(String name, String phone) async {
    try {
      final decoded = await _api.request(
        '/auth/login',
        method: 'POST',
        body: {'name': name, 'phone': phone},
      );
      print('[AuthApi] login response: $decoded');
      final map = decoded as Map<String, dynamic>?;
      if (map == null)
        throw AuthApiException(
          statusCode: 0,
          message: 'No data',
          code: null,
          details: null,
        );
      return _parseAuthResponse(map, fallbackError: 'Login failed');
    } on ApiException catch (e) {
      print(
        '[AuthApi] login error: statusCode=${e.statusCode}, message=${e.message}, code=${e.code}, details=${e.details}',
      );
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }

  AuthLoginResult _parseAuthResponse(
    Map<String, dynamic> map, {
    required String fallbackError,
  }) {
    final success = map['success'] as bool? ?? false;
    if (!success) {
      throw AuthApiException(
        statusCode: 0,
        message: map['error'] as String? ?? fallbackError,
        code: map['code'] as String?,
        details: map['details'] as Map<String, dynamic>?,
      );
    }
    final data = map['data'] as Map<String, dynamic>?;
    if (data == null)
      throw AuthApiException(
        statusCode: 0,
        message: 'No data',
        code: null,
        details: null,
      );

    final userMap = data['user'] as Map<String, dynamic>?;
    if (userMap == null)
      throw AuthApiException(
        statusCode: 0,
        message: 'No user',
        code: null,
        details: null,
      );

    final token = data['token'] as String?;
    if (token == null || token.isEmpty)
      throw AuthApiException(
        statusCode: 0,
        message: 'No token',
        code: null,
        details: null,
      );

    final user = UserModel.fromJson(userMap);
    final tokenModel = TokenModel(
      token: token,
      refreshToken: data['refreshToken'] as String?,
      expiresIn: data['expiresIn'] as int?,
    );
    return AuthLoginResult(user: user, tokenModel: tokenModel);
  }

  /// GET /auth/me. Headers: Authorization: Bearer {token}. Returns current user.
  Future<UserModel> getMe(String token) async {
    try {
      final decoded = await _api.request(
        '/auth/me',
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

  /// POST /auth/logout. Headers: Authorization: Bearer {token}.
  Future<void> logout(String token) async {
    try {
      final decoded = await _api.request(
        '/auth/logout',
        method: 'POST',
        token: token,
      );
      print('[AuthApi] logout response: $decoded');
    } on ApiException catch (e) {
      print(
        '[AuthApi] logout error: statusCode=${e.statusCode}, message=${e.message}',
      );
      throw AuthApiException(
        statusCode: e.statusCode,
        message: e.message,
        code: e.code,
        details: e.details,
      );
    }
  }
}

/// Exception for auth/customer API errors. Matches backend: success=false, error, code, details.
class AuthApiException implements Exception {
  AuthApiException({
    required this.statusCode,
    required this.message,
    this.code,
    this.details,
  });
  final int statusCode;
  final String message;

  /// e.g. VALIDATION_ERROR, UNAUTHORIZED, ACCOUNT_DEACTIVATED, NOT_FOUND
  final String? code;

  /// For validation: field -> list of messages
  final Map<String, dynamic>? details;
  @override
  String toString() => 'AuthApiException($statusCode: $message, code: $code)';
}
