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
  final String _selectedFabric = 'Katun';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeCustomerScreen(initialIndex: 1),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFF8FBC8F),
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
                                          UkuranBajuCustomerScreen(
                                            selectedFabric: _selectedFabric,
                                          ),
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
                                          UkuranCelanaCustomerScreen(
                                            selectedFabric: _selectedFabric,
                                          ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
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
  const _ModelCardModern({
    required this.icon,
    required this.imageText,
    required this.title,
    required this.onTap,
  });

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
                child: Icon(
                  icon,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 40,
                ),
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
