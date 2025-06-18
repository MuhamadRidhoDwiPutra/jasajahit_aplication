import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk Clipboard
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';

class CekDetailAdminScreen extends StatelessWidget {
  final String orderCode;
  final String model;
  final String fabricType;
  final int productQuantity;
  final String orderDate;

  const CekDetailAdminScreen({
    super.key,
    required this.orderCode,
    required this.model,
    required this.fabricType,
    required this.productQuantity,
    required this.orderDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Detail Pesanan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
      ),
      body: Center(
        child: Card(
          color: Colors.white,
          elevation: 3,
          margin: const EdgeInsets.all(24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kode Pesanan',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(orderCode, style: const TextStyle(fontSize: 16)),
                const Divider(height: 24, color: Colors.black12),
                const Text('Model',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(model, style: const TextStyle(fontSize: 16)),
                const Divider(height: 24, color: Colors.black12),
                const Text('Jenis Kain',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(fabricType, style: const TextStyle(fontSize: 16)),
                const Divider(height: 24, color: Colors.black12),
                const Text('Jumlah Produk',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(productQuantity.toString(),
                    style: const TextStyle(fontSize: 16)),
                const Divider(height: 24, color: Colors.black12),
                const Text('Tanggal Pesan',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(orderDate, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDE8500),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    onPressed: () {/* aksi kembali */},
                    child: const Text('Kembali',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildInfoRow(BuildContext context,
      {required String label,
      required String value,
      bool hasCopyButton = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Warna teks label
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12), // Padding lebih proporsional
          decoration: BoxDecoration(
            color: Colors.white, // Warna latar belakang container
            borderRadius: BorderRadius.circular(10), // Sudut lebih membulat
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.black), // Warna teks nilai
                ),
              ),
              if (hasCopyButton)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Disalin!')),
                    );
                  },
                  child: Text(
                    'Salin',
                    style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold), // Gaya teks tombol salin
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
