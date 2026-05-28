import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../router.dart';
import '../../widgets/primary_button.dart';
import 'auth_widgets.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String? _infoMessage;

  Future<void> _resend() async {
    final auth = context.read<AuthProvider>();
    await auth.resendVerificationEmail();
    if (mounted && auth.error == null) {
      setState(() {
        _infoMessage = context.read<LanguageProvider>().s.authVerificationSent;
      });
    }
  }

  Future<void> _checkVerified() async {
    final auth = context.read<AuthProvider>();
    final s = context.read<LanguageProvider>().s;
    final verified = await auth.refreshEmailVerification();
    if (!mounted) return;
    if (verified) {
      context.go(AppRoutes.dashboard);
    } else {
      setState(() => _infoMessage = s.authVerificationPending);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();
    final s = lang.s;
    final email = auth.firebaseUser?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AuthTopBar(),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AuthCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthHeader(
                            title: s.authVerifyEmailTitle,
                            subtitle: s.authVerifyEmailSubtitle,
                          ),
                          if (email.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              email,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          if (auth.error != null) ...[
                            AuthErrorBanner(message: auth.error!),
                            const SizedBox(height: 16),
                          ],
                          if (_infoMessage != null) ...[
                            AuthSuccessBanner(message: _infoMessage!),
                            const SizedBox(height: 16),
                          ],
                          PrimaryButton(
                            label: s.authCheckVerification,
                            loading: auth.loading,
                            onPressed: auth.loading ? null : _checkVerified,
                            fullWidth: true,
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: auth.loading ? null : _resend,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(s.authResendVerification),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: auth.loading
                                ? null
                                : () async {
                                    await auth.logout();
                                    if (context.mounted) {
                                      context.go(AppRoutes.login);
                                    }
                                  },
                            child: Text(s.authSignOut),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
