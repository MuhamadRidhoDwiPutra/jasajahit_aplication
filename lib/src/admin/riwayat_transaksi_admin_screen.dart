import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';

class RiwayatTransaksiAdminScreen extends StatefulWidget {
  const RiwayatTransaksiAdminScreen({super.key});

  @override
  State<RiwayatTransaksiAdminScreen> createState() =>
      _RiwayatTransaksiAdminScreenState();
}

class _RiwayatTransaksiAdminScreenState
    extends State<RiwayatTransaksiAdminScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Search and filter variables
  late TextEditingController _searchController;
  String _searchQuery = '';
  String _selectedStatusFilter = 'Semua Status';
  String _sortBy = 'name'; // 'name', 'status'
  bool _isAscending = false;

  List<String> statusOptions = ['Pesanan telah selesai', 'Pesanan Dibatalkan'];

  List<String> get allStatusOptions => ['Semua Status', ...statusOptions];

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

  // Search and filter functions
  List<QueryDocumentSnapshot> _filterAndSortOrders(
    List<QueryDocumentSnapshot> orders,
  ) {
    List<QueryDocumentSnapshot> filteredOrders = orders.where((order) {
      final orderData = order.data() as Map<String, dynamic>;

      // Hanya tampilkan pesanan yang sudah selesai atau dibatalkan
      final status = orderData['status']?.toString().toLowerCase() ?? '';
      if (!status.contains('selesai') && !status.contains('batal')) {
        return false;
      }

      // Status filter
      if (_selectedStatusFilter != 'Semua Status') {
        if (orderData['status'] != _selectedStatusFilter) {
          return false;
        }
      }

      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final orderId = order.id.toLowerCase();
        final customerName = (orderData['customerName'] ?? '')
            .toString()
            .toLowerCase();
        final userName = (orderData['userName'] ?? '').toString().toLowerCase();
        final customerAddress = (orderData['customerAddress'] ?? '')
            .toString()
            .toLowerCase();
        final orderStatus = (orderData['status'] ?? '')
            .toString()
            .toLowerCase();

        if (!orderId.contains(query) &&
            !customerName.contains(query) &&
            !userName.contains(query) &&
            !customerAddress.contains(query) &&
            !orderStatus.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort orders
    filteredOrders.sort((a, b) {
      final aData = a.data() as Map<String, dynamic>;
      final bData = b.data() as Map<String, dynamic>;

      int comparison = 0;

      switch (_sortBy) {
        case 'name':
          final aName = (aData['customerName'] ?? aData['userName'] ?? '')
              .toString();
          final bName = (bData['customerName'] ?? bData['userName'] ?? '')
              .toString();
          comparison = aName.compareTo(bName);
          break;
        case 'status':
          final aStatus = (aData['status'] ?? '').toString();
          final bStatus = (bData['status'] ?? '').toString();
          comparison = aStatus.compareTo(bStatus);
          break;
      }

      return _isAscending ? comparison : -comparison;
    });

    return filteredOrders;
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  Color _getStatusColor(String status) {
    status = status.toLowerCase();
    if (status.contains('selesai')) {
      return Colors.green; // #4CAF50
    } else if (status.contains('batal')) {
      return Colors.red; // #F44336
    }
    return const Color(0xFFDE8500); // Default orange
  }

  // Fungsi untuk mendapatkan data customer yang benar
  Future<Map<String, String>> _getCustomerData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return {
          'name': userData['name'] ?? userData['username'] ?? 'Tanpa Nama',
          'username':
              userData['username'] ?? userData['email'] ?? 'Tanpa Username',
          'address': userData['address'] ?? 'Alamat belum diisi',
        };
      }
    } catch (e) {
      print('Error getting customer data: $e');
    }
    return {
      'name': 'Tanpa Nama',
      'username': 'Tanpa Username',
      'address': 'Alamat belum diisi',
    };
  }

  // Fungsi untuk format tanggal yang aman
  String _formatOrderDate(dynamic orderDate) {
    try {
      if (orderDate is Timestamp) {
        return orderDate.toDate().toString().substring(0, 19);
      } else if (orderDate is DateTime) {
        return orderDate.toString().substring(0, 19);
      } else {
        return 'Tanggal tidak tersedia';
      }
    } catch (e) {
      print('Error formatting date: $e');
      return 'Tanggal tidak tersedia';
    }
  }

  // Fungsi pencarian yang lebih canggih
  List<QueryDocumentSnapshot> _filterOrders(
    List<QueryDocumentSnapshot> docs,
    String query,
  ) {
    if (query.isEmpty) return docs;

    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final searchTerm = query.toLowerCase();

      final userName = (data['userName'] as String? ?? '').toLowerCase();
      final customerName = (data['customerName'] as String? ?? '')
          .toLowerCase();
      final email = (data['email'] as String? ?? '').toLowerCase();
      final orderId = doc.id.toLowerCase();
      final status = (data['status'] as String? ?? '').toLowerCase();

      return userName.contains(searchTerm) ||
          customerName.contains(searchTerm) ||
          email.contains(searchTerm) ||
          orderId.contains(searchTerm) ||
          status.contains(searchTerm);
    }).toList();
  }

  Widget _buildResultsList(
    List<QueryDocumentSnapshot> filteredDocs,
    bool isDark,
  ) {
    if (filteredDocs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.history,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Tidak ada transaksi ditemukan'
                  : 'Belum ada transaksi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Coba ubah kata kunci pencarian',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredDocs.length,
      itemBuilder: (context, index) {
        final order = filteredDocs[index];
        final orderData = order.data() as Map<String, dynamic>;

        return FutureBuilder<Map<String, String>>(
          future: _getCustomerData(orderData['userId'] ?? ''),
          builder: (context, customerSnapshot) {
            final customerData =
                customerSnapshot.data ??
                {
                  'name':
                      orderData['customerName'] ??
                      orderData['userName'] ??
                      'Tanpa Nama',
                  'username': orderData['userName'] ?? 'Tanpa Username',
                  'address':
                      orderData['customerAddress'] ?? 'Alamat belum diisi',
                };

            return Card(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Kode: ${order.id}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              orderData['status'] ?? 'N/A',
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            orderData['status'] ?? 'N/A',
                            style: TextStyle(
                              color: _getStatusColor(
                                orderData['status'] ?? 'N/A',
                              ),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: isDark ? Colors.white24 : Colors.black12,
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8FBC8F).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.shopping_bag,
                              size: 30,
                              color: Color(0xFF8FBC8F),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nama Pelanggan',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                customerData['name'] ?? 'Tanpa Nama',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Username',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                customerData['username'] ?? 'Tanpa Username',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Alamat',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                customerData['address'] ?? 'Alamat belum diisi',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tanggal Pesan',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _formatOrderDate(orderData['orderDate']),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Total: Rp ${(orderData['estimatedPrice'] ?? orderData['totalPrice'] ?? orderData['price'] ?? 0).toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      appBar: AppBar(iconTheme: const IconThemeData(color: Color(0xFFDE8500))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                // Search bar tanpa filter
                TextField(
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Cari berdasarkan kode, nama, atau username...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey[400],
                    ),
                    fillColor: isDark ? const Color(0xFF3A3A3A) : Colors.white,
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('orders').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Terjadi kesalahan: ${snapshot.error}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filter data menggunakan fungsi pencarian yang baru
                var filteredDocs = _filterAndSortOrders(snapshot.data!.docs);

                // Tampilkan semua data tanpa search info bar
                return _buildResultsList(filteredDocs, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }
}
