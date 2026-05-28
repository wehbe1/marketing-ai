import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants.dart';
import '../localization/app_language.dart';
import '../models/post_generator_models.dart';

class HashtagAnalysisException implements Exception {
  final int statusCode;
  final String message;
  final String? endpoint;

  const HashtagAnalysisException({
    required this.statusCode,
    required this.message,
    this.endpoint,
  });

  String friendlyMessage(AppLanguage lang) {
    if (statusCode == 404) {
      return lang == AppLanguage.he
          ? 'שירות ניתוח ההאשטגים לא נמצא בשרת. ודא שה-backend עודכן ופועל.'
          : 'Hashtag analysis endpoint not found. Ensure the backend is deployed and running.';
    }
    if (statusCode == 0 || message.contains('Failed to fetch') || message.contains('SocketException')) {
      return lang == AppLanguage.he
          ? 'לא ניתן להתחבר לשרת. בדוק חיבור לאינטרנט או כתובת API.'
          : 'Could not reach the server. Check your connection or API base URL.';
    }
    if (statusCode >= 500) {
      return lang == AppLanguage.he
          ? 'שגיאת שרת זמנית. נסה שוב בעוד רגע.'
          : 'Temporary server error. Please try again shortly.';
    }
    return message;
  }

  @override
  String toString() => 'HashtagAnalysisException($statusCode): $message';
}

class HashtagAnalysisService {
  static Future<HashtagAnalysisResponse> analyzeHashtags(
    HashtagAnalysisRequest request, {
    List<String> endpoints = const [
      ApiConstants.analyzeHashtags,
      ApiConstants.analyzeHashtagsLegacy,
    ],
  }) async {
    Object? lastError;

    for (final endpoint in endpoints) {
      try {
        return await _postAnalyze(endpoint, request);
      } on HashtagAnalysisException catch (e) {
        lastError = e;
        if (e.statusCode != 404) rethrow;
      } catch (e) {
        lastError = e;
        rethrow;
      }
    }

    if (lastError is HashtagAnalysisException) throw lastError;
    throw HashtagAnalysisException(
      statusCode: 404,
      message: 'Hashtag analysis endpoint not available',
      endpoint: endpoints.first,
    );
  }

  static Future<HashtagAnalysisResponse> _postAnalyze(
    String url,
    HashtagAnalysisRequest request,
  ) async {
    http.Response response;
    try {
      response = await http
          .post(
            Uri.parse(url),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 90));
    } on Exception catch (e) {
      throw HashtagAnalysisException(
        statusCode: 0,
        message: e.toString(),
        endpoint: url,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      if (json is! Map<String, dynamic>) {
        throw HashtagAnalysisException(
          statusCode: response.statusCode,
          message: 'Invalid response format',
          endpoint: url,
        );
      }
      return HashtagAnalysisResponse.fromJson(json);
    }

    String message;
    try {
      final json = jsonDecode(response.body);
      if (json is Map && json['detail'] != null) {
        message = json['detail'].toString();
      } else {
        message = response.body;
      }
    } catch (_) {
      message = response.body;
    }

    throw HashtagAnalysisException(
      statusCode: response.statusCode,
      message: message,
      endpoint: url,
    );
  }
}
