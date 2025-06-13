import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk Clipboard

class CekDetailAdminScreen extends StatelessWidget {
  final String orderCode;
  final String model;
  final String fabricType;
  final int productQuantity;
  final String orderDate;

  const CekDetailAdminScreen({
    Key? key,
    required this.orderCode,
    required this.model,
    required this.fabricType,
    required this.productQuantity,
    required this.orderDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              context,
              label: 'Kode pesanan',
              value: orderCode,
              hasCopyButton: true,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              label: 'Model',
              value: model,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              label: 'Jenis kain',
              value: fabricType,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              label: 'Jumlah produk',
              value: productQuantity.toString(),
            ),
            const SizedBox(height: 32),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color:
                      Colors.grey[200], // Warna placeholder gambar lebih terang
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Gambar\nBaju yang\ndipesan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14), // Gaya teks placeholder
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Tanggal Pemesanan\n$orderDate',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500), // Gaya teks tanggal
              ),
            ),
          ],
        ),
      ),
    );
  }

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
