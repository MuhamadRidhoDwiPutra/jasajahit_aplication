// ignore: file_names
import 'package:flutter/material.dart';
import 'desain_customer_screen.dart';
import 'konfirmasi_desain_baju_customer_screen.dart';

class UkuranBajuCustomerScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const UkuranBajuCustomerScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FBC8F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DesainCustomerScreen()),
            );
          },
        ),
        title: const Text(
          'Ukuran Baju',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            // Card gambar detail
            Center(
              child: Container(
                width: 140,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Gambar\nBaju',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Form input ukuran
            _InputField(
                controller: lingkarDadaController, label: 'Lingkar Dada'),
            const SizedBox(height: 12),
            _InputField(controller: lebarBahuController, label: 'Lebar Bahu'),
            const SizedBox(height: 12),
            _InputField(
                controller: panjangBajuController, label: 'Panjang Baju'),
            const SizedBox(height: 12),
            _InputField(
                controller: panjangLenganController, label: 'Panjang Lengan'),
            const SizedBox(height: 12),
            _InputField(
                controller: lebarLenganController, label: 'Lebar Lengan'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const KonfirmasiDesainBajuCustomerScreen()),
                  );
                },
                child: const Text('Simpan Data',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const _InputField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
