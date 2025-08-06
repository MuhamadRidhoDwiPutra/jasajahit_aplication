import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/customer/berhasil_pesan_baju_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart' as mymodel;
import 'ukuran_baju_customer_screen.dart';
import 'home_customer_screen.dart';
import 'pembayaran_baju_customer_screen.dart';
import 'konfirmasi_desain_baju_customer_screen.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jasa_jahit_aplication/Core/provider/auth_provider.dart'
    as app_auth;
import 'ukuran_celana_customer_screen.dart';

class KonfirmasiPesananCustomerScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final List<Map<String, dynamic>> items;
  final String status;
  final bool isDark;

  const KonfirmasiPesananCustomerScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.items,
    this.status = 'Menunggu Konfirmasi',
    this.isDark = false,
  });

  @override
  State<KonfirmasiPesananCustomerScreen> createState() =>
      _KonfirmasiPesananCustomerScreenState();
}

class _KonfirmasiPesananCustomerScreenState
    extends State<KonfirmasiPesananCustomerScreen> {
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _items = List<Map<String, dynamic>>.from(widget.items);
  }

  // Fungsi untuk mendapatkan data customer dari Firestore
  Future<Map<String, String>> _getCustomerData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final authProvider = Provider.of<app_auth.AuthProvider>(
          context,
          listen: false,
        );
        final userData = await authProvider.getUserData(currentUser.uid);

        if (userData != null) {
          return {
            'name': userData['name'] ?? 'Customer',
            'username': userData['username'] ?? currentUser.email ?? 'Customer',
            'address': userData['address'] ?? '',
          };
        }
      }

      // Fallback jika tidak ada data di Firestore
      return {
        'name': FirebaseAuth.instance.currentUser?.displayName ?? 'Customer',
        'username': FirebaseAuth.instance.currentUser?.email ?? 'Customer',
        'address': '',
      };
    } catch (e) {
      print('Error getting customer data: $e');
      return {'name': 'Customer', 'username': 'Customer', 'address': ''};
    }
  }

  double getTotal() {
    double total = 0;
    for (var item in _items) {
      total += (item['price'] ?? 0).toDouble();
    }
    return total;
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _addPesanan() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.checkroom, color: Color(0xFFDE8500)),
                title: const Text('Tambah Baju'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UkuranBajuCustomerScreen(
                        selectedFabric: '',
                        items: _items,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.shopping_bag,
                  color: Color(0xFFDE8500),
                ),
                title: const Text('Tambah Celana'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UkuranCelanaCustomerScreen(
                        selectedFabric: '',
                        items: _items,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _lanjutkanPembayaran() async {
    if (_items.isEmpty) return;

    // Dapatkan data customer
    final customerData = await _getCustomerData();

    // Hitung total harga
    double totalPrice = 0;
    for (var item in _items) {
      totalPrice += (item['price'] ?? 0).toDouble();
    }

    // Ambil data estimasi dari item pertama (asumsi semua item memiliki estimasi yang sama)
    final firstItem = _items.first;
    final estimatedPrice = firstItem['price'] ?? 0;
    final estimatedSize = firstItem['estimatedSize'] ?? 'M';
    final isCustomSize = firstItem['isCustomSize'] ?? false;
    final selectedKain = firstItem['fabric'] ?? 'Kain yang dipilih';

    final order = mymodel.Order(
      userId: widget.userId,
      userName: customerData['username'] ?? widget.userName,
      customerName: customerData['name'],
      customerAddress: customerData['address'],
      items: _items,
      status: widget.status,
      orderDate: Timestamp.now(),
      totalPrice: totalPrice,
      estimatedPrice: estimatedPrice,
      estimatedSize: estimatedSize,
      isCustomSize: isCustomSize,
      selectedKain: selectedKain,
    );

    // Navigasi ke halaman pembayaran
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PembayaranBajuCustomerScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        elevation: 1,
        title: Text(
          'Konfirmasi Pesanan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Card(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                    child: ListTile(
                      title: Text(
                        '${item['orderType'] ?? '-'} - ${item['jenisBaju'] ?? item['jenisCelana'] ?? item['model'] ?? '-'}',
                      ),
                      subtitle: Text(
                        'Kain: ${item['fabric'] ?? '-'}\nHarga: Rp ${item['price'] ?? 0}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  'Rp ${getTotal().toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDE8500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _addPesanan,
                    child: const Text(
                      '+ Tambah Pesanan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDE8500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _lanjutkanPembayaran,
                    child: const Text(
                      'Lanjutkan ke Pembayaran',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
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

class KonfirmasiDesainBajuCustomerScreen extends StatelessWidget {
  final mymodel.Order order;
  const KonfirmasiDesainBajuCustomerScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFDE8500).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFFDE8500),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UkuranBajuCustomerScreen(
                                      selectedFabric: '',
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Konfirmasi Desain',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                            fontFamily: 'SF Pro Display',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Pesanan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const SizedBox(height: 16),
                            _DetailItem(
                              label: 'Model',
                              value: order.model,
                              icon: Icons.checkroom,
                            ),
                            Divider(
                              height: 24,
                              color: isDark ? Colors.white24 : Colors.black12,
                            ),
                            _DetailItem(
                              label: 'Kain',
                              value: order.fabric,
                              icon: Icons.checkroom,
                            ),
                            Divider(
                              height: 24,
                              color: isDark ? Colors.white24 : Colors.black12,
                            ),
                            _DetailItem(
                              label: 'Ukuran',
                              value:
                                  'Lingkar Dada: ${order.measurements['lingkarDada']}cm\nLebar Bahu: ${order.measurements['lebarBahu']}cm\nPanjang Baju: ${order.measurements['panjangBaju']}cm\nPanjang Lengan: ${order.measurements['panjangLengan']}cm\nLebar Lengan: ${order.measurements['lebarLengan']}cm',
                              icon: Icons.straighten,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Pembayaran',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.grey,
                                    fontFamily: 'SF Pro Text',
                                  ),
                                ),
                                Text(
                                  'Rp ${order.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.grey[600],
                                    fontFamily: 'SF Pro Text',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                                const Text(
                                  'Rp 150.000',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFDE8500),
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDE8500),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PembayaranBajuCustomerScreen(order: order),
                            ),
                          );
                        },
                        child: const Text(
                          'Lanjutkan ke Pembayaran',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'SF Pro Text',
                          ),
                        ),
                      ),
                    ],
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

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFDE8500).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFDE8500), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.grey,
                  fontFamily: 'SF Pro Text',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black,
                  fontFamily: 'SF Pro Text',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
