import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e/core/api/api_service.dart';
import 'features/about/about_module.dart';
import 'features/admin/admin_module.dart';
import 'features/auth/auth_module.dart';
import 'features/auth/views/address_page.dart';
import 'features/auth/views/edit_profile_page.dart';
import 'features/cart/cart_module.dart';
import 'features/contact/contact_module.dart';
import 'features/checkout/checkout_module.dart';
import 'features/orders/orders_module.dart';
import 'features/orders/services/order_api.dart';
import 'features/orders/views/customer_order_detail_page.dart';
import 'features/orders/views/my_orders_page.dart';
import 'features/privacy/privacy_module.dart';
import 'features/products/products_module.dart';
import 'utils/app_theme.dart';
import 'views/admin_home_page.dart';
import 'views/home_page.dart';
import 'views/profile_page.dart';
import 'widgets/login_dialog.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set system UI overlay style for a premium look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final navKey = GlobalKey<NavigatorState>();
  runApp(MyApp(prefs: prefs, navigatorKey: navKey));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.prefs, required this.navigatorKey});

  final SharedPreferences prefs;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        createAuthProvider(prefs: prefs, navigatorKey: navigatorKey),
        Provider<CustomerApi>(
          create: (ctx) => CustomerApi(apiService: ctx.read<ApiService>()),
        ),
        Provider<OrderApi>(
          create: (ctx) => OrderApi(apiService: ctx.read<ApiService>()),
        ),
        createProductProvider(
          showLoginDialog: () {
            final c = navigatorKey.currentContext;
            if (c != null)
              showDialog(
                context: c,
                barrierDismissible: true,
                builder: (_) => const LoginDialog(),
              );
          },
          navigateToCheckoutForProduct: (p, color, size, price) =>
              navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (_) => CustomerInfoFormPage(
                    items: null,
                    isSingleProduct: true,
                    productId: p.id,
                    productName: p.name,
                    productColor: color,
                    size: size,
                    price: price,
                    quantity: 1,
                  ),
                ),
              ),
        ),
        createCartProvider(),
        createOrderProvider(),
        createAdminApiProvider(),
        createAdminProductProvider(),
        createCategoryProvider(),
        createAdminOrderProvider(),
        createAdminAnalyticsProvider(),
        createCheckoutProvider(navigatorKey),
        createAboutProvider(navigatorKey),
        createContactProvider(navigatorKey),
        createPrivacyProvider(navigatorKey),
      ],
      child: RepaintBoundary(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Westerngram - Premium Western Wear',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: '/',
          // Optimized for Web: Smooth scrolling and consistent mouse behavior
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            scrollbars: true,
          ),
          routes: {
            '/': (context) => const SplashPage(),
            '/home': (context) => const HomePage(),
            '/admin': (context) => const AdminHomePage(),
            '/product-list': (context) => const ProductListPage(),
            '/product-detail': (context) => const ProductDetailPage(),
            '/cart': (context) => const CartPage(),
            '/order-confirmation': (context) => const OrderConfirmationPage(),
            '/about': (context) => const AboutPage(),
            '/contact': (context) => const ContactPage(),
            '/profile': (context) => ProfilePage(),
            '/product-management': (context) => const ProductManagementPage(),
            '/sales-dashboard': (context) => const SalesDashboardPage(),
            '/order-management': (context) => const OrderManagementPage(),
            '/order-detail': (context) {
              final arg = ModalRoute.of(context)?.settings.arguments;
              return OrderDetailPage(orderId: arg is String ? arg : '');
            },
            '/my-orders': (context) => const MyOrdersPage(),
            '/my-order-detail': (context) {
              final arg = ModalRoute.of(context)?.settings.arguments;
              return CustomerOrderDetailPage(orderId: arg is String ? arg : '');
            },
            '/privacy-policy': (context) => const PrivacyPolicyPage(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/edit-profile': (context) => const EditProfilePage(),
            '/address': (context) => const AddressPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name != null &&
                settings.name!.startsWith('/product/')) {
              final uri = Uri.parse(settings.name!);
              final id = uri.pathSegments.last;
              final color = uri.queryParameters['color'];

              return MaterialPageRoute(
                settings: settings,
                builder: (context) => ProductDetailPage(
                  initialProductId: id,
                  initialColor: color,
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
