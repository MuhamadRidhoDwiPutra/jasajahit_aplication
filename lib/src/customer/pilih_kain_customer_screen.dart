import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/model/kain_model.dart';
import 'package:jasa_jahit_aplication/src/services/firestore_service.dart';

class PilihKainCustomerScreen extends StatefulWidget {
  final Function(KainModel) onKainSelected;
  const PilihKainCustomerScreen({super.key, required this.onKainSelected});

  @override
  State<PilihKainCustomerScreen> createState() =>
      _PilihKainCustomerScreenState();
}

class _PilihKainCustomerScreenState extends State<PilihKainCustomerScreen> {
  KainModel? _selectedKain;
  final _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kain'),
      ),
      body: StreamBuilder<List<KainModel>>(
        stream: _firestoreService.getKainList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Terjadi kesalahan: \\${snapshot.error}'));
          }
          final kainList = snapshot.data ?? [];
          if (kainList.isEmpty) {
            return const Center(child: Text('Belum ada data kain.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: kainList.length,
            itemBuilder: (context, index) {
              final kain = kainList[index];
              final selected = kain.id == _selectedKain?.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedKain = kain;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.orange.shade900
                        : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(16),
                    border: selected
                        ? Border.all(color: Colors.orange, width: 2)
                        : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kain.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              kain.warna,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rp \\${kain.harga.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (m) => '\\${m[1]}.')}/meter',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        const Icon(Icons.check_circle,
                            color: Colors.orange, size: 32),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _selectedKain == null
                ? null
                : () {
                    widget.onKainSelected(_selectedKain!);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Lanjut',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
