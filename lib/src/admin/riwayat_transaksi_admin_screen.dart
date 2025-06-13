import 'package:flutter/material.dart';

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
            padding: const EdgeInsets.all(16.0),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return _TransactionCard(
                orderCode: transaction['orderCode'],
                imageText: transaction['imageText'],
                orderDate: transaction['orderDate'],
                finishDate: transaction['finishDate'],
                productQuantity: transaction['productQuantity'],
                totalPrice: transaction['totalPrice'],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final String orderCode;
  final String imageText;
  final String orderDate;
  final String finishDate;
  final int productQuantity;
  final int totalPrice;

  const _TransactionCard({
    Key? key,
    required this.orderCode,
    required this.imageText,
    required this.orderDate,
    required this.finishDate,
    required this.productQuantity,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kode pesanan: $orderCode',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const Divider(color: Colors.black26, height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                      child: Text(imageText,
                          style: TextStyle(color: Colors.grey[600]))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal Pemesanan:',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                      Text(orderDate,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text('Tanggal selesai:',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                      Text(finishDate,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text('Jumlah Produk:',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                      Text(productQuantity.toString(),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total pesanan: Rp. ${totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     // Aksi ketika tombol detail ditekan
                  //   },
                  //   child: const Text(
                  //     'Cek detail',
                  //     style: TextStyle(color: Colors.black87, fontSize: 12),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
