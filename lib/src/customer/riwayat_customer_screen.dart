import 'package:flutter/material.dart';

class RiwayatCustomerScreen extends StatelessWidget {
  const RiwayatCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B7F6B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B7F6B),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.notifications, color: Colors.black),
          ),
        ),
        title: const Text(
          'Riwayat Pemesanan',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.refresh, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 24, right: 24, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            // List riwayat
            Expanded(
              child: Center(
                child: Text(
                  'Belum ada data riwayat pesanan.\nSilakan tunggu data dari backend.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              color: Colors.orange[700],
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _BottomNavIcon(icon: Icons.home, label: 'Icon menu beranda'),
                  _BottomNavIcon(icon: Icons.message, label: 'Icon menu Pesan'),
                  _BottomNavIcon(
                      icon: Icons.local_shipping,
                      label: 'Icon pelacakan pesanan'),
                  _BottomNavIcon(
                      icon: Icons.history, label: 'Icon menu riwayat'),
                  _BottomNavIcon(
                      icon: Icons.person, label: 'Icon menu profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _RiwayatCard extends StatelessWidget {
  final String model;
  final String imageLabel;
  final String tanggal;
  final int jumlah;
  final String harga;
  const _RiwayatCard({
    required this.model,
    required this.imageLabel,
    required this.tanggal,
    required this.jumlah,
    required this.harga,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Model Pakaian : $model',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    imageLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal Pemesanan\n$tanggal',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Jumlah Produk\n$jumlah',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Harga:\n$harga',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: const [
            Text('Status: Selesai', style: TextStyle(fontSize: 14)),
            SizedBox(width: 4),
            Icon(Icons.check, color: Colors.black, size: 18),
          ],
        ),
      ],
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BottomNavIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      ],
    );
  }
}
