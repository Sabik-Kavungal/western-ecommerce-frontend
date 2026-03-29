// Admin feature: API, view models, providers. For business_admin only.

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:e/core/api/api_service.dart';

import '../auth/viewmodels/auth_vm.dart';
import 'services/admin_api.dart';
import 'viewmodels/admin_analytics_vm.dart';
import 'viewmodels/admin_order_vm.dart';
import 'viewmodels/admin_product_vm.dart';
import 'viewmodels/category_vm.dart';

export 'models/analytics_models.dart';
export 'models/api_order_model.dart';
export 'services/admin_api.dart';
export 'viewmodels/admin_analytics_vm.dart';
export 'viewmodels/admin_order_vm.dart';
export 'viewmodels/admin_product_vm.dart';
export 'viewmodels/category_vm.dart';

Provider<AdminApi> createAdminApiProvider() {
  return Provider<AdminApi>(
    create: (c) => AdminApi(apiService: c.read<ApiService>()),
  );
}

ChangeNotifierProvider<AdminProductViewModel> createAdminProductProvider() {
  return ChangeNotifierProvider<AdminProductViewModel>(
    create: (c) => AdminProductViewModel(
      api: c.read<AdminApi>(),
      getToken: () => c.read<AuthViewModel>().token,
      pickImages: () async => await ImagePicker().pickMultiImage(),
    ),
  );
}

ChangeNotifierProvider<AdminOrderViewModel> createAdminOrderProvider() {
  return ChangeNotifierProvider<AdminOrderViewModel>(
    create: (c) => AdminOrderViewModel(
      api: c.read<AdminApi>(),
      getToken: () => c.read<AuthViewModel>().token,
    ),
  );
}

ChangeNotifierProvider<AdminAnalyticsViewModel> createAdminAnalyticsProvider() {
  return ChangeNotifierProvider<AdminAnalyticsViewModel>(
    create: (c) => AdminAnalyticsViewModel(
      api: c.read<AdminApi>(),
      getToken: () => c.read<AuthViewModel>().token,
    ),
  );
}

ChangeNotifierProvider<CategoryViewModel> createCategoryProvider() {
  return ChangeNotifierProvider<CategoryViewModel>(
    create: (c) => CategoryViewModel(
      api: c.read<AdminApi>(),
      getToken: () => c.read<AuthViewModel>().token,
    ),
  );
}
