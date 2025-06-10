import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/customer/home_customer_screen.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/customer/pesan_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/profile_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/tracking_pesanan_customer_screen.dart';
import 'desain_customer_screen.dart';

class RiwayatCustomerScreen extends StatelessWidget {
  const RiwayatCustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for order history
    final List<_OrderHistory> orders = [
      _OrderHistory(
        id: 'ORD123456',
        item: 'Kemeja Formal',
        date: '12 Juni 2024',
        total: 'Rp 300.000',
        status: OrderStatus.selesai,
      ),
      _OrderHistory(
        id: 'ORD123457',
        item: 'Seragam Sekolah',
        date: '10 Juni 2024',
        total: 'Rp 200.000',
        status: OrderStatus.diproses,
      ),
      _OrderHistory(
        id: 'ORD123458',
        item: 'Jas Pria',
        date: '5 Juni 2024',
        total: 'Rp 400.000',
        status: OrderStatus.dibatalkan,
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // AppBar with gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[700]!, Colors.green[500]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeCustomerScreen()),
                            );
                          },
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Riwayat Pesanan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Order History List or Empty State
                Expanded(
                  child: orders.isEmpty
                      ? _EmptyHistory()
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: orders.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return _OrderHistoryCard(order: order);
                          },
                        ),
                ),
              ],
            ),
            // ... existing code ...
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD600),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DesainCustomerScreen()),
          );
        },
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavIcon(
              icon: Icons.home,
              label: 'Beranda',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeCustomerScreen()),
                );
              },
            ),
            _BottomNavIcon(
              icon: Icons.local_shipping,
              label: 'Tracking',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const TrackingPesananCustomerScreen()),
                );
              },
            ),
            const SizedBox(width: 48), // Space for FAB
            _BottomNavIcon(
              icon: Icons.history,
              label: 'Riwayat',
              onTap: () {},
              isActive: true,
            ),
            _BottomNavIcon(
              icon: Icons.person,
              label: 'Profil',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileCustomerScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum OrderStatus { selesai, diproses, dibatalkan }

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

class _OrderHistoryCard extends StatelessWidget {
  final _OrderHistory order;
  const _OrderHistoryCard({required this.order});

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.selesai:
        return Colors.green[600]!;
      case OrderStatus.diproses:
        return Colors.orange[700]!;
      case OrderStatus.dibatalkan:
        return Colors.red[400]!;
    }
  }

  IconData getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.selesai:
        return Icons.check_circle_rounded;
      case OrderStatus.diproses:
        return Icons.local_shipping_rounded;
      case OrderStatus.dibatalkan:
        return Icons.cancel_rounded;
    }
  }

  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.selesai:
        return 'Selesai';
      case OrderStatus.diproses:
        return 'Diproses';
      case OrderStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: getStatusColor(order.status).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getStatusIcon(order.status),
              color: getStatusColor(order.status),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.item,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(order.date,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor(order.status).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        getStatusText(order.status),
                        style: TextStyle(
                          color: getStatusColor(order.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(order.total,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Belum ada riwayat pesanan',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _BottomNavIcon({
    required this.icon,
    required this.label,
    this.onTap,
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
