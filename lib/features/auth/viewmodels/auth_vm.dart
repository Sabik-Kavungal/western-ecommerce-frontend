// feature-first auth: ViewModel owns ALL form state, validation, API, loading/error,
// and navigation. UI MUST only call VM methods and render VM state (Provider).
// No TextEditingController; form state as primitives for testability and separation of concerns.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e/core/constants/app_roles.dart';

import '../models/token_model.dart';
import '../models/user_model.dart';
import '../services/auth_api.dart';

const _kKeyToken = 'auth_token';
const _kKeyRefresh = 'auth_refresh_token';

/// ViewModel for auth: form (name, phone), login, restoreSession, logout.
/// Injected: AuthApi, SharedPreferences, Navigator key for VM-driven navigation.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required AuthApi authApi,
    required SharedPreferences prefs,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : _authApi = authApi,
       _prefs = prefs,
       _navigatorKey = navigatorKey;

  final AuthApi _authApi;
  final SharedPreferences _prefs;
  final GlobalKey<NavigatorState>? _navigatorKey;

  // ---------- Form state (NO TextEditingController; UI binds value + onChanged) ----------
  String _name = '';
  String _phone = '';
  String _password = '';
  String _email = '';

  String get name => _name;
  String get phone => _phone;
  String get password => _password;
  String get email => _email;

  void updateName(String value) {
    _name = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  /// Clear password and email (e.g. when leaving register screen).
  void clearRegisterFields() {
    _password = '';
    _email = '';
    notifyListeners();
  }

  // ---------- Async and error ----------
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasRestoreAttempted = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? v) {
    _errorMessage = v;
    notifyListeners();
  }

  // ---------- User and auth ----------
  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  /// Compatibility with existing consumers (profile, product_detail, etc.)
  String? get userId => _user?.id;
  String? get userName => _user?.name;
  String? get userEmail => _user?.email;

  /// JWT for CustomerApi and other authenticated calls. Null when not logged in.
  String? get token => _loadToken();

  /// Update current user (e.g. after PUT /customers/me). Use from EditProfilePage.
  void setUser(UserModel u) {
    _user = u;
    notifyListeners();
  }

  // ---------- Persistence (SharedPreferences) ----------
  Future<void> _saveToken(TokenModel t) async {
    await _prefs.setString(_kKeyToken, t.token);
    if (t.refreshToken != null && t.refreshToken!.isNotEmpty) {
      await _prefs.setString(_kKeyRefresh, t.refreshToken!);
    }
  }

  Future<void> _clearToken() async {
    await _prefs.remove(_kKeyToken);
    await _prefs.remove(_kKeyRefresh);
  }

  String? _loadToken() => _prefs.getString(_kKeyToken);

  // ---------- Login (validation + API + persist + navigate) ----------
  /// Call from Login button onPressed. Validation and API in VM; UI only triggers.
  Future<void> login() async {
    _setError(null);
    final n = _name.trim();
    final p = _phone.trim();

    // Validation in ViewModel (not in UI)
    if (n.isEmpty) {
      _setError('Name is required');
      return;
    }
    if (n.length < 2 || n.length > 100) {
      _setError('Name must be between 2 and 100 characters');
      return;
    }
    if (p.isEmpty) {
      _setError('Phone is required');
      return;
    }
    if (p.length != 10 || !RegExp(r'^\d+$').hasMatch(p)) {
      _setError('Phone must be exactly 10 digits');
      return;
    }

    _setLoading(true);
    try {
      final result = await _authApi.login(n, p);
      await _saveToken(result.tokenModel);
      _user = result.user;
      _setError(null);
      _setLoading(false);
      notifyListeners();
      _navigateTo(
        _user?.role == AppRoles.businessAdmin ? '/admin' : '/home',
        clearStack: true,
      );
    } on AuthApiException catch (e) {
      if (e.code == 'NOT_REGISTERED') {
        _setError(
          'Phone number not registered. Please create an account first.',
        );
      } else if (e.code == 'ACCOUNT_DEACTIVATED') {
        _setError('Your account has been deactivated. Please contact support.');
      } else if (e.details != null && e.details!.isNotEmpty) {
        final parts = e.details!.entries.map((entry) {
          final v = entry.value;
          final text = v is List ? v.join(', ') : v.toString();
          return '${entry.key}: $text';
        });
        _setError('${e.message}\n${parts.join('\n')}');
      } else {
        _setError(e.message);
      }
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // ---------- Register (validation + API + persist + navigate) ----------
  /// Call from Register button. Creates customer with name, phone, password; email optional.
  Future<void> register() async {
    _setError(null);
    final n = _name.trim();
    final p = _phone.trim();
    final pw = _password;
    final em = _email.trim();

    if (n.isEmpty) {
      _setError('Name is required');
      return;
    }
    if (n.length < 2 || n.length > 100) {
      _setError('Name must be between 2 and 100 characters');
      return;
    }
    if (p.isEmpty) {
      _setError('Phone is required');
      return;
    }
    if (p.length != 10 || !RegExp(r'^\d+$').hasMatch(p)) {
      _setError('Phone must be exactly 10 digits');
      return;
    }
    if (pw.isEmpty) {
      _setError('Password is required');
      return;
    }
    if (pw.length < 6) {
      _setError('Password must be at least 6 characters');
      return;
    }

    _setLoading(true);
    try {
      final result = await _authApi.register(
        n,
        p,
        pw,
        email: em.isEmpty ? null : em,
      );
      await _saveToken(result.tokenModel);
      _user = result.user;
      _setError(null);
      _setLoading(false);
      clearRegisterFields();
      notifyListeners();
      _navigateTo('/home', clearStack: true);
    } on AuthApiException catch (e) {
      if (e.code == 'ALREADY_REGISTERED') {
        _setError('This phone number is already registered. Please sign in.');
      } else if (e.code == 'ACCOUNT_DEACTIVATED') {
        _setError('Your account has been deactivated. Please contact support.');
      } else if (e.details != null && e.details!.isNotEmpty) {
        final parts = e.details!.entries.map((entry) {
          final v = entry.value;
          final text = v is List ? v.join(', ') : v.toString();
          return '${entry.key}: $text';
        });
        _setError('${e.message}\n${parts.join('\n')}');
      } else {
        _setError(e.message);
      }
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // ---------- Restore session (splash: call once, then navigate) ----------
  /// Idempotent. Call from Splash (e.g. post-frame). VM decides: /home if valid token, else /login.
  Future<void> restoreSession() async {
    if (_hasRestoreAttempted) return;
    _hasRestoreAttempted = true;

    final token = _loadToken();
    if (token == null || token.isEmpty) {
      _user = null;
      // Only navigate to home if we are NOT at the home page (prevents double home pages)
      _navigateTo('/home', clearStack: true, force: false);
      return;
    }

    try {
      final u = await _authApi.getMe(token);
      _user = u;
      _setError(null);
      notifyListeners();

      final destination = _user?.role == AppRoles.businessAdmin
          ? '/admin'
          : '/home';
      _navigateTo(destination, clearStack: true, force: false);
    } catch (_) {
      await _clearToken();
      _user = null;
      notifyListeners();
      _navigateTo('/home', clearStack: true, force: false);
    }
  }

  // ---------- Logout ----------
  /// Calls logout API (best-effort), then always clears local storage (SharedPreferences)
  /// and navigates to /login. User is logged out even when offline.
  Future<void> logout() async {
    final t = _loadToken();
    if (t != null && t.isNotEmpty) {
      try {
        await _authApi.logout(t);
      } catch (_) {}
    }
    await _clearToken();
    _user = null;
    _setError(null);
    notifyListeners();
    _navigateTo('/login', clearStack: true);
  }

  /// For LoginDialog: navigate to /login (dialog’s button should pop first, then call this).
  void navigateToLogin() {
    _navigateTo('/login', replace: false);
  }

  /// Navigate to /register (e.g. from LoginDialog or LoginPage).
  void navigateToRegister() {
    _navigateTo('/register');
  }

  void _navigateTo(
    String route, {
    bool clearStack = false,
    bool replace = true,
    bool force = true,
  }) {
    // Web Stability: Ensure navigation happens after the current frame to prevent "!isDisposed" crashes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = _navigatorKey?.currentState;
      if (state == null) return;

      String? currentRouteName;
      state.popUntil((route) {
        currentRouteName = route.settings.name;
        return true;
      });

      if (currentRouteName == route) return;

      // Prevent automatic session restoration navigation from nuking deep links
      if (!force && currentRouteName != null && currentRouteName != '/') {
        return;
      }

      if (clearStack) {
        state.pushNamedAndRemoveUntil(route, (_) => false);
      } else if (replace) {
        state.pushReplacementNamed(route);
      } else {
        state.pushNamed(route);
      }
    });
  }
}
