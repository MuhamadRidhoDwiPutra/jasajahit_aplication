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
      builder: (context) => LayoutBuilder(
        builder: (context, constraints) {
          return AlertDialog(
            title: Text(kain == null ? 'Tambah Kain' : 'Edit Kain'),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth > 600
                      ? 400
                      : constraints.maxWidth * 0.9,
                  maxHeight: constraints.maxHeight * 0.7,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaController,
                      decoration: const InputDecoration(labelText: 'Nama Kain'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: warnaController,
                      decoration: const InputDecoration(labelText: 'Warna'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: hargaController,
                      decoration: const InputDecoration(
                        labelText: 'Harga per meter',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: deskripsiController,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        alignLabelWithHint: true,
                      ),
                      maxLines: constraints.maxWidth > 600 ? 4 : 3,
                      textInputAction: TextInputAction.newline,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: kebutuhanMeterController,
                      decoration: const InputDecoration(
                        labelText: 'Kebutuhan Kain (meter)',
                        helperText: 'Contoh: 1.5 untuk celana, 1.0 untuk kaos',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: biayaJahitController,
                      decoration: const InputDecoration(
                        labelText: 'Biaya Jahit Dasar (Rp)',
                        helperText: 'Biaya jahit untuk ukuran M',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Section untuk kebutuhan kain per kategori
                    const Text(
                      'Kebutuhan Kain per Kategori (meter)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: kebutuhanBayiController,
                            decoration: const InputDecoration(
                              labelText: 'Bayi',
                              helperText: '0.4m',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: kebutuhanBalitaController,
                            decoration: const InputDecoration(
                              labelText: 'Balita',
                              helperText: '0.6m',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: kebutuhanAnakController,
                            decoration: const InputDecoration(
                              labelText: 'Anak',
                              helperText: '0.8m',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: kebutuhanRemajaController,
                            decoration: const InputDecoration(
                              labelText: 'Remaja',
                              helperText: '1.0m',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: kebutuhanDewasaController,
                            decoration: const InputDecoration(
                              labelText: 'Dewasa',
                              helperText: '1.2m',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: kebutuhanLansiaController,
                            decoration: const InputDecoration(
                              labelText: 'Lansia',
                              helperText: '1.3m',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section untuk biaya jahit per kategori
                    const Text(
                      'Biaya Jahit per Kategori (Rp)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: biayaBayiController,
                            decoration: const InputDecoration(
                              labelText: 'Bayi',
                              helperText: 'Rp 25.000',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: biayaBalitaController,
                            decoration: const InputDecoration(
                              labelText: 'Balita',
                              helperText: 'Rp 35.000',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: biayaAnakController,
                            decoration: const InputDecoration(
                              labelText: 'Anak',
                              helperText: 'Rp 45.000',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: biayaRemajaController,
                            decoration: const InputDecoration(
                              labelText: 'Remaja',
                              helperText: 'Rp 55.000',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: biayaDewasaController,
                            decoration: const InputDecoration(
                              labelText: 'Dewasa',
                              helperText: 'Rp 60.000',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: biayaLansiaController,
                            decoration: const InputDecoration(
                              labelText: 'Lansia',
                              helperText: 'Rp 70.000',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nama = namaController.text.trim();
                  final warna = warnaController.text.trim();
                  final harga = int.tryParse(hargaController.text.trim()) ?? 0;
                  final deskripsi = deskripsiController.text.trim();
                  final kebutuhanMeter =
                      double.tryParse(kebutuhanMeterController.text.trim()) ??
                      1.0;
                  final biayaJahitDasar =
                      int.tryParse(biayaJahitController.text.trim()) ?? 50000;

                  // Kumpulkan data kebutuhan kain per kategori
                  final kebutuhanKainPerKategori = {
                    'bayi':
                        double.tryParse(kebutuhanBayiController.text.trim()) ??
                        0.4,
                    'balita':
                        double.tryParse(
                          kebutuhanBalitaController.text.trim(),
                        ) ??
                        0.6,
                    'anak':
                        double.tryParse(kebutuhanAnakController.text.trim()) ??
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
                        int.tryParse(biayaBayiController.text.trim()) ?? 25000,
                    'balita':
                        int.tryParse(biayaBalitaController.text.trim()) ??
                        35000,
                    'anak':
                        int.tryParse(biayaAnakController.text.trim()) ?? 45000,
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

                  if (nama.isEmpty || warna.isEmpty || harga <= 0) return;

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
                        kebutuhanKainPerKategori: kebutuhanKainPerKategori,
                        biayaJahitPerKategori: biayaJahitPerKategori,
                      ),
                    );
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
                        kebutuhanKainPerKategori: kebutuhanKainPerKategori,
                        biayaJahitPerKategori: biayaJahitPerKategori,
                      ),
                    );
                  }
                  if (mounted) Navigator.pop(context);
                },
                child: Text(kain == null ? 'Tambah' : 'Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  void _confirmDelete(KainModel kain) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kain'),
        content: Text('Yakin ingin menghapus kain "${kain.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firestoreService.deleteKain(kain.id);
              if (mounted) Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Model Kain Admin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Data Jenis Kain',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _showKainDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<KainModel>>(
                stream: _firestoreService.getKainList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final kainList = snapshot.data ?? [];
                  if (kainList.isEmpty) {
                    return const Center(child: Text('Belum ada data kain.'));
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Jika layar lebar (desktop/tablet), gunakan DataTable
                      if (constraints.maxWidth > 800) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 24,
                            headingRowHeight: 40,
                            dataRowHeight: 48,
                            columns: const [
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Nama Kain',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Warna',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Harga/meter',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Kebutuhan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Biaya Jahit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Aksi',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: List.generate(kainList.length, (index) {
                              final kain = kainList[index];
                              return DataRow(
                                cells: [
                                  DataCell(Center(child: Text('${index + 1}'))),
                                  DataCell(Center(child: Text(kain.nama))),
                                  DataCell(Center(child: Text(kain.warna))),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        'Rp ${kain.harga.toString()}',
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        '${kain.kebutuhanMeter.toStringAsFixed(1)}m',
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        'Rp ${kain.biayaJahitDasar.toString()}',
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () =>
                                              _showKainDialog(kain: kain),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            minimumSize: const Size(40, 36),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                          ),
                                          child: const Text(
                                            'Edit',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () => _confirmDelete(kain),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            minimumSize: const Size(40, 36),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                          ),
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        );
                      } else {
                        // Jika layar kecil (mobile), gunakan ListView
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: kainList.length,
                          itemBuilder: (context, index) {
                            final kain = kainList[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${index + 1}. ${kain.nama}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () =>
                                                  _showKainDialog(kain: kain),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                minimumSize: const Size(50, 36),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                              ),
                                              child: const Text(
                                                'Edit',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  _confirmDelete(kain),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                minimumSize: const Size(50, 36),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                              ),
                                              child: const Text(
                                                'Hapus',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow('Warna', kain.warna),
                                    _buildInfoRow(
                                      'Harga',
                                      'Rp ${kain.harga.toString()}/meter',
                                    ),
                                    _buildInfoRow(
                                      'Kebutuhan',
                                      '${kain.kebutuhanMeter.toStringAsFixed(1)} meter',
                                    ),
                                    _buildInfoRow(
                                      'Biaya Jahit',
                                      'Rp ${kain.biayaJahitDasar.toString()}',
                                    ),
                                    _buildInfoRow('Deskripsi', kain.deskripsi),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
