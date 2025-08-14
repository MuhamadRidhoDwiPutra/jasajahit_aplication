import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart';
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/customer/home_customer_screen.dart';
import 'riwayat_customer_screen.dart';

class CekDetailRiwayatCelanaCustomerScreen extends StatelessWidget {
  final Order order;
  const CekDetailRiwayatCelanaCustomerScreen({super.key, required this.order});

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
    final estimasiHarga = order.estimatedPrice ?? 0;
    final firstItem = (order.items.isNotEmpty) ? order.items[0] : {};
    final model = firstItem['jenisCelana'] ?? '-';
    final fabric = firstItem['fabric'] ?? '-';
    final measurements = firstItem['measurements'] ?? {};
    final orderType = (firstItem['orderType'] ?? '').toString();

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        elevation: 1,
        title: Text(
          'Detail Pesanan Celana',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeCustomerScreen(initialIndex: 3),
              ),
            );
          },
        ),
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
                    model,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    'Jenis Kain',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fabric,
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
                      final itemModel = item['jenisCelana'] ?? '-';
                      final itemFabric = item['fabric'] ?? '-';
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
                              label: 'Jenis Kain',
                              value: itemFabric,
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
                      'Rp ${estimasiHarga.toStringAsFixed(0)}',
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
                  Builder(
                    builder: (context) {
                      if (orderType.toLowerCase() == 'celana') {
                        return Text(
                          [
                            if (measurements['panjangCelana'] != null &&
                                measurements['panjangCelana']
                                    .toString()
                                    .isNotEmpty)
                              'Panjang Celana: ${measurements['panjangCelana']} cm',
                            if (measurements['lingkarPinggang'] != null &&
                                measurements['lingkarPinggang']
                                    .toString()
                                    .isNotEmpty)
                              'Lingkar Pinggang: ${measurements['lingkarPinggang']} cm',
                            if (measurements['lingkarPinggul'] != null &&
                                measurements['lingkarPinggul']
                                    .toString()
                                    .isNotEmpty)
                              'Lingkar Pinggul: ${measurements['lingkarPinggul']} cm',
                            if (measurements['lingkarPesak'] != null &&
                                measurements['lingkarPesak']
                                    .toString()
                                    .isNotEmpty)
                              'Lingkar Pesak: ${measurements['lingkarPesak']} cm',
                            if (measurements['lingkarPaha'] != null &&
                                measurements['lingkarPaha']
                                    .toString()
                                    .isNotEmpty)
                              'Lingkar Paha: ${measurements['lingkarPaha']} cm',
                            if (measurements['lebarBawahCelana'] != null &&
                                measurements['lebarBawahCelana']
                                    .toString()
                                    .isNotEmpty)
                              'Lebar Bawah Celana: ${measurements['lebarBawahCelana']} cm',
                          ].join('\n'),
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        );
                      } else {
                        return const Text('-');
                      }
                    },
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomeCustomerScreen(initialIndex: 3),
                          ),
                        );
                      },
                      child: const Text(
                        'Kembali ke Riwayat',
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
