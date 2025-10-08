import 'dart:async';
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
import 'package:tabler_icons_flutter/tabler_icons_flutter.dart';
import 'package:jasa_jahit_aplication/Core/provider/notification_provider.dart';
import 'package:jasa_jahit_aplication/src/page/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jasa_jahit_aplication/src/model/product_model.dart';
import 'pembayaran_model_customer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';
import 'kategori_baju_screen.dart';
import 'kategori_celana_screen.dart';
import 'kategori_rok_screen.dart';
import 'kategori_jas_screen.dart';

class HomeCustomerScreen extends StatefulWidget {
  final int initialIndex;
  const HomeCustomerScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeCustomerScreen> createState() => _HomeCustomerScreenState();
}

class _HomeCustomerScreenState extends State<HomeCustomerScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    // Setup FCM token untuk customer
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      notificationProvider.setupFirebaseMessaging(context);

      // Simpan FCM token customer ke Firestore
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await notificationProvider.saveFCMTokenToFirestore(
          currentUser.uid,
          'customer',
        );
      }

      // Load notifikasi dari Firestore
      if (currentUser != null) {
        await notificationProvider.loadNotificationsFromFirestore('customer');
      }
    });
  }

  final List<Widget> _customerScreens = [
    const _HomeCustomerContent(),
    const DesainCustomerScreen(),
    const StatusPesananCustomerScreen(),
    const RiwayatCustomerScreen(),
    const ProfileCustomerScreen(),
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

  void _showNotificationDialog(BuildContext context) async {
    // Tandai semua notifikasi customer sebagai sudah dibaca
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('⚠️ No current user found for marking notifications as read');
      return;
    }

    final notificationsRef = FirebaseFirestore.instance.collection(
      'notifications',
    );
    final unreadNotifications = await notificationsRef
        .where('recipientId', isEqualTo: currentUser.uid)
        .where('isRead', isEqualTo: false)
        .get();

    // Update semua notifikasi menjadi sudah dibaca
    for (var doc in unreadNotifications.docs) {
      await doc.reference.update({'isRead': true});
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationScreen()),
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
                                  .where(
                                    'recipientId',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser?.uid,
                                  )
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
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFDE8500).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Color(0xFF25D366),
                            size: 24,
                          ),
                          onPressed: () {
                            WhatsAppChatHelper.openWhatsAppChat(context);
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

class _HomeCustomerContent extends StatefulWidget {
  const _HomeCustomerContent({super.key});

  @override
  State<_HomeCustomerContent> createState() => _HomeCustomerContentState();
}

class _HomeCustomerContentState extends State<_HomeCustomerContent> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  // Data produk model terbaru
  List<Product> get _products => [
    // Celana
    Product(
      id: '1',
      name: 'Celana Kain Panjang',
      description:
          'Celana panjang dengan bahan kain berkualitas tinggi, nyaman dipakai untuk acara formal maupun casual.',
      price: 150000,
      imagePath: 'assets/images/celana_kain_panjang.jpg',
      category: 'Celana',
    ),
    Product(
      id: '2',
      name: 'Celana Jeans Slim Fit',
      description:
          'Celana jeans slim fit dengan warna biru yang elegan, cocok untuk tampilan casual yang stylish.',
      price: 120000,
      imagePath: 'assets/images/celana_jeans_slim_fit.jpg',
      category: 'Celana',
    ),
    Product(
      id: '3',
      name: 'Celana Chino Coklat',
      description:
          'Celana chino coklat dengan bahan yang ringan dan nyaman, cocok untuk acara semi-formal.',
      price: 110000,
      imagePath: 'assets/images/celana_chino_coklat.jpg',
      category: 'Celana',
    ),
    Product(
      id: '4',
      name: 'Celana Training Hitam',
      description:
          'Celana training hitam untuk aktivitas olahraga, dengan bahan yang nyaman dan fleksibel.',
      price: 85000,
      imagePath: 'assets/images/celana_training_hitam.jpg',
      category: 'Celana',
    ),

    // Baju
    Product(
      id: '5',
      name: 'Kaos Oblong Hitam',
      description:
          'Kaos oblong hitam dengan bahan katun yang lembut dan nyaman, cocok untuk penggunaan sehari-hari.',
      price: 80000,
      imagePath: 'assets/images/kaos_oblong_hitam.jpg',
      category: 'Baju',
    ),
    Product(
      id: '6',
      name: 'Kaos Oblong Coklat',
      description:
          'Kaos oblong coklat dengan bahan premium, nyaman dan stylish untuk penggunaan sehari-hari.',
      price: 85000,
      imagePath: 'assets/images/kaos_oblong_coklat.jpg',
      category: 'Baju',
    ),
    Product(
      id: '7',
      name: 'Kemeja Lengan Panjang Hitam',
      description:
          'Kemeja lengan panjang hitam dengan desain klasik, cocok untuk acara formal dan semi-formal.',
      price: 120000,
      imagePath: 'assets/images/kemeja_lengan_panjang_hitam.jpg',
      category: 'Baju',
    ),
    Product(
      id: '8',
      name: 'Polo Shirt Biru',
      description:
          'Polo shirt biru dengan kerah yang rapi dan nyaman, cocok untuk acara casual yang elegan.',
      price: 95000,
      imagePath: 'assets/images/polo_shirt_biru.jpg',
      category: 'Baju',
    ),

    // Rok
    Product(
      id: '9',
      name: 'Rok Panjang Hitam',
      description:
          'Rok panjang hitam dengan potongan modern, cocok untuk acara formal dan semi-formal.',
      price: 180000,
      imagePath: 'assets/images/rok_panjang_hitam.jpg',
      category: 'Rok',
    ),
    Product(
      id: '10',
      name: 'Rok Mini Polos',
      description:
          'Rok mini dengan desain simpel dan modern, cocok untuk tampilan casual yang stylish.',
      price: 75000,
      imagePath: 'assets/images/rok_mini_polos.jpg',
      category: 'Rok',
    ),
    Product(
      id: '11',
      name: 'Rok A-Line Coklat',
      description:
          'Rok A-line dengan potongan yang flattering, cocok untuk berbagai bentuk tubuh.',
      price: 85000,
      imagePath: 'assets/images/rok_A-line_coklat.jpg',
      category: 'Rok',
    ),
    Product(
      id: '12',
      name: 'Rok Pencil Hitam',
      description:
          'Rok pencil hitam untuk tampilan formal dan profesional, cocok untuk acara kantor.',
      price: 100000,
      imagePath: 'assets/images/rok_pencil_hitam.jpg',
      category: 'Rok',
    ),

    // Jas
    Product(
      id: '13',
      name: 'Jas Hitam Elegan',
      description:
          'Jas hitam elegan dengan potongan modern, cocok untuk acara formal dan profesional.',
      price: 250000,
      imagePath: 'assets/images/jaz_hitam.jpg',
      category: 'Jas',
    ),
    Product(
      id: '14',
      name: 'Jas Navy Blue',
      description:
          'Jas navy blue dengan desain klasik dan elegan, cocok untuk acara formal yang stylish.',
      price: 280000,
      imagePath: 'assets/images/jaz_navy_blue.jpg',
      category: 'Jas',
    ),
    Product(
      id: '15',
      name: 'Jas Abu-abu Modern',
      description:
          'Jas abu-abu dengan potongan modern dan stylish, cocok untuk acara formal yang kontemporer.',
      price: 260000,
      imagePath: 'assets/images/jaz_abu-abu_modern.jpg',
      category: 'Jas',
    ),
    Product(
      id: '16',
      name: 'Jas Coklat Vintage',
      description:
          'Jas coklat dengan gaya vintage yang unik dan menarik, cocok untuk acara formal yang berbeda.',
      price: 240000,
      imagePath: 'assets/images/jaz_coklat_vintage.jpg',
      category: 'Jas',
    ),
  ];

  // Getter untuk produk yang sudah difilter berdasarkan search
  List<Product> get _filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products.where((product) {
      final query = _searchQuery.toLowerCase();
      return product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
  }

  // Fungsi debounce untuk search
  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = value;
      });
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

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
              const Icon(Icons.search, color: Color(0xFFDE8500), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontFamily: 'SF Pro Text',
                  ),
                  decoration: InputDecoration(
                    hintText: _searchQuery.isEmpty
                        ? 'Cari model pakaian... (nama, kategori, deskripsi)'
                        : 'Mencari "$_searchQuery"...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey[400],
                      fontSize: 14,
                      fontFamily: 'SF Pro Text',
                    ),
                    border: InputBorder.none,
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Color(0xFFDE8500),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: _onSearchChanged,
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
            fontFamily: 'SF Pro Text',
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _CategoryCard(
                icon: null,
                imagePath: 'assets/images/logo_baju.png',
                label: 'Baju',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KategoriBajuScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _CategoryCard(
                icon: null,
                imagePath: 'assets/images/logo_celana.png',
                label: 'Celana',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KategoriCelanaScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _CategoryCard(
                icon: null,
                imagePath: 'assets/images/logo_ok.png',
                label: 'Rok',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KategoriRokScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _CategoryCard(
                icon: null,
                imagePath: 'assets/images/logo_jaz.png',
                label: 'Jas',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KategoriJasScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _searchQuery.isEmpty ? 'Model Terbaru' : 'Hasil Pencarian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
                fontFamily: 'SF Pro Text',
              ),
            ),
            if (_searchQuery.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDE8500).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_filteredProducts.length} hasil',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFDE8500),
                    fontFamily: 'SF Pro Text',
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        // Tampilkan hasil search atau semua produk
        if (_filteredProducts.isEmpty && _searchQuery.isNotEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: isDark ? Colors.white70 : Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada model pakaian ditemukan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontFamily: 'SF Pro Text',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coba kata kunci lain atau hapus pencarian',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.grey[500],
                    fontFamily: 'SF Pro Text',
                  ),
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio:
                  0.7, // Perbesar gambar dengan aspect ratio lebih kecil
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return _ModelCard(product: product);
            },
          ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final dynamic
  icon; // Gunakan dynamic untuk mendukung FontAwesome, Material Icons, dan Image
  final String label;
  final VoidCallback onTap;
  final String? imagePath; // Tambahkan path untuk gambar

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDE8500).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    )
                  : Icon(icon, color: const Color(0xFFDE8500), size: 40),
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
  final Product product;

  const _ModelCard({required this.product, super.key});

  void _showProductDetail(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header dengan gambar
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    child: Image.asset(
                      product.imagePath,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: isDark ? Colors.grey[700] : Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: isDark ? Colors.white70 : Colors.black54,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp ${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDE8500),
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Deskripsi:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontFamily: 'SF Pro Text',
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Tutup',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDE8500),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PembayaranModelCustomerScreen(
                                          product: product,
                                          selectedSize: 'L',
                                          firestoreService: FirestoreService(),
                                          sourcePage:
                                              'home', // Tambah parameter asal halaman
                                        ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Beli Sekarang',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
            child: Container(
              height: 120, // Perbesar dari 100 ke 120 untuk gambar lebih besar
              width: double.infinity,
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  product.imagePath,
                  height:
                      120, // Perbesar dari 100 ke 120 untuk gambar lebih besar
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height:
                          120, // Perbesar dari 100 ke 120 untuk gambar lebih besar
                      width: double.infinity,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: isDark ? Colors.white70 : Colors.black54,
                          size: 28, // Perbesar dari 24 ke 28
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                8,
              ), // Tingkatkan dari 6 ke 8 untuk memberikan ruang lebih
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: 'SF Pro Text',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 3,
                  ), // Kurangi dari 4 ke 3 untuk menghemat ruang
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 8,
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontFamily: 'SF Pro Text',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFDE8500),
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ), // Kurangi dari 4 ke 3 untuk menghemat ruang
                  SizedBox(
                    height:
                        26, // Tingkatkan dari 24 ke 26 untuk mencegah overflow
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDE8500),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                              ), // Tingkatkan dari 2 ke 3
                              minimumSize: const Size(
                                0,
                                20,
                              ), // Tambahkan minimum size
                            ),
                            onPressed: () => _showProductDetail(context),
                            child: const Text(
                              'Detail',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro Text',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3), // Tingkatkan dari 2 ke 3
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                              ), // Tingkatkan dari 2 ke 3
                              minimumSize: const Size(
                                0,
                                20,
                              ), // Tambahkan minimum size
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PembayaranModelCustomerScreen(
                                        product: product,
                                        selectedSize: 'L',
                                        firestoreService: FirestoreService(),
                                        sourcePage:
                                            'home', // Tambah parameter asal halaman
                                      ),
                                ),
                              );
                            },
                            child: const Text(
                              'Beli',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro Text',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
