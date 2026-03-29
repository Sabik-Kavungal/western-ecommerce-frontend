/// App constants: pricing, delivery, API, contact. No colors (see [AppColors]).
class Constants {
  Constants._();

  // ----- Pricing -----
  static const double baseCost = 250.0;
  static const double onlinePrice = 400.0;
  static const double commissionFee = 50.0;
  static const double fixedPrice = 400.0;

  // ----- Contact / payments -----
  static const String whatsappNumber = '918317351027';
  static const String gpayNumber = '919544383434';
  static const String phonepeNumber = '919544383434';
  static const String orderWhatsAppNumber = '918317351027';
  static const String secondaryOrderNumber = '918217027807';
  static const String instagramHandle = 'your_shop_handle';

  // ----- Delivery -----
  static const String deliveryDays = '3 working days';

  // ----- API -----
  static const String apiBaseUrl = 'https://api.westerngram.net/api/v1';
  //static const String apiBaseUrl = 'http://172.20.10.7:8080/api/v1';
  /// Origin for resolving image paths like /uploads/xxx to full URL.
  static String get apiOrigin => Uri.parse(apiBaseUrl).origin;
}
