/// Role and permission string constants matching backend API.
class AppRoles {
  AppRoles._();

  static const String customer = 'customer';
  static const String businessAdmin = 'business_admin';
}

/// Permission strings from backend (e.g. user.permissions, /auth/register response).
class AppPermissions {
  AppPermissions._();

  // Product
  static const String viewProducts = 'view_products';
  static const String viewProductDetails = 'view_product_details';
  static const String readProducts = 'read:products';

  // Cart
  static const String addToCart = 'add_to_cart';
  static const String viewCart = 'view_cart';
  static const String updateCart = 'update_cart';
  static const String removeFromCart = 'remove_from_cart';

  // Orders
  static const String createOrder = 'create_order';
  static const String createOrders = 'create:orders';
  static const String viewOwnOrders = 'view_own_orders';

  // Profile
  static const String viewOwnProfile = 'view_own_profile';
  static const String updateOwnProfile = 'update_own_profile';
}
