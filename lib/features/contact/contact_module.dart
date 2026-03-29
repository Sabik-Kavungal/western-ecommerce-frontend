// feature-first contact: Public API. ViewModel owns launch logic; onError via ScaffoldMessenger.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e/core/constants/app_color.dart';
import 'services/contact_service.dart';
import 'viewmodels/contact_vm.dart';
import 'views/contact_page.dart';

export 'viewmodels/contact_vm.dart';
export 'views/contact_page.dart';

ChangeNotifierProvider<ContactViewModel> createContactProvider(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return ChangeNotifierProvider<ContactViewModel>(
    create: (_) => ContactViewModel(
      contactService: ContactService(),
      navigatorKey: navigatorKey,
      onError: (msg) {
        final ctx = navigatorKey.currentContext;
        if (ctx != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: AppColors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          );
        }
      },
    ),
  );
}
