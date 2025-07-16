import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/admin/cek_detail_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/status_pesanan_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/riwayat_transaksi_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/model_kain_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/profile_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart'; // Perbaiki path import Order
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart'; // Added import for FirestoreService
import 'package:fl_chart/fl_chart.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  int _selectedIndex = 0;

  final List<Widget> _adminScreens = [
    _HomeAdminContent(),
    StatusPesananAdminScreen(),
    RiwayatTransaksiAdminScreen(),
    ModelKainAdminScreen(),
    ProfileAdminScreen(),
  ];

  final List<String> _appBarTitles = const [
    'Daftar Pesanan',
    'Status Pesanan',
    'Riwayat Transaksi',
    'Model Pakaian',
    'Profil Admin',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFDE8500).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: Color(0xFFDE8500)),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _appBarTitles[_selectedIndex],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFDE8500).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.account_circle_outlined,
                          color: Color(0xFFDE8500)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _adminScreens,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomNavIcon(
                  icon: Icons.home,
                  label: 'Beranda',
                  index: 0,
                  selectedIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
                _BottomNavIcon(
                  icon: Icons.message,
                  label: 'Pesan',
                  index: 1,
                  selectedIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
                _BottomNavIcon(
                  icon: Icons.history,
                  label: 'Riwayat',
                  index: 2,
                  selectedIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
                _BottomNavIcon(
                  icon: Icons.checkroom,
                  label: 'Model',
                  index: 3,
                  selectedIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
                _BottomNavIcon(
                  icon: Icons.person,
                  label: 'Profil',
                  index: 4,
                  selectedIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavIcon({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xFFDE8500)
                : (isDark ? Colors.grey[600] : Colors.grey[400]),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFFDE8500)
                  : (isDark ? Colors.grey[600] : Colors.grey[400]),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro Text',
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeAdminContent extends StatelessWidget {
  const _HomeAdminContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // DASHBOARD SUMMARY
        StreamBuilder<List<Order>>(
          stream: FirestoreService().getAllOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final orders = snapshot.data ?? [];
            final masuk =
                orders.where((o) => o.status == 'Menunggu Konfirmasi').length;
            final dikonfirmasi =
                orders.where((o) => o.status == 'Pesanan Dikonfirmasi').length;
            final dikerjakan =
                orders.where((o) => o.status == 'Sedang dikerjakan').length;
            final selesai = orders.where((o) => o.status == 'Selesai').length;
            final dibatalkan =
                orders.where((o) => o.status == 'Dibatalkan').length;
            return Column(
              children: [
                Card(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF232323)
                      : Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _DashboardItem(
                            label: 'Masuk',
                            count: masuk,
                            color: Colors.orange,
                            icon: Icons.inbox),
                        _DashboardItem(
                            label: 'Dikonfirmasi',
                            count: dikonfirmasi,
                            color: Colors.blue,
                            icon: Icons.check_circle_outline),
                        _DashboardItem(
                            label: 'Dikerjakan',
                            count: dikerjakan,
                            color: Colors.purple,
                            icon: Icons.build),
                        _DashboardItem(
                            label: 'Selesai',
                            count: selesai,
                            color: Colors.green,
                            icon: Icons.done_all),
                        _DashboardItem(
                            label: 'Batal',
                            count: dibatalkan,
                            color: Colors.red,
                            icon: Icons.cancel),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // BAR CHART
                Card(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF232323)
                      : Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: [
                                masuk,
                                dikonfirmasi,
                                dikerjakan,
                                selesai,
                                dibatalkan
                              ].reduce((a, b) => a > b ? a : b).toDouble() +
                              2,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 28),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  const labels = [
                                    'Masuk',
                                    'Dikonf.',
                                    'Dikerj.',
                                    'Selesai',
                                    'Batal'
                                  ];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(labels[value.toInt()],
                                        style: const TextStyle(fontSize: 12)),
                                  );
                                },
                                interval: 1,
                              ),
                            ),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [
                              BarChartRodData(
                                  toY: masuk.toDouble(), color: Colors.orange)
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(
                                  toY: dikonfirmasi.toDouble(),
                                  color: Colors.blue)
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(
                                  toY: dikerjakan.toDouble(),
                                  color: Colors.purple)
                            ]),
                            BarChartGroupData(x: 3, barRods: [
                              BarChartRodData(
                                  toY: selesai.toDouble(), color: Colors.green)
                            ]),
                            BarChartGroupData(x: 4, barRods: [
                              BarChartRodData(
                                  toY: dibatalkan.toDouble(), color: Colors.red)
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        _OrderCard(
          orderCode: 'A876U6',
          imageText: 'Gambar Celana',
          orderDate: '12 Mei 2024',
          productQuantity: 1,
        ),
        SizedBox(height: 16),
        _OrderCard(
          orderCode: 'P45US8',
          imageText: 'Gambar Celana',
          orderDate: '12 Mei 2024',
          productQuantity: 1,
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderCode;
  final String imageText;
  final String orderDate;
  final int productQuantity;

  const _OrderCard({
    Key? key,
    required this.orderCode,
    required this.imageText,
    required this.orderDate,
    required this.productQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kode pesanan: $orderCode',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDE8500).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Baru',
                    style: TextStyle(
                      color: Color(0xFFDE8500),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: isDark ? Colors.white24 : Colors.black12,
              height: 24,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8FBC8F).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      imageText,
                      style: const TextStyle(
                        color: Color(0xFF8FBC8F),
                        fontSize: 12,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Pesanan',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey[600],
                          fontSize: 12,
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        orderDate,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black,
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Jumlah Produk',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey[600],
                          fontSize: 12,
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$productQuantity item',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black,
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.chevron_right, color: Color(0xFFDE8500)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CekDetailAdminScreen(
                          orderCode: orderCode,
                          model: 'Seragam',
                          fabricType: 'Katun',
                          productQuantity: productQuantity,
                          orderDate: orderDate,
                          measurements: {},
                          orderType: '',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _DashboardItem({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
