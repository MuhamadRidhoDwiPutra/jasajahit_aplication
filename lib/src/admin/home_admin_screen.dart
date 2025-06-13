import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/admin/cek_detail_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/status_pesanan_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/riwayat_transaksi_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/model_pakaian_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/profile_admin_screen.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  int _selectedIndex = 0;

  final List<Widget> _adminScreens = [
    _HomeAdminContent(), // Konten beranda saat ini
    StatusPesananAdminScreen(),
    RiwayatTransaksiAdminScreen(),
    ModelPakaianAdminScreen(),
    ProfileAdminScreen(),
  ];

  final List<String> _appBarTitles = const [
    'Daftar Pesanan',
    'Status Pesanan',
    'Riwayat Transaksi Pesanan',
    'Model Pakaian',
    'Profil Admin',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Column(
          children: [
            // Bar Navigasi Kustom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _appBarTitles[_selectedIndex],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.account_circle_outlined,
                          color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            // Konten halaman yang berubah
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _adminScreens,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.orange[700],
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavIcon(
                icon: Icons.home,
                label: 'Beranda',
                index: 0,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped),
            _BottomNavIcon(
                icon: Icons.message,
                label: 'Pesan',
                index: 1,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped),
            _BottomNavIcon(
                icon: Icons.history,
                label: 'Riwayat',
                index: 2,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped),
            _BottomNavIcon(
                icon: Icons.checkroom,
                label: 'Model Pakaian',
                index: 3,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped),
            _BottomNavIcon(
                icon: Icons.person,
                label: 'Profil',
                index: 4,
                selectedIndex: _selectedIndex,
                onTap: _onItemTapped),
          ],
        ),
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavIcon({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.white70),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.black87 : Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeAdminContent extends StatelessWidget {
  const _HomeAdminContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        _OrderCard(
          orderCode: 'A876U6',
          imageText: 'Gambar Celana',
          orderDate: '12 Mei 2024',
          productQuantity: 1,
        ),
        SizedBox(height: 16),
        _OrderCard(
          orderCode: 'P45US8',
          imageText: 'Gambar Celana',
          orderDate: '12 Mei 2024',
          productQuantity: 1,
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderCode;
  final String imageText;
  final String orderDate;
  final int productQuantity;

  const _OrderCard({
    Key? key,
    required this.orderCode,
    required this.imageText,
    required this.orderDate,
    required this.productQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      margin: EdgeInsets.zero,
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
              child: TextButton(
                onPressed: () {
                  // Aksi ketika tombol detail ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CekDetailAdminScreen(
                        orderCode: orderCode,
                        model:
                            'Seragam', // Placeholder, ganti dengan data sebenarnya jika ada
                        fabricType: 'Katun', // Placeholder
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
            ),
          ],
        ),
      ),
    );
  }
}
