import 'package:e/core/constants/app_constants.dart';

/// Central API base URL and path constants.
/// Use [baseUrl] for [ApiService] (from [Constants.apiBaseUrl]).
class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl => Constants.apiBaseUrl;
}
