// feature-first payment: GET /payment/info.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/payment_api.dart';
import 'viewmodels/payment_vm.dart';
import 'views/payment_page.dart';

export 'viewmodels/payment_vm.dart';
export 'views/payment_page.dart';

ChangeNotifierProvider<PaymentViewModel> createPaymentProvider(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return ChangeNotifierProvider<PaymentViewModel>(
    create: (c) => PaymentViewModel(
      navigatorKey: navigatorKey,
      paymentApi: c.read<PaymentApi>(),
    ),
  );
}
