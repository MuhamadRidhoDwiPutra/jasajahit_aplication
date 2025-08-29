import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart'
    as order_model;
import 'package:jasa_jahit_aplication/src/model/product_model.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';
import 'package:jasa_jahit_aplication/src/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'berhasil_pesan_model_customer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jasa_jahit_aplication/Core/provider/auth_provider.dart'
    as app_auth;
import 'home_customer_screen.dart';

class PembayaranModelCustomerScreen extends StatefulWidget {
  final Product product;
  final String selectedSize;
  final FirestoreService firestoreService;
  final String? sourcePage; // Tambah parameter untuk tracking asal halaman
  final bool isDraft; // Tambah parameter untuk menandai apakah ini adalah draft
  final order_model.Order? order; // Tambah parameter order untuk kasus draft

  const PembayaranModelCustomerScreen({
    super.key,
    required this.product,
    required this.selectedSize,
    required this.firestoreService,
    this.sourcePage, // Parameter opsional
    this.isDraft = false, // Parameter opsional, default false
    this.order, // Parameter opsional untuk kasus draft
  });

  @override
  State<PembayaranModelCustomerScreen> createState() =>
      _PembayaranModelCustomerScreenState();
}

class _PembayaranModelCustomerScreenState
    extends State<PembayaranModelCustomerScreen> {
  File? _selectedFile;
  String? _fileName;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  String _selectedSize = 'L'; // Default size

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

          if (!await file.exists()) {
            throw Exception('File tidak ditemukan');
          }

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
                // Dari multi order, kembali ke halaman input ukuran (tab Pesan)
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
          'Pembayaran Model',
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
                  Text(
                    'Detail Model',
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
                      // Data produk
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Model: ${widget.product.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ukuran: $_selectedSize',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDE8500),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Deskripsi: ${widget.product.description}',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Harga: Rp ${widget.product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDE8500),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tanggal: ${DateTime.now().day} ${_getMonth(DateTime.now().month)} ${DateTime.now().year}',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            // Tambahkan kode pesanan jika ada
                            if (widget.order?.id != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Kode Pesanan: ${widget.order!.id}',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
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
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Pilihan ukuran
            Text(
              'Pilih Ukuran',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['S', 'L', 'XL'].map((size) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedSize == size
                            ? const Color(0xFFDE8500)
                            : (isDark
                                  ? const Color(0xFF2A2A2A)
                                  : Colors.grey[300]),
                        foregroundColor: _selectedSize == size
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedSize = size;
                        });
                      },
                      child: Text(
                        size,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
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
            const SizedBox(height: 8), // Kurangi spacing karena QRIS dihapus
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
                    // Jika bukan draft (dari pesanan baru), buat order baru
                    String orderId;
                    if (widget.isDraft && widget.order != null) {
                      // Simpan order baru untuk draft
                      final orderDoc = await widget.firestoreService.saveOrder(
                        widget.order!,
                      );
                      orderId = orderDoc.id;
                      print(
                        '🔍 DEBUG: Order draft disimpan dengan ID: $orderId',
                      );
                    } else {
                      // Buat order baru untuk pesanan baru
                      final order = order_model.Order(
                        userId:
                            FirebaseAuth.instance.currentUser?.uid ??
                            'customer_001',
                        userName: customerData['username'] ?? 'Customer',
                        customerName: customerData['name'],
                        customerAddress: customerData['address'],
                        items: [
                          {
                            'orderType': 'Model',
                            'model': widget.product.name,
                            'description': widget.product.description,
                            'price': widget.product.price,
                            'imagePath': widget.product.imagePath,
                            'category': widget.product.category,
                            'size': widget.selectedSize,
                          },
                        ],
                        orderDate: Timestamp.now(),
                        totalPrice: widget.product.price,
                        estimatedPrice: widget.product.price.toInt(),
                      );

                      final orderDoc = await widget.firestoreService.saveOrder(
                        order,
                      );
                      orderId = orderDoc.id;
                      print('🔍 DEBUG: Order baru dibuat dengan ID: $orderId');
                    }

                    print('🔍 DEBUG PembayaranModelCustomerScreen:');
                    print('   - orderId: $orderId');
                    print(
                      '   - widget.order.id (sebelum): ${widget.order?.id}',
                    );

                    // Upload bukti pembayaran
                    final paymentProofUrl = await widget.firestoreService
                        .uploadPaymentProof(_selectedFile!, orderId);

                    // Update order dengan URL bukti pembayaran
                    await widget.firestoreService.updateOrderWithPaymentProof(
                      orderId,
                      paymentProofUrl,
                      _fileName ?? 'bukti_pembayaran.jpg',
                    );

                    // Kirim notifikasi ke admin
                    await FirebaseFirestore.instance
                        .collection('notifications')
                        .add({
                          'title': 'Pesanan Baru',
                          'body': 'Ada pesanan baru yang memerlukan konfirmasi',
                          'orderId': orderId,
                          'customerId':
                              FirebaseAuth.instance.currentUser?.uid ??
                              'customer_001',
                          'type': 'new_order',
                          'recipientRole': 'admin',
                          'recipientId': 'admin_001',
                          'timestamp': FieldValue.serverTimestamp(),
                          'isRead': false,
                          'createdAt': FieldValue.serverTimestamp(),
                        });

                    // Tutup loading dialog
                    Navigator.pop(context);

                    // Buat order baru dengan ID yang sudah didapatkan dari Firebase
                    final updatedOrder = order_model.Order(
                      id: orderId,
                      userId: widget.isDraft && widget.order != null
                          ? widget.order!.userId
                          : (FirebaseAuth.instance.currentUser?.uid ??
                                'customer_001'),
                      userName: widget.isDraft && widget.order != null
                          ? widget.order!.userName
                          : (customerData['username'] ?? 'Customer'),
                      customerName: widget.isDraft && widget.order != null
                          ? widget.order!.customerName
                          : customerData['name'],
                      customerAddress: widget.isDraft && widget.order != null
                          ? widget.order!.customerAddress
                          : customerData['address'],
                      items: widget.isDraft && widget.order != null
                          ? widget.order!.items
                          : [
                              {
                                'orderType': 'Model',
                                'model': widget.product.name,
                                'description': widget.product.description,
                                'price': widget.product.price,
                                'imagePath': widget.product.imagePath,
                                'category': widget.product.category,
                                'size': widget.selectedSize,
                              },
                            ],
                      status: widget.isDraft && widget.order != null
                          ? widget.order!.status
                          : 'Menunggu Konfirmasi',
                      orderDate: widget.isDraft && widget.order != null
                          ? widget.order!.orderDate
                          : Timestamp.now(),
                      totalPrice: widget.isDraft && widget.order != null
                          ? widget.order!.totalPrice
                          : widget.product.price,
                      paymentProofUrl: paymentProofUrl,
                      paymentProofFileName: _fileName ?? 'bukti_pembayaran.jpg',
                      estimatedPrice: widget.isDraft && widget.order != null
                          ? widget.order!.estimatedPrice
                          : widget.product.price.toInt(),
                      estimatedSize: widget.isDraft && widget.order != null
                          ? widget.order!.estimatedSize
                          : widget.selectedSize,
                      isCustomSize: widget.isDraft && widget.order != null
                          ? widget.order!.isCustomSize
                          : false,
                      selectedKain: widget.isDraft && widget.order != null
                          ? widget.order!.selectedKain
                          : null,
                    );

                    print('   - updatedOrder.id: ${updatedOrder.id}');
                    print('   - updatedOrder.userId: ${updatedOrder.userId}');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BerhasilPesanModelCustomerScreen(
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

          if (!await file.exists()) {
            throw Exception('File tidak ditemukan');
          }

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
