// feature-first contact: ViewModel owns navigation and launch actions.
// UI only binds buttons to VM; VM calls service, reports errors via onError.

import 'package:flutter/material.dart';

import '../services/contact_service.dart';

class ContactViewModel extends ChangeNotifier {
  ContactViewModel({
    required ContactService contactService,
    required GlobalKey<NavigatorState> navigatorKey,
    void Function(String message)? onError,
  }) : _contactService = contactService,
       _navigatorKey = navigatorKey,
       _onError = onError;

  final ContactService _contactService;
  final GlobalKey<NavigatorState> _navigatorKey;
  final void Function(String message)? _onError;

  void goBack() {
    _navigatorKey.currentState?.pop();
  }

  /// All button logic in VM. Calls service; on failure invokes onError.
  Future<void> launchWhatsApp() async {
    try {
      await _contactService.launchWhatsAppForContact();
    } catch (e) {
      _onError?.call('Error: $e');
    }
  }

  Future<void> launchInstagram() async {
    try {
      await _contactService.launchInstagram();
    } catch (e) {
      _onError?.call('Error: $e');
    }
  }
}
