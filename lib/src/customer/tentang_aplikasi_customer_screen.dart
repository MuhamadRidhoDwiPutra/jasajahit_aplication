import 'package:flutter/material.dart';

class TentangAplikasiCustomerScreen extends StatelessWidget {
  const TentangAplikasiCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Tentang Aplikasi',
            style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.checkroom, size: 64, color: Color(0xFFDE8500)),
            const SizedBox(height: 16),
            const Text('Jasa Jahit App',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Versi 1.0.0', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Aplikasi jasa jahit custom yang memudahkan pelanggan untuk memesan, melacak, dan mengelola pesanan pakaian secara online.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
