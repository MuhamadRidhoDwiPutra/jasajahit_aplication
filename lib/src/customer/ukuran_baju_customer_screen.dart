// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'desain_customer_screen.dart';
import 'konfirmasi_desain_baju_customer_screen.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart';
import 'package:jasa_jahit_aplication/src/model/kain_model.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';
import 'pilih_kain_customer_screen.dart';
import 'home_customer_screen.dart';

class UkuranBajuCustomerScreen extends StatefulWidget {
  final String selectedFabric;
  final List<Map<String, dynamic>>? items;
  const UkuranBajuCustomerScreen({super.key, required this.selectedFabric, this.items});

  @override
  State<UkuranBajuCustomerScreen> createState() =>
      _UkuranBajuCustomerScreenState();
}

class _UkuranBajuCustomerScreenState extends State<UkuranBajuCustomerScreen> {
  final TextEditingController lingkarDadaController = TextEditingController();
  final TextEditingController lebarBahuController = TextEditingController();
  final TextEditingController panjangBajuController = TextEditingController();
  final TextEditingController panjangLenganController = TextEditingController();
  final TextEditingController lebarLenganController = TextEditingController();
  
  final FirestoreService _firestoreService = FirestoreService();
  KainModel? _selectedKain;
  int _estimasiHarga = 0;
  String _ukuranEstimasi = 'M';
  bool _isCustomUkuran = false;
  
  // Jenis baju yang tersedia
  final List<String> _jenisBajuList = [
    'Kaos Oblong',
    'Kemeja',
    'Polo (Kaos Berkerah)',
  ];
  String _selectedJenisBaju = 'Kaos Oblong';

  void _hitungEstimasiHarga() {
    if (_selectedKain != null) {
      final lingkarDada = double.tryParse(lingkarDadaController.text) ?? 0;
      
      // Tentukan ukuran berdasarkan lingkar dada
      if (lingkarDada > 0) {
        if (lingkarDada < 90) {
          _ukuranEstimasi = 'S';
          _isCustomUkuran = false;
        } else if (lingkarDada < 100) {
          _ukuranEstimasi = 'M';
          _isCustomUkuran = false;
        } else if (lingkarDada < 110) {
          _ukuranEstimasi = 'L';
          _isCustomUkuran = false;
        } else if (lingkarDada < 120) {
          _ukuranEstimasi = 'XL';
          _isCustomUkuran = false;
        } else {
          _ukuranEstimasi = 'Custom';
          _isCustomUkuran = true;
        }
      }
      
      setState(() {
        _estimasiHarga = _selectedKain!.hitungEstimasiHarga(
          jenisPakaian: 'baju',
          ukuran: _ukuranEstimasi,
          isExpress: false,
          isCustomUkuran: _isCustomUkuran,
          kategoriUmur: 'dewasa', // Default untuk dewasa
          lokasi: 'kota_kecil', // Default untuk kota kecil
        );
      });
    }
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
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Color(0xFFDE8500)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                                  builder: (context) => const HomeCustomerScreen(initialIndex: 1)),
            );
          },
        ),
                      ),
                      Expanded(
                        child: Text(
          'Ukuran Baju',
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
                            // Dropdown Jenis Baju
                            Text(
                              'Jenis Baju',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF3A3A3A) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFDE8500),
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedJenisBaju,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.checkroom,
                                    color: Color(0xFFDE8500),
                                  ),
                                ),
                                dropdownColor: isDark ? const Color(0xFF3A3A3A) : Colors.white,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontFamily: 'SF Pro Text',
                                  fontSize: 16,
                                ),
                                items: _jenisBajuList.map((String jenis) {
                                  return DropdownMenuItem<String>(
                                    value: jenis,
                                    child: Text(jenis),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedJenisBaju = newValue!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
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
                              label: 'Lingkar Dada',
                              controller: lingkarDadaController,
                              icon: Icons.straighten,
                            ),
                            const SizedBox(height: 16),
                            _MeasurementField(
                              label: 'Lebar Bahu',
                              controller: lebarBahuController,
                              icon: Icons.straighten,
                ),
                            const SizedBox(height: 16),
                            _MeasurementField(
                              label: 'Panjang Baju',
                              controller: panjangBajuController,
                              icon: Icons.straighten,
                            ),
                            const SizedBox(height: 16),
                            _MeasurementField(
                              label: 'Panjang Lengan',
                              controller: panjangLenganController,
                              icon: Icons.straighten,
                            ),
                            const SizedBox(height: 16),
                            _MeasurementField(
                              label: 'Lebar Lengan',
                              controller: lebarLenganController,
                              icon: Icons.straighten,
                            ),
                          ],
                        ),
                      ),
                      
                      // Preview Estimasi Harga
                      if (_selectedKain != null && _estimasiHarga > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimasi Harga',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rp ${_estimasiHarga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Jenis: $_selectedJenisBaju • Ukuran: $_ukuranEstimasi • Kain: ${_selectedKain!.nama}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Pilih Kain untuk Estimasi
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(16),
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
                            Text(
                              'Pilih Kain untuk Estimasi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                                fontFamily: 'SF Pro Display',
                              ),
                            ),
                            const SizedBox(height: 12),
                            StreamBuilder<List<KainModel>>(
                              stream: _firestoreService.getKainList(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                final kainList = snapshot.data ?? [];
                                if (kainList.isEmpty) {
                                  return const Center(child: Text('Belum ada data kain.'));
                                }
                                return SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: kainList.length,
                                    itemBuilder: (context, index) {
                                      final kain = kainList[index];
                                      final selected = kain.id == _selectedKain?.id;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedKain = kain;
                                            _hitungEstimasiHarga();
                                          });
                                        },
                                        child: Container(
                                          width: 150,
                                          margin: const EdgeInsets.only(right: 12),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? Colors.orange.shade900
                                                : isDark ? Colors.grey[800] : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(12),
                                            border: selected
                                                ? Border.all(color: Colors.orange, width: 2)
                                                : null,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                kain.nama,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: selected ? Colors.white : null,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                kain.warna,
                                                style: TextStyle(
                                                  color: selected ? Colors.white70 : null,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Text(
                                                'Rp ${kain.harga.toString()}/m',
                                                style: TextStyle(
                                                  color: selected ? Colors.orange : null,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
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

                          if (_selectedKain == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Silakan pilih kain terlebih dahulu.')),
                            );
                            return;
                          }

                          final measurements = {
                            'lingkarDada': lingkarDadaController.text,
                            'lebarBahu': lebarBahuController.text,
                            'panjangBaju': panjangBajuController.text,
                            'panjangLengan': panjangLenganController.text,
                            'lebarLengan': lebarLenganController.text,
                          };

                          // Langsung lanjut ke konfirmasi dengan kain yang sudah dipilih
                          final items = widget.items ?? [];
                          final modelName = 'Model Baju';
                          
                          items.add({
                            'orderType': 'Baju',
                            'model': modelName,
                            'jenisBaju': _selectedJenisBaju,
                            'fabric': _selectedKain!.nama,
                            'measurements': measurements,
                            'price': _estimasiHarga,
                            'estimatedSize': _ukuranEstimasi,
                            'isCustomSize': _isCustomUkuran,
                          });
                          
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KonfirmasiPesananCustomerScreen(
                                userId: user.uid,
                                userName: user.displayName ?? user.email ?? 'No Name',
                                items: items,
                                isDark: isDark,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Lanjut',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
