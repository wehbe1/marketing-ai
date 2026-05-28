/// Google Sign-In OAuth client ID for Firebase Auth.
abstract final class FirebaseAuthConfig {
  /// Web client ID from Firebase/Google Cloud (required for Google Sign-In).
  static const googleWebClientId = String.fromEnvironment(
    'FIREBASE_WEB_CLIENT_ID',
    defaultValue:
        '1077900367333-7gtb8luklphci5bjbr6ep2cfc2bn627d.apps.googleusercontent.com',
  );
}
