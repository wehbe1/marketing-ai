/// Central API configuration.
///
/// Production default points to the Render backend.
/// Local override:
///   flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8000
abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://marketing-ai-jspk.onrender.com',
  );

  static bool get isProduction =>
      !baseUrl.contains('localhost') &&
      !baseUrl.contains('127.0.0.1') &&
      !baseUrl.contains('ngrok');
}
