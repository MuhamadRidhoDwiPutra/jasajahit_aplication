import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/customer/home_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/profile_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/status_pesanan_customer_screen.dart';
import 'desain_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';
import 'package:jasa_jahit_aplication/Core/provider/auth_provider.dart'
    as core_auth;
import 'package:jasa_jahit_aplication/src/model/order_model.dart'
    as order_model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jasa_jahit_aplication/src/customer/pembayaran_baju_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/pembayaran_celana_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/pembayaran_model_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/model/product_model.dart';
import 'package:jasa_jahit_aplication/src/customer/cek_detail_pesanan_baju_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/cek_detail_pesanan_celana_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/cek_detail_pesanan_model_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/cek_detail_riwayat_baju_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/customer/cek_detail_riwayat_celana_customer_screen.dart';

class RiwayatCustomerScreen extends StatefulWidget {
  const RiwayatCustomerScreen({super.key});

  @override
  State<RiwayatCustomerScreen> createState() => _RiwayatCustomerScreenState();
}

class _RiwayatCustomerScreenState extends State<RiwayatCustomerScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: TextEditingController(text: _searchQuery),
                    decoration: InputDecoration(
                      hintText: 'Cari pesanan... (kode, nama, model, jenis)',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF2A2A2A)
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<order_model.Order>>(
                    stream: FirestoreService().getOrdersByUserId(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Terjadi kesalahan'));
                      }
                      final orders =
                          snapshot.data
                              ?.where((order) {
                                // Tampilkan semua pesanan di riwayat (seperti sebelumnya)
                                return true;
                              })
                              .where((order) {
                                final query = _searchQuery.toLowerCase();
                                final firstItem = (order.items.isNotEmpty)
                                    ? order.items[0]
                                    : {};
                                final orderType = (firstItem['orderType'] ?? '')
                                    .toString();
                                final productModel =
                                    (firstItem['jenisBaju'] ??
                                            firstItem['jenisCelana'] ??
                                            firstItem['model'] ??
                                            '')
                                        .toString();
                                final userName = order.userName.toString();
                                final orderId = order.id ?? '';

                                // Pencarian berdasarkan: kode pesanan, tipe pesanan, model produk, dan nama user
                                return orderId.toLowerCase().contains(query) ||
                                    orderType.toLowerCase().contains(query) ||
                                    productModel.toLowerCase().contains(
                                      query,
                                    ) ||
                                    userName.toLowerCase().contains(query);
                              })
                              .toList() ??
                          [];
                      if (orders.isEmpty) {
                        if (_searchQuery.isNotEmpty) {
                          // Jika ada query pencarian tapi tidak ada hasil
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada hasil pencarian',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Coba kata kunci lain atau hapus pencarian',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                  child: const Text(
                                    'Hapus Pencarian',
                                    style: TextStyle(
                                      color: Color(0xFFDE8500),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Jika tidak ada query pencarian dan tidak ada pesanan
                          return Center(
                            child: Text(
                              'Belum ada riwayat pesanan',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          );
                        }
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final firstItem = (order.items.isNotEmpty)
                              ? order.items[0]
                              : {};
                          final orderType = firstItem['orderType'] ?? '-';
                          final price =
                              order.estimatedPrice?.toDouble() ??
                              order.totalPrice ??
                              firstItem['price'] ??
                              0;

                          // Cek apakah order sudah memiliki bukti pembayaran
                          final hasPaymentProof =
                              order.paymentProofUrl != null &&
                              order.paymentProofUrl!.isNotEmpty;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
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
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order.id ?? '-',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.grey,
                                          fontFamily: 'SF Pro Text',
                                        ),
                                      ),
                                      // Status pembayaran
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: hasPaymentProof
                                              ? Colors.green.withOpacity(0.2)
                                              : Colors.orange.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          hasPaymentProof
                                              ? 'Pembayaran Selesai'
                                              : 'Menunggu Pembayaran',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: hasPaymentProof
                                                ? Colors.green
                                                : Colors.orange,
                                            fontFamily: 'SF Pro Text',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.black12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderType,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: 'SF Pro Display',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Tambahkan detail pesanan
                                      if (firstItem['jenisBaju'] != null ||
                                          firstItem['jenisCelana'] != null ||
                                          firstItem['model'] != null) ...[
                                        Text(
                                          'Model: ${firstItem['jenisBaju'] ?? firstItem['jenisCelana'] ?? firstItem['model'] ?? '-'}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                            fontFamily: 'SF Pro Text',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      if (firstItem['fabric'] != null ||
                                          order.selectedKain != null) ...[
                                        Text(
                                          'Kain: ${firstItem['fabric'] ?? order.selectedKain ?? '-'}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                            fontFamily: 'SF Pro Text',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      if (firstItem['measurements'] != null ||
                                          order.estimatedSize != null) ...[
                                        Text(
                                          'Ukuran: ${order.isCustomSize == true ? 'Custom' : (order.estimatedSize ?? 'Standard')}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                            fontFamily: 'SF Pro Text',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      if (firstItem['size'] != null) ...[
                                        Text(
                                          'Size: ${firstItem['size']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                            fontFamily: 'SF Pro Text',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            order.orderDate
                                                .toDate()
                                                .toString()
                                                .substring(0, 16),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.grey,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                          Text(
                                            'Rp ${_formatCurrency(price)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFDE8500),
                                              fontFamily: 'SF Pro Display',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Tampilkan tombol berdasarkan status pesanan
                                      Row(
                                        children: [
                                          // Tombol Cek Detail selalu tersedia
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                              ),
                                              icon: const Icon(
                                                Icons.visibility,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                'Cek Detail',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                _handleDetail(order, firstItem);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          // Tombol Pesan Lagi hanya untuk pesanan yang sudah selesai
                                          if (hasPaymentProof) ...[
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFFDE8500,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                ),
                                                icon: const Icon(
                                                  Icons.shopping_cart,
                                                  color: Colors.white,
                                                ),
                                                label: const Text(
                                                  'Pesan Lagi',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  _handlePesanLagi(
                                                    order,
                                                    firstItem,
                                                    userId,
                                                  );
                                                },
                                              ),
                                            ),
                                          ] else ...[
                                            // Tombol Lanjutkan Pembayaran untuk pesanan yang belum dibayar
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                ),
                                                icon: const Icon(
                                                  Icons.payment,
                                                  color: Colors.white,
                                                ),
                                                label: const Text(
                                                  'Lanjutkan Pembayaran',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _handleLanjutkanPembayaran(
                                                    order,
                                                    firstItem,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      // Pesan informasi untuk pesanan yang belum dibayar
                                      if (!hasPaymentProof) ...[
                                        const SizedBox(height: 12),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(
                                              0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.orange.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color: Colors.orange,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'Selesaikan pembayaran untuk dapat memesan lagi',
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 11,
                                                    fontFamily: 'SF Pro Text',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _handlePesanLagi(
    order_model.Order order,
    Map<dynamic, dynamic> firstItem,
    String userId,
  ) async {
    print('Button Pesan Lagi ditekan');
    try {
      // Tentukan tipe pesanan untuk navigasi yang tepat
      final orderType = firstItem['orderType'] ?? '';
      final productModel =
          firstItem['jenisBaju'] ??
          firstItem['jenisCelana'] ??
          firstItem['model'] ??
          '';
      final fabric = firstItem['fabric'] ?? order.selectedKain ?? '';
      final measurements = firstItem['measurements'] ?? {};
      final price =
          firstItem['price'] ??
          order.estimatedPrice?.toDouble() ??
          order.totalPrice ??
          0;
      final estimatedSize = order.estimatedSize ?? 'M';
      final isCustomSize = order.isCustomSize ?? false;

      print('orderType = $orderType');
      print('productModel = $productModel');
      print('price = $price');
      print('firstItem = $firstItem');

      // Validasi data
      if (orderType.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data pesanan tidak valid'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Buat order baru berdasarkan tipe pesanan dengan data yang sesuai database
      final newOrder = order_model.Order(
        id: null,
        userId: userId,
        userName: order.userName,
        customerName: order.customerName,
        customerAddress: order.customerAddress,
        items: [
          {
            'orderType': orderType,
            'jenisBaju': firstItem['jenisBaju'],
            'jenisCelana': firstItem['jenisCelana'],
            'model': productModel,
            'fabric': fabric,
            'measurements': measurements,
            'price': price,
            'size': firstItem['size'],
          },
        ],
        status: 'Menunggu Konfirmasi',
        orderDate: Timestamp.now(),
        totalPrice: price.toDouble(),
        estimatedPrice: price.toInt(),
        estimatedSize: estimatedSize,
        isCustomSize: isCustomSize,
        selectedKain: fabric,
      );

      print('Order baru dibuat: ${newOrder.id}');

      // Simpan order terlebih dahulu
      await FirestoreService().saveOrder(newOrder);

      print('Order berhasil disimpan');

      // Navigasi ke screen pembayaran berdasarkan tipe pesanan
      if (orderType == 'Baju') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PembayaranBajuCustomerScreen(
              order: newOrder,
              sourcePage: 'riwayat', // Tambah parameter asal halaman
            ),
          ),
        );
      } else if (orderType == 'Celana') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PembayaranCelanaCustomerScreen(
              order: newOrder,
              sourcePage: 'riwayat', // Tambah parameter asal halaman
            ),
          ),
        );
      } else {
        // Untuk model, gunakan screen model
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PembayaranModelCustomerScreen(
              product: Product(
                id: 'reorder_${DateTime.now().millisecondsSinceEpoch}',
                name: productModel,
                description: 'Pesanan ulang dari riwayat',
                price: price.toDouble(),
                imagePath: 'assets/images/default_product.jpg',
                category: orderType,
              ),
              selectedSize: firstItem['size'] ?? 'L',
              firestoreService: FirestoreService(),
              sourcePage: 'riwayat', // Tambah parameter asal halaman
            ),
          ),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Pesanan berhasil dibuat! Silakan lakukan pembayaran.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error dalam Pesan Lagi: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat pesanan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleDetail(order_model.Order order, Map<dynamic, dynamic> firstItem) {
    // Navigasi ke detail pesanan berdasarkan tipe
    final orderType = firstItem['orderType'] ?? '';

    if (orderType == 'Baju') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CekDetailRiwayatBajuCustomerScreen(order: order),
        ),
      );
    } else if (orderType == 'Celana') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CekDetailRiwayatCelanaCustomerScreen(order: order),
        ),
      );
    } else {
      // Untuk model, gunakan screen detail yang baru dan lebih baik
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CekDetailPesananModelCustomerScreen(
            order: order,
            firstItem: firstItem,
          ),
        ),
      );
    }
  }

  void _handleLanjutkanPembayaran(
    order_model.Order order,
    Map<dynamic, dynamic> firstItem,
  ) {
    // Navigasi ke screen pembayaran berdasarkan tipe pesanan
    final orderType = firstItem['orderType'] ?? '';

    if (orderType == 'Baju') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PembayaranBajuCustomerScreen(
            order: order,
            sourcePage: 'riwayat', // Tambah parameter asal halaman
          ),
        ),
      );
    } else if (orderType == 'Celana') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PembayaranCelanaCustomerScreen(
            order: order,
            sourcePage: 'riwayat', // Tambah parameter asal halaman
          ),
        ),
      );
    } else {
      // Untuk model, gunakan screen model
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PembayaranModelCustomerScreen(
            product: Product(
              id: 'reorder_${DateTime.now().millisecondsSinceEpoch}',
              name: firstItem['model'] ?? 'Model',
              description: 'Pesanan ulang dari riwayat',
              price: firstItem['price'] ?? 0,
              imagePath: 'assets/images/default_product.jpg',
              category: orderType,
            ),
            selectedSize: firstItem['size'] ?? 'L',
            firestoreService: FirestoreService(),
            sourcePage: 'riwayat', // Tambah parameter asal halaman
          ),
        ),
      );
    }
  }

  String _formatCurrency(double amount) {
    // Format manual untuk currency Indonesia
    final number = amount.toInt();
    final formatted = number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return formatted;
  }
}
