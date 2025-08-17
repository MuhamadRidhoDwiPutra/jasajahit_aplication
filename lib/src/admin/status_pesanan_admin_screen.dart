import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/admin/cek_detail_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart'
    as order_model;
import 'package:jasa_jahit_aplication/src/page/notification_screen.dart';
import 'package:jasa_jahit_aplication/Core/provider/notification_provider.dart';

class StatusPesananAdminScreen extends StatefulWidget {
  const StatusPesananAdminScreen({super.key});

  @override
  State<StatusPesananAdminScreen> createState() =>
      _StatusPesananAdminScreenState();
}

class _StatusPesananAdminScreenState extends State<StatusPesananAdminScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> statusOptions = [
    'Menunggu Konfirmasi',
    'Sedang dikerjakan',
    'Pesanan Dikonfirmasi',
    'Pesanan telah selesai',
    'Pesanan Dibatalkan',
  ];

  Color getStatusColor(String status) {
    status = status.toLowerCase();
    if (status.contains('menunggu konfirmasi')) {
      return Colors.orange; // #FFA500
    } else if (status.contains('dikonfirmasi')) {
      return Colors.blue; // #2196F3
    } else if (status.contains('sedang dikerjakan')) {
      return Colors.amber; // #FFC107
    } else if (status.contains('selesai')) {
      return Colors.green; // #4CAF50
    } else if (status.contains('batal')) {
      return Colors.red; // #F44336
    }
    return Colors.grey; // Default
  }

  // Fungsi untuk mendapatkan data customer yang benar
  Future<Map<String, String>> _getCustomerData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return {
          'name': userData['name'] ?? userData['username'] ?? 'Tanpa Nama',
          'username':
              userData['username'] ?? userData['email'] ?? 'Tanpa Username',
          'address': userData['address'] ?? 'Alamat belum diisi',
        };
      }
    } catch (e) {
      print('Error getting customer data: $e');
    }
    return {
      'name': 'Tanpa Nama',
      'username': 'Tanpa Username',
      'address': 'Alamat belum diisi',
    };
  }

  // Fungsi untuk format tanggal yang aman
  String _formatOrderDate(dynamic orderDate) {
    try {
      if (orderDate is Timestamp) {
        return orderDate.toDate().toString().substring(0, 19);
      } else if (orderDate is DateTime) {
        return orderDate.toString().substring(0, 19);
      } else {
        return 'Tanggal tidak tersedia';
      }
    } catch (e) {
      print('Error formatting date: $e');
      return 'Tanggal tidak tersedia';
    }
  }

  Future<void> _updateOrderStatus(String docId, String status) async {
    try {
      // Update status di Firestore
      await _firestore.collection('orders').doc(docId).update({
        'status': status,
      });

      // Ambil data order untuk notifikasi
      final orderDoc = await _firestore.collection('orders').doc(docId).get();
      final orderData = orderDoc.data() as Map<String, dynamic>;

      // Kirim notifikasi ke customer
      print(
        '🔄 Admin updating order status, sending notification to customer...',
      );
      print('📝 Order details: $docId, ${orderData['userId']}, $status');

      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );

      try {
        await notificationProvider.sendStatusUpdateNotificationToCustomer(
          orderId: docId,
          customerId: orderData['userId'] ?? '',
          newStatus: status,
          orderType: orderData['items']?[0]?['orderType'] ?? 'pakaian',
        );

        // Reload notifications untuk admin
        await notificationProvider.loadNotificationsFromFirestore('admin');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Status berhasil diubah dan notifikasi dikirim ke customer',
            ),
            backgroundColor: Colors.green,
          ),
        );

        print('✅ Status update notification sent successfully');
      } catch (e) {
        print('❌ Error sending status update notification: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Status berhasil diubah! Error mengirim notifikasi: $e',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui status: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    // Update status lama "Pesanan Diterima" ke "Pesanan telah selesai"
    _updateOldStatuses();
  }

  // Fungsi untuk mengupdate status lama "Pesanan Diterima" ke "Pesanan telah selesai"
  Future<void> _updateOldStatuses() async {
    try {
      final ordersRef = FirebaseFirestore.instance.collection('orders');
      final oldStatusQuery = await ordersRef
          .where('status', isEqualTo: 'Pesanan Diterima')
          .get();

      if (oldStatusQuery.docs.isNotEmpty) {
        print(
          '🔄 Updating ${oldStatusQuery.docs.length} orders with old status "Pesanan Diterima"',
        );

        for (var doc in oldStatusQuery.docs) {
          await doc.reference.update({
            'status': 'Pesanan telah selesai',
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        print(
          '✅ Successfully updated ${oldStatusQuery.docs.length} orders to "Pesanan telah selesai"',
        );

        // Tampilkan snackbar untuk konfirmasi
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ ${oldStatusQuery.docs.length} pesanan berhasil diupdate dari "Pesanan Diterima" ke "Pesanan telah selesai"',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error updating old statuses: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error mengupdate status: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Column(
          children: [
            // Header dihapus sepenuhnya
            // Content area
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('orders').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final orders = snapshot.data!.docs;

                  if (orders.isEmpty) {
                    return const Center(child: Text('Belum ada pesanan.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final orderData = order.data() as Map<String, dynamic>;
                      final String currentStatus =
                          orderData['status'] ?? 'Menunggu Konfirmasi';

                      // Ensure currentStatus is a valid option
                      final statusValue = statusOptions.contains(currentStatus)
                          ? currentStatus
                          : statusOptions.first;

                      return FutureBuilder<Map<String, String>>(
                        future: _getCustomerData(orderData['userId'] ?? ''),
                        builder: (context, customerSnapshot) {
                          final customerData =
                              customerSnapshot.data ??
                              {
                                'name':
                                    orderData['customerName'] ??
                                    orderData['userName'] ??
                                    'Tanpa Nama',
                                'username':
                                    orderData['userName'] ?? 'Tanpa Username',
                                'address':
                                    orderData['customerAddress'] ??
                                    'Alamat belum diisi',
                              };

                          return Card(
                            color: isDark
                                ? const Color(0xFF2A2A2A)
                                : Colors.white,
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Kode: ${order.id}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getStatusColor(
                                            currentStatus,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          currentStatus,
                                          style: TextStyle(
                                            color: getStatusColor(
                                              currentStatus,
                                            ),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: isDark
                                        ? Colors.white24
                                        : Colors.black12,
                                    height: 24,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF8FBC8F,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.shopping_bag,
                                            size: 40,
                                            color: Color(0xFF8FBC8F),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Nama Pelanggan',
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              customerData['name'] ??
                                                  'Tanpa Nama',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Username',
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              customerData['username'] ??
                                                  'Tanpa Username',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Alamat',
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              customerData['address'] ??
                                                  'Alamat belum diisi',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Tanggal Pesan',
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              _formatOrderDate(
                                                orderData['orderDate'],
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: DropdownButton<String>(
                                          value: statusValue,
                                          isExpanded: true,
                                          dropdownColor: isDark
                                              ? const Color(0xFF2A2A2A)
                                              : Colors.white,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          items: statusOptions
                                              .map(
                                                (status) => DropdownMenuItem(
                                                  value: status,
                                                  child: Text(status),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              _updateOrderStatus(
                                                order.id,
                                                value,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFDE8500,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                        ),
                                        onPressed: () {
                                          // Buat Order object dari data Firestore dengan penanganan error yang lebih baik
                                          try {
                                            final orderObj =
                                                order_model.Order.fromMap(
                                                  orderData,
                                                  order.id,
                                                );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CekDetailAdminScreen(
                                                      order: orderObj,
                                                      orderCode: order.id,
                                                      model:
                                                          orderObj.model ?? '',
                                                      fabricType:
                                                          orderObj.fabric ?? '',
                                                      productQuantity:
                                                          orderObj.items.length,
                                                      orderDate: _formatOrderDate(
                                                        orderData['orderDate'],
                                                      ),
                                                      measurements:
                                                          orderObj
                                                              .measurements ??
                                                          {},
                                                      orderType:
                                                          orderObj.orderType ??
                                                          '',
                                                    ),
                                              ),
                                            );
                                          } catch (e) {
                                            print(
                                              'Error creating Order object: $e',
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Error membuka detail: $e',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          'Cek Detail',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
