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
import 'package:jasa_jahit_aplication/src/model/order_model.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                  child: StreamBuilder<List<model.Order>>(
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
                              ?.where(
                                (order) =>
                                    order.status.toLowerCase().contains(
                                      'selesai',
                                    ) ||
                                    order.status.toLowerCase().contains(
                                      'batal',
                                    ),
                              )
                              .where((order) {
                                final query = _searchQuery.toLowerCase();
                                final firstItem = (order.items.isNotEmpty)
                                    ? order.items[0]
                                    : {};
                                final orderType = (firstItem['orderType'] ?? '')
                                    .toString();
                                final model = (firstItem['model'] ?? '')
                                    .toString();
                                final userName = order.userName.toString();
                                return orderType.toLowerCase().contains(
                                      query,
                                    ) ||
                                    model.toLowerCase().contains(query) ||
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
                          final model = firstItem['model'] ?? '-';
                          final price = firstItem['price'] ?? 0;
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
                                            'Rp ${price.toString()}',
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
                                            final newOrder = model.Order(
                                              id: null,
                                              userId: userId,
                                              userName: order.userName,
                                              orderType: orderType,
                                              measurements: order.measurements,
                                              fabric: order.fabric,
                                              model: model,
                                              price: price,
                                              status: 'Menunggu Konfirmasi',
                                              orderDate: Timestamp.now(),
                                              items: [],
                                            );
                                            await FirestoreService().saveOrder(
                                              newOrder,
                                            );
                                            if (mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Pesanan berhasil diulang!',
                                                  ),
                                                ),
                                              );
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
