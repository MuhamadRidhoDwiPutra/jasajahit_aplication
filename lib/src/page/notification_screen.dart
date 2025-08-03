import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/Core/provider/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifikasi dari Firestore saat screen dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      await notificationProvider.loadNotificationsFromFirestore('customer');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<NotificationProvider>(
      builder: (context, notifProvider, _) {
        final notifications = notifProvider.notifications;
        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF1A1A1A)
              : const Color(0xFF8FBC8F),
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFDE8500).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFFDE8500),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Notifikasi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                            fontFamily: 'SF Pro Display',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (notifications.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_sweep,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Hapus Semua Notifikasi'),
                                  content: const Text(
                                    'Apakah Anda yakin ingin menghapus semua notifikasi?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        notifProvider.clearNotifications();
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Hapus',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      // Tombol refresh notifikasi
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: Color(0xFF2196F3),
                          ),
                          onPressed: () async {
                            await notifProvider.loadNotificationsFromFirestore(
                              'customer',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notifikasi diperbarui!'),
                                backgroundColor: Color(0xFF2196F3),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: notifications.isEmpty
                      ? _buildEmptyState(isDark)
                      : _buildNotificationList(notifications, isDark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.notifications_none,
              size: 60,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Notifikasi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
              fontFamily: 'SF Pro Display',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifikasi akan muncul di sini\nketika ada pesan baru',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.black54,
              fontFamily: 'SF Pro Text',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List notifications, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notif = notifications[notifications.length - 1 - index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFDE8500).withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.notifications_active,
                color: Color(0xFFDE8500),
                size: 24,
              ),
            ),
            title: Text(
              notif.notification?.title ?? 'Notifikasi',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
                fontFamily: 'SF Pro Display',
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  notif.notification?.body ?? 'Tidak ada pesan',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatTimestamp(notif.sentTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black38,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
              onPressed: () {
                // TODO: Implement notification actions (mark as read, delete, etc.)
              },
            ),
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return 'Baru saja';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }
}
