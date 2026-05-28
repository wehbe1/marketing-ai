import 'package:firebase_auth/firebase_auth.dart';

import '../localization/strings.dart';

/// Maps Firebase auth error codes to localized user-facing messages.
String firebaseAuthErrorMessage(FirebaseAuthException error, AppStrings s) {
  switch (error.code) {
    case 'email-already-in-use':
      return s.authErrorEmailInUse;
    case 'invalid-email':
      return s.errorEmailInvalid;
    case 'weak-password':
      return s.errorPasswordWeak;
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
    case 'invalid-login-credentials':
      return s.authErrorInvalidCredentials;
    case 'user-disabled':
      return s.authErrorUserDisabled;
    case 'too-many-requests':
      return s.authErrorTooManyRequests;
    case 'network-request-failed':
      return s.authErrorNetwork;
    case 'operation-not-allowed':
      return s.authErrorProviderDisabled;
    case 'requires-recent-login':
      return s.authErrorRecentLogin;
    default:
      return s.authErrorGeneric;
  }
}

String googleSignInErrorMessage(Object error, AppStrings s) {
  final message = error.toString();
  if (message.contains('canceled') || message.contains('cancelled')) {
    return s.authErrorGoogleCanceled;
  }
  return s.authErrorGeneric;
}
