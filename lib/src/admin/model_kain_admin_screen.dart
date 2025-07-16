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
        text: kain?.harga != null ? kain!.harga.toString() : '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(kain == null ? 'Tambah Kain' : 'Edit Kain'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama Kain'),
            ),
            TextField(
              controller: warnaController,
              decoration: const InputDecoration(labelText: 'Warna'),
            ),
            TextField(
              controller: hargaController,
              decoration: const InputDecoration(labelText: 'Harga per meter'),
              keyboardType: TextInputType.number,
            ),
          ],
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
              if (nama.isEmpty || warna.isEmpty || harga <= 0) return;
              if (kain == null) {
                // Tambah
                await _firestoreService.addKain(
                    KainModel(id: '', nama: nama, warna: warna, harga: harga));
              } else {
                // Edit
                await _firestoreService.updateKain(
                    kain.id,
                    KainModel(
                        id: kain.id, nama: nama, warna: warna, harga: harga));
              }
              if (mounted) Navigator.pop(context);
            },
            child: Text(kain == null ? 'Tambah' : 'Simpan'),
          ),
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
                const Text('Data Jenis Kain',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _showKainDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
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
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 24,
                      headingRowHeight: 40,
                      dataRowHeight: 48,
                      columns: const [
                        DataColumn(
                            label: Center(
                                child: Text('No',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)))),
                        DataColumn(
                            label: Center(
                                child: Text('Nama Kain',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)))),
                        DataColumn(
                            label: Center(
                                child: Text('Warna',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)))),
                        DataColumn(
                            label: Center(
                                child: Text('Harga/meter',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)))),
                        DataColumn(
                            label: Center(
                                child: Text('Aksi',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)))),
                      ],
                      rows: List.generate(kainList.length, (index) {
                        final kain = kainList[index];
                        return DataRow(cells: [
                          DataCell(Center(child: Text('${index + 1}'))),
                          DataCell(Center(child: Text(kain.nama))),
                          DataCell(Center(child: Text(kain.warna))),
                          DataCell(Center(
                              child: Text('Rp ${kain.harga.toString()}'))),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _showKainDialog(kain: kain),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: const Size(40, 36),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                  ),
                                  child: const Text('Edit',
                                      style: TextStyle(fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _confirmDelete(kain),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize: const Size(40, 36),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                  ),
                                  child: const Text('Hapus',
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }),
                    ),
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
