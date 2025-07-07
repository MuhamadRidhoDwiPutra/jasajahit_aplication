import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk Clipboard
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';

class CekDetailAdminScreen extends StatelessWidget {
  final String orderCode;
  final String model;
  final String fabricType;
  final int productQuantity;
  final String orderDate;
  final Map<String, dynamic> measurements;
  final String orderType;

  const CekDetailAdminScreen({
    super.key,
    required this.orderCode,
    required this.model,
    required this.fabricType,
    required this.productQuantity,
    required this.orderDate,
    required this.measurements,
    required this.orderType,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8FBC8F),
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
      body: Center(
        child: Card(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          elevation: 3,
          margin: const EdgeInsets.all(24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                Text(
                  orderCode,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12),
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
                Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12),
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
                  fabricType,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12),
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
                  productQuantity.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12),
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
                  orderDate,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
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
                    if (orderType.toLowerCase() == 'baju') {
                      return Text(
                        [
                          if (measurements['lingkarDada'] != null &&
                              measurements['lingkarDada'].toString().isNotEmpty)
                            'Lingkar Dada: ${measurements['lingkarDada']} cm',
                          if (measurements['lebarBahu'] != null &&
                              measurements['lebarBahu'].toString().isNotEmpty)
                            'Lebar Bahu: ${measurements['lebarBahu']} cm',
                          if (measurements['panjangBaju'] != null &&
                              measurements['panjangBaju'].toString().isNotEmpty)
                            'Panjang Baju: ${measurements['panjangBaju']} cm',
                          if (measurements['panjangLengan'] != null &&
                              measurements['panjangLengan']
                                  .toString()
                                  .isNotEmpty)
                            'Panjang Lengan: ${measurements['panjangLengan']} cm',
                          if (measurements['lebarLengan'] != null &&
                              measurements['lebarLengan'].toString().isNotEmpty)
                            'Lebar Lengan: ${measurements['lebarLengan']} cm',
                        ].join('\n'),
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      );
                    } else if (orderType.toLowerCase() == 'celana') {
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
                              measurements['lingkarPaha'].toString().isNotEmpty)
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
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDE8500),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    onPressed: () {/* aksi kembali */},
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
    );
  }

  // ignore: unused_element
  Widget _buildInfoRow(BuildContext context,
      {required String label,
      required String value,
      bool hasCopyButton = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              if (hasCopyButton)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Disalin!')),
                    );
                  },
                  child: Text(
                    'Salin',
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
