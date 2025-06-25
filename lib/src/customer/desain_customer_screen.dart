import 'package:flutter/material.dart';
import 'ukuran_baju_customer_screen.dart';
import 'home_customer_screen.dart';
import 'ukuran_celana_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';

class DesainCustomerScreen extends StatefulWidget {
  const DesainCustomerScreen({super.key});

  @override
  State<DesainCustomerScreen> createState() => _DesainCustomerScreenState();
}

class _DesainCustomerScreenState extends State<DesainCustomerScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeCustomerScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF1A1A1A) : const Color(0xFF8FBC8F),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          'Lengkapi Form Pemesanan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black54,
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
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _ModelCardModern(
                                icon: Icons.checkroom,
                                imageText: 'Gambar Baju',
                                title: 'Desain Baju',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UkuranBajuCustomerScreen(),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return _ModelCardModern(
                                icon: Icons.shopping_bag,
                                imageText: 'Gambar Celana',
                                title: 'Desain Celana',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UkuranCelanaCustomerScreen(),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Pilih Kain',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FabricCardModern(
                          name: 'Katun',
                          description: 'Nyaman dan menyerap keringat',
                          price: 'Rp 50.000/meter',
                          selected: true,
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _FabricCardModern(
                          name: 'Polyester',
                          description: 'Tahan lama dan mudah dirawat',
                          price: 'Rp 45.000/meter',
                          selected: false,
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _FabricCardModern(
                          name: 'Rayon',
                          description: 'Halus dan mengalir',
                          price: 'Rp 55.000/meter',
                          selected: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModelCardModern extends StatelessWidget {
  final IconData icon;
  final String imageText;
  final String title;
  final VoidCallback onTap;
  const _ModelCardModern(
      {required this.icon,
      required this.imageText,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 18, bottom: 12),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(icon,
                    color: isDark ? Colors.white70 : Colors.black54, size: 40),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              imageText,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.black54,
                fontFamily: 'SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabricCardModern extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const _FabricCardModern({
    required this.name,
    required this.description,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: selected
              ? (isDark
                  ? const Color(0xFFDE8500).withOpacity(0.2)
                  : const Color(0xFFDE8500).withOpacity(0.1))
              : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: selected
              ? Border.all(
                  color: const Color(0xFFDE8500),
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFFDE8500),
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDE8500),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
