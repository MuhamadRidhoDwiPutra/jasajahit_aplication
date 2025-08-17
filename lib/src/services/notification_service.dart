// TODO: Pastikan sudah menambahkan dependency berikut di pubspec.yaml:
// firebase_messaging: ^14.0.0
// flutter_local_notifications: ^16.0.0
// firebase_core: ^2.0.0
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:jasa_jahit_aplication/Core/provider/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize(BuildContext context) async {
    // Inisialisasi local notification
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          _showPopup(context, response.payload!);
        }
      },
    );

    // Request permission (iOS)
    await _messaging.requestPermission();

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showSimpleNotification(
        Text(message.notification?.title ?? 'Notifikasi'),
        subtitle: Text(message.notification?.body ?? ''),
        background: Colors.green,
        duration: const Duration(seconds: 3),
      );
      // Simpan notifikasi ke provider
      final provider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      provider.addRemoteMessage(message);
      _showLocalNotification(message);
    });

    // Background (app dibuka dari notifikasi)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final provider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      provider.addRemoteMessage(message);
      _showPopup(context, message.notification?.body ?? '');
    });

    // Terminated
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final provider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      provider.addRemoteMessage(initialMessage);
      _showPopup(context, initialMessage.notification?.body ?? '');
    }
  }

  static Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    _showLocalNotification(message);
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'order_channel',
          'Order Notifications',
          importance: Importance.max,
          priority: Priority.high,
        );
    const NotificationDetails notifDetails = NotificationDetails(
      android: androidDetails,
    );
    await _localNotifications.show(
      0,
      message.notification?.title ?? 'Notifikasi',
      message.notification?.body ?? '',
      notifDetails,
      payload: message.data['orderId'] ?? '',
    );
  }

  static void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detail Notifikasi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mengirim notifikasi ke admin saat customer membeli model
  static Future<void> sendModelPurchaseNotification({
    required String customerName,
    required String productName,
    required String orderId,
    required double price,
  }) async {
    try {
      // Simpan notifikasi ke Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'recipientId': 'admin_001',
        'title': 'Pembelian Model Baru',
        'body': '$customerName telah membeli $productName seharga Rp ${price.toStringAsFixed(0)}',
        'type': 'model_purchase',
        'orderId': orderId,
        'customerName': customerName,
        'productName': productName,
        'price': price,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      print('Notifikasi pembelian model berhasil dikirim ke admin');
    } catch (e) {
      print('Error mengirim notifikasi pembelian model: $e');
    }
  }

  // Fungsi untuk mengirim notifikasi ke admin saat customer pesan jasa jahit
  static Future<void> sendJasaJahitNotification({
    required String customerName,
    required String orderType,
    required String orderId,
    required double price,
  }) async {
    try {
      // Simpan notifikasi ke Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'recipientId': 'admin_001',
        'title': 'Pemesanan Jasa Jahit Baru',
        'body': '$customerName telah memesan $orderType seharga Rp ${price.toStringAsFixed(0)}',
        'type': 'jasa_jahit',
        'orderId': orderId,
        'customerName': customerName,
        'orderType': orderType,
        'price': price,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      print('Notifikasi pemesanan jasa jahit berhasil dikirim ke admin');
    } catch (e) {
      print('Error mengirim notifikasi pemesanan jasa jahit: $e');
    }
  }
}
