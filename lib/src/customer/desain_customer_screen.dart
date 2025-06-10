import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/customer/pesan_customer_screen.dart';
import 'ukuran_customer_screen.dart';
import 'home_customer_screen.dart';

class DesainCustomerScreen extends StatefulWidget {
  const DesainCustomerScreen({super.key});

  @override
  State<DesainCustomerScreen> createState() => _DesainCustomerScreenState();
}

class _DesainCustomerScreenState extends State<DesainCustomerScreen> {
  String? selectedModel;
  String? selectedKain;

  final List<String> modelList = ['Model A', 'Model B', 'Model C'];
  final List<String> kainList = ['Kain Katun', 'Kain Polyester', 'Kain Rayon'];

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
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
        appBar: AppBar(
          backgroundColor: const Color(0xFF8FBC8F),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeCustomerScreen()),
              );
            },
          ),
          title: const Text(
            'Desain Kaos custom',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Lengkapi Form Pemesanan',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              // Dropdown Model
              const Text('Model', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedModel,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.black, size: 32),
                    hint: const Text('Pilih Model'),
                    items: modelList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedModel = val),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 18),
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
                        builder: (context) => const UkuranCustomerScreen(),
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
