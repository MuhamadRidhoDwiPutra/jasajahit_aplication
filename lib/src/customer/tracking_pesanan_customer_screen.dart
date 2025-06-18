import 'package:flutter/material.dart';
// ignore: unused_import
import 'home_customer_screen.dart';
// ignore: unused_import
import 'pesan_customer_screen.dart';
// ignore: unused_import
import 'riwayat_customer_screen.dart';
// ignore: unused_import
import 'profile_customer_screen.dart';
// ignore: unused_import
import 'desain_customer_screen.dart';

class TrackingPesananCustomerScreen extends StatelessWidget {
  const TrackingPesananCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data pesanan
    final orders = [
      {
        'orderCode': 'ORD123456',
        'imageText': 'Gambar Baju',
        'orderDate': '12 Juni 2024',
        'finishDate': '19 Juni 2024',
        'productQuantity': 1,
        'status': 'Diproses',
      },
      {
        'orderCode': 'ORD654321',
        'imageText': 'Gambar Celana',
        'orderDate': '10 Juni 2024',
        'finishDate': '18 Juni 2024',
        'productQuantity': 2,
        'status': 'Selesai',
      },
    ];
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Kode: ${order['orderCode'].toString()}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color:
                                      // ignore: deprecated_member_use
                                      const Color(0xFFDE8500).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(order['status'].toString(),
                                    style: const TextStyle(
                                        color: Color(0xFFDE8500),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.black12, height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color:
                                      // ignore: deprecated_member_use
                                      const Color(0xFF8FBC8F).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                    child: Text(order['imageText'].toString(),
                                        style: const TextStyle(
                                            color: Color(0xFF8FBC8F)))),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Tanggal Pesan',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12)),
                                    Text(order['orderDate'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Text('Tanggal Selesai',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12)),
                                    Text(order['finishDate'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Text('Jumlah Produk',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12)),
                                    Text(order['productQuantity'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDE8500),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                onPressed: () {/* aksi detail */},
                                child: const Text('Cek Detail',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontFamily: 'SF Pro Text',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
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
    // ignore: unused_element_parameter
    this.isFirst = false,
    // ignore: unused_element_parameter
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 24,
                  color:
                      isCompleted ? const Color(0xFFDE8500) : Colors.grey[300],
                ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color:
                      isCompleted ? const Color(0xFFDE8500) : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 24,
                  color:
                      isCompleted ? const Color(0xFFDE8500) : Colors.grey[300],
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isCompleted ? Colors.black : Colors.grey[600],
                  fontFamily: 'SF Pro Text',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
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
            Icon(
              icon,
              color: isActive ? const Color(0xFF8FBC8F) : Colors.grey,
            ),
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
