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
  late TextEditingController _searchController;
  String _sortBy = 'date'; // 'date', 'name', 'model'

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Method untuk mengurutkan hasil pencarian
  void _sortOrders(List<order_model.Order> orders) {
    switch (_sortBy) {
      case 'date':
        // Urutkan berdasarkan tanggal (terbaru di atas)
        orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
        break;
      case 'name':
        // Urutkan berdasarkan nama user (A-Z)
        orders.sort((a, b) => a.userName.compareTo(b.userName));
        break;
      case 'model':
        // Urutkan berdasarkan model produk (A-Z)
        orders.sort((a, b) {
          final aModel = a.items.isNotEmpty
              ? (a.items.first['model'] ?? '')
              : '';
          final bModel = b.items.isNotEmpty
              ? (b.items.first['model'] ?? '')
              : '';
          return aModel.compareTo(bModel);
        });
        break;
    }
  }

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
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText:
                              'Cari pesanan... (kode, nama, model, jenis)',
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
                                      _searchController.clear();
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
                      const SizedBox(height: 8),
                      // Dropdown untuk memilih urutan sorting
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sortBy,
                            isExpanded: true,
                            icon: Icon(
                              Icons.sort,
                              color: isDark ? Colors.white70 : Colors.grey[600],
                            ),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                            dropdownColor: isDark
                                ? const Color(0xFF2A2A2A)
                                : Colors.white,
                            items: const [
                              DropdownMenuItem(
                                value: 'date',
                                child: Text('Urutkan: Tanggal (Terbaru)'),
                              ),
                              DropdownMenuItem(
                                value: 'name',
                                child: Text('Urutkan: Nama (A-Z)'),
                              ),
                              DropdownMenuItem(
                                value: 'model',
                                child: Text('Urutkan: Model (A-Z)'),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _sortBy = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
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
                                // Hanya tampilkan pesanan yang sudah selesai atau dibatalkan di riwayat
                                final status = order.status.toLowerCase();
                                return status.contains('selesai') ||
                                    status.contains('batal') ||
                                    status.contains('pembayaran selesai');
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

                      // Urutkan hasil pencarian berdasarkan kriteria yang dipilih
                      _sortOrders(orders);
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
                        padding: const EdgeInsets.all(12), // Kurangi dari 16
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final firstItem = (order.items.isNotEmpty)
                              ? order.items[0]
                              : {};
                          final orderType = firstItem['orderType'] ?? '-';

                          // Hitung total harga dan jumlah item
                          final totalPrice = order.items.fold<double>(
                            0,
                            (sum, item) =>
                                sum + (item['price'] ?? 0).toDouble(),
                          );
                          final itemCount = order.items.length;
                          final isMultiOrder = itemCount > 1;

                          final price = isMultiOrder
                              ? totalPrice
                              : (order.estimatedPrice?.toDouble() ??
                                    order.totalPrice ??
                                    firstItem['price'] ??
                                    0);

                          // Cek status order untuk menentukan tampilan
                          final orderStatus = order.status.toLowerCase();
                          final isCompleted =
                              orderStatus.contains('selesai') ||
                              orderStatus.contains('pembayaran selesai');
                          final isCancelled = orderStatus.contains('batal');

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ), // Kurangi dari 16
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
                                  padding: const EdgeInsets.all(
                                    12,
                                  ), // Kurangi dari 16
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
                                          horizontal: 6, // Kurangi dari 8
                                          vertical: 3, // Kurangi dari 4
                                        ),
                                        decoration: BoxDecoration(
                                          color: isCompleted
                                              ? Colors.green.withOpacity(0.2)
                                              : isCancelled
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.orange.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8, // Kurangi dari 12
                                          ),
                                        ),
                                        child: Text(
                                          isCompleted
                                              ? 'Selesai' // Singkat teks untuk mencegah overflow
                                              : isCancelled
                                              ? 'Batal' // Status untuk pesanan yang dibatalkan
                                              : 'Bayar', // Status untuk pesanan yang belum dibayar
                                          style: TextStyle(
                                            fontSize: 11, // Kurangi dari 12
                                            fontWeight: FontWeight.w500,
                                            color: isCompleted
                                                ? Colors.green
                                                : isCancelled
                                                ? Colors.red
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
                                  padding: const EdgeInsets.all(
                                    12,
                                  ), // Kurangi dari 16
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isMultiOrder
                                            ? 'Multi Order'
                                            : orderType,
                                        style: TextStyle(
                                          fontSize: 15, // Kurangi dari 16
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontFamily: 'SF Pro Display',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Tambahkan detail pesanan dengan pembedaan single vs multi item
                                      if (firstItem['jenisBaju'] != null ||
                                          firstItem['jenisCelana'] != null ||
                                          firstItem['model'] != null) ...[
                                        // Cek apakah ini multi item order
                                        if (order.items.length > 1) ...[
                                          Text(
                                            '${order.items.length} Items',
                                            style: TextStyle(
                                              fontSize: 13, // Kurangi dari 14
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'First: ${firstItem['jenisBaju'] ?? firstItem['jenisCelana'] ?? firstItem['model'] ?? '-'}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.grey[600],
                                              fontFamily: 'SF Pro Text',
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ] else ...[
                                          Text(
                                            'Model: ${firstItem['jenisBaju'] ?? firstItem['jenisCelana'] ?? firstItem['model'] ?? '-'}',
                                            style: TextStyle(
                                              fontSize: 13, // Kurangi dari 14
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black54,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 4),
                                      ],
                                      if (firstItem['fabric'] != null ||
                                          order.selectedKain != null) ...[
                                        // Cek apakah ini multi item order
                                        if (order.items.length > 1) ...[
                                          Text(
                                            'Kain: Various',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black54,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                        ] else ...[
                                          Text(
                                            'Kain: ${firstItem['fabric'] ?? order.selectedKain ?? '-'}',
                                            style: TextStyle(
                                              fontSize: 13, // Kurangi dari 14
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black54,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 4),
                                      ],
                                      if (firstItem['measurements'] != null ||
                                          order.estimatedSize != null) ...[
                                        // Cek apakah ini multi item order
                                        if (order.items.length > 1) ...[
                                          Text(
                                            'Ukuran: Various',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black54,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                        ] else ...[
                                          Text(
                                            'Ukuran: ${order.isCustomSize == true ? 'Custom' : (order.estimatedSize ?? 'Standard')}',
                                            style: TextStyle(
                                              fontSize: 13, // Kurangi dari 14
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black54,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 4),
                                      ],
                                      if (firstItem['size'] != null) ...[
                                        // Cek apakah ini multi item order
                                        if (order.items.length > 1) ...[
                                          Text(
                                            'Size: Various',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black54,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                        ] else ...[
                                          Text(
                                            'Size: ${firstItem['size']}',
                                            style: TextStyle(
                                              fontSize: 13, // Kurangi dari 14
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black54,
                                              fontFamily: 'SF Pro Text',
                                            ),
                                          ),
                                        ],
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
                                              fontSize: 13, // Kurangi dari 14
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
                                                      vertical:
                                                          10, // Kurangi dari 12
                                                    ),
                                              ),
                                              icon: const Icon(
                                                Icons.visibility,
                                                color: Colors.white,
                                                size: 18, // Kurangi ukuran icon
                                              ),
                                              label: const Text(
                                                'Cek Detail',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      12, // Kurangi ukuran font
                                                ),
                                              ),
                                              onPressed: () {
                                                _handleDetail(order, firstItem);
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ), // Kurangi dari 8
                                          // Tombol Pesan Lagi hanya untuk pesanan yang sudah selesai
                                          if (isCompleted) ...[
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
                                                        vertical:
                                                            10, // Kurangi dari 12
                                                      ),
                                                ),
                                                icon: const Icon(
                                                  Icons.shopping_cart,
                                                  color: Colors.white,
                                                  size:
                                                      18, // Kurangi ukuran icon
                                                ),
                                                label: const Text(
                                                  'Pesan Lagi',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        12, // Kurangi ukuran font
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
                                                        vertical:
                                                            10, // Kurangi dari 12
                                                      ),
                                                ),
                                                icon: const Icon(
                                                  Icons.payment,
                                                  color: Colors.white,
                                                  size:
                                                      18, // Kurangi ukuran icon
                                                ),
                                                label: const Text(
                                                  'Bayar', // Singkat teks untuk mencegah overflow
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        12, // Kurangi ukuran font
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
                                      if (!isCompleted && !isCancelled) ...[
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

      // Buat order sementara (tidak disimpan ke database) untuk navigasi
      // Salin semua item dari order asli untuk mendukung multi order
      final tempOrder = order_model.Order(
        id: null,
        userId: userId,
        userName: order.userName,
        customerName: order.customerName,
        customerAddress: order.customerAddress,
        items: order.items, // Salin semua item, bukan hanya item pertama
        status: 'Draft', // Status sementara, bukan 'Menunggu Konfirmasi'
        orderDate: Timestamp.now(),
        totalPrice: order.items.fold<double>(
          0,
          (sum, item) => sum + (item['price'] ?? 0).toDouble(),
        ), // Hitung total dari semua item
        estimatedPrice: order.items.fold<int>(
          0,
          (sum, item) => sum + ((item['price'] ?? 0) as int),
        ), // Hitung total dari semua item
        estimatedSize: estimatedSize,
        isCustomSize: isCustomSize,
        selectedKain: fabric,
      );

      print('Order sementara dibuat untuk navigasi');

      // Navigasi ke screen pembayaran berdasarkan tipe pesanan
      if (orderType == 'Baju') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PembayaranBajuCustomerScreen(
              order: tempOrder,
              sourcePage: 'riwayat', // Tambah parameter asal halaman
              isDraft: true, // Tambah parameter untuk menandai ini adalah draft
            ),
          ),
        );
      } else if (orderType == 'Celana') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PembayaranCelanaCustomerScreen(
              order: tempOrder,
              sourcePage: 'riwayat', // Tambah parameter asal halaman
              isDraft: true, // Tambah parameter untuk menandai ini adalah draft
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
              isDraft: true, // Tambah parameter untuk menandai ini adalah draft
              order: tempOrder, // Tambah parameter order untuk kasus draft
            ),
          ),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Silakan lakukan pembayaran untuk melanjutkan pesanan.',
            ),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      print('Error dalam Pesan Lagi: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memproses pesanan: $e'),
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
            order:
                order, // Tambah parameter order untuk kasus lanjutkan pembayaran
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
