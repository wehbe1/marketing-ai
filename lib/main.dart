import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase/firebase_initializer.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    await FirebaseInitializer.initializeGoogleSignIn();
  } catch (e, stack) {
    debugPrint('Google Sign-In init skipped: $e\n$stack');
  }

  final auth = AuthProvider();
  await auth.initialize();

  runApp(App(authProvider: auth));
}
