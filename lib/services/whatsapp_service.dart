import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';

class WhatsAppService {
  static Future<void> launchWhatsAppForContact({
    String? phoneNumber,
    String? message,
  }) async {
    final phone = phoneNumber ?? Constants.whatsappNumber;
    final text =
        message ?? 'Hello! I would like to know more about your products.';
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(text)}';

    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (e) {
      throw 'Could not launch WhatsApp: $e';
    }
  }
}
