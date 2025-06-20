import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/admin/cek_detail_admin_screen.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';

class StatusPesananAdminScreen extends StatefulWidget {
  const StatusPesananAdminScreen({super.key});

  @override
  State<StatusPesananAdminScreen> createState() =>
      _StatusPesananAdminScreenState();
}

class _StatusPesananAdminScreenState extends State<StatusPesananAdminScreen> {
  // Contoh data untuk pesanan
  List<Map<String, dynamic>> orders = [];

  List<String> statusOptions = [
    'Sedang dikerjakan',
    'Pesanan Dikonfirmasi',
    'Pesanan telah selesai',
    'Pesanan Diterima',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Status Pesanan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            color: Colors.white,
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Kode: ${order['orderCode']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDE8500).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(order['status'],
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
                          color: const Color(0xFF8FBC8F).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                            child: Text(order['imageText'],
                                style:
                                    const TextStyle(color: Color(0xFF8FBC8F)))),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tanggal Pesan',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
                            Text(order['orderDate'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            Text('Tanggal Selesai',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
                            Text(order['finishDate'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            Text('Jumlah Produk',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CekDetailAdminScreen(
                                orderCode: order['orderCode'],
                                model: 'Seragam',
                                fabricType: 'Katun',
                                productQuantity: order['productQuantity'],
                                orderDate: order['orderDate'],
                              ),
                            ),
                          );
                        },
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
    );
  }
}
