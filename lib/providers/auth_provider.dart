import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../localization/app_language.dart';
import '../localization/strings.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import '../utils/firebase_auth_errors.dart';

enum AuthStatus {
  unknown,
  unauthenticated,
  emailVerificationRequired,
  authenticated,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  UserModel? _user;
  User? _firebaseUser;
  bool _loading = false;
  String? _error;
  StreamSubscription<User?>? _authSub;
  AppStrings _strings = AppStrings(AppLanguage.he);

  AuthStatus get status => _status;
  UserModel? get user => _user;
  User? get firebaseUser => _firebaseUser;
  bool get loading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get needsEmailVerification =>
      _status == AuthStatus.emailVerificationRequired;
  bool get isInitialized => _status != AuthStatus.unknown;
  bool get isFirebaseConfigured => Firebase.apps.isNotEmpty;

  void setLocalizedStrings(AppStrings strings) {
    _strings = strings;
  }

  /// Called once at app startup after Firebase.initializeApp().
  Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    final redirectResult = await FirebaseAuthService.getRedirectResult();
    if (redirectResult?.user != null) {
      await _handleFirebaseUser(redirectResult!.user);
    } else {
      await _handleFirebaseUser(FirebaseAuthService.currentUser);
    }

    _authSub ??= FirebaseAuthService.authStateChanges().listen(
      _handleFirebaseUser,
    );
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> login({required String email, required String password}) async {
    _setLoading(true);
    try {
      final credential = await FirebaseAuthService.signInWithEmail(
        email: email.trim(),
        password: password,
      );
      await _handleFirebaseUser(credential.user);
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
    } catch (e) {
      _setError(_mapGenericError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    _setLoading(true);
    try {
      final credential = await FirebaseAuthService.signUpWithEmail(
        email: email.trim(),
        password: password,
        displayName: fullName,
      );
      _firebaseUser = credential.user;
      _user = null;
      _status = AuthStatus.emailVerificationRequired;
      _error = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
    } catch (e) {
      _setError(_mapGenericError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      final credential = await FirebaseAuthService.signInWithGoogle();
      if (credential == null) {
        // Mobile web redirect flow — page will reload after Google auth.
        return;
      }
      await _handleFirebaseUser(credential.user);
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
    } catch (e) {
      _setError(googleSignInErrorMessage(e, _strings));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    _setLoading(true);
    try {
      await FirebaseAuthService.sendPasswordResetEmail(email.trim());
      _error = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resendVerificationEmail() async {
    _setLoading(true);
    try {
      await FirebaseAuthService.sendEmailVerification();
      _error = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> refreshEmailVerification() async {
    _setLoading(true);
    try {
      final verified = await FirebaseAuthService.reloadAndCheckEmailVerified();
      if (verified) {
        await _syncBackendUser(fullName: _firebaseUser?.displayName);
      } else {
        _status = AuthStatus.emailVerificationRequired;
        notifyListeners();
      }
      return verified;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
      return false;
    } catch (e) {
      _setError(_mapGenericError(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await FirebaseAuthService.signOut();
    _firebaseUser = null;
    _user = null;
    _error = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> _handleFirebaseUser(User? firebaseUser) async {
    _firebaseUser = firebaseUser;

    if (firebaseUser == null) {
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    if (!FirebaseAuthService.hasVerifiedAccess(firebaseUser)) {
      _user = null;
      _status = AuthStatus.emailVerificationRequired;
      notifyListeners();
      return;
    }

    try {
      await _syncBackendUser(fullName: firebaseUser.displayName);
    } catch (e) {
      debugPrint('Backend sync failed: $e');
      await FirebaseAuthService.signOut();
      _firebaseUser = null;
      _user = null;
      _status = AuthStatus.unauthenticated;
      _setError(_mapBackendSyncError(e));
    }
  }

  Future<void> _syncBackendUser({String? fullName}) async {
    await FirebaseAuthService.getIdToken(forceRefresh: true);
    _user = await AuthService.syncUser(fullName: fullName);
    _status = AuthStatus.authenticated;
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    if (value) _error = null;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    return firebaseAuthErrorMessage(e, _strings);
  }

  String _mapGenericError(Object e) {
    final msg = e.toString();
    if (msg.contains('401')) return _strings.authErrorSessionExpired;
    if (msg.contains('503')) return _strings.authErrorServiceUnavailable;
    if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
      return _strings.authErrorNetwork;
    }
    return _strings.authErrorGeneric;
  }

  String _mapBackendSyncError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('403')) {
      return _strings.authErrorSessionExpired;
    }
    if (msg.contains('503') || msg.contains('502')) {
      return _strings.authErrorServiceUnavailable;
    }
    if (msg.contains('SocketException') || msg.contains('Failed host lookup')) {
      return _strings.authErrorNetwork;
    }
    return _strings.authErrorBackendSync;
  }
}
