import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart';
import 'home_customer_screen.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/Core/provider/notification_provider.dart';

class BerhasilPesanCelanaCustomerScreen extends StatelessWidget {
  final Order order;

  const BerhasilPesanCelanaCustomerScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Kirim notifikasi ke admin saat pesanan berhasil
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('🔄 Customer order completed, sending notification to admin...');

      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );

      try {
        await notificationProvider.sendOrderNotificationToAdmin(
          orderId: order.id ?? 'N/A',
          customerName: order.userName,
          orderType: 'celana',
          totalPrice: (order.estimatedPrice ?? 0).toDouble(),
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Pesanan berhasil! Notifikasi telah dikirim ke admin.',
            ),
            backgroundColor: Colors.green,
          ),
        );

        print('✅ Notification sent successfully');
      } catch (e) {
        print('❌ Error sending notification: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pesanan berhasil! Error mengirim notifikasi: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Ambil data dari order
    final kodePesanan = order.id ?? 'N/A';
    final tanggalPesanan = order.orderDate.toDate();
    final estimasiHarga = order.estimatedPrice ?? 0;

    // Debug print untuk memastikan data yang diterima
    print('🔍 DEBUG BerhasilPesanCelanaCustomerScreen:');
    print('   - order.id: ${order.id}');
    print('   - order.userId: ${order.userId}');
    print('   - order.orderDate: ${order.orderDate}');
    print('   - order.estimatedPrice: ${order.estimatedPrice}');
    print('   - kodePesanan: $kodePesanan');

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pesanan Berhasil',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                            fontFamily: 'SF Pro Display',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDE8500).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: Color(0xFFDE8500),
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Pesanan Berhasil',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pesanan Anda telah berhasil dibuat dan sedang diproses',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.white70 : Colors.grey,
                                fontFamily: 'SF Pro Text',
                              ),
                            ),
                            const SizedBox(height: 24),
                            _DetailItem(
                              label: 'Kode Pesanan',
                              value: kodePesanan.isNotEmpty
                                  ? kodePesanan
                                  : 'Sedang diproses...',
                              icon: Icons.receipt_long,
                              isCopyable: true,
                            ),
                            Divider(
                              height: 24,
                              color: isDark ? Colors.white24 : Colors.black12,
                            ),
                            _DetailItem(
                              label: 'Tanggal',
                              value:
                                  '${tanggalPesanan.day} ${_getMonth(tanggalPesanan.month)} ${tanggalPesanan.year}',
                              icon: Icons.calendar_today,
                            ),
                            Divider(
                              height: 24,
                              color: isDark ? Colors.white24 : Colors.black12,
                            ),
                            _DetailItem(
                              label: 'Total Pembayaran',
                              value: 'Rp ${estimasiHarga.toStringAsFixed(0)}',
                              icon: Icons.payments,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDE8500),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeCustomerScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Kembali ke Beranda',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'SF Pro Text',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isCopyable;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.icon,
    this.isCopyable = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFDE8500).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFDE8500), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.grey,
                  fontFamily: 'SF Pro Text',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                  if (isCopyable)
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kode pesanan berhasil disalin!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.copy,
                        color: Color(0xFFDE8500),
                        size: 20,
                      ),
                      tooltip: 'Salin kode pesanan',
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
