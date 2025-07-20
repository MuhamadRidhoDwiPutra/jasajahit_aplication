import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk Clipboard
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart'
    as order_model;
import 'package:cloud_firestore/cloud_firestore.dart';

class CekDetailAdminScreen extends StatelessWidget {
  final order_model.Order order;

  const CekDetailAdminScreen({super.key, required this.order, required String orderCode, required String model, required String fabricType, required int productQuantity, required String orderDate, required Map measurements, required String orderType});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        elevation: 1,
        title: Text(
          'Detail Pesanan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi Customer
            Card(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Customer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'Nama',
                      value: order.userName,
                      isDark: isDark,
                    ),
                    _DetailRow(
                      label: 'ID Customer',
                      value: order.userId,
                      isDark: isDark,
                      canCopy: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Detail Pesanan
            Card(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Pesanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'Status',
                      value: order.status,
                      isDark: isDark,
                    ),
                    _DetailRow(
                      label: 'Tanggal Pesanan',
                      value:
                          '${order.orderDate.toDate().day}/${order.orderDate.toDate().month}/${order.orderDate.toDate().year}',
                      isDark: isDark,
                    ),
                    _DetailRow(
                      label: 'Total Harga',
                      value: 'Rp ${order.price.toStringAsFixed(0)}',
                      isDark: isDark,
                    ),
                    _DetailRow(
                      label: 'Jumlah Item',
                      value: '${order.items.length} item',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Daftar Item
            if (order.items.isNotEmpty) ...[
              Card(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar Item',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...order.items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item['orderType'] ?? '-'} - ${item['model'] ?? '-'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Kain: ${item['fabric'] ?? '-'}',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'Harga: Rp ${item['price']?.toStringAsFixed(0) ?? '0'}',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                  if (item['measurements'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Ukuran: ${_formatMeasurements(item['measurements'])}',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Bukti Pembayaran
            if (order.paymentProofUrl != null) ...[
              Card(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bukti Pembayaran',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (order.paymentProofFileName != null)
                        _DetailRow(
                          label: 'Nama File',
                          value: order.paymentProofFileName!,
                          isDark: isDark,
                        ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? Colors.white24 : Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            order.paymentProofUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Gagal memuat gambar',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatMeasurements(Map<String, dynamic> measurements) {
    List<String> formatted = [];
    measurements.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        formatted.add('$key: $value cm');
      }
    });
    return formatted.join(', ');
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool canCopy;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.canCopy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
                if (canCopy)
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      size: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Berhasil disalin ke clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
