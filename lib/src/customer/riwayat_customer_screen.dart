import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/customer/home_customer_screen.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/customer/pesan_customer_screen.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/customer/profile_customer_screen.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/customer/tracking_pesanan_customer_screen.dart';
// ignore: unused_import
import 'desain_customer_screen.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
// ignore: unused_import

class RiwayatCustomerScreen extends StatelessWidget {
  const RiwayatCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for order history
    final List<_OrderHistory> orders = [];
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
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
                                    order.id,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontFamily: 'SF Pro Text',
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(order.status)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _getStatusText(order.status),
                                      style: TextStyle(
                                        color: _getStatusColor(order.status),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        fontFamily: 'SF Pro Text',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Colors.black12),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.item,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: 'SF Pro Display',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order.date,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontFamily: 'SF Pro Text',
                                        ),
                                      ),
                                      Text(
                                        order.total,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFDE8500),
                                          fontFamily: 'SF Pro Display',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.green[700] : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.green[700] : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
