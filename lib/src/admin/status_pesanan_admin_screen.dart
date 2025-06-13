import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/admin/cek_detail_admin_screen.dart';

class StatusPesananAdminScreen extends StatefulWidget {
  const StatusPesananAdminScreen({super.key});

  @override
  State<StatusPesananAdminScreen> createState() =>
      _StatusPesananAdminScreenState();
}

class _StatusPesananAdminScreenState extends State<StatusPesananAdminScreen> {
  // Contoh data untuk pesanan
  List<Map<String, dynamic>> orders = [
    {
      'orderCode': 'A876U6',
      'imageText': 'Gambar Celana',
      'orderDate': '12 Mei 2024',
      'finishDate': '22 Mei 2024',
      'productQuantity': 1,
      'status': 'Pesanan telah selesai',
    },
    {
      'orderCode': 'P45US8',
      'imageText': 'Gambar Celana',
      'orderDate': '12 Mei 2024',
      'finishDate': '22 Mei 2024',
      'productQuantity': 1,
      'status': 'Sedang dikerjakan',
    },
  ];

  List<String> statusOptions = [
    'Sedang dikerjakan',
    'Pesanan Dikonfirmasi',
    'Pesanan telah selesai',
    'Pesanan Diterima',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _StatusOrderCard(
                orderCode: order['orderCode'],
                imageText: order['imageText'],
                orderDate: order['orderDate'],
                finishDate: order['finishDate'],
                productQuantity: order['productQuantity'],
                currentStatus: order['status'],
                statusOptions: statusOptions,
                onStatusChanged: (newStatus) {
                  setState(() {
                    orders[index]['status'] = newStatus;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatusOrderCard extends StatelessWidget {
  final String orderCode;
  final String imageText;
  final String orderDate;
  final String finishDate;
  final int productQuantity;
  final String currentStatus;
  final List<String> statusOptions;
  final ValueChanged<String?> onStatusChanged;

  const _StatusOrderCard({
    Key? key,
    required this.orderCode,
    required this.imageText,
    required this.orderDate,
    required this.finishDate,
    required this.productQuantity,
    required this.currentStatus,
    required this.statusOptions,
    required this.onStatusChanged,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: currentStatus,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.black54),
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 14),
                      onChanged: onStatusChanged,
                      items: statusOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.black87)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CekDetailAdminScreen(
                          orderCode: orderCode,
                          model: 'Seragam',
                          fabricType: 'Katun',
                          productQuantity: productQuantity,
                          orderDate: orderDate,
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Colors.orange[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Cek detail',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
