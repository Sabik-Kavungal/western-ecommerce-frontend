// feature-first contact: External actions (WhatsApp, Instagram). Testability via DI.

import 'package:url_launcher/url_launcher.dart';

import '../../../services/whatsapp_service.dart';
import '../../../utils/constants.dart';

class ContactService {
  /// Launches WhatsApp for general contact. Throws on failure.
  Future<void> launchWhatsAppForContact({
    String? phoneNumber,
    String? message,
  }) async {
    await WhatsAppService.launchWhatsAppForContact(
      phoneNumber: phoneNumber,
      message: message,
    );
  }

  /// Launches Instagram profile. Throws on failure.
  Future<void> launchInstagram() async {
    final url = 'https://instagram.com/${Constants.instagramHandle}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Instagram';
    }
  }
}
