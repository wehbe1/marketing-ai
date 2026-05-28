import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../router.dart';
import '../../utils/auth_validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';
import 'auth_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    try {
      await auth.sendPasswordReset(_emailCtrl.text.trim());
      if (mounted) setState(() => _emailSent = true);
    } catch (_) {
      // Error shown via auth.error
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();
    final s = lang.s;

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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthHeader(
                              title: s.authForgotPasswordTitle,
                              subtitle: s.authForgotPasswordSubtitle,
                            ),
                            const SizedBox(height: 32),
                            if (auth.error != null) ...[
                              AuthErrorBanner(message: auth.error!),
                              const SizedBox(height: 16),
                            ],
                            if (_emailSent) ...[
                              AuthSuccessBanner(message: s.authResetEmailSent),
                              const SizedBox(height: 16),
                            ],
                            AppTextField(
                              controller: _emailCtrl,
                              label: s.fieldEmail,
                              hint: 'you@example.com',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              validator: (v) => AuthValidators.validateEmail(v, s),
                            ),
                            const SizedBox(height: 28),
                            PrimaryButton(
                              label: s.authSendResetLink,
                              loading: auth.loading,
                              onPressed: auth.loading ? null : _submit,
                              fullWidth: true,
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () => context.go(AppRoutes.login),
                              child: Text(s.authBackToLogin),
                            ),
                          ],
                        ),
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
