import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart';
import 'pembayaran_celana_customer_screen.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';

class CekDetailPesananCelanaScreen extends StatelessWidget {
  final Order order;
  const CekDetailPesananCelanaScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8FBC8F),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PembayaranCelanaCustomerScreen(order: order),
              ),
            );
          },
        ),
        title: Text(
          'Detail Pesanan Celana',
          style: TextStyle(
              color: isDark ? Colors.white : Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Kode pesanan',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: order.id ?? 'N/A'),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            isDark ? const Color(0xFF2A2A2A) : Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDark ? const Color(0xFF2A2A2A) : Colors.grey[300],
                      foregroundColor: isDark ? Colors.white : Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    child: const Text('Salin'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Model',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(text: order.model),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      isDark ? const Color(0xFF2A2A2A) : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Jenis kain',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(text: order.fabric),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      isDark ? const Color(0xFF2A2A2A) : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Jumlah produk',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(text: '1'),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      isDark ? const Color(0xFF2A2A2A) : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 80,
                      child: Card(
                        color: isDark ? Colors.grey[700] : Colors.grey,
                        child: Center(
                          child: Text(
                            'Gambar desain\nCelana yang dipesan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tanggal Pemesanan\n${order.orderDate.toDate().day} ${_getMonth(order.orderDate.toDate().month)} ${order.orderDate.toDate().year}',
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Harga',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(
                    text: 'Rp ${order.price.toStringAsFixed(0)}'),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      isDark ? const Color(0xFF2A2A2A) : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _getMonth(int month) {
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  return months[month - 1];
}
