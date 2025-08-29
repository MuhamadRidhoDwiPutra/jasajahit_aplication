import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/customer/cek_detail_status_pesanan_customer_screen.dart';
import 'home_customer_screen.dart';
import 'riwayat_customer_screen.dart';
import 'profile_customer_screen.dart';
import 'desain_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';
import 'package:jasa_jahit_aplication/Core/provider/auth_provider.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class StatusPesananCustomerScreen extends StatelessWidget {
  const StatusPesananCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<model.Order>>(
                stream: FirestoreService().getOrdersByUserId(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Terjadi kesalahan:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  final orders =
                      snapshot.data?.where((order) {
                        final status = order.status.toLowerCase();
                        return status.contains('menunggu konfirmasi') ||
                            status.contains('dikonfirmasi') ||
                            status.contains('sedang dikerjakan');
                      }).toList() ??
                      [];
                  if (orders.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada pesanan berjalan',
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
                      final model =
                          firstItem['jenisBaju'] ??
                          firstItem['jenisCelana'] ??
                          firstItem['model'] ??
                          '-';
                      // Gunakan selectedKain dari order, bukan fabric dari item
                      final jenisKain = order.selectedKain ?? '-';

                      // Debug print untuk multi order
                      print(
                        '🔍 DEBUG StatusPesananCustomerScreen - Order ${order.id}:',
                      );
                      print('   - items.length: ${order.items.length}');
                      print('   - isMultiOrder: ${order.items.length > 1}');
                      print('   - totalPrice: ${order.totalPrice}');
                      print('   - selectedKain: ${order.selectedKain}');

                      for (int i = 0; i < order.items.length; i++) {
                        final item = order.items[i];
                        print(
                          '   - Item $i: model=${item['model']}, price=${item['price']}, orderType=${item['orderType']}',
                        );
                      }

                      // Hitung total harga dan jumlah item
                      final totalPrice = order.items.fold<double>(
                        0,
                        (sum, item) => sum + (item['price'] ?? 0).toDouble(),
                      );
                      final itemCount = order.items.length;
                      final isMultiOrder = itemCount > 1;

                      // Gunakan total harga untuk multi order, harga item pertama untuk single order
                      final displayPrice = isMultiOrder
                          ? totalPrice
                          : (firstItem['price'] ?? 0);
                      return Card(
                        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kode: ${order.id ?? '-'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14, // Kurangi dari 16
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ), // Tambahkan spacing
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8, // Kurangi dari 12
                                      vertical: 4, // Kurangi dari 6
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(
                                        order.status,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                        6,
                                      ), // Kurangi dari 8
                                    ),
                                    child: Text(
                                      order.status,
                                      style: TextStyle(
                                        color: getStatusColor(order.status),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10, // Kurangi dari 12
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: isDark ? Colors.white24 : Colors.black12,
                                height: 24,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60, // Kurangi dari 80
                                    height: 60, // Kurangi dari 80
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF8FBC8F,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ), // Kurangi dari 12
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.checkroom,
                                            color: Color(0xFF8FBC8F),
                                            size: 20,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            isMultiOrder
                                                ? 'Multi Order'
                                                : orderType,
                                            style: const TextStyle(
                                              color: Color(0xFF8FBC8F),
                                              fontSize: 8,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (isMultiOrder) ...[
                                            const SizedBox(height: 1),
                                            Text(
                                              '($itemCount items)',
                                              style: const TextStyle(
                                                color: Color(0xFF8FBC8F),
                                                fontSize: 6,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12), // Kurangi dari 16
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tanggal Pesan',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.grey[600],
                                            fontSize: 10, // Kurangi dari 12
                                          ),
                                        ),
                                        Text(
                                          order.orderDate
                                              .toDate()
                                              .toString()
                                              .substring(0, 16),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize:
                                                11, // Tambahkan ukuran font yang lebih kecil
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ), // Kurangi dari 8
                                        Text(
                                          'Model',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.grey[600],
                                            fontSize: 10, // Kurangi dari 12
                                          ),
                                        ),
                                        if (isMultiOrder) ...[
                                          Text(
                                            '$itemCount Items',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'First: $model',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.grey[600],
                                              fontSize: 9,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ] else ...[
                                          Text(
                                            model,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(
                                          height: 6,
                                        ), // Kurangi dari 8
                                        Text(
                                          'Jenis Kain',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.grey[600],
                                            fontSize: 10, // Kurangi dari 12
                                          ),
                                        ),
                                        if (isMultiOrder) ...[
                                          Text(
                                            'Various',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ] else ...[
                                          Text(
                                            jenisKain,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(
                                          height: 6,
                                        ), // Kurangi dari 8
                                        Text(
                                          'Harga',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.grey[600],
                                            fontSize: 10, // Kurangi dari 12
                                          ),
                                        ),
                                        Text(
                                          'Rp ${displayPrice.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFDE8500),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6), // Kurangi dari 8
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFDE8500),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          3,
                                        ), // Kurangi dari 4
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8, // Kurangi dari 12
                                        vertical: 4, // Kurangi dari 6
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CekDetailStatusPesananCustomerScreen(
                                                order: order,
                                              ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Cek Detail',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9, // Kurangi dari 10
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white70 : Colors.grey,
            fontFamily: 'SF Pro Text',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
            fontFamily: 'SF Pro Text',
          ),
        ),
      ],
    );
  }
}

// ignore: unused_element
class _ProgressStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;

  const _ProgressStep({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFDE8500)
                    : (isDark ? Colors.grey[700] : Colors.grey[300]),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.schedule,
                color: isCompleted
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.grey[600]),
                size: 16,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? const Color(0xFFDE8500)
                    : (isDark ? Colors.grey[700] : Colors.grey[300]),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isCompleted
                      ? const Color(0xFFDE8500)
                      : (isDark ? Colors.white : Colors.black),
                  fontFamily: 'SF Pro Display',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                  fontFamily: 'SF Pro Text',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: unused_element
class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _BottomNavIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    // ignore: unused_element_parameter
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? const Color(0xFF8FBC8F) : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF8FBC8F) : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
