import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/customer/home_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/profile_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/status_pesanan_customer_screen.dart';
import 'desain_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';
import 'package:jasa_jahit_aplication/Core/provider/auth_provider.dart'
    as core_auth;
import 'package:jasa_jahit_aplication/src/model/order_model.dart'
    as order_model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jasa_jahit_aplication/src/customer/pembayaran_baju_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/pembayaran_celana_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/pembayaran_model_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/model/product_model.dart';

class RiwayatCustomerScreen extends StatefulWidget {
  const RiwayatCustomerScreen({super.key});

  @override
  State<RiwayatCustomerScreen> createState() => _RiwayatCustomerScreenState();
}

class _RiwayatCustomerScreenState extends State<RiwayatCustomerScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // ignore: unused_local_variable
    final authProvider = core_auth.AuthProvider();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari pesanan... (nama, model, jenis)',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF2A2A2A)
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<order_model.Order>>(
                    stream: FirestoreService().getOrdersByUserId(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Terjadi kesalahan'));
                      }
                      final orders =
                          snapshot.data
                              ?.where((order) {
                                // Tampilkan semua order (tidak hanya selesai/batal)
                                return true;
                              })
                              .where((order) {
                                final query = _searchQuery.toLowerCase();
                                final firstItem = (order.items.isNotEmpty)
                                    ? order.items[0]
                                    : {};
                                final orderType = (firstItem['orderType'] ?? '')
                                    .toString();
                                final productModel =
                                    (firstItem['jenisBaju'] ??
                                            firstItem['jenisCelana'] ??
                                            firstItem['model'] ??
                                            '')
                                        .toString();
                                final userName = order.userName.toString();
                                return orderType.toLowerCase().contains(
                                      query,
                                    ) ||
                                    productModel.toLowerCase().contains(
                                      query,
                                    ) ||
                                    userName.toLowerCase().contains(query);
                              })
                              .toList() ??
                          [];
                      if (orders.isEmpty) {
                        return Center(
                          child: Text(
                            'Belum ada riwayat pesanan',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final firstItem = (order.items.isNotEmpty)
                              ? order.items[0]
                              : {};
                          final orderType = firstItem['orderType'] ?? '-';
                          final price =
                              order.estimatedPrice?.toDouble() ??
                              order.totalPrice ??
                              firstItem['price'] ??
                              0;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2A2A2A)
                                  : Colors.white,
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
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order.id ?? '-',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.grey,
                                          fontFamily: 'SF Pro Text',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.black12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderType,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: 'SF Pro Display',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Tambahkan detail pesanan
                                      if (firstItem['jenisBaju'] != null ||
                                          firstItem['jenisCelana'] != null) ...[
                                        Text(
                                          'Model: ${firstItem['jenisBaju'] ?? firstItem['jenisCelana'] ?? '-'}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                            fontFamily: 'SF Pro Text',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      if (firstItem['fabric'] != null) ...[
                                        Text(
                                          'Kain: ${firstItem['fabric']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                            fontFamily: 'SF Pro Text',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      if (firstItem['measurements'] !=
                                          null) ...[
                                        Text(
                                          'Ukuran: Custom',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                            fontFamily: 'SF Pro Text',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            order.orderDate
                                                .toDate()
                                                .toString()
                                                .substring(0, 16),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.grey,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                          Text(
                                            'Rp ${_formatCurrency(price)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFDE8500),
                                              fontFamily: 'SF Pro Display',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFDE8500,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.shopping_cart,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            'Pesan Lagi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () async {
                                            print(
                                              'DEBUG: Button Pesan Lagi ditekan',
                                            );
                                            try {
                                              // Tentukan tipe pesanan untuk navigasi yang tepat
                                              final orderType =
                                                  firstItem['orderType'] ?? '';
                                              final productModel =
                                                  firstItem['jenisBaju'] ??
                                                  firstItem['jenisCelana'] ??
                                                  firstItem['model'] ??
                                                  '';
                                              final fabric =
                                                  firstItem['fabric'] ?? '';
                                              final measurements =
                                                  firstItem['measurements'] ??
                                                  {};
                                              final price =
                                                  firstItem['price'] ?? 0;

                                              print(
                                                'DEBUG: orderType = $orderType',
                                              );
                                              print(
                                                'DEBUG: productModel = $productModel',
                                              );
                                              print('DEBUG: price = $price');
                                              print(
                                                'DEBUG: firstItem = $firstItem',
                                              );

                                              // Validasi data
                                              if (orderType.isEmpty) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Data pesanan tidak valid',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                                return;
                                              }

                                              // Buat order baru berdasarkan tipe pesanan
                                              final newOrder = order_model.Order(
                                                id: null,
                                                userId: userId,
                                                userName: order.userName,
                                                items: [
                                                  {
                                                    'orderType': orderType,
                                                    'jenisBaju':
                                                        firstItem['jenisBaju'],
                                                    'jenisCelana':
                                                        firstItem['jenisCelana'],
                                                    'model': productModel,
                                                    'fabric': fabric,
                                                    'measurements':
                                                        measurements,
                                                    'price': price,
                                                  },
                                                ],
                                                status: 'Menunggu Konfirmasi',
                                                orderDate: Timestamp.now(),
                                                totalPrice: price.toDouble(),
                                                estimatedPrice: price.toInt(),
                                              );

                                              print(
                                                'DEBUG: Order baru dibuat: ${newOrder.id}',
                                              );

                                              // Simpan order terlebih dahulu
                                              await FirestoreService()
                                                  .saveOrder(newOrder);

                                              print(
                                                'DEBUG: Order berhasil disimpan',
                                              );

                                              // Navigasi ke screen pembayaran berdasarkan tipe pesanan
                                              if (orderType == 'Baju') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PembayaranBajuCustomerScreen(
                                                          order: newOrder,
                                                        ),
                                                  ),
                                                );
                                              } else if (orderType ==
                                                  'Celana') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PembayaranCelanaCustomerScreen(
                                                          order: newOrder,
                                                        ),
                                                  ),
                                                );
                                              } else {
                                                // Untuk model, gunakan screen model
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PembayaranModelCustomerScreen(
                                                          product: Product(
                                                            id: 'reorder_${DateTime.now().millisecondsSinceEpoch}',
                                                            name: productModel,
                                                            description:
                                                                'Pesanan ulang dari riwayat',
                                                            price: price
                                                                .toDouble(),
                                                            imagePath:
                                                                'assets/images/default_product.jpg',
                                                            category: orderType,
                                                          ),
                                                        ),
                                                  ),
                                                );
                                              }

                                              if (mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Pesanan berhasil dibuat! Silakan lakukan pembayaran.',
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              print(
                                                'DEBUG: Error dalam Pesan Lagi: $e',
                                              );
                                              if (mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Gagal membuat pesanan: $e',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.selesai:
        return Colors.green;
      case OrderStatus.diproses:
        return const Color(0xFFDE8500);
      case OrderStatus.dibatalkan:
        return Colors.red;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.selesai:
        return 'Selesai';
      case OrderStatus.diproses:
        return 'Diproses';
      case OrderStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  String _formatCurrency(double amount) {
    // Format manual untuk currency Indonesia
    final number = amount.toInt();
    final formatted = number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return formatted;
  }
}

enum OrderStatus { selesai, diproses, dibatalkan }

// ignore: unused_element
class _OrderHistory {
  final String id;
  final String item;
  final String date;
  final String total;
  final OrderStatus status;

  _OrderHistory({
    required this.id,
    required this.item,
    required this.date,
    required this.total,
    required this.status,
  });
}

// ignore: unused_element
class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _BottomNavIcon({
    required this.icon,
    required this.label,
    // ignore: unused_element_parameter
    this.onTap,
    // ignore: unused_element_parameter
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive
                ? const Color(0xFFDE8500)
                : (isDark ? Colors.white70 : Colors.grey),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? const Color(0xFFDE8500)
                  : (isDark ? Colors.white70 : Colors.grey),
              fontFamily: 'SF Pro Text',
            ),
          ),
        ],
      ),
    );
  }
}
