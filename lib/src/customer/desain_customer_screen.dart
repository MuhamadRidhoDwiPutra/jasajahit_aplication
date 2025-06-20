import 'package:flutter/material.dart';
// ignore: unused_import
import 'ukuran_baju_customer_screen.dart';
import 'home_customer_screen.dart';
// ignore: unused_import
import 'ukuran_celana_customer_screen.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';


class DesainCustomerScreen extends StatefulWidget {
  const DesainCustomerScreen({super.key});

  @override
  State<DesainCustomerScreen> createState() => _DesainCustomerScreenState();
}

class _DesainCustomerScreenState extends State<DesainCustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeCustomerScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF8FBC8F),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'Lengkapi Form Pemesanan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
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
                        const Text(
                          'Pilih Kain',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(icon, color: Colors.black54, size: 40),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDE8500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  onPressed: onTap,
                  child: const Text(
                    'Buat Desain mu',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
  const _FabricCardModern(
      {required this.name,
      required this.description,
      required this.price,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFDE8500).withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFFDE8500) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFDE8500).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.checkroom,
                  color: Color(0xFFDE8500), size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFFDE8500),
                fontFamily: 'SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
