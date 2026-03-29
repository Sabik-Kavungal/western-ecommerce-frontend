// feature-first privacy: Public API.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/privacy_vm.dart';
import 'views/privacy_policy_page.dart';

export 'viewmodels/privacy_vm.dart';
export 'views/privacy_policy_page.dart';

ChangeNotifierProvider<PrivacyViewModel> createPrivacyProvider(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return ChangeNotifierProvider<PrivacyViewModel>(
    create: (_) => PrivacyViewModel(navigatorKey: navigatorKey),
  );
}
