// feature-first about: Public API. Central export for testability and scalability.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/about_vm.dart';
import 'views/about_page.dart';

export 'viewmodels/about_vm.dart';
export 'views/about_page.dart';

ChangeNotifierProvider<AboutViewModel> createAboutProvider(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return ChangeNotifierProvider<AboutViewModel>(
    create: (_) => AboutViewModel(navigatorKey: navigatorKey),
  );
}
