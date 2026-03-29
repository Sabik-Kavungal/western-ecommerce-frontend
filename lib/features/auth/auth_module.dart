// feature-first auth: Public API of the auth feature.
// Central export for testability, clear boundaries, and scalability.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e/core/api/api_service.dart';

import 'services/auth_api.dart';
import 'viewmodels/auth_vm.dart';

export 'models/token_model.dart';
export 'models/user_model.dart';
export 'services/auth_api.dart';
export 'services/customer_api.dart';
export 'viewmodels/auth_vm.dart';
export 'views/login_page.dart';
export 'views/register_page.dart';
export 'views/splash_page.dart';

/// Builds the AuthViewModel provider for MultiProvider. Requires [ApiService] above in the tree.
ChangeNotifierProvider<AuthViewModel> createAuthProvider({
  required SharedPreferences prefs,
  required GlobalKey<NavigatorState> navigatorKey,
}) {
  return ChangeNotifierProvider<AuthViewModel>(
    create: (context) => AuthViewModel(
      authApi: AuthApi(apiService: context.read<ApiService>()),
      prefs: prefs,
      navigatorKey: navigatorKey,
    ),
  );
}
