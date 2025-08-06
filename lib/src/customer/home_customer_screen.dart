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
import 'package:jasa_jahit_aplication/Core/provider/notification_provider.dart';
import 'package:jasa_jahit_aplication/src/page/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jasa_jahit_aplication/src/model/product_model.dart';
import 'pembayaran_model_customer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';

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
                          icon: Image.asset(
                            'assets/images/ikon_WA.png',
                            width: 24,
                            height: 24,
                            color: const Color(0xFF25D366),
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

class _HomeCustomerContent extends StatelessWidget {
  const _HomeCustomerContent({super.key});

  // Data produk model terbaru
  List<Product> get _products => [
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
      name: 'Jas Hitam',
      description:
          'Jas hitam elegan dengan potongan modern, cocok untuk acara formal dan profesional.',
      price: 250000,
      imagePath: 'assets/images/jaz_hitam.jpg',
      category: 'Jas',
    ),
    Product(
      id: '3',
      name: 'Kaos Oblong Hitam',
      description:
          'Kaos oblong hitam dengan bahan katun yang lembut dan nyaman, cocok untuk penggunaan sehari-hari.',
      price: 80000,
      imagePath: 'assets/images/kaos_oblong_hitam.jpg',
      category: 'Kaos',
    ),
    Product(
      id: '4',
      name: 'Kemeja Lengan Panjang Hitam',
      description:
          'Kemeja lengan panjang hitam dengan desain klasik, cocok untuk acara formal dan semi-formal.',
      price: 120000,
      imagePath: 'assets/images/kemeja_lengan_panjang_hitam.jpg',
      category: 'Kemeja',
    ),
  ];

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
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
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
                icon: FontAwesomeIcons.shirt, // Baju - sudah tepat
                label: 'Baju',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Baju'),
                      content: const Text(
                        'Baju adalah pakaian atasan yang digunakan sehari-hari atau untuk acara tertentu.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _CategoryCard(
                icon: FontAwesomeIcons
                    .personWalking, // Celana - ikon orang berjalan lebih sesuai
                label: 'Celana',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Celana'),
                      content: const Text(
                        'Celana adalah pakaian bawahan yang menutupi bagian pinggang hingga kaki.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _CategoryCard(
                icon: FontAwesomeIcons.personDress, // Rok - sudah tepat
                label: 'Rok',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Rok'),
                      content: const Text(
                        'Rok adalah pakaian bawahan yang menutupi bagian pinggang hingga lutut atau kaki, biasanya digunakan oleh wanita.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _CategoryCard(
                icon: FontAwesomeIcons.userTie, // Jas - ikon jas lebih sesuai
                label: 'Jas',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Jas'),
                      content: const Text(
                        'Jas adalah pakaian formal bagian atas yang biasanya digunakan untuk acara resmi.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
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
            childAspectRatio: 0.95,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return _ModelCard(product: product);
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
              child: Icon(icon, color: const Color(0xFFDE8500), size: 24),
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
              height: 80, // Kurangi dari 100
              width: double.infinity,
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              child: Image.asset(
                product.imagePath,
                height: 80, // Kurangi dari 100
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 80, // Kurangi dari 100
                    width: double.infinity,
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: isDark ? Colors.white70 : Colors.black54,
                        size: 24, // Kurangi dari 32
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4), // Kurangi dari 6
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 10, // Kurangi dari 11
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: 'SF Pro Display',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1), // Kurangi dari 2
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 7, // Kurangi dari 8
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontFamily: 'SF Pro Text',
                    ),
                    maxLines: 1, // Kurangi dari 2
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 9, // Kurangi dari 10
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFDE8500),
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                  const SizedBox(height: 2), // Kurangi dari 4
                  SizedBox(
                    height: 20, // Kurangi dari 24
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDE8500),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  3,
                                ), // Kurangi dari 4
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 1,
                              ), // Kurangi dari 2
                            ),
                            onPressed: () => _showProductDetail(context),
                            child: const Text(
                              'Detail',
                              style: TextStyle(
                                fontSize: 7, // Kurangi dari 8
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 1), // Kurangi dari 2
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  3,
                                ), // Kurangi dari 4
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 1,
                              ), // Kurangi dari 2
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
                                      ),
                                ),
                              );
                            },
                            child: const Text(
                              'Beli',
                              style: TextStyle(
                                fontSize: 7, // Kurangi dari 8
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro Display',
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
