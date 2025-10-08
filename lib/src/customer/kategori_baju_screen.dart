import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jasa_jahit_aplication/src/model/product_model.dart';
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
import 'package:jasa_jahit_aplication/src/customer/pembayaran_model_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';

class KategoriBajuScreen extends StatefulWidget {
  const KategoriBajuScreen({super.key});

  @override
  State<KategoriBajuScreen> createState() => _KategoriBajuScreenState();
}

class _KategoriBajuScreenState extends State<KategoriBajuScreen> {
  List<Product> _bajuProducts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBajuProducts();
  }

  Future<void> _loadBajuProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Data model baju hardcoded (tidak perlu Firestore)
      final List<Product> hardcodedProducts = [
        Product(
          id: 'baju_001',
          name: 'Kaos Oblong Hitam',
          description:
              'Kaos oblong hitam dengan bahan katun premium yang nyaman dipakai',
          price: 85000,
          imagePath: 'assets/images/kaos_oblong_hitam.jpg',
          category: 'baju',
        ),
        Product(
          id: 'baju_002',
          name: 'Kaos Oblong Coklat',
          description: 'Kaos oblong coklat dengan desain simpel dan elegan',
          price: 85000,
          imagePath: 'assets/images/kaos_oblong_coklat.jpg',
          category: 'baju',
        ),
        Product(
          id: 'baju_003',
          name: 'Kemeja Lengan Panjang Hitam',
          description: 'Kemeja formal lengan panjang dengan potongan modern',
          price: 120000,
          imagePath: 'assets/images/kemeja_lengan_panjang_hitam.jpg',
          category: 'baju',
        ),
        Product(
          id: 'baju_004',
          name: 'Polo Shirt Biru',
          description: 'Polo shirt biru dengan kerah yang rapi dan nyaman',
          price: 95000,
          imagePath: 'assets/images/polo_shirt_biru.jpg',
          category: 'baju',
        ),
      ];

      // Simulasi loading delay
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _bajuProducts = hardcodedProducts;
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
          'Kategori Baju',
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
        onRefresh: _loadBajuProducts,
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
                      onPressed: _loadBajuProducts,
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
            : _bajuProducts.isEmpty
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
                      'Belum ada model baju',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Model baju akan muncul di sini',
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
                      'Model Baju Terbaru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pilih model baju yang ingin Anda pesan',
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
                            childAspectRatio: 0.7,
                          ),
                      itemCount: _bajuProducts.length,
                      itemBuilder: (context, index) {
                        final product = _bajuProducts[index];
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
