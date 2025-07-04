import 'package:url_launcher/url_launcher.dart';

class WhatsAppChatHelper {
  static Future<void> openWhatsAppChat() async {
    const phone = '6281339918892'; // Nomor admin tanpa tanda +
    const message = 'Halo, saya ingin bertanya tentang layanan jahit.';
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Tidak dapat membuka WhatsApp.');
    }
  }
}
