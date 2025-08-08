import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';

class RiwayatTransaksiAdminScreen extends StatefulWidget {
  const RiwayatTransaksiAdminScreen({super.key});

  @override
  State<RiwayatTransaksiAdminScreen> createState() =>
      _RiwayatTransaksiAdminScreenState();
}

class _RiwayatTransaksiAdminScreenState
    extends State<RiwayatTransaksiAdminScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = '';

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        elevation: 1,
        title: Text(
          'Riwayat Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari berdasarkan kode atau nama...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey[400],
                      ),
                      fillColor: isDark
                          ? const Color(0xFF3A3A3A)
                          : Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
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

                var filteredDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final userName = (data['userName'] as String? ?? '')
                      .toLowerCase();
                  final orderId = doc.id.toLowerCase();
                  return userName.contains(searchQuery) ||
                      orderId.contains(searchQuery);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada transaksi ditemukan.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final order = filteredDocs[index];
                    final orderData = order.data() as Map<String, dynamic>;

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
                                        color: const Color(
                                          0xFFDE8500,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        orderData['status'] ?? 'N/A',
                                        style: const TextStyle(
                                          color: Color(0xFFDE8500),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF8FBC8F,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          orderData['items']?[0]?['orderType'] ??
                                              'Baju',
                                          style: const TextStyle(
                                            color: Color(0xFF8FBC8F),
                                          ),
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Total: Rp ${(orderData['estimatedPrice'] ?? orderData['totalPrice'] ?? orderData['price'] ?? 0).toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
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
    );
  }
}
