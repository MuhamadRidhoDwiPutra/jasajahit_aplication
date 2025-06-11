import 'package:flutter/material.dart';
import 'desain_customer_screen.dart';
import 'konfirmasi_desain_baju_customer_screen.dart';

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
          'Ukuran Celana',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
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
                      'Gambar\nDetail cara\nmengukur',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Dropdown Kain
              const Text('Kain', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedKain,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.black, size: 32),
                    hint: const Text('Pilih Kain'),
                    items: kainList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedKain = val),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _InputField(
                  controller: panjangCelanaController, label: 'Panjang celana'),
              const SizedBox(height: 12),
              _InputField(
                  controller: lingkarPinggangController,
                  label: 'lingkar pinggang'),
              const SizedBox(height: 12),
              _InputField(
                  controller: lingkarPinggulController,
                  label: 'lingkar pinggul'),
              const SizedBox(height: 12),
              _InputField(
                  controller: lingkarPesakController, label: 'lingkar pesak'),
              const SizedBox(height: 12),
              _InputField(
                  controller: lingkarPahaController, label: 'lingkar paha'),
              const SizedBox(height: 12),
              _InputField(
                  controller: lebarBawahCelanaController,
                  label: 'lebar bawah celana'),
              const SizedBox(height: 24),
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
                            const KonfirmasiDesainBajuCustomerScreen(),
                      ),
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
