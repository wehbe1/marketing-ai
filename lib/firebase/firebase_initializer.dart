import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_auth_config.dart';

/// Initializes Google Sign-In after [Firebase.initializeApp].
abstract final class FirebaseInitializer {
  static bool _googleSignInReady = false;

  static bool get isGoogleSignInReady => _googleSignInReady;

  static Future<void> initializeGoogleSignIn() async {
    if (_googleSignInReady || Firebase.apps.isEmpty) return;

    // Web uses Firebase Auth signInWithPopup — GoogleSignIn init not needed.
    if (kIsWeb) {
      _googleSignInReady = true;
      return;
    }

    final webClientId = FirebaseAuthConfig.googleWebClientId;
    if (webClientId.isEmpty) return;

    await GoogleSignIn.instance.initialize(serverClientId: webClientId);
    _googleSignInReady = true;
  }
}
