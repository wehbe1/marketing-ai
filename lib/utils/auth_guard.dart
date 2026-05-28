import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../router.dart';

/// Redirects based on auth state. Used on the landing page for protected CTAs.
class AuthGuard {
  AuthGuard._();

  static void goToApp(BuildContext context) {
    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      context.go(AppRoutes.dashboard);
    } else if (auth.needsEmailVerification) {
      context.go(AppRoutes.verifyEmail);
    } else {
      context.go(AppRoutes.login);
    }
  }
}
