import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/admin/cek_detail_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/status_pesanan_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/riwayat_transaksi_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/model_kain_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/profile_admin_screen.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart'
    as order_model; // Perbaiki path import Order
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart'; // Added import for FirestoreService
import 'package:fl_chart/fl_chart.dart';
import 'package:jasa_jahit_aplication/Core/provider/notification_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jasa_jahit_aplication/src/page/admin_notification_screen.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Setup FCM token untuk admin
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      notificationProvider.setupFirebaseMessaging(context);

      // Simpan FCM token admin ke Firestore
      await notificationProvider.saveFCMTokenToFirestore('admin_001', 'admin');

      // Load notifikasi dari Firestore
      await notificationProvider.loadNotificationsFromFirestore('admin');
    });
  }

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

  void _showNotificationDialog(BuildContext context) async {
    // Tandai semua notifikasi admin sebagai sudah dibaca
    final notificationsRef = FirebaseFirestore.instance.collection(
      'notifications',
    );
    final unreadNotifications = await notificationsRef
        .where('recipientId', isEqualTo: 'admin_001')
        .where('isRead', isEqualTo: false)
        .get();

    // Update semua notifikasi menjadi sudah dibaca
    for (var doc in unreadNotifications.docs) {
      await doc.reference.update({'isRead': true});
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminNotificationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
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
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFDE8500).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Color(0xFFDE8500),
                          ),
                          onPressed: () => _showNotificationDialog(context),
                        ),
                      ),
                      // Penanda notifikasi baru
                      Positioned(
                        right: 8,
                        top: 8,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('notifications')
                              .where('recipientId', isEqualTo: 'admin_001')
                              .where('isRead', isEqualTo: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${snapshot.data!.docs.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
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
                  const SizedBox(width: 48), // Spacer untuk balance layout
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
                  icon: Icons.shopping_bag_outlined,
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

extension on RemoteMessage {
  String? get title => null;

  String? get body => null;
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
    super.key,
  });

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

class _HomeAdminContent extends StatefulWidget {
  const _HomeAdminContent({super.key});

  @override
  State<_HomeAdminContent> createState() => _HomeAdminContentState();
}

class _HomeAdminContentState extends State<_HomeAdminContent> {
  int selectedMonthIndex = DateTime.now().month - 1; // Bulan saat ini (0-11)

  // Fungsi untuk mendapatkan nama bulan
  String _getMonthName(int monthIndex) {
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
    return months[monthIndex];
  }

  // Fungsi untuk menghitung data berdasarkan bulan yang dipilih
  Map<String, dynamic> _calculateDataForMonth(
    List<order_model.Order> orders,
    int monthIndex,
  ) {
    final now = DateTime.now();
    final selectedMonth = DateTime(now.year, monthIndex + 1);
    final nextMonth = DateTime(now.year, monthIndex + 2);

    // Filter orders berdasarkan bulan yang dipilih
    final ordersThisMonth = orders.where((order) {
      final orderDate = order.orderDate.toDate();
      return orderDate.isAfter(
            selectedMonth.subtract(const Duration(days: 1)),
          ) &&
          orderDate.isBefore(nextMonth);
    }).toList();

    // Hitung status pesanan untuk bulan yang dipilih
    final masuk = ordersThisMonth
        .where((order) => order.status == 'Menunggu Konfirmasi')
        .length;
    final dikonfirmasi = ordersThisMonth
        .where((order) => order.status == 'Dikonfirmasi')
        .length;
    final dikerjakan = ordersThisMonth
        .where((order) => order.status == 'Sedang dikerjakan')
        .length;
    final selesai = ordersThisMonth
        .where((order) => order.status == 'Selesai')
        .length;
    final dibatalkan = ordersThisMonth
        .where((order) => order.status == 'Dibatalkan')
        .length;

    // Hitung keuntungan dari pesanan yang selesai
    final completedOrdersThisMonth = ordersThisMonth.where((order) {
      return order.status == 'Selesai';
    }).toList();

    final totalRevenue = completedOrdersThisMonth.fold<double>(
      0,
      (sum, order) =>
          sum + (order.estimatedPrice?.toDouble() ?? order.totalPrice ?? 0),
    );

    // Hitung keuntungan (asumsi margin 30%)
    final totalProfit = totalRevenue * 0.3;

    // Data untuk pie chart berdasarkan jenis pesanan yang selesai
    final bajuOrders = completedOrdersThisMonth.where((order) {
      return order.items.any((item) => item['orderType'] == 'Baju');
    }).toList();

    final celanaOrders = completedOrdersThisMonth.where((order) {
      return order.items.any((item) => item['orderType'] == 'Celana');
    }).toList();

    final modelOrders = completedOrdersThisMonth.where((order) {
      return order.items.any((item) => item['orderType'] == 'Model');
    }).toList();

    final bajuRevenue = bajuOrders.fold<double>(
      0,
      (sum, order) =>
          sum + (order.estimatedPrice?.toDouble() ?? order.totalPrice ?? 0),
    );
    final celanaRevenue = celanaOrders.fold<double>(
      0,
      (sum, order) =>
          sum + (order.estimatedPrice?.toDouble() ?? order.totalPrice ?? 0),
    );
    final modelRevenue = modelOrders.fold<double>(
      0,
      (sum, order) =>
          sum + (order.estimatedPrice?.toDouble() ?? order.totalPrice ?? 0),
    );

    final bajuProfit = bajuRevenue * 0.3;
    final celanaProfit = celanaRevenue * 0.3;
    final modelProfit = modelRevenue * 0.3;

    // Hitung jumlah item terjual
    final bajuSold = bajuOrders.fold<int>(
      0,
      (sum, order) =>
          sum + order.items.where((item) => item['orderType'] == 'Baju').length,
    );
    final celanaSold = celanaOrders.fold<int>(
      0,
      (sum, order) =>
          sum +
          order.items.where((item) => item['orderType'] == 'Celana').length,
    );
    final modelSold = modelOrders.fold<int>(
      0,
      (sum, order) =>
          sum +
          order.items.where((item) => item['orderType'] == 'Model').length,
    );

    return {
      'masuk': masuk,
      'dikonfirmasi': dikonfirmasi,
      'dikerjakan': dikerjakan,
      'selesai': selesai,
      'dibatalkan': dibatalkan,
      'totalProfit': totalProfit,
      'bajuProfit': bajuProfit,
      'celanaProfit': celanaProfit,
      'modelProfit': modelProfit,
      'bajuSold': bajuSold,
      'celanaSold': celanaSold,
      'modelSold': modelSold,
      'completedOrders': completedOrdersThisMonth.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // DASHBOARD SUMMARY
        StreamBuilder<List<order_model.Order>>(
          stream: FirestoreService().getAllOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final orders = snapshot.data ?? [];

            // Hitung data untuk bulan yang dipilih
            final monthData = _calculateDataForMonth(
              orders,
              selectedMonthIndex,
            );

            // Print status counts untuk troubleshooting
            print('Status Counts for ${_getMonthName(selectedMonthIndex)}:');
            print('Masuk: ${monthData['masuk']}');
            print('Dikonfirmasi: ${monthData['dikonfirmasi']}');
            print('Dikerjakan: ${monthData['dikerjakan']}');
            print('Selesai: ${monthData['selesai']}');
            print('Dibatalkan: ${monthData['dibatalkan']}');
            print('Total Profit: ${monthData['totalProfit']}');

            return Column(
              children: [
                Card(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF232323)
                      : Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _DashboardItem(
                          label: 'Masuk',
                          count: monthData['masuk'],
                          color: Colors.orange,
                          icon: Icons.inbox,
                        ),
                        _DashboardItem(
                          label: 'Dikonfirmasi',
                          count: monthData['dikonfirmasi'],
                          color: Colors.blue,
                          icon: Icons.check_circle_outline,
                        ),
                        _DashboardItem(
                          label: 'Dikerjakan',
                          count: monthData['dikerjakan'],
                          color: Colors.purple,
                          icon: Icons.build,
                        ),
                        _DashboardItem(
                          label: 'Selesai',
                          count: monthData['selesai'],
                          color: Colors.green,
                          icon: Icons.done_all,
                        ),
                        _DashboardItem(
                          label: 'Batal',
                          count: monthData['dibatalkan'],
                          color: Colors.red,
                          icon: Icons.cancel,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // BAR CHART - REAL TIME STATUS PESANAN
                Card(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF232323)
                      : Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
                              'Status Pesanan Real-time',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            // Selector Bulan untuk Bar Chart
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDE8500).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFFDE8500),
                                ),
                              ),
                              child: DropdownButton<int>(
                                value: selectedMonthIndex,
                                underline: Container(),
                                style: TextStyle(
                                  color: const Color(0xFFDE8500),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                items: List.generate(12, (index) {
                                  return DropdownMenuItem<int>(
                                    value: index,
                                    child: Text(_getMonthName(index)),
                                  );
                                }),
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedMonthIndex = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY:
                                  [
                                    monthData['masuk'],
                                    monthData['dikonfirmasi'],
                                    monthData['dikerjakan'],
                                    monthData['selesai'],
                                    monthData['dibatalkan'],
                                  ].reduce((a, b) => a > b ? a : b).toDouble() +
                                  2,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                        const labels = [
                                          'Masuk',
                                          'Dikonfirmasi',
                                          'Dikerjakan',
                                          'Selesai',
                                          'Dibatalkan',
                                        ];
                                        return BarTooltipItem(
                                          '${labels[group.x]}: ${rod.toY.toInt()} pesanan',
                                          const TextStyle(color: Colors.white),
                                        );
                                      },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white70
                                              : Colors.black54,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
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
                                            'Batal',
                                          ];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: Text(
                                              labels[value.toInt()],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    Theme.of(
                                                          context,
                                                        ).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white70
                                                    : Colors.black54,
                                              ),
                                            ),
                                          );
                                        },
                                    interval: 1,
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 1,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white10
                                        : Colors.grey[300],
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: monthData['masuk'].toDouble(),
                                      color: Colors.orange,
                                      width: 20,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: monthData['dikonfirmasi'].toDouble(),
                                      color: Colors.blue,
                                      width: 20,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                      toY: monthData['dikerjakan'].toDouble(),
                                      color: Colors.purple,
                                      width: 20,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 3,
                                  barRods: [
                                    BarChartRodData(
                                      toY: monthData['selesai'].toDouble(),
                                      color: Colors.green,
                                      width: 20,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 4,
                                  barRods: [
                                    BarChartRodData(
                                      toY: monthData['dibatalkan'].toDouble(),
                                      color: Colors.red,
                                      width: 20,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // PIE CHART KEUNTUNGAN BULANAN
                Card(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF232323)
                      : Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
                              'Keuntungan Bulanan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            // Selector Bulan untuk Pie Chart
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDE8500).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFDE8500),
                                ),
                              ),
                              child: DropdownButton<int>(
                                value: selectedMonthIndex,
                                underline: Container(),
                                style: TextStyle(
                                  color: const Color(0xFFDE8500),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                items: List.generate(12, (index) {
                                  return DropdownMenuItem<int>(
                                    value: index,
                                    child: Text(_getMonthName(index)),
                                  );
                                }),
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedMonthIndex = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Keuntungan: Rp ${monthData['totalProfit'].toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                            fontFamily: 'SF Pro Text',
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Pie Chart dan Legend
                        if (monthData['totalProfit'] > 0) ...[
                          SizedBox(
                            height: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        if (monthData['bajuProfit'] > 0)
                                          PieChartSectionData(
                                            value: monthData['bajuProfit'],
                                            title:
                                                'Baju\n${((monthData['bajuProfit'] / monthData['totalProfit']) * 100).toStringAsFixed(1)}%',
                                            color: Colors.blue,
                                            radius: 80,
                                            titleStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        if (monthData['celanaProfit'] > 0)
                                          PieChartSectionData(
                                            value: monthData['celanaProfit'],
                                            title:
                                                'Celana\n${((monthData['celanaProfit'] / monthData['totalProfit']) * 100).toStringAsFixed(1)}%',
                                            color: Colors.green,
                                            radius: 80,
                                            titleStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        if (monthData['modelProfit'] > 0)
                                          PieChartSectionData(
                                            value: monthData['modelProfit'],
                                            title:
                                                'Model\n${((monthData['modelProfit'] / monthData['totalProfit']) * 100).toStringAsFixed(1)}%',
                                            color: Colors.orange,
                                            radius: 80,
                                            titleStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                      ],
                                      centerSpaceRadius: 40,
                                      sectionsSpace: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (monthData['bajuProfit'] > 0)
                                        _PieChartLegend(
                                          label: 'Baju',
                                          value: monthData['bajuProfit'],
                                          sold: monthData['bajuSold'],
                                          color: Colors.blue,
                                        ),
                                      if (monthData['celanaProfit'] > 0)
                                        _PieChartLegend(
                                          label: 'Celana',
                                          value: monthData['celanaProfit'],
                                          sold: monthData['celanaSold'],
                                          color: Colors.green,
                                        ),
                                      if (monthData['modelProfit'] > 0)
                                        _PieChartLegend(
                                          label: 'Model',
                                          value: monthData['modelProfit'],
                                          sold: monthData['modelSold'],
                                          color: Colors.orange,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pie_chart_outline,
                                    size: 48,
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[600]
                                        : Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Belum ada data keuntungan',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[600]
                                          : Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
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

// Widget untuk legend pie chart
class _PieChartLegend extends StatelessWidget {
  final String label;
  final double value;
  final int sold;
  final Color color;

  const _PieChartLegend({
    required this.label,
    required this.value,
    required this.sold,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label\nRp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}\nTerjual: $sold item',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black54,
                fontFamily: 'SF Pro Text',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
