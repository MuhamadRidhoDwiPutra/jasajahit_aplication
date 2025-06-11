import 'package:flutter/material.dart';
import 'pembayaran_celana_customer_screen.dart';

class CekDetailPesananCelanaScreen extends StatelessWidget {
  const CekDetailPesananCelanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FBC8F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PembayaranCelanaCustomerScreen(),
              ),
            );
          },
        ),
        title: const Text(
          'Detail Pesanan Celana',
          style: TextStyle(color: Colors.white, fontSize: 18),
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
              const Text('Kode pesanan', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: ''),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
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
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
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
              const Text('Model', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(text: ''),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Jenis kain', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(text: ''),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Jumlah produk',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(text: ''),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
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
                  children: const [
                    SizedBox(
                      width: 120,
                      height: 80,
                      child: Card(
                        color: Colors.grey,
                        child: Center(
                          child: Text(
                            'Gambar desain\nCelana yang dipesan',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tanggal Pemesanan\n',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text('Harga', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(text: ''),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
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
