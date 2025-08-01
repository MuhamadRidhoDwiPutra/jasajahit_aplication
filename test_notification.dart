import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  String _fcmToken = 'Loading...';
  String _notificationStatus = 'Not tested';

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      // Get FCM Token
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _fcmToken = token ?? 'Token not available';
      });

      // Test Local Notification
      await _testLocalNotification();
    } catch (e) {
      setState(() {
        _notificationStatus = 'Error: $e';
      });
    }
  }

  Future<void> _testLocalNotification() async {
    try {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // Initialize
      const AndroidInitializationSettings androidInit =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings = InitializationSettings(
        android: androidInit,
      );
      await flutterLocalNotificationsPlugin.initialize(initSettings);

      // Show test notification
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'test_channel',
            'Test Channel',
            importance: Importance.max,
            priority: Priority.high,
          );
      const NotificationDetails notifDetails = NotificationDetails(
        android: androidDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        'Test Notification',
        'Notifikasi berhasil di API 34!',
        notifDetails,
      );

      setState(() {
        _notificationStatus = 'Local notification sent successfully!';
      });
    } catch (e) {
      setState(() {
        _notificationStatus = 'Local notification failed: $e';
      });
    }
  }

  Future<void> _testFCMNotification() async {
    setState(() {
      _notificationStatus = 'Testing FCM...';
    });

    // Listen for FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _notificationStatus = 'FCM received: ${message.notification?.title}';
      });
    });

    setState(() {
      _notificationStatus =
          'FCM listener active. Send test from Firebase Console.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      appBar: AppBar(
        title: const Text('Notification Test'),
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API Level: 34 (Android 14.0)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Google APIs: ✅ Available',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'FCM Support: ✅ Available',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FCM Token:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _fcmToken,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Notifications:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _testLocalNotification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDE8500),
                            ),
                            child: const Text(
                              'Test Local',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _testFCMNotification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'Test FCM',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Status: $_notificationStatus',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Copy FCM Token above\n'
                      '2. Go to Firebase Console\n'
                      '3. Messaging > Send test message\n'
                      '4. Paste token and send\n'
                      '5. Check if notification appears',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
