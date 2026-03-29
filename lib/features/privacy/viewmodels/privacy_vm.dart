// feature-first privacy: ViewModel owns navigation and derived state (lastUpdated).
// Keeps UI dumb: no DateTime logic in the view.

import 'package:flutter/material.dart';

class PrivacyViewModel extends ChangeNotifier {
  PrivacyViewModel({required GlobalKey<NavigatorState> navigatorKey})
    : _navigatorKey = navigatorKey;

  final GlobalKey<NavigatorState> _navigatorKey;

  void goBack() {
    _navigatorKey.currentState?.pop();
  }

  /// Derived state: UI renders this string only.
  String get lastUpdated => DateTime.now().toString().split(' ')[0];
}
