import 'package:flutter/material.dart';
import 'home_customer_screen.dart';
import 'pesan_customer_screen.dart';
import 'riwayat_customer_screen.dart';
import 'profile_customer_screen.dart';
import 'desain_customer_screen.dart';

class TrackingPesananCustomerScreen extends StatelessWidget {
  const TrackingPesananCustomerScreen({Key? key}) : super(key: key);

  get floatingActionButton => null;

  @override
  Widget build(BuildContext context) {
    // Dummy data for progress
    final int currentStep =
        2; // 0: Diterima, 1: Diproses, 2: Dikirim, 3: Selesai
    final List<String> steps = [
      'Diterima',
      'Diproses',
      'Dikirim',
      'Selesai',
    ];
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // AppBar with gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[700]!, Colors.green[500]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeCustomerScreen()),
                            );
                          },
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Tracking Pesanan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Status Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          currentStep == 3
                              ? Icons.check_circle_rounded
                              : Icons.local_shipping_rounded,
                          color:
                              currentStep == 3 ? Colors.green : Colors.orange,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentStep == 3
                                    ? 'Pesanan Selesai'
                                    : 'Pesanan Sedang ${steps[currentStep]}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: currentStep == 3
                                      ? Colors.green
                                      : Colors.orange[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentStep == 3
                                    ? 'Terima kasih telah mempercayakan pesanan Anda.'
                                    : 'Pesanan Anda sedang dalam proses ${steps[currentStep].toLowerCase()}.',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(steps.length, (index) {
                      final isActive = index <= currentStep;
                      return Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.green[700]
                                    : Colors.grey[300],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isActive
                                      ? Colors.green
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  index == 3 ? Icons.check : Icons.circle,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              steps[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: isActive
                                    ? Colors.green[700]
                                    : Colors.grey[500],
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).expand((widget) sync* {
                      yield widget;
                      if (widget != steps.length - 1) {
                        yield SizedBox(width: 8);
                      }
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                // Order Details Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Detail Pesanan',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        _OrderDetailRow(
                            label: 'No. Pesanan', value: 'ORD123456'),
                        _OrderDetailRow(
                            label: 'Tanggal', value: '12 Juni 2024'),
                        _OrderDetailRow(label: 'Item', value: 'Kemeja Formal'),
                        _OrderDetailRow(label: 'Jumlah', value: '2'),
                        _OrderDetailRow(label: 'Total', value: 'Rp 300.000'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFD600),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DesainCustomerScreen()),
          );
        },
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavIcon(
              icon: Icons.home,
              label: 'Beranda',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeCustomerScreen()),
                );
              },
            ),
            _BottomNavIcon(
              icon: Icons.local_shipping,
              label: 'Tracking',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const TrackingPesananCustomerScreen()),
                );
              },
            ),
            const SizedBox(width: 48), // Space for FAB
            _BottomNavIcon(
              icon: Icons.history,
              label: 'Riwayat',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RiwayatCustomerScreen()),
                );
              },
            ),
            _BottomNavIcon(
              icon: Icons.person,
              label: 'Profil',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileCustomerScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _OrderDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _BottomNavIcon({
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.green[700] : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.green[700] : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
