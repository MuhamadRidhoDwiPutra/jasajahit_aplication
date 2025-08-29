import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart';
import 'pembayaran_baju_customer_screen.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';

class CekDetailPesananBajuScreen extends StatelessWidget {
  final Order order;
  const CekDetailPesananBajuScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Ambil data estimasi dari order
    final estimasiHarga = order.estimatedPrice ?? 0;
    final ukuranEstimasi = order.estimatedSize ?? 'M';
    final isCustomUkuran = order.isCustomSize ?? false;
    final selectedKain = order.selectedKain ?? 'Kain yang dipilih';

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PembayaranBajuCustomerScreen(order: order),
              ),
            );
          },
        ),
        title: Text(
          'Detail Pesanan',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Kode pesanan',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(
                        text: order.id ?? 'N/A',
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF2A2A2A)
                            : Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? const Color(0xFF2A2A2A)
                          : Colors.grey[300],
                      foregroundColor: isDark ? Colors.white : Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text('Salin'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Model',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(
                  text: order.items.isNotEmpty 
                      ? (order.items.first['jenisBaju'] ?? order.items.first['model'] ?? 'Baju Custom')
                      : 'Baju Custom'
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2A2A2A)
                      : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Jenis kain',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(text: selectedKain),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2A2A2A)
                      : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Jumlah produk',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(text: order.items.length.toString()),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2A2A2A)
                      : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Ukuran yang dipilih',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(
                  text: isCustomUkuran
                      ? 'Custom Ukuran'
                      : 'Ukuran $ukuranEstimasi',
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2A2A2A)
                      : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Harga',
                style: TextStyle(color: isDark ? Colors.white : Colors.white),
              ),
              const SizedBox(height: 4),
              TextField(
                enabled: false,
                controller: TextEditingController(
                  text: 'Rp ${(order.totalPrice ?? estimasiHarga).toStringAsFixed(0)}',
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2A2A2A)
                      : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Detail Ukuran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              
              // Tampilkan detail ukuran jika ada
              if (order.items.isNotEmpty) ...[
                Text(
                  [
                    if (order.items.first['measurements']['lingkarDada'] != null &&
                        order.items.first['measurements']['lingkarDada'].toString().isNotEmpty)
                      'Lingkar Dada: ${order.items.first['measurements']['lingkarDada']} cm',
                    if (order.items.first['measurements']['lebarBahu'] != null &&
                        order.items.first['measurements']['lebarBahu'].toString().isNotEmpty)
                      'Lebar Bahu: ${order.items.first['measurements']['lebarBahu']} cm',
                    if (order.items.first['measurements']['panjangBaju'] != null &&
                        order.items.first['measurements']['panjangBaju'].toString().isNotEmpty)
                      'Panjang Baju: ${order.items.first['measurements']['panjangBaju']} cm',
                    if (order.items.first['measurements']['panjangLengan'] != null &&
                        order.items.first['measurements']['panjangLengan'].toString().isNotEmpty)
                      'Panjang Lengan: ${order.items.first['measurements']['panjangLengan']} cm',
                    if (order.items.first['measurements']['lebarLengan'] != null &&
                        order.items.first['measurements']['lebarLengan'].toString().isNotEmpty)
                      'Lebar Lengan: ${order.items.first['measurements']['lebarLengan']} cm',
                  ].join('\n'),
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ] else ...[
                Text(
                  'Ukuran standar: $ukuranEstimasi',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
              
              // Tampilkan semua item jika multi order
              if (order.items.length > 1) ...[
                const SizedBox(height: 24),
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
                  final itemModel = item['jenisBaju'] ?? item['model'] ?? 'Baju';
                  final itemPrice = item['price'] ?? 0;
                  final itemSize = item['size'] ?? 'M';

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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Item ${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              'Rp ${itemPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: const Color(0xFFDE8500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Model: $itemModel',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ukuran: $itemSize',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
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
                       'Rp ${(order.totalPrice ?? 0).toStringAsFixed(0)}',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 18,
                         color: const Color(0xFFDE8500),
                       ),
                     ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
