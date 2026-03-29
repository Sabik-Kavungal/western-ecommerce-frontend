import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_endpoints.dart';
import 'api_exception.dart';

/// Descriptor for a file to upload in a multipart request.
class MultipartFileDesc {
  const MultipartFileDesc({
    this.bytes = const [],
    required this.filename,
    this.mimeType = 'image/jpeg',
    this.stream,
    this.length,
  });
  final List<int> bytes;
  final String filename;
  final String mimeType;
  final Stream<List<int>>? stream;
  final int? length;
}

/// Central HTTP client. Use for all API calls.
/// Handles JSON, Bearer token, and throws [ApiException] on 4xx/5xx.
/// No Flutter/Provider; inject [ApiService] where needed.
class ApiService {
  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? ApiEndpoints.baseUrl;

  final String baseUrl;

  /// [endpoint] must start with / (e.g. /auth/login).
  /// [extraHeaders] e.g. {'X-Tenant-ID': tenantId}.
  /// On 2xx returns decoded JSON; on 4xx/5xx or network error throws [ApiException].
  Future<dynamic> request(
    String endpoint, {
    required String method,
    Map<String, dynamic>? body,
    String? token,
    Map<String, String>? extraHeaders,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    if (extraHeaders != null) headers.addAll(extraHeaders);

    int attempts = 0;
    const int maxAttempts = 3;

    while (attempts < maxAttempts) {
      try {
        attempts++;
        http.Response response;

        switch (method.toUpperCase()) {
          case 'POST':
            response = await http
                .post(
                  url,
                  headers: headers,
                  body: body != null ? jsonEncode(body) : null,
                )
                .timeout(const Duration(seconds: 600));
            break;
          case 'GET':
            response = await http
                .get(url, headers: headers)
                .timeout(const Duration(seconds: 600));
            break;
          case 'PUT':
            response = await http
                .put(
                  url,
                  headers: headers,
                  body: body != null ? jsonEncode(body) : null,
                )
                .timeout(const Duration(seconds: 600));
            break;
          case 'PATCH':
            response = await http
                .patch(
                  url,
                  headers: headers,
                  body: body != null ? jsonEncode(body) : null,
                )
                .timeout(const Duration(seconds: 600));
            break;
          case 'DELETE':
            response = await http
                .delete(url, headers: headers)
                .timeout(const Duration(seconds: 600));
            break;
          default:
            throw ApiException(
              statusCode: 0,
              message: 'Unsupported HTTP method: $method',
              code: null,
              details: null,
            );
        }

        // Only retry GET requests on 5xx or network errors
        if (method.toUpperCase() == 'GET' &&
            response.statusCode >= 500 &&
            attempts < maxAttempts) {
          await Future.delayed(Duration(milliseconds: 500 * attempts));
          continue;
        }

        return _handleResponse(response);
      } catch (e) {
        if (e is ApiException) rethrow;

        // Retry GET on network timeout/error
        if (method.toUpperCase() == 'GET' && attempts < maxAttempts) {
          await Future.delayed(Duration(milliseconds: 500 * attempts));
          continue;
        }

        throw ApiException(
          statusCode: 0,
          message: e.toString(),
          code: null,
          details: null,
        );
      }
    }
    // Should not reach here due to rethrow/return, but for safety:
    throw ApiException(
      statusCode: 0,
      message: 'Request failed after $maxAttempts attempts',
      code: null,
      details: null,
    );
  }

  /// Detect MIME type from file extension
  static String _detectMimeType(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'svg':
        return 'image/svg+xml';
      case 'ico':
        return 'image/x-icon';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream'; // More generic for "validation-free"
    }
  }

  /// POST multipart/form-data. [endpoint] e.g. /upload/images. [files] field name
  /// is `images` (multiple). On 2xx returns decoded JSON; throws [ApiException] otherwise.
  Future<dynamic> uploadMultipart(
    String endpoint, {
    required List<MultipartFileDesc> files,
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', url);
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    for (final f in files) {
      // Always detect MIME type from filename to ensure accuracy
      final mimeType = _detectMimeType(f.filename);

      if (f.stream != null && f.length != null) {
        request.files.add(
          http.MultipartFile(
            'images',
            f.stream!,
            f.length!,
            filename: f.filename,
            contentType: http.MediaType.parse(mimeType),
          ),
        );
      } else {
        request.files.add(
          http.MultipartFile.fromBytes(
            'images',
            f.bytes,
            filename: f.filename,
            contentType: http.MediaType.parse(mimeType),
          ),
        );
      }
    }
    try {
      print('🚀 UPLOADING TO: ${url.toString()}');
      final streamed = await request.send().timeout(
        const Duration(
          seconds: 900,
        ), // Increased to 15 mins for very large batches
      );
      final response = await http.Response.fromStream(streamed);
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      String msg = e.toString();
      if (msg.contains('TimeoutException')) {
        msg =
            'Upload timed out. Please check your internet connection or try Fewer/smaller images.';
      }
      throw ApiException(
        statusCode: 0,
        message: msg,
        code: 'UPLOAD_ERROR',
        details: {'error': e.toString()},
      );
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      if (response.body.trim() == 'null') return null;
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Invalid JSON: $e',
          code: null,
          details: null,
        );
      }
    }

    // 4xx / 5xx: parse error body and throw
    String message = 'Request failed';
    String? code;
    Map<String, dynamic>? details;

    if (response.body.isNotEmpty) {
      try {
        final map = jsonDecode(response.body) as Map<String, dynamic>?;
        if (map != null) {
          message =
              (map['error'] as String?) ??
              (map['message'] as String?) ??
              message;
          code = (map['code'] as String?) ?? (map['errorCode'] as String?);
          details = map['details'] as Map<String, dynamic>?;
        }
      } catch (_) {
        message = response.body;
      }
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: message,
      code: code,
      details: details,
    );
  }
}
