import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/auth_splash_screen.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'router.dart';

class App extends StatelessWidget {
  final AuthProvider authProvider;

  const App({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth is created before the widget tree and passed in so GoRouter
        // can hold a reference to it via refreshListenable.
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider(),
        ),
      ],
      child: Consumer2<AuthProvider, LanguageProvider>(
        builder: (context, auth, lang, _) {
          auth.setLocalizedStrings(lang.s);
          if (!auth.isInitialized) {
            return Directionality(
              textDirection: lang.textDirection,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                home: const AuthSplashScreen(),
              ),
            );
          }
          return Directionality(
            textDirection: lang.textDirection,
            child: MaterialApp.router(
              title: 'MarketingAI',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              routerConfig: createRouter(auth),
              builder: (context, child) => Directionality(
                textDirection: lang.textDirection,
                child: child ?? const SizedBox(),
              ),
            ),
          );
        },
      ),
    );
  }
}
