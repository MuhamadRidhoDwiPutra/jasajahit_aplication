import 'package:flutter/material.dart';
// ignore: unused_import
import 'home_customer_screen.dart';

class TrackingPesananCustomerScreen extends StatelessWidget {
  const TrackingPesananCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B7F6B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B7F6B),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.notifications, color: Colors.black),
          ),
        ),
        title: const Text(
          'Status Pesanan',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.refresh, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[400],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Text(
                    'Kode pesanan:',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Masukan kode pesanan...',
                        hintStyle: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: ListView(
                  children: const [
                    _TimelineItem(
                      date: '12 mei\n18.00',
                      status: '[Pesanan diproses] Menunggu konfirmasi penjahit',
                      isActive: true,
                      isLast: false,
                      isChecked: true,
                    ),
                    _TimelineItem(
                      date: '13 mei\n18.00',
                      status:
                          '[Pesanan diterima] Pesanan telah dikonfirmasi oleh jasa jahit',
                      isActive: false,
                      isLast: false,
                    ),
                    _TimelineItem(
                      date: '14 mei\n18.00',
                      status: '[Pesanan sedang dikerjakan]',
                      isActive: false,
                      isLast: false,
                    ),
                    _TimelineItem(
                      date: '14 mei\n18.00',
                      status: '[Pesanan Telah Selesai]',
                      isActive: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.orange[700],
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _BottomNavIcon(icon: Icons.home, label: 'Icon menu beranda'),
                  _BottomNavIcon(icon: Icons.message, label: 'Icon menu Pesan'),
                  _BottomNavIcon(
                      icon: Icons.local_shipping,
                      label: 'Icon pelacakan pesanan'),
                  _BottomNavIcon(
                      icon: Icons.history, label: 'Icon menu riwayat'),
                  _BottomNavIcon(
                      icon: Icons.person, label: 'Icon menu profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _TimelineItem extends StatelessWidget {
  final String date;
  final String status;
  final bool isActive;
  final bool isLast;
  final bool isChecked;

  const _TimelineItem({
    required this.date,
    required this.status,
    // ignore: unused_element
    this.isActive = false,
    // ignore: unused_element
    this.isLast = false,
    // ignore: unused_element
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              date,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.right,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 2),
              ),
          ],
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                if (isChecked)
                  const Icon(Icons.check, color: Colors.white, size: 14),
              ],
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 2),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
        if (isChecked)
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 2),
            child: Icon(Icons.check, color: Colors.black, size: 20),
          ),
      ],
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BottomNavIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      ],
    );
  }
}
