import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/model/kain_model.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';

class KalkulatorHargaScreen extends StatefulWidget {
  const KalkulatorHargaScreen({super.key});

  @override
  State<KalkulatorHargaScreen> createState() => _KalkulatorHargaScreenState();
}

class _KalkulatorHargaScreenState extends State<KalkulatorHargaScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  KainModel? _selectedKain;
  String _jenisPakaian = 'celana';
  String _ukuran = 'M';
  String _kategoriUmur = 'dewasa';
  String _lokasi = 'kota_kecil';
  bool _isExpress = false;
  bool _isCustomUkuran = false;
  int _estimasiHarga = 0;

  final List<String> _jenisPakaianList = [
    'celana',
    'kaos',
    'oblong',
    'baju',
    'kemeja',
    'jas',
    'blazer',
  ];

  final List<String> _ukuranList = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'XXXL',
    'Custom',
  ];

  final List<String> _kategoriUmurList = [
    'bayi',
    'balita',
    'anak',
    'remaja',
    'dewasa',
    'lansia',
  ];

  final List<String> _lokasiList = ['desa', 'kota_kecil', 'kota_besar'];

  void _hitungEstimasi() {
    if (_selectedKain != null) {
      setState(() {
        _estimasiHarga = _selectedKain!.hitungEstimasiHarga(
          jenisPakaian: _jenisPakaian,
          ukuran: _ukuran,
          isExpress: _isExpress,
          isCustomUkuran: _isCustomUkuran,
          kategoriUmur: _kategoriUmur,
          lokasi: _lokasi,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Estimasi Harga'),
        backgroundColor: isDark ? Colors.grey[900] : Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pilih Kain
            Text(
              'Pilih Kain',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
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
                  height: 120,
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
                            _hitungEstimasi();
                          });
                        },
                        child: Container(
                          width: 200,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.orange.shade900
                                : isDark
                                ? Colors.grey[800]
                                : Colors.grey[200],
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
                                ),
                              ),
                              Text(
                                kain.warna,
                                style: TextStyle(
                                  color: selected ? Colors.white70 : null,
                                ),
                              ),
                              Text(
                                'Rp ${kain.harga.toString()}/meter',
                                style: TextStyle(
                                  color: selected ? Colors.orange : null,
                                  fontWeight: FontWeight.bold,
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
            const SizedBox(height: 24),

            // Form Input
            Text(
              'Detail Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Jenis Pakaian
            Text(
              'Jenis Pakaian',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _jenisPakaian,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _jenisPakaianList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toUpperCase()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _jenisPakaian = newValue!;
                  _hitungEstimasi();
                });
              },
            ),
            const SizedBox(height: 16),

            // Kategori Umur
            Text(
              'Kategori Umur',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _kategoriUmur,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _kategoriUmurList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toUpperCase()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _kategoriUmur = newValue!;
                  _hitungEstimasi();
                });
              },
            ),
            const SizedBox(height: 16),

            // Lokasi
            Text(
              'Lokasi',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _lokasi,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _lokasiList.map((String value) {
                String displayText = '';
                switch (value) {
                  case 'desa':
                    displayText = 'Desa (20% lebih murah)';
                    break;
                  case 'kota_kecil':
                    displayText = 'Kota Kecil (Harga standar)';
                    break;
                  case 'kota_besar':
                    displayText = 'Kota Besar (30% lebih mahal)';
                    break;
                }
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(displayText),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _lokasi = newValue!;
                  _hitungEstimasi();
                });
              },
            ),
            const SizedBox(height: 16),

            // Ukuran
            Text(
              'Ukuran',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _ukuran,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _ukuranList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _ukuran = newValue!;
                  _isCustomUkuran = newValue == 'Custom';
                  _hitungEstimasi();
                });
              },
            ),
            const SizedBox(height: 16),

            // Checkbox Options
            CheckboxListTile(
              title: const Text('Pengerjaan Express (1-2 hari)'),
              subtitle: const Text('Biaya tambahan 50%'),
              value: _isExpress,
              onChanged: (bool? value) {
                setState(() {
                  _isExpress = value!;
                  _hitungEstimasi();
                });
              },
            ),

            if (_ukuran == 'Custom')
              CheckboxListTile(
                title: const Text('Ukuran Custom'),
                subtitle: const Text('Biaya tambahan untuk ukuran khusus'),
                value: _isCustomUkuran,
                onChanged: (bool? value) {
                  setState(() {
                    _isCustomUkuran = value!;
                    _hitungEstimasi();
                  });
                },
              ),

            const SizedBox(height: 24),

            // Hasil Estimasi
            if (_selectedKain != null && _estimasiHarga > 0)
              Container(
                width: double.infinity,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${_estimasiHarga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Detail:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    Text(
                      '• Kain: ${_selectedKain!.nama} (${_selectedKain!.kebutuhanMeter.toStringAsFixed(1)}m)',
                    ),
                    Text('• Jenis: ${_jenisPakaian.toUpperCase()}'),
                    Text('• Kategori: ${_kategoriUmur.toUpperCase()}'),
                    Text(
                      '• Lokasi: ${_lokasi.replaceAll('_', ' ').toUpperCase()}',
                    ),
                    Text('• Ukuran: $_ukuran'),
                    if (_isExpress) Text('• Express: Ya'),
                    if (_isCustomUkuran) Text('• Custom Ukuran: Ya'),
                  ],
                ),
              ),

            const Spacer(),

            // Tombol Lanjut
            if (_selectedKain != null && _estimasiHarga > 0)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to order screen with calculated price
                    Navigator.pop(context, {
                      'kain': _selectedKain,
                      'jenisPakaian': _jenisPakaian,
                      'ukuran': _ukuran,
                      'isExpress': _isExpress,
                      'isCustomUkuran': _isCustomUkuran,
                      'estimasiHarga': _estimasiHarga,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lanjut ke Pesanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
