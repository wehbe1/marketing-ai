import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/firebase_auth_service.dart';

/// Thrown when the server returns a non-2xx status code.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Base HTTP client.
///
/// - Automatically injects `Authorization: Bearer <Firebase ID token>`.
/// - Decodes JSON responses.
/// - Throws [ApiException] on error responses.
abstract final class ApiClient {
  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final token = await FirebaseAuthService.getIdToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static dynamic _decode(http.Response response) {
    final body = utf8.decode(response.bodyBytes);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(body);
    }
    String message;
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      message = json['detail']?.toString() ?? 'Unknown error';
    } catch (_) {
      message = body;
    }
    throw ApiException(statusCode: response.statusCode, message: message);
  }

  static Future<dynamic> get(String url, {bool auth = true}) async {
    final response = await http.get(
      Uri.parse(url),
      headers: await _headers(auth: auth),
    );
    return _decode(response);
  }

  static Future<dynamic> post(
    String url,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _decode(response);
  }
}
