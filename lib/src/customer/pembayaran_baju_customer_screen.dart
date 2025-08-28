// ignore: unused_import
import 'package:jasa_jahit_aplication/src/customer/konfirmasi_desain_baju_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart'
    as order_model;
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';
import 'package:jasa_jahit_aplication/src/services/notification_service.dart';
import 'cek_detail_pesanan_baju_screen.dart';
import 'package:flutter/material.dart';
import 'berhasil_pesan_baju_customer_screen.dart';
import 'home_customer_screen.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jasa_jahit_aplication/Core/provider/auth_provider.dart'
    as app_auth;

class PembayaranBajuCustomerScreen extends StatefulWidget {
  final order_model.Order order;
  final FirestoreService _firestoreService = FirestoreService();
  final String? sourcePage; // Tambah parameter untuk tracking asal halaman
  final bool isDraft; // Tambah parameter untuk menandai apakah ini adalah draft

  PembayaranBajuCustomerScreen({
    super.key,
    required this.order,
    this.sourcePage, // Parameter opsional
    this.isDraft = false, // Parameter opsional, default false
  });

  @override
  State<PembayaranBajuCustomerScreen> createState() =>
      _PembayaranBajuCustomerScreenState();
}

class _PembayaranBajuCustomerScreenState
    extends State<PembayaranBajuCustomerScreen> {
  File? _selectedFile;
  String? _fileName;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickFile() async {
    try {
      // Coba pick image dengan error handling yang lebih baik
      final XFile? pickedFile = await _picker
          .pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
            maxWidth: 1920,
            maxHeight: 1080,
          )
          .catchError((error) {
            print('Image picker error: $error');
            throw Exception(
              'Gagal membuka galeri. Pastikan aplikasi memiliki izin akses galeri.',
            );
          });

      if (pickedFile != null) {
        try {
          final file = File(pickedFile.path);

          // Validasi file exists
          if (!await file.exists()) {
            throw Exception('File tidak ditemukan');
          }

          // Validasi ukuran file (max 10MB)
          final fileSize = await file.length();
          if (fileSize > 10 * 1024 * 1024) {
            throw Exception('Ukuran file terlalu besar (maksimal 10MB)');
          }

          setState(() {
            _selectedFile = file;
            _fileName = pickedFile.name;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File berhasil dipilih'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (fileError) {
          throw Exception('Gagal memproses file: $fileError');
        }
      }
    } catch (e) {
      print('File picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih file: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Coba Lagi',
            textColor: Colors.white,
            onPressed: () => _pickFile(),
          ),
        ),
      );
    }
  }

  // Method untuk menghitung total harga dari semua item
  double _calculateTotalPrice() {
    double total = 0;
    for (var item in widget.order.items) {
      total += (item['price'] ?? 0).toDouble();
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFF8FBC8F),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            // Navigasi cerdas berdasarkan asal halaman
            switch (widget.sourcePage) {
              case 'riwayat':
                // Dari "Pesan Lagi" di riwayat, kembali ke riwayat
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const HomeCustomerScreen(initialIndex: 3),
                  ),
                );
                break;
              case 'home':
                // Dari pembelian di home, kembali ke home
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const HomeCustomerScreen(initialIndex: 0),
                  ),
                );
                break;
              case 'multi_order':
                // Dari multi order, kembali ke halaman input ukuran baju
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const HomeCustomerScreen(initialIndex: 1),
                  ),
                );
                break;
              default:
                // Default: kembali ke halaman sebelumnya
                Navigator.pop(context);
                break;
            }
          },
        ),
        title: Text(
          'Daftar Pesanan',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Detail Pesanan',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Card utama
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Model pakaian
                  Text(
                    'Detail Pesanan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon belanja
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[700] : Colors.grey[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.shopping_bag,
                            size: 32,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Data pesanan
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Pemesanan\n${widget.order.orderDate.toDate().day} ${_getMonth(widget.order.orderDate.toDate().month)} ${widget.order.orderDate.toDate().year}',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              'Jumlah Produk\n${widget.order.items.length}',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              'Total Harga:\nRp. ${_calculateTotalPrice().toStringAsFixed(0)}',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.order.items.length > 1) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Daftar Item:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...widget.order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• ${item['orderType'] ?? '-'} - ${item['jenisBaju'] ?? item['model'] ?? '-'} (Rp ${item['price']?.toStringAsFixed(0) ?? '0'})',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'No. Rekening: 073253718293',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CekDetailPesananBajuScreen(
                                order: widget.order,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Cek detail',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Upload bukti pembayaran
            Text(
              'Kirim bukti pembayaran',
              style: TextStyle(color: isDark ? Colors.white : Colors.white),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? const Color(0xFF2A2A2A)
                          : Colors.grey[300],
                      foregroundColor: isDark ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      _pickFile();
                    },
                    child: _selectedFile != null
                        ? Text('File dipilih: $_fileName')
                        : const Text('Choose file'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color(0xFF2A2A2A)
                        : Colors.grey[300],
                    foregroundColor: isDark ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    _pickFileFromCamera();
                  },
                  child: const Text('Camera'),
                ),
              ],
            ),
            if (_selectedFile != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.attach_file,
                      color: isDark ? Colors.white70 : Colors.black54,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _fileName ?? 'File terpilih',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: isDark ? Colors.white70 : Colors.black54,
                        size: 16,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedFile = null;
                          _fileName = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),
            // QRIS
            Text(
              'QRIS',
              style: TextStyle(color: isDark ? Colors.white : Colors.white),
            ),
            const SizedBox(height: 6),
            Center(
              child: Container(
                width: 120,
                height: 90,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Scan disini',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  if (_selectedFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Silakan pilih bukti pembayaran terlebih dahulu',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  try {
                    // Tampilkan loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Text('Menyimpan pesanan...'),
                            ],
                          ),
                        );
                      },
                    );

                    // Dapatkan data customer
                    final customerData = await _getCustomerData();

                    // Jika ini adalah draft (dari fitur Pesan Lagi), simpan order baru
                    // Jika bukan draft (dari pesanan baru), gunakan order yang sudah ada
                    String orderId;
                    if (widget.isDraft) {
                      // Simpan order baru untuk draft
                      final orderDoc = await widget._firestoreService.saveOrder(
                        widget.order,
                      );
                      orderId = orderDoc.id;
                      print(
                        '🔍 DEBUG: Order draft disimpan dengan ID: $orderId',
                      );
                    } else {
                      // Gunakan order yang sudah ada
                      orderId = widget.order.id ?? '';
                      print(
                        '🔍 DEBUG: Menggunakan order yang sudah ada dengan ID: $orderId',
                      );
                    }

                    print('🔍 DEBUG PembayaranBajuCustomerScreen:');
                    print('   - orderId: $orderId');
                    print('   - widget.order.id (sebelum): ${widget.order.id}');

                    // Upload bukti pembayaran
                    final paymentProofUrl = await widget._firestoreService
                        .uploadPaymentProof(_selectedFile!, orderId);

                    // Update order dengan URL bukti pembayaran
                    await widget._firestoreService.updateOrderWithPaymentProof(
                      orderId,
                      paymentProofUrl,
                      _fileName ?? 'bukti_pembayaran.jpg',
                    );

                    // Kirim notifikasi ke admin
                    await NotificationService.sendJasaJahitNotification(
                      customerName: customerData['name'] ?? 'Customer',
                      orderType: 'Baju',
                      orderId: orderId,
                      price: widget.order.totalPrice ?? 0,
                    );

                    // Tambahkan notifikasi ke Firestore untuk admin
                    await firestore.FirebaseFirestore.instance
                        .collection('notifications')
                        .add({
                          'title': 'Pesanan Baru',
                          'body':
                              '${customerData['name'] ?? 'Customer'} telah membuat pesanan Baju seharga Rp ${(widget.order.totalPrice ?? 0).toStringAsFixed(0)}',
                          'orderId': orderId,
                          'customerId':
                              FirebaseAuth.instance.currentUser?.uid ??
                              'customer_001',
                          'type': 'new_order',
                          'recipientRole': 'admin',
                          'recipientId': 'admin_001',
                          'timestamp': firestore.FieldValue.serverTimestamp(),
                          'isRead': false,
                          'createdAt': firestore.FieldValue.serverTimestamp(),
                        });

                    // Tutup loading dialog
                    Navigator.pop(context);

                    // Buat order baru dengan ID yang sudah didapatkan dari Firebase
                    final updatedOrder = order_model.Order(
                      id: orderId,
                      userId: widget.order.userId,
                      userName: widget.order.userName,
                      customerName: widget.order.customerName,
                      customerAddress: widget.order.customerAddress,
                      items: widget.order.items,
                      status: widget.order.status,
                      orderDate: widget.order.orderDate,
                      totalPrice: widget.order.totalPrice,
                      paymentProofUrl: paymentProofUrl,
                      paymentProofFileName: _fileName ?? 'bukti_pembayaran.jpg',
                      estimatedPrice: widget.order.estimatedPrice,
                      estimatedSize: widget.order.estimatedSize,
                      isCustomSize: widget.order.isCustomSize,
                      selectedKain: widget.order.selectedKain,
                    );

                    print('   - updatedOrder.id: ${updatedOrder.id}');
                    print('   - updatedOrder.userId: ${updatedOrder.userId}');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BerhasilPesanBajuCustomerScreen(
                          order: updatedOrder,
                        ),
                      ),
                    );
                  } catch (e) {
                    // Tutup loading dialog jika masih terbuka
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menyimpan pesanan: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Bayar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFileFromCamera() async {
    try {
      // Coba pick image dari camera dengan error handling yang lebih baik
      final XFile? pickedFile = await _picker
          .pickImage(
            source: ImageSource.camera,
            imageQuality: 80,
            maxWidth: 1920,
            maxHeight: 1080,
          )
          .catchError((error) {
            print('Camera picker error: $error');
            throw Exception(
              'Gagal membuka camera. Pastikan aplikasi memiliki izin akses camera.',
            );
          });

      if (pickedFile != null) {
        try {
          final file = File(pickedFile.path);

          // Validasi file exists
          if (!await file.exists()) {
            throw Exception('File tidak ditemukan');
          }

          // Validasi ukuran file (max 10MB)
          final fileSize = await file.length();
          if (fileSize > 10 * 1024 * 1024) {
            throw Exception('Ukuran file terlalu besar (maksimal 10MB)');
          }

          setState(() {
            _selectedFile = file;
            _fileName = 'camera_${DateTime.now().millisecondsSinceEpoch}.jpg';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto berhasil diambil'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (fileError) {
          throw Exception('Gagal memproses foto: $fileError');
        }
      }
    } catch (e) {
      print('Camera picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil foto: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Coba Lagi',
            textColor: Colors.white,
            onPressed: () => _pickFileFromCamera(),
          ),
        ),
      );
    }
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
    'Desember',
  ];
  return months[month - 1];
}

// ignore: unused_element
class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? const Color(0xFFDE8500).withOpacity(0.2)
                    : const Color(0xFFDE8500).withOpacity(0.1))
              : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFFDE8500), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFDE8500).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFFDE8500), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFDE8500),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
