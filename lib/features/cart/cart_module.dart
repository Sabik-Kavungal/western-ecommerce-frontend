// feature-first: Cart feature API.

import 'package:provider/provider.dart';

import 'package:e/core/api/api_service.dart';
import '../auth/viewmodels/auth_vm.dart';
import 'services/cart_api.dart';
import 'viewmodels/cart_vm.dart';

export 'models/cart_item_model.dart';
export 'viewmodels/cart_vm.dart';
export 'views/cart_page.dart';

ChangeNotifierProvider<CartViewModel> createCartProvider() {
  return ChangeNotifierProvider<CartViewModel>(
    create: (ctx) => CartViewModel(
      cartApi: CartApi(apiService: ctx.read<ApiService>()),
      authVm: ctx.read<AuthViewModel>(),
    ),
  );
}
