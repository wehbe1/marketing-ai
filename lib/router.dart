import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'screens/landing_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/verify_email_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/marketing_plan_screen.dart';
import 'screens/post_generator_screen.dart';

abstract final class AppRoutes {
  static const landing = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const verifyEmail = '/verify-email';
  static const dashboard = '/dashboard';
  static const marketing = '/marketing';
  static const posts = '/posts';
}

GoRouter createRouter(AuthProvider auth) => GoRouter(
  refreshListenable: auth,
  initialLocation: AppRoutes.landing,
  redirect: (context, state) {
    if (!auth.isInitialized) return null;

    final loc = state.matchedLocation;
    final isPublicAuthRoute =
        loc == AppRoutes.login ||
        loc == AppRoutes.register ||
        loc == AppRoutes.forgotPassword;
    final isLanding = loc == AppRoutes.landing;
    final isVerifyEmail = loc == AppRoutes.verifyEmail;

    if (auth.needsEmailVerification) {
      if (!isVerifyEmail && !isPublicAuthRoute && !isLanding) {
        return AppRoutes.verifyEmail;
      }
      if (isPublicAuthRoute && loc != AppRoutes.login) {
        return AppRoutes.verifyEmail;
      }
      return null;
    }

    if (!auth.isAuthenticated) {
      if (!isPublicAuthRoute && !isLanding) return AppRoutes.login;
      return null;
    }

    if (isPublicAuthRoute || isVerifyEmail) {
      return AppRoutes.dashboard;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.landing,
      pageBuilder: (_, __) => const NoTransitionPage(child: LandingScreen()),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (_, __) => const NoTransitionPage(child: LoginScreen()),
    ),
    GoRoute(
      path: AppRoutes.register,
      pageBuilder: (_, __) => const NoTransitionPage(child: RegisterScreen()),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      pageBuilder: (_, __) =>
          const NoTransitionPage(child: ForgotPasswordScreen()),
    ),
    GoRoute(
      path: AppRoutes.verifyEmail,
      pageBuilder: (_, __) =>
          const NoTransitionPage(child: VerifyEmailScreen()),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      pageBuilder: (_, __) => const NoTransitionPage(child: DashboardScreen()),
    ),
    GoRoute(
      path: AppRoutes.marketing,
      builder: (context, _) {
        final lang = context.read<LanguageProvider>().language;
        return MarketingPlanScreen(language: lang);
      },
    ),
    GoRoute(
      path: AppRoutes.posts,
      builder: (context, _) {
        final lang = context.read<LanguageProvider>().language;
        return PostGeneratorScreen(language: lang);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);
