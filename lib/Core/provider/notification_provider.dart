import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added for currentUser

class NotificationProvider extends ChangeNotifier {
  List<RemoteMessage> _notifications = [];
  String? _fcmToken;

  List<RemoteMessage> get notifications => _notifications;
  String? get fcmToken => _fcmToken;

  // Fungsi untuk setup Firebase Messaging
  void setupFirebaseMessaging(BuildContext context) {
    // Request permission
    FirebaseMessaging.instance.requestPermission();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.notification?.title}');
      _notifications.add(message);
      notifyListeners();
    });

    // Listen for background messages when app is opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
        'App opened from background message: ${message.notification?.title}',
      );
      _notifications.add(message);
      notifyListeners();
    });

    // Check for initial message when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print(
          'App opened from terminated state: ${message.notification?.title}',
        );
        _notifications.add(message);
        notifyListeners();
      }
    });

    // Get FCM token
    _getFCMToken();
  }

  // Fungsi untuk mendapatkan FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken();
      print('🔥 FCM Token: $_fcmToken');
      print('📱 Copy token ini untuk testing notifikasi');
      notifyListeners();
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  // Fungsi untuk menyimpan FCM token ke Firestore berdasarkan role
  Future<void> saveFCMTokenToFirestore(String userId, String role) async {
    try {
      await FirebaseFirestore.instance.collection('fcm_tokens').doc(userId).set(
        {
          'token': _fcmToken,
          'role': role, // 'admin' atau 'customer'
          'userId': userId,
          'lastUpdated': FieldValue.serverTimestamp(),
        },
      );
      print('✅ FCM token saved to Firestore for $role: $userId');
    } catch (e) {
      print('❌ Error saving FCM token: $e');
    }
  }

  // Fungsi untuk mengirim notifikasi ke admin saat customer membuat pesanan
  Future<void> sendOrderNotificationToAdmin({
    required String orderId,
    required String customerName,
    required String orderType, // 'baju' atau 'celana'
    required double totalPrice,
  }) async {
    try {
      print('🔄 Sending order notification to admin...');
      print(
        '📝 Order details: $orderId, $customerName, $orderType, $totalPrice',
      );

      // Validasi data sebelum menyimpan
      if (customerName.isEmpty) {
        print('⚠️ Warning: customerName is empty, using default name');
        customerName = 'Customer';
      }

      if (orderId.isEmpty) {
        print('⚠️ Warning: orderId is empty, using default ID');
        orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
      }

      // Simpan notifikasi ke Firestore
      final notificationData = {
        'title': 'Pesanan Baru',
        'body':
            '$customerName telah membuat pesanan $orderType seharga Rp${totalPrice.toStringAsFixed(0)}',
        'orderId': orderId,
        'type': 'new_order',
        'recipientRole': 'admin',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(), // Backup timestamp
      };

      print('📝 Saving notification data: $notificationData');

      final notificationRef = await FirebaseFirestore.instance
          .collection('notifications')
          .add(notificationData);

      print('✅ Notification saved to Firestore with ID: ${notificationRef.id}');

      // Verifikasi data tersimpan
      final savedDoc = await notificationRef.get();
      print('🔍 Verification - Saved data: ${savedDoc.data()}');

      // Tambahkan ke local notifications untuk admin
      final notificationMessage = RemoteMessage(
        notification: RemoteNotification(
          title: 'Pesanan Baru',
          body:
              '$customerName telah membuat pesanan $orderType seharga Rp${totalPrice.toStringAsFixed(0)}',
        ),
        data: {
          'orderId': orderId,
          'type': 'new_order',
          'notificationId': notificationRef.id,
        },
      );

      _notifications.add(notificationMessage);
      notifyListeners();

      print(
        '✅ Order notification added to local list. Total notifications: ${_notifications.length}',
      );
    } catch (e) {
      print('❌ Error sending order notification: $e');
      print('🔍 Error details: ${e.toString()}');
    }
  }

  // Fungsi untuk mengirim notifikasi update status ke customer
  Future<void> sendStatusUpdateNotificationToCustomer({
    required String orderId,
    required String customerId,
    required String newStatus,
    required String orderType,
  }) async {
    try {
      print('📤 Sending status update notification to customer...');
      print('👤 Customer ID: $customerId');
      print('📦 Order ID: $orderId');
      print('🔄 New Status: $newStatus');

      // Buat notifikasi di Firestore
      final notificationRef = await FirebaseFirestore.instance
          .collection('notifications')
          .add({
            'title': 'Update Status Pesanan',
            'body':
                'Status pesanan $orderType Anda telah diubah menjadi: $newStatus',
            'orderId': orderId,
            'customerId': customerId,
            'type': 'status_update',
            'recipientRole': 'customer',
            'recipientId': customerId, // Gunakan customerId yang sebenarnya
            'timestamp': FieldValue.serverTimestamp(),
            'isRead': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      print(
        '✅ Status update notification saved to Firestore with ID: ${notificationRef.id}',
      );

      // Verifikasi data tersimpan
      final savedDoc = await notificationRef.get();
      print('🔍 Verification - Saved status update data: ${savedDoc.data()}');

      // Tambahkan ke local notifications untuk customer
      final notificationMessage = RemoteMessage(
        notification: RemoteNotification(
          title: 'Update Status Pesanan',
          body:
              'Status pesanan $orderType Anda telah diubah menjadi: $newStatus',
        ),
        data: {
          'orderId': orderId,
          'type': 'status_update',
          'notificationId': notificationRef.id,
        },
      );

      _notifications.add(notificationMessage);
      notifyListeners();

      print(
        '✅ Status update notification added to local list. Total notifications: ${_notifications.length}',
      );
    } catch (e) {
      print('❌ Error sending status update notification: $e');
      print('🔍 Error details: ${e.toString()}');
    }
  }

  // Fungsi untuk mendapatkan token admin
  Future<List<String>> _getAdminTokens() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('fcm_tokens')
          .where('role', isEqualTo: 'admin')
          .get();

      return snapshot.docs.map((doc) => doc.data()['token'] as String).toList();
    } catch (e) {
      print('❌ Error getting admin tokens: $e');
      return [];
    }
  }

  // Fungsi untuk mendapatkan token customer
  Future<String?> _getCustomerToken(String customerId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('fcm_tokens')
          .doc(customerId)
          .get();

      return doc.data()?['token'] as String?;
    } catch (e) {
      print('❌ Error getting customer token: $e');
      return null;
    }
  }

  // Fungsi untuk mendapatkan notifikasi dari Firestore
  Future<List<Map<String, dynamic>>> getNotificationsFromFirestore(
    String userId,
    String role,
  ) async {
    try {
      print(
        '🔍 Querying Firestore for notifications with role: $role, userId: $userId',
      );

      Query query = FirebaseFirestore.instance.collection('notifications');

      // Jika role adalah customer, filter berdasarkan recipientId (userId)
      if (role == 'customer' && userId.isNotEmpty) {
        query = query.where('recipientId', isEqualTo: userId);
      } else {
        // Untuk admin, filter berdasarkan recipientRole
        query = query.where('recipientRole', isEqualTo: role);
      }

      final snapshot = await query.limit(50).get();

      print(
        '📊 Found ${snapshot.docs.length} notifications in Firestore for role: $role, userId: $userId',
      );

      final notifications = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        print('📝 Notification data: ${data['title']} - ${data['body']}');
        return data;
      }).toList();

      // Sort manually jika orderBy gagal
      notifications.sort((a, b) {
        final timestampA = a['timestamp'] as Timestamp?;
        final timestampB = b['timestamp'] as Timestamp?;
        if (timestampA == null || timestampB == null) return 0;
        return timestampB.compareTo(timestampA); // descending
      });

      return notifications;
    } catch (e) {
      print('❌ Error getting notifications: $e');
      print('🔧 Trying alternative query without orderBy...');

      try {
        // Fallback query tanpa orderBy
        Query query = FirebaseFirestore.instance.collection('notifications');

        // Jika role adalah customer, filter berdasarkan recipientId (userId)
        if (role == 'customer' && userId.isNotEmpty) {
          query = query.where('recipientId', isEqualTo: userId);
        } else {
          // Untuk admin, filter berdasarkan recipientRole
          query = query.where('recipientRole', isEqualTo: role);
        }

        final snapshot = await query.limit(50).get();

        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
      } catch (fallbackError) {
        print('❌ Fallback query also failed: $fallbackError');
        return [];
      }
    }
  }

  // Fungsi untuk load notifikasi dari Firestore ke local list
  Future<void> loadNotificationsFromFirestore(String role) async {
    try {
      print('🔄 Loading notifications from Firestore for $role...');

      String userId = '';
      // Jika role adalah customer, ambil userId dari Firebase Auth
      if (role == 'customer') {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          userId = currentUser.uid;
          print('👤 Current user ID: $userId');
        } else {
          print('⚠️ No current user found for customer notifications');
          return;
        }
      }

      final notifications = await getNotificationsFromFirestore(userId, role);
      print('📊 Found ${notifications.length} notifications in Firestore');

      // Clear existing notifications
      _notifications.clear();

      // Convert Firestore notifications to RemoteMessage
      for (final notification in notifications) {
        print('📝 Processing notification: ${notification['title']}');

        final remoteMessage = RemoteMessage(
          notification: RemoteNotification(
            title: notification['title'] ?? '',
            body: notification['body'] ?? '',
          ),
          data: {
            'orderId': notification['orderId'] ?? '',
            'type': notification['type'] ?? '',
            'notificationId': notification['id'] ?? '',
          },
        );
        _notifications.add(remoteMessage);
      }

      notifyListeners();
      print(
        '✅ Loaded ${_notifications.length} notifications from Firestore for $role',
      );
    } catch (e) {
      print('❌ Error loading notifications: $e');
    }
  }

  // Fungsi untuk refresh notifikasi dari Firestore
  Future<void> refreshNotifications(String role) async {
    await loadNotificationsFromFirestore(role);
  }

  // Fungsi untuk cek semua notifikasi di Firestore
  Future<void> checkAllNotifications() async {
    try {
      print('🔍 Checking all notifications in Firestore...');

      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .get();

      print('📊 Total notifications in Firestore: ${snapshot.docs.length}');

      for (final doc in snapshot.docs) {
        final data = doc.data();
        print('📝 Notification ID: ${doc.id}');
        print('   Title: ${data['title']}');
        print('   Body: ${data['body']}');
        print('   Role: ${data['recipientRole']}');
        print('   Type: ${data['type']}');
        print('   Timestamp: ${data['timestamp']}');
        print('   ---');
      }
    } catch (e) {
      print('❌ Error checking all notifications: $e');
    }
  }

  // Fungsi untuk menandai notifikasi sebagai sudah dibaca
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('❌ Error marking notification as read: $e');
    }
  }

  // Fungsi untuk menghapus semua notifikasi
  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Fungsi untuk menambahkan remote message (untuk NotificationService)
  void addRemoteMessage(RemoteMessage message) {
    _notifications.add(message);
    notifyListeners();
  }

  // Fungsi untuk menambahkan notifikasi test (hanya untuk admin)
  void addTestNotification() {
    const testMessage = RemoteMessage(
      notification: RemoteNotification(
        title: 'Test Notifikasi',
        body: 'Ini adalah notifikasi test dari aplikasi',
      ),
      data: {'orderId': 'test-123', 'type': 'test'},
    );
    _notifications.add(testMessage);
    notifyListeners();
    print(
      'Test notification added. Total notifications: ${_notifications.length}',
    );
  }

  // Fungsi untuk menambahkan notifikasi dengan data custom
  void addCustomNotification(
    String title,
    String body, {
    Map<String, dynamic>? data,
  }) {
    final customMessage = RemoteMessage(
      notification: RemoteNotification(title: title, body: body),
      data: data ?? {},
    );
    _notifications.add(customMessage);
    notifyListeners();
  }
}
