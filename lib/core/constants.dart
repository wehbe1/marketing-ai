import 'api_config.dart';

abstract final class ApiConstants {
  static const baseUrl = ApiConfig.baseUrl;

  // Auth (Firebase)
  static const sync = '$baseUrl/auth/sync';
  static const me = '$baseUrl/auth/me';

  // AI features
  static const analyzeMarketing = '$baseUrl/analyze/marketing';
  static const analyzeMarketingHtml = '$baseUrl/analyze/marketing/html';
  static const generatePost = '$baseUrl/post/generate';

  /// Primary hashtag analysis endpoint (POST).
  static const analyzeHashtags = '$baseUrl/analyze_hashtags';

  /// Legacy alias kept for backward compatibility.
  static const analyzeHashtagsLegacy = '$baseUrl/post/hashtags/analyze';

  // Reports
  static const reports = '$baseUrl/reports';
  static String reportById(String id) => '$baseUrl/reports/$id';

  // Health
  static const health = '$baseUrl/health';
}
