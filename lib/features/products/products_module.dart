// feature-first: Products. ProductViewModel uses ProductApi.

import 'package:provider/provider.dart';

import 'package:e/core/api/api_service.dart';
import '../auth/viewmodels/auth_vm.dart';
import 'models/product_model.dart';
import 'services/product_service.dart';
import 'viewmodels/product_vm.dart';
import 'views/product_detail_page.dart';
import 'views/product_list_page.dart';
import 'views/product_management_page.dart';

export 'models/product_model.dart';
export 'viewmodels/product_vm.dart';
export 'views/product_detail_page.dart';
export 'views/product_list_page.dart';
export 'views/product_management_page.dart';

ChangeNotifierProvider<ProductViewModel> createProductProvider({
  required void Function() showLoginDialog,
  required void Function(
    ProductModel p,
    String? color,
    String? size,
    double price,
  )
  navigateToCheckoutForProduct,
}) {
  return ChangeNotifierProvider<ProductViewModel>(
    create: (context) => ProductViewModel(
      api: ProductApi(api: context.read<ApiService>()),
      authVm: context.read<AuthViewModel>(),
      showLoginDialog: showLoginDialog,
      navigateToCheckoutForProduct: navigateToCheckoutForProduct,
    ),
  );
}
