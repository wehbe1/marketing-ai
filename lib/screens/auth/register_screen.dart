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



class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});



  @override

  State<RegisterScreen> createState() => _RegisterScreenState();

}



class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();

  final _emailCtrl = TextEditingController();

  final _passwordCtrl = TextEditingController();

  final _emailFocus = FocusNode();

  final _passwordFocus = FocusNode();

  bool _showPassword = false;



  @override

  void dispose() {

    _nameCtrl.dispose();

    _emailCtrl.dispose();

    _passwordCtrl.dispose();

    _emailFocus.dispose();

    _passwordFocus.dispose();

    super.dispose();

  }



  Future<void> _submit() async {

    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    if (!auth.isFirebaseConfigured) return;

    await auth.register(

      email: _emailCtrl.text.trim(),

      password: _passwordCtrl.text,

      fullName: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),

    );

    if (!mounted) return;

    if (auth.needsEmailVerification) {

      context.go(AppRoutes.verifyEmail);

    } else if (auth.isAuthenticated) {

      context.go(AppRoutes.dashboard);

    }

  }



  Future<void> _googleSignIn() async {

    final auth = context.read<AuthProvider>();

    if (!auth.isFirebaseConfigured) return;

    await auth.signInWithGoogle();

    if (!mounted) return;

    if (auth.isAuthenticated) {

      context.go(AppRoutes.dashboard);

    } else if (auth.needsEmailVerification) {

      context.go(AppRoutes.verifyEmail);

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

                              title: s.registerTitle,

                              subtitle: s.registerSubtitle,

                            ),

                            const SizedBox(height: 32),



                            if (!auth.isFirebaseConfigured) ...[

                              AuthErrorBanner(message: s.authFirebaseNotConfigured),

                              const SizedBox(height: 16),

                            ],



                            if (auth.error != null) ...[

                              AuthErrorBanner(message: auth.error!),

                              const SizedBox(height: 16),

                            ],



                            AppTextField(

                              controller: _nameCtrl,

                              label: s.fieldFullName,

                              hint: lang.isRtl ? 'ישראל ישראלי' : 'John Smith',

                              textInputAction: TextInputAction.next,

                              onFieldSubmitted: (_) =>

                                  _emailFocus.requestFocus(),

                            ),

                            const SizedBox(height: 16),



                            AppTextField(

                              controller: _emailCtrl,

                              label: s.fieldEmail,

                              hint: 'you@example.com',

                              keyboardType: TextInputType.emailAddress,

                              focusNode: _emailFocus,

                              textInputAction: TextInputAction.next,

                              onFieldSubmitted: (_) =>

                                  _passwordFocus.requestFocus(),

                              validator: (v) =>

                                  AuthValidators.validateEmail(v, s),

                            ),

                            const SizedBox(height: 16),



                            AppTextField(

                              controller: _passwordCtrl,

                              label: s.fieldPassword,

                              focusNode: _passwordFocus,

                              obscureText: !_showPassword,

                              textInputAction: TextInputAction.done,

                              onFieldSubmitted: (_) => _submit(),

                              suffixIcon: IconButton(

                                icon: Icon(

                                  _showPassword

                                      ? Icons.visibility_off_outlined

                                      : Icons.visibility_outlined,

                                  color: AppColors.textLight,

                                  size: 20,

                                ),

                                onPressed: () => setState(

                                  () => _showPassword = !_showPassword,

                                ),

                              ),

                              validator: (v) =>

                                  AuthValidators.validatePassword(v, s),

                            ),

                            const SizedBox(height: 28),



                            PrimaryButton(

                              label: s.registerButton,

                              loading: auth.loading,

                              onPressed:

                                  auth.loading || !auth.isFirebaseConfigured

                                  ? null

                                  : _submit,

                              fullWidth: true,

                            ),

                            const SizedBox(height: 20),



                            AuthOrDivider(label: s.authOrDivider),

                            const SizedBox(height: 20),



                            GoogleSignInButton(

                              label: s.authContinueWithGoogle,

                              loading: auth.loading,

                              onPressed: auth.isFirebaseConfigured

                                  ? _googleSignIn

                                  : null,

                            ),

                            const SizedBox(height: 20),



                            Row(

                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [

                                Text(

                                  s.registerHaveAccount,

                                  style: const TextStyle(

                                    color: AppColors.textMedium,

                                    fontSize: 14,

                                  ),

                                ),

                                const SizedBox(width: 4),

                                TextButton(

                                  onPressed: () => context.go(AppRoutes.login),

                                  style: TextButton.styleFrom(

                                    padding: EdgeInsets.zero,

                                    minimumSize: Size.zero,

                                    tapTargetSize:

                                        MaterialTapTargetSize.shrinkWrap,

                                  ),

                                  child: Text(s.registerLoginLink),

                                ),

                              ],

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

