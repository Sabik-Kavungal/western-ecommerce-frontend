// feature-first: Checkout. CheckoutViewModel uses OrderApi, CustomerApi, CartViewModel, AuthViewModel.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/viewmodels/auth_vm.dart';
import '../auth/services/customer_api.dart';
import '../cart/viewmodels/cart_vm.dart';
import '../orders/services/order_api.dart';
import 'viewmodels/checkout_vm.dart';

export 'models/customer_info_model.dart';
export 'viewmodels/checkout_vm.dart';
export 'views/customer_info_form_page.dart';

ChangeNotifierProvider<CheckoutViewModel> createCheckoutProvider(
  GlobalKey<NavigatorState> navKey,
) {
  return ChangeNotifierProvider<CheckoutViewModel>(
    create: (c) => CheckoutViewModel(
      orderApi: c.read<OrderApi>(),
      customerApi: c.read<CustomerApi>(),
      cartVm: c.read<CartViewModel>(),
      authVm: c.read<AuthViewModel>(),
      navigatorKey: navKey,
    ),
  );
}
