import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/customer/home_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/admin/home_admin_screen.dart';
import 'profile_customer_screen.dart';
import 'status_pesanan_customer_screen.dart';
import 'riwayat_customer_screen.dart';
import 'desain_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/customer/whatsapp_chat_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    StatusPesananCustomerScreen(),
    RiwayatCustomerScreen(),
    ProfileCustomerScreen(),
  ];

  final List<String> _appBarTitles = const [
    'Beranda',
    'Pesan',
    'Status Pesanan',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          icon:
                              const Icon(Icons.chat, color: Color(0xFF25D366)),
                          onPressed: () {
                            WhatsAppChatHelper.openWhatsAppChat();
                          },
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.home_outlined,
                  label: 'Beranda',
                  isActive: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
                _NavBarItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Pesan',
                  isActive: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
                _NavBarItem(
                  icon: Icons.email_outlined,
                  label: 'Status Pesanan',
                  isActive: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
                _NavBarItem(
                  icon: Icons.history,
                  label: 'Riwayat',
                  isActive: _selectedIndex == 3,
                  onTap: () => _onItemTapped(3),
                ),
                _NavBarItem(
                  icon: Icons.person_outline,
                  label: 'Profil',
                  isActive: _selectedIndex == 4,
                  onTap: () => _onItemTapped(4),
                ),
              ],
            ),
          ),
        ),
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
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFDE8500).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? const Color(0xFFDE8500)
                  : (isDark ? Colors.grey[600] : Colors.grey[600]),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFFDE8500)
                  : (isDark ? Colors.grey[600] : Colors.grey[600]),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeCustomerContent extends StatelessWidget {
  const _HomeCustomerContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFFDE8500)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari model pakaian...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey[400],
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
        Text(
          'Kategori',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
            fontFamily: 'SF Pro Display',
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _CategoryCard(
                icon: FontAwesomeIcons.shirt, // Baju
                label: 'Baju',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Baju'),
                      content: const Text(
                          'Baju adalah pakaian atasan yang digunakan sehari-hari atau untuk acara tertentu.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'))
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _CategoryCard(
                icon: FontAwesomeIcons
                    .personDress, // Celana (gunakan ikon dress sebagai pengganti celana)
                label: 'Celana',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Celana'),
                      content: const Text(
                          'Celana adalah pakaian bawahan yang menutupi bagian pinggang hingga kaki.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'))
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _CategoryCard(
                icon: FontAwesomeIcons
                    .userTie, // Seragam (gunakan ikon userTie sebagai pengganti seragam)
                label: 'Seragam',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Seragam'),
                      content: const Text(
                          'Seragam adalah pakaian yang digunakan secara bersama-sama dalam suatu kelompok atau institusi.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'))
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _CategoryCard(
                icon: FontAwesomeIcons.suitcase, // Jas
                label: 'Jas',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Jas'),
                      content: const Text(
                          'Jas adalah pakaian formal bagian atas yang biasanya digunakan untuk acara resmi.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'))
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Model Terbaru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
            fontFamily: 'SF Pro Display',
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _ModelCard(
              imageUrl: 'https://via.placeholder.com/150',
              title: 'Model ${index + 1}',
              price: 'Rp ${(index + 1) * 100000}',
            );
          },
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final dynamic icon; // Ubah dari IconData ke dynamic
  final String label;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
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
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
                fontFamily: 'SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const _ModelCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    super.key,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
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
