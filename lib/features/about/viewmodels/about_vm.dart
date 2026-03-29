// feature-first about: ViewModel owns navigation. No business logic; static content.
// Separation of concerns: UI only renders, VM owns goBack for testability.

import 'package:flutter/material.dart';

class AboutViewModel extends ChangeNotifier {
  AboutViewModel({required GlobalKey<NavigatorState> navigatorKey})
    : _navigatorKey = navigatorKey;

  final GlobalKey<NavigatorState> _navigatorKey;

  /// All button logic in VM: AppBar back. Navigator ownership for testability.
  void goBack() {
    _navigatorKey.currentState?.pop();
  }
}
