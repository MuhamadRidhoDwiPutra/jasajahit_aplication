import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart';

class CekDetailStatusPesananCustomerScreen extends StatelessWidget {
  final Order order;
  const CekDetailStatusPesananCustomerScreen({Key? key, required this.order})
      : super(key: key);

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
                Text('Kode Pesanan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 4),
                Text(order.id ?? '-',
                    style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black87)),
                Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12),
                Text('Model',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 4),
                Text(order.model,
                    style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black87)),
                Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12),
                Text('Jenis Kain',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 4),
                Text(order.fabric,
                    style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black87)),
                Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12),
                Text('Jumlah Produk',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 4),
                Text('1',
                    style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black87)),
                Divider(
                    height: 24,
                    color: isDark ? Colors.white24 : Colors.black12),
                Text('Tanggal Pesan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 4),
                Text(order.orderDate.toDate().toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black87)),
                const SizedBox(height: 24),
                Text('Ukuran',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 4),
                Builder(
                  builder: (context) {
                    if (order.orderType.toLowerCase() == 'baju') {
                      return Text(
                          [
                            if (order.measurements['lingkarDada'] != null &&
                                order.measurements['lingkarDada']
                                    .toString()
                                    .isNotEmpty)
                              'Lingkar Dada: ${order.measurements['lingkarDada']} cm',
                            if (order.measurements['lebarBahu'] != null &&
                                order.measurements['lebarBahu']
                                    .toString()
                                    .isNotEmpty)
                              'Lebar Bahu: ${order.measurements['lebarBahu']} cm',
                            if (order.measurements['panjangBaju'] != null &&
                                order.measurements['panjangBaju']
                                    .toString()
                                    .isNotEmpty)
                              'Panjang Baju: ${order.measurements['panjangBaju']} cm',
                            if (order.measurements['panjangLengan'] != null &&
                                order.measurements['panjangLengan']
                                    .toString()
                                    .isNotEmpty)
                              'Panjang Lengan: ${order.measurements['panjangLengan']} cm',
                            if (order.measurements['lebarLengan'] != null &&
                                order.measurements['lebarLengan']
                                    .toString()
                                    .isNotEmpty)
                              'Lebar Lengan: ${order.measurements['lebarLengan']} cm',
                          ].join('\n'),
                          style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white70 : Colors.black87));
                    } else if (order.orderType.toLowerCase() == 'celana') {
                      return Text(
                          [
                            if (order.measurements['panjangCelana'] != null &&
                                order.measurements['panjangCelana']
                                    .toString()
                                    .isNotEmpty)
                              'Panjang Celana: ${order.measurements['panjangCelana']} cm',
                            if (order.measurements['lingkarPinggang'] != null &&
                                order.measurements['lingkarPinggang']
                                    .toString()
                                    .isNotEmpty)
                              'Lingkar Pinggang: ${order.measurements['lingkarPinggang']} cm',
                            if (order.measurements['lingkarPinggul'] != null &&
                                order.measurements['lingkarPinggul']
                                    .toString()
                                    .isNotEmpty)
                              'Lingkar Pinggul: ${order.measurements['lingkarPinggul']} cm',
                            if (order.measurements['lingkarPesak'] != null &&
                                order.measurements['lingkarPesak']
                                    .toString()
                                    .isNotEmpty)
                              'Lingkar Pesak: ${order.measurements['lingkarPesak']} cm',
                            if (order.measurements['lingkarPaha'] != null &&
                                order.measurements['lingkarPaha']
                                    .toString()
                                    .isNotEmpty)
                              'Lingkar Paha: ${order.measurements['lingkarPaha']} cm',
                            if (order.measurements['lebarBawahCelana'] !=
                                    null &&
                                order.measurements['lebarBawahCelana']
                                    .toString()
                                    .isNotEmpty)
                              'Lebar Bawah Celana: ${order.measurements['lebarBawahCelana']} cm',
                          ].join('\n'),
                          style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white70 : Colors.black87));
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
    );
  }
}
