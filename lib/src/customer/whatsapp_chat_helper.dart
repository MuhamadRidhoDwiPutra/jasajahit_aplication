import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class WhatsAppChatHelper {
  static Future<void> openWhatsAppChat(BuildContext context) async {
    const phone = '6281339918892'; // Nomor admin tanpa tanda +
    const message = 'Halo, saya ingin bertanya tentang layanan jahit.';
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';

    try {
      // Cek apakah URL bisa dibuka
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        // Jika tidak bisa dibuka, tampilkan dialog dengan opsi
        _showWhatsAppNotAvailableDialog(context, phone, message);
      }
    } catch (e) {
      // Jika ada error, tampilkan dialog dengan opsi
      _showWhatsAppNotAvailableDialog(context, phone, message);
    }
  }

  static void _showWhatsAppNotAvailableDialog(
    BuildContext context,
    String phone,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('WhatsApp Tidak Tersedia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WhatsApp tidak terinstal di perangkat ini atau tidak dapat dibuka.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Opsi yang tersedia:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('1. Install WhatsApp dari Play Store'),
              const Text('2. Buka WhatsApp Web di browser'),
              const Text('3. Hubungi admin via SMS/Telepon'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Buka WhatsApp Web di browser
                _openWhatsAppWeb(phone, message);
              },
              child: const Text('WhatsApp Web'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Buka Play Store untuk install WhatsApp
                _openPlayStore();
              },
              child: const Text('Install WhatsApp'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _openWhatsAppWeb(String phone, String message) async {
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      print('❌ Error opening WhatsApp Web: $e');
    }
  }

  static Future<void> _openPlayStore() async {
    const whatsappPackage = 'com.whatsapp';
    final playStoreUrl = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=$whatsappPackage'
        : 'https://apps.apple.com/app/whatsapp-messenger/id310633997';

    try {
      await launchUrl(
        Uri.parse(playStoreUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print('❌ Error opening Play Store: $e');
    }
  }

  // Fungsi untuk cek apakah WhatsApp terinstal (untuk testing)
  static Future<bool> isWhatsAppInstalled() async {
    const phone = '6281339918892';
    const message = 'Test';
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
    return await canLaunchUrl(Uri.parse(url));
  }
}
