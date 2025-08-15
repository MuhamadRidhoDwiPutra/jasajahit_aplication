import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/model/kain_model.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';

class ModelKainAdminScreen extends StatefulWidget {
  const ModelKainAdminScreen({super.key});

  @override
  State<ModelKainAdminScreen> createState() => _ModelKainAdminScreenState();
}

class _ModelKainAdminScreenState extends State<ModelKainAdminScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  void _showKainDialog({KainModel? kain}) {
    final namaController = TextEditingController(text: kain?.nama ?? '');
    final warnaController = TextEditingController(text: kain?.warna ?? '');
    final hargaController = TextEditingController(
      text: kain?.harga != null ? kain!.harga.toString() : '',
    );
    final deskripsiController = TextEditingController(
      text: kain?.deskripsi ?? '',
    );
    final kebutuhanMeterController = TextEditingController(
      text: kain?.kebutuhanMeter != null
          ? kain!.kebutuhanMeter.toString()
          : '1.0',
    );
    final biayaJahitController = TextEditingController(
      text: kain?.biayaJahitDasar != null
          ? kain!.biayaJahitDasar.toString()
          : '50000',
    );

    // Controllers untuk kebutuhan kain per kategori
    final kebutuhanBayiController = TextEditingController(
      text: kain?.kebutuhanKainPerKategori['bayi']?.toString() ?? '0.4',
    );
    final kebutuhanBalitaController = TextEditingController(
      text: kain?.kebutuhanKainPerKategori['balita']?.toString() ?? '0.6',
    );
    final kebutuhanAnakController = TextEditingController(
      text: kain?.kebutuhanKainPerKategori['anak']?.toString() ?? '0.8',
    );
    final kebutuhanRemajaController = TextEditingController(
      text: kain?.kebutuhanKainPerKategori['remaja']?.toString() ?? '1.0',
    );
    final kebutuhanDewasaController = TextEditingController(
      text: kain?.kebutuhanKainPerKategori['dewasa']?.toString() ?? '1.2',
    );
    final kebutuhanLansiaController = TextEditingController(
      text: kain?.kebutuhanKainPerKategori['lansia']?.toString() ?? '1.3',
    );

