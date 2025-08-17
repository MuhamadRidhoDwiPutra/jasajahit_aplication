import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart';

class CekDetailStatusPesananCustomerScreen extends StatelessWidget {
  final Order order;
  const CekDetailStatusPesananCustomerScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final firstItem = (order.items.isNotEmpty) ? order.items[0] : {};
    final model =
        firstItem['jenisBaju'] ??
        firstItem['jenisCelana'] ??
        firstItem['model'] ??
        '-';
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
          'Detail Pesanan',
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
                  Text(
                    order.id ?? '-',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
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
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
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
                  Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
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
                  Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
                  // Tampilkan semua item jika multi order
                  if (order.items.length > 1) ...[
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
                      final itemModel =
                          item['jenisBaju'] ??
                          item['jenisCelana'] ??
                          item['model'] ??
                          '-';
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
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDE8500),
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
                  ],
                  // Total harga untuk multi order
                  if (order.items.length > 1) ...[
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFFDE8500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
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
                    order.orderDate.toDate().toString(),
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
                  // Tampilkan ukuran untuk setiap item jika multi order
                  if (order.items.length > 1) ...[
                    ...order.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final itemMeasurements = item['measurements'] ?? {};
                      final itemOrderType = (item['orderType'] ?? '')
                          .toString();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDE8500),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Ukuran Item ${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Builder(
                              builder: (context) {
                                if (itemOrderType.toLowerCase() == 'baju') {
                                  return Text(
                                    [
                                      if (itemMeasurements['lingkarDada'] !=
                                              null &&
                                          itemMeasurements['lingkarDada']
                                              .toString()
                                              .isNotEmpty)
                                        'Lingkar Dada: ${itemMeasurements['lingkarDada']} cm',
                                      if (itemMeasurements['lebarBahu'] !=
                                              null &&
                                          itemMeasurements['lebarBahu']
                                              .toString()
                                              .isNotEmpty)
                                        'Lebar Bahu: ${itemMeasurements['lebarBahu']} cm',
                                      if (itemMeasurements['panjangBaju'] !=
                                              null &&
                                          itemMeasurements['panjangBaju']
                                              .toString()
                                              .isNotEmpty)
                                        'Panjang Baju: ${itemMeasurements['panjangBaju']} cm',
                                      if (itemMeasurements['panjangLengan'] !=
                                              null &&
                                          itemMeasurements['panjangLengan']
                                              .toString()
                                              .isNotEmpty)
                                        'Panjang Lengan: ${itemMeasurements['panjangLengan']} cm',
                                      if (itemMeasurements['lebarLengan'] !=
                                              null &&
                                          itemMeasurements['lebarLengan']
                                              .toString()
                                              .isNotEmpty)
                                        'Lebar Lengan: ${itemMeasurements['lebarLengan']} cm',
                                    ].join('\n'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  );
                                } else if (itemOrderType.toLowerCase() ==
                                    'celana') {
                                  return Text(
                                    [
                                      if (itemMeasurements['panjangCelana'] !=
                                              null &&
                                          itemMeasurements['panjangCelana']
                                              .toString()
                                              .isNotEmpty)
                                        'Panjang Celana: ${itemMeasurements['panjangCelana']} cm',
                                      if (itemMeasurements['lingkarPinggang'] !=
                                              null &&
                                          itemMeasurements['lingkarPinggang']
                                              .toString()
                                              .isNotEmpty)
                                        'Lingkar Pinggang: ${itemMeasurements['lingkarPinggang']} cm',
                                      if (itemMeasurements['lingkarPinggul'] !=
                                              null &&
                                          itemMeasurements['lingkarPinggul']
                                              .toString()
                                              .isNotEmpty)
                                        'Lingkar Pinggul: ${itemMeasurements['lingkarPinggul']} cm',
                                      if (itemMeasurements['lingkarPesak'] !=
                                              null &&
                                          itemMeasurements['lingkarPesak']
                                              .toString()
                                              .isNotEmpty)
                                        'Lingkar Pesak: ${itemMeasurements['lingkarPesak']} cm',
                                      if (itemMeasurements['lingkarPaha'] !=
                                              null &&
                                          itemMeasurements['lingkarPaha']
                                              .toString()
                                              .isNotEmpty)
                                        'Lingkar Paha: ${itemMeasurements['lingkarPaha']} cm',
                                      if (itemMeasurements['lebarBawahCelana'] !=
                                              null &&
                                          itemMeasurements['lebarBawahCelana']
                                              .toString()
                                              .isNotEmpty)
                                        'Lebar Bawah Celana: ${itemMeasurements['lebarBawahCelana']} cm',
                                    ].join('\n'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'Ukuran: ${itemMeasurements['size'] ?? 'Standard'}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ] else ...[
                    // Untuk single order, tampilkan ukuran seperti sebelumnya
                    Builder(
                      builder: (context) {
                        if (orderType.toLowerCase() == 'baju') {
                          return Text(
                            [
                              if (measurements['lingkarDada'] != null &&
                                  measurements['lingkarDada']
                                      .toString()
                                      .isNotEmpty)
                                'Lingkar Dada: ${measurements['lingkarDada']} cm',
                              if (measurements['lebarBahu'] != null &&
                                  measurements['lebarBahu']
                                      .toString()
                                      .isNotEmpty)
                                'Lebar Bahu: ${measurements['lebarBahu']} cm',
                              if (measurements['panjangBaju'] != null &&
                                  measurements['panjangBaju']
                                      .toString()
                                      .isNotEmpty)
                                'Panjang Baju: ${measurements['panjangBaju']} cm',
                              if (measurements['panjangLengan'] != null &&
                                  measurements['panjangLengan']
                                      .toString()
                                      .isNotEmpty)
                                'Panjang Lengan: ${measurements['panjangLengan']} cm',
                              if (measurements['lebarLengan'] != null &&
                                  measurements['lebarLengan']
                                      .toString()
                                      .isNotEmpty)
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
                  ],
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 32), // Tambah padding bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateTotalPrice() {
    return order.items.fold(0.0, (sum, item) => sum + (item['price'] ?? 0));
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
