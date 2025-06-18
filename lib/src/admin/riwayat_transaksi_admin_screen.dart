import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';

class RiwayatTransaksiAdminScreen extends StatefulWidget {
  const RiwayatTransaksiAdminScreen({super.key});

  @override
  State<RiwayatTransaksiAdminScreen> createState() =>
      _RiwayatTransaksiAdminScreenState();
}

class _RiwayatTransaksiAdminScreenState
    extends State<RiwayatTransaksiAdminScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> transactions = [
    {
      'orderCode': 'A876U6',
      'imageText': 'Gambar Celana',
      'orderDate': '12 Mei 2024',
      'finishDate': '22 Mei 2024',
      'productQuantity': 1,
      'totalPrice': 50000,
    },
    {
      'orderCode': 'P45US8',
      'imageText': 'Gambar Celana',
      'orderDate': '12 Mei 2024',
      'finishDate': '22 Mei 2024',
      'productQuantity': 1,
      'totalPrice': 50000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Riwayat Transaksi',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onChanged: (value) {
                      // Implementasi pencarian di sini
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Aksi pencarian
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final trx = transactions[index];
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
                            Text('Kode: ${trx['orderCode']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDE8500).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(trx['status'],
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
                                  child: Text(trx['imageText'],
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
                                  Text(trx['orderDate'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 8),
                                  Text('Tanggal Selesai',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12)),
                                  Text(trx['finishDate'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 8),
                                  Text('Jumlah Produk',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12)),
                                  Text(trx['productQuantity'].toString(),
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
    );
  }
}
