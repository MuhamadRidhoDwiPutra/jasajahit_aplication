import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart';
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'home_customer_screen.dart';

class CekDetailPesananModelCustomerScreen extends StatelessWidget {
  final Order order;
  final Map<dynamic, dynamic> firstItem;

  const CekDetailPesananModelCustomerScreen({
    super.key,
    required this.order,
    required this.firstItem,
  });

  // Method untuk menghitung total harga dari semua item
  double _calculateTotalPrice() {
    double total = 0;
    for (var item in order.items) {
      total += (item['price'] ?? 0).toDouble();
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Ambil data dari order
    final kodePesanan = order.id ?? 'N/A';
    final tanggalPesanan = order.orderDate.toDate();

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        elevation: 1,
        title: Text(
          'Detail Pesanan Model',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            elevation: 3,
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kode Pesanan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          kodePesanan,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: kodePesanan));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kode pesanan berhasil disalin!'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.copy,
                          color: const Color(0xFFDE8500),
                          size: 20,
                        ),
                        tooltip: 'Salin kode pesanan',
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    'Model',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    firstItem['model'] ?? '-',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    'Kategori',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    firstItem['category'] ?? firstItem['orderType'] ?? '-',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    'Ukuran',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    firstItem['size'] ?? 'Standard',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    'Jumlah Produk',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.items.length}',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  // Tampilkan semua item jika multi order
                  if (order.items.length > 1) ...[
                    const Divider(height: 24),
                    Text(
                      'Daftar Item Pesanan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...order.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final itemModel = item['model'] ?? '-';
                      final itemPrice = item['price'] ?? 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? Colors.white24
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDE8500),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Item ${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _DetailRow(
                              label: 'Model',
                              value: itemModel,
                              isDark: isDark,
                            ),
                            _DetailRow(
                              label: 'Harga',
                              value: 'Rp ${itemPrice.toStringAsFixed(0)}',
                              isDark: isDark,
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 24),
                    // Total harga untuk multi order
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Harga:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          'Rp ${_calculateTotalPrice().toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: const Color(0xFFDE8500),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Untuk single order, tampilkan harga item pertama
                    const Divider(height: 24),
                    Text(
                      'Harga',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${_formatCurrency(firstItem['price'] ?? 0)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                  const Divider(height: 24),
                  Text(
                    'Tanggal Pesan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tanggalPesanan.day} ${_getMonth(tanggalPesanan.month)} ${tanggalPesanan.year}',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDE8500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Kembali',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    status = status.toLowerCase();
    if (status.contains('menunggu konfirmasi')) {
      return Colors.orange;
    } else if (status.contains('dikonfirmasi')) {
      return Colors.blue;
    } else if (status.contains('sedang dikerjakan')) {
      return Colors.amber;
    } else if (status.contains('selesai')) {
      return Colors.green;
    } else if (status.contains('batal')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  String _formatCurrency(double amount) {
    final number = amount.toInt();
    final formatted = number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return formatted;
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
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
