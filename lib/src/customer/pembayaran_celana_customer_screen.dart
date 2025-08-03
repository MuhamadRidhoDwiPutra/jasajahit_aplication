import 'cek_detail_pesanan_celana_screen.dart';
import 'package:flutter/material.dart';
import 'berhasil_pesan_celana_customer_screen.dart';
import 'home_customer_screen.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PembayaranCelanaCustomerScreen extends StatefulWidget {
  final Order order;
  final FirestoreService _firestoreService = FirestoreService();

  PembayaranCelanaCustomerScreen({super.key, required this.order});

  @override
  State<PembayaranCelanaCustomerScreen> createState() =>
      _PembayaranCelanaCustomerScreenState();
}

class _PembayaranCelanaCustomerScreenState
    extends State<PembayaranCelanaCustomerScreen> {
  File? _selectedFile;
  String? _fileName;
  final ImagePicker _picker = ImagePicker();

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
          onPressed: () => Navigator.pop(context),
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
                      // Gambar pakaian
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[700] : Colors.grey[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Gambar pakaian',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
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
                              'Total Harga:\nRp. ${widget.order.estimatedPrice?.toStringAsFixed(0) ?? widget.order.price.toStringAsFixed(0)}',
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
                          '• ${item['orderType'] ?? '-'} - ${item['jenisCelana'] ?? item['model'] ?? '-'} (Rp ${item['price']?.toStringAsFixed(0) ?? '0'})',
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
                              builder: (context) =>
                                  CekDetailPesananCelanaScreen(
                                    order: widget.order,
                                  ),
                            ),
                          );
                        },
                        child: Text(
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

                    // Simpan order terlebih dahulu
                    final orderDoc = await widget._firestoreService.saveOrder(
                      widget.order,
                    );

                    // Upload bukti pembayaran
                    final paymentProofUrl = await widget._firestoreService
                        .uploadPaymentProof(_selectedFile!, orderDoc.id);

                    // Update order dengan URL bukti pembayaran
                    await widget._firestoreService.updateOrderWithPaymentProof(
                      orderDoc.id,
                      paymentProofUrl,
                      _fileName ?? 'bukti_pembayaran.jpg',
                    );

                    // Tutup loading dialog
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BerhasilPesanCelanaCustomerScreen(
                          order: widget.order,
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
