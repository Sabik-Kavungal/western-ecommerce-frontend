/// Thrown by [ApiService] on 4xx/5xx or network errors.
/// Matches backend: success=false, error, code, details.
class ApiException implements Exception {
  ApiException({
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
  String toString() => 'ApiException($statusCode: $message, code: $code)';
}
