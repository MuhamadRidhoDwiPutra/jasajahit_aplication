import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/customer/home_customer_screen.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/admin/home_admin_screen.dart';
import 'profile_customer_screen.dart';
// ignore: unused_import
import 'pesan_customer_screen.dart';
// ignore: unused_import
import 'tracking_pesanan_customer_screen.dart';
// ignore: unused_import
import 'riwayat_customer_screen.dart';
import 'desain_customer_screen.dart';

class HomeCustomerScreen extends StatefulWidget {
  const HomeCustomerScreen({super.key});

  @override
  State<HomeCustomerScreen> createState() => _HomeCustomerScreenState();
}

class _HomeCustomerScreenState extends State<HomeCustomerScreen> {
  int _selectedIndex = 0;

  final List<Widget> _customerScreens = [
    _HomeCustomerContent(),
    DesainCustomerScreen(),
    TrackingPesananCustomerScreen(),
    RiwayatCustomerScreen(),
    ProfileCustomerScreen(),
  ];

  final List<String> _appBarTitles = const [
    'Beranda',
    'Pesan',
    'Pelacakan',
    'Riwayat',
    'Profil',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
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
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
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
                    children: _customerScreens,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDE8500),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBarItem(
            icon: Icons.home,
            label: 'Beranda',
            isActive: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarItem(
            icon: Icons.message,
            label: 'Pesan',
            isActive: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavBarItem(
            icon: Icons.local_shipping,
            label: 'Pelacakan',
            isActive: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavBarItem(
            icon: Icons.history,
            label: 'Riwayat',
            isActive: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
          _NavBarItem(
            icon: Icons.person,
            label: 'Profil',
            isActive: selectedIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _NavBarItem({
    // ignore: unused_element_parameter
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.black87,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              decoration:
                  isActive ? TextDecoration.underline : TextDecoration.none,
              decorationColor: Colors.white,
              decorationThickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeCustomerContent extends StatelessWidget {
  // ignore: unused_element_parameter
  const _HomeCustomerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFFDE8500)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari model pakaian...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontFamily: 'SF Pro Text',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Kategori',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'SF Pro Display',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CategoryCard(
              icon: Icons.checkroom,
              label: 'Seragam',
              onTap: () {},
            ),
            _CategoryCard(
              icon: Icons.checkroom,
              label: 'Celana',
              onTap: () {},
            ),
            _CategoryCard(
              icon: Icons.checkroom,
              label: 'Kemeja',
              onTap: () {},
            ),
            _CategoryCard(
              icon: Icons.checkroom,
              label: 'Lainnya',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Rekomendasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'SF Pro Display',
          ),
        ),
        const SizedBox(height: 16),
        const _RecommendationCard(
          imageText: 'Gambar Seragam',
          title: 'Seragam Sekolah',
          price: 'Rp 150.000',
        ),
        const SizedBox(height: 16),
        const _RecommendationCard(
          imageText: 'Gambar Celana',
          title: 'Celana Chino',
          price: 'Rp 200.000',
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.onTap,
    // ignore: unused_element_parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: const Color(0xFFDE8500).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFFDE8500),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: 'SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String imageText;
  final String title;
  final String price;

  const _RecommendationCard({
    required this.imageText,
    required this.title,
    required this.price,
    // ignore: unused_element_parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: const Color(0xFF8FBC8F).withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Text(
                imageText,
                style: const TextStyle(
                  color: Color(0xFF8FBC8F),
                  fontSize: 16,
                  fontFamily: 'SF Pro Text',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFDE8500),
                    fontFamily: 'SF Pro Text',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
