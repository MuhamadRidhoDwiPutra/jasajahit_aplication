import 'package:flutter/material.dart';
import 'desain_customer_screen.dart';
import 'konfirmasi_desain_baju_customer_screen.dart';
import 'konfirmasi_desain_celana_customer_screen.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart' as model;

class UkuranCelanaCustomerScreen extends StatefulWidget {
  const UkuranCelanaCustomerScreen({super.key});

  @override
  State<UkuranCelanaCustomerScreen> createState() =>
      _UkuranCelanaCustomerScreenState();
}

class _UkuranCelanaCustomerScreenState
    extends State<UkuranCelanaCustomerScreen> {
  String? selectedKain;

  final List<String> kainList = ['Kain Katun', 'Kain Polyester', 'Kain Rayon'];

  final TextEditingController panjangCelanaController = TextEditingController();
  final TextEditingController lingkarPinggangController =
      TextEditingController();
  final TextEditingController lingkarPinggulController =
      TextEditingController();
  final TextEditingController lingkarPesakController = TextEditingController();
  final TextEditingController lingkarPahaController = TextEditingController();
  final TextEditingController lebarBawahCelanaController =
      TextEditingController();

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
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Color(0xFFDE8500)),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DesainCustomerScreen()),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Ukuran Celana',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                            fontFamily: 'SF Pro Display',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isDark ? const Color(0xFF2A2A2A) : Colors.white,
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
                            Text(
                              'Ukuran (cm)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const SizedBox(height: 16),
                            _MeasurementField(
                              label: 'Panjang Celana',
                              controller: panjangCelanaController,
                              icon: Icons.straighten,
                            ),
                            const SizedBox(height: 16),
                            _MeasurementField(
                              label: 'Lingkar Pinggang',
                              controller: lingkarPinggangController,
                              icon: Icons.straighten,
                            ),
                            const SizedBox(height: 16),
                            _MeasurementField(
                              label: 'Lingkar Pinggul',
                              controller: lingkarPinggulController,
                              icon: Icons.straighten,
                            ),
                            const SizedBox(height: 16),
                            _MeasurementField(
                              label: 'Lingkar Pesak',
                              controller: lingkarPesakController,
                              icon: Icons.straighten,
                            ),
                            const SizedBox(height: 16),
                            _MeasurementField(
                              label: 'Lingkar Paha',
                              controller: lingkarPahaController,
                              icon: Icons.straighten,
                            ),
                            const SizedBox(height: 16),
                            _MeasurementField(
                              label: 'Lebar Bawah Celana',
                              controller: lebarBawahCelanaController,
                              icon: Icons.straighten,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDE8500),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Anda harus login untuk membuat pesanan.')),
                            );
                            return;
                          }

                          final measurements = {
                            'panjangCelana': panjangCelanaController.text,
                            'lingkarPinggang': lingkarPinggangController.text,
                            'lingkarPinggul': lingkarPinggulController.text,
                            'lingkarPesak': lingkarPesakController.text,
                            'lingkarPaha': lingkarPahaController.text,
                            'lebarBawahCelana': lebarBawahCelanaController.text,
                          };

                          final order = model.Order(
                            userId: user.uid,
                            userName:
                                user.displayName ?? user.email ?? 'No Name',
                            orderType: 'Celana',
                            measurements: measurements,
                            orderDate: fs.Timestamp.now(),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  KonfirmasiDesainCelanaCustomerScreen(
                                      order: order),
                            ),
                          );
                        },
                        child: const Text(
                          'Lanjutkan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'SF Pro Text',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;

  const _MeasurementField({
    required this.label,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.grey,
            fontFamily: 'SF Pro Text',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontFamily: 'SF Pro Text',
          ),
          decoration: InputDecoration(
            hintText: 'Masukkan ukuran',
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey[400],
              fontFamily: 'SF Pro Text',
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFFDE8500),
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF3A3A3A) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFDE8500),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