    // Controllers untuk biaya jahit per kategori
    final biayaBayiController = TextEditingController(
      text: kain?.biayaJahitPerKategori['bayi']?.toString() ?? '25000',
    );
    final biayaBalitaController = TextEditingController(
      text: kain?.biayaJahitPerKategori['balita']?.toString() ?? '35000',
    );
    final biayaAnakController = TextEditingController(
      text: kain?.biayaJahitPerKategori['anak']?.toString() ?? '45000',
    );
    final biayaRemajaController = TextEditingController(
      text: kain?.biayaJahitPerKategori['remaja']?.toString() ?? '55000',
    );
    final biayaDewasaController = TextEditingController(
      text: kain?.biayaJahitPerKategori['dewasa']?.toString() ?? '60000',
    );
    final biayaLansiaController = TextEditingController(
      text: kain?.biayaJahitPerKategori['lansia']?.toString() ?? '70000',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      kain == null ? Icons.add : Icons.edit,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      kain == null ? 'Tambah Kain' : 'Edit Kain',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Informasi Dasar
                      Text(
                        'Informasi Dasar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Kain',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.inventory),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: warnaController,
                        decoration: const InputDecoration(
                          labelText: 'Warna',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.color_lens),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: hargaController,
                        decoration: const InputDecoration(
                          labelText: 'Harga per meter (Rp)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: deskripsiController,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Kebutuhan dan Biaya Dasar
                      Text(
                        'Kebutuhan dan Biaya Dasar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: kebutuhanMeterController,
                              decoration: const InputDecoration(
                                labelText: 'Kebutuhan (meter)',
                                border: OutlineInputBorder(),
                                helperText:
                                    'Contoh: 1.5 untuk celana, 1.0 untuk kaos',
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: biayaJahitController,
                              decoration: const InputDecoration(
                                labelText: 'Biaya Jahit Dasar (Rp)',
                                border: OutlineInputBorder(),
                                helperText: 'Biaya jahit untuk ukuran M',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Kebutuhan Kain per Kategori
                      Text(
                        'Kebutuhan Kain per Kategori (meter)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCategoryRow(
                        'Bayi',
                        kebutuhanBayiController,
                        '0.4m',
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryRow(
                        'Balita',
                        kebutuhanBalitaController,
                        '0.6m',
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryRow(
                        'Anak',
                        kebutuhanAnakController,
                        '0.8m',
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryRow(
                        'Remaja',
                        kebutuhanRemajaController,
                        '1.0m',
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryRow(
                        'Dewasa',
                        kebutuhanDewasaController,
                        '1.2m',
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryRow(
                        'Lansia',
                        kebutuhanLansiaController,
                        '1.3m',
                      ),
                      const SizedBox(height: 16),

                      // Biaya Jahit per Kategori
                      Text(
                        'Biaya Jahit per Kategori (Rp)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCategoryRow(
                        'Bayi',
                        biayaBayiController,
                        'Rp 25.000',
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryRow(
                        'Balita',
                        biayaBalitaController,
                        'Rp 35.000',
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryRow(
                        'Anak',
                        biayaAnakController,
                        'Rp 45.000',
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryRow(
                        'Remaja',
                        biayaRemajaController,
                        'Rp 55.000',
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryRow(
                        'Dewasa',
                        biayaDewasaController,
                        'Rp 60.000',
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryRow(
                        'Lansia',
                        biayaLansiaController,
                        'Rp 70.000',
                      ),
                    ],
                  ),
                ),
              ),
              // Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2A2A2A)
                      : Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final nama = namaController.text.trim();
                        final warna = warnaController.text.trim();
                        final harga =
                            int.tryParse(hargaController.text.trim()) ?? 0;
                        final deskripsi = deskripsiController.text.trim();
                        final kebutuhanMeter =
                            double.tryParse(
                              kebutuhanMeterController.text.trim(),
                            ) ??
                            1.0;
                        final biayaJahitDasar =
                            int.tryParse(biayaJahitController.text.trim()) ??
                            50000;

                        // Kumpulkan data kebutuhan kain per kategori
                        final kebutuhanKainPerKategori = {
                          'bayi':
                              double.tryParse(
                                kebutuhanBayiController.text.trim(),
                              ) ??
                              0.4,
                          'balita':
                              double.tryParse(
                                kebutuhanBalitaController.text.trim(),
                              ) ??
                              0.6,
                          'anak':
                              double.tryParse(
                                kebutuhanAnakController.text.trim(),
                              ) ??
                              0.8,
                          'remaja':
                              double.tryParse(
                                kebutuhanRemajaController.text.trim(),
                              ) ??
                              1.0,
                          'dewasa':
                              double.tryParse(
                                kebutuhanDewasaController.text.trim(),
                              ) ??
                              1.2,
                          'lansia':
                              double.tryParse(
                                kebutuhanLansiaController.text.trim(),
                              ) ??
                              1.3,
                        };

                        // Kumpulkan data biaya jahit per kategori
                        final biayaJahitPerKategori = {
                          'bayi':
                              int.tryParse(biayaBayiController.text.trim()) ??
                              25000,
                          'balita':
                              int.tryParse(biayaBalitaController.text.trim()) ??
                              35000,
                          'anak':
                              int.tryParse(biayaAnakController.text.trim()) ??
                              45000,
                          'remaja':
                              int.tryParse(biayaRemajaController.text.trim()) ??
                              55000,
                          'dewasa':
                              int.tryParse(biayaDewasaController.text.trim()) ??
                              60000,
                          'lansia':
                              int.tryParse(biayaLansiaController.text.trim()) ??
                              70000,
                        };

                        if (nama.isEmpty || warna.isEmpty || harga <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Mohon lengkapi data yang diperlukan',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        try {
                          if (kain == null) {
                            // Tambah
                            await _firestoreService.addKain(
                              KainModel(
                                id: '',
                                nama: nama,
                                warna: warna,
                                harga: harga,
                                deskripsi: deskripsi,
                                kebutuhanMeter: kebutuhanMeter,
                                biayaJahitDasar: biayaJahitDasar,
                                kebutuhanKainPerKategori:
                                    kebutuhanKainPerKategori,
                                biayaJahitPerKategori: biayaJahitPerKategori,
                              ),
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kain berhasil ditambahkan'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } else {
                            // Edit
                            await _firestoreService.updateKain(
                              kain.id,
                              KainModel(
                                id: kain.id,
                                nama: nama,
                                warna: warna,
                                harga: harga,
                                deskripsi: deskripsi,
                                kebutuhanMeter: kebutuhanMeter,
                                biayaJahitDasar: biayaJahitDasar,
                                kebutuhanKainPerKategori:
                                    kebutuhanKainPerKategori,
                                biayaJahitPerKategori: biayaJahitPerKategori,
                              ),
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kain berhasil diperbarui'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                          if (mounted) Navigator.pop(context);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(kain == null ? 'Tambah' : 'Simpan'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryRow(
    String label,
    TextEditingController controller,
    String helperText,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              helperText: helperText,
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(KainModel kain) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        title: Text(
          'Hapus Kain',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          'Yakin ingin menghapus kain "${kain.nama}"?',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firestoreService.deleteKain(kain.id);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kain berhasil dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error menghapus kain: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      appBar: AppBar(
        title: Text(
          'Model Kain',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () => _showKainDialog(),
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Kain',
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF8FBC8F),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<KainModel>>(
        stream: _firestoreService.getKainList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            );
          }
          final kainList = snapshot.data ?? [];
          if (kainList.isEmpty) {
            return Center(
              child: Text(
                'Belum ada data kain',
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: kainList.length,
            itemBuilder: (context, index) {
              final kain = kainList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                child: ListTile(
                  title: Text(
                    kain.nama,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Warna: ${kain.warna}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      Text(
                        'Harga: Rp ${kain.harga}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      Text(
                        'Kebutuhan: ${kain.kebutuhanMeter}m',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      Text(
                        'Biaya Jahit: Rp ${kain.biayaJahitDasar}',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _showKainDialog(kain: kain),
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () => _confirmDelete(kain),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
