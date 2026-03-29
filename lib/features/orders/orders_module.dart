// feature-first: Orders. OrderViewModel uses OrderApi + AuthViewModel for loadOrders.

import 'package:provider/provider.dart';

import '../auth/viewmodels/auth_vm.dart';
import 'services/order_api.dart';
import 'viewmodels/order_vm.dart';

export 'models/order_model.dart';
export 'viewmodels/order_vm.dart';
export 'views/order_management_page.dart';
export 'views/order_confirmation_page.dart';
export 'views/order_detail_page.dart';
export 'views/sales_dashboard_page.dart';

ChangeNotifierProvider<OrderViewModel> createOrderProvider() {
  return ChangeNotifierProvider<OrderViewModel>(
    create: (c) => OrderViewModel(
      orderApi: c.read<OrderApi>(),
      authVm: c.read<AuthViewModel>(),
    ),
  );
}
