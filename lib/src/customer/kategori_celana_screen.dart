import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jasa_jahit_aplication/src/model/product_model.dart';
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
import 'package:jasa_jahit_aplication/src/customer/pembayaran_model_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';

class KategoriCelanaScreen extends StatefulWidget {
  const KategoriCelanaScreen({super.key});

  @override
  State<KategoriCelanaScreen> createState() => _KategoriCelanaScreenState();
}

class _KategoriCelanaScreenState extends State<KategoriCelanaScreen> {
  List<Product> _celanaProducts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCelanaProducts();
  }

  Future<void> _loadCelanaProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Data model celana hardcoded (tidak perlu Firestore)
      final List<Product> hardcodedProducts = [
        Product(
          id: 'celana_001',
          name: 'Celana Kain Panjang Hitam',
          description:
              'Celana kain panjang hitam dengan potongan modern dan nyaman',
          price: 95000,
          imagePath: 'assets/images/celana_kain_panjang.jpg',
          category: 'celana',
        ),
        Product(
          id: 'celana_002',
          name: 'Celana Jeans Slim Fit',
          description: 'Celana jeans slim fit dengan warna biru yang elegan',
          price: 120000,
          imagePath: 'assets/images/celana_jeans_slim_fit.jpg',
          category: 'celana',
        ),
        Product(
          id: 'celana_003',
          name: 'Celana Chino Coklat',
          description:
              'Celana chino coklat dengan bahan yang ringan dan nyaman',
          price: 110000,
          imagePath: 'assets/images/celana_chino_coklat.jpg',
          category: 'celana',
        ),
        Product(
          id: 'celana_004',
          name: 'Celana Training Hitam',
          description: 'Celana training hitam untuk aktivitas olahraga',
          price: 85000,
          imagePath: 'assets/images/celana_training_hitam.jpg',
          category: 'celana',
        ),
      ];

      // Simulasi loading delay
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _celanaProducts = hardcodedProducts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data: $e';
        _isLoading = false;
      });
    }
  }

  void _onProductTap(Product product) {
    // Navigasi langsung ke screen pembayaran model seperti di home customer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PembayaranModelCustomerScreen(
          product: product,
          selectedSize: 'L', // Default size
          firestoreService: FirestoreService(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kategori Celana',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadCelanaProducts,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFDE8500)),
              )
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: isDark ? Colors.white70 : Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi kesalahan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                        fontFamily: 'SF Pro Text',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadCelanaProducts,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDE8500),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
            : _celanaProducts.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: isDark ? Colors.white70 : Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada model celana',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Model celana akan muncul di sini',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Model Celana Terbaru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pilih model celana yang ingin Anda pesan',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: _celanaProducts.length,
                      itemBuilder: (context, index) {
                        final product = _celanaProducts[index];
                        return _ProductCard(
                          product: product,
                          onTap: () => _onProductTap(product),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      product.imagePath,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: 'SF Pro Display',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFDE8500),
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDE8500),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Pesan Sekarang',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'SF Pro Text',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
