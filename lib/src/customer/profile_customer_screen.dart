import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
// ignore: unused_import
import 'home_customer_screen.dart';
// ignore: unused_import
import 'pesan_customer_screen.dart';
// ignore: unused_import
import 'tracking_pesanan_customer_screen.dart';
// ignore: unused_import
import 'riwayat_customer_screen.dart';
// ignore: unused_import
import 'desain_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/page/login_screen.dart';

import 'ubah_password_customer_screen.dart';
import 'tentang_aplikasi_customer_screen.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';

class ProfileCustomerScreen extends StatefulWidget {
  const ProfileCustomerScreen({super.key});

  @override
  State<ProfileCustomerScreen> createState() => _ProfileCustomerScreenState();
}

class _ProfileCustomerScreenState extends State<ProfileCustomerScreen> {
  File? _profileImage;
  String _name = 'Ridho';
  String _nip = '199004252015021001';
  String _posisi = 'Customer';
  String _unit = 'Engineering';

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : const AssetImage(
                                        'assets/avatar_placeholder.png')
                                    as ImageProvider,
                            backgroundColor: Colors.grey,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                final picker = ImagePicker();
                                final picked = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (picked != null) {
                                  setState(() {
                                    _profileImage = File(picked.path);
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Color(0xFFDE8500), size: 22),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _ProfileInfoRow(label: 'Nama', value: _name),
                            const SizedBox(height: 8),
                            _ProfileInfoRow(label: 'NIP', value: _nip),
                            const SizedBox(height: 8),
                            _ProfileInfoRow(label: 'Posisi', value: _posisi),
                            const SizedBox(height: 8),
                            _ProfileInfoRow(label: 'Unit', value: _unit),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit, size: 18),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDE8500),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        onPressed: () async {
                          final result = await showDialog<Map<String, String>>(
                            context: context,
                            builder: (context) {
                              final nameCtrl =
                                  TextEditingController(text: _name);
                              final nipCtrl = TextEditingController(text: _nip);
                              final posisiCtrl =
                                  TextEditingController(text: _posisi);
                              final unitCtrl =
                                  TextEditingController(text: _unit);
                              return AlertDialog(
                                title: const Text('Edit Profil'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextField(
                                          controller: nameCtrl,
                                          decoration: const InputDecoration(
                                              labelText: 'Nama')),
                                      const SizedBox(height: 8),
                                      TextField(
                                          controller: nipCtrl,
                                          decoration: const InputDecoration(
                                              labelText: 'NIP')),
                                      const SizedBox(height: 8),
                                      TextField(
                                          controller: posisiCtrl,
                                          decoration: const InputDecoration(
                                              labelText: 'Posisi')),
                                      const SizedBox(height: 8),
                                      TextField(
                                          controller: unitCtrl,
                                          decoration: const InputDecoration(
                                              labelText: 'Unit')),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Batal')),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFDE8500)),
                                    onPressed: () {
                                      Navigator.pop(context, {
                                        'name': nameCtrl.text,
                                        'nip': nipCtrl.text,
                                        'posisi': posisiCtrl.text,
                                        'unit': unitCtrl.text,
                                      });
                                    },
                                    child: const Text('Simpan'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (result != null) {
                            setState(() {
                              _name = result['name'] ?? _name;
                              _nip = result['nip'] ?? _nip;
                              _posisi = result['no tlp'] ?? _posisi;
                              _unit = result['nama lain'] ?? _unit;
                            });
                          }
                        },
                        label: const Text('Edit Profil',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 24),
                      _ProfileMenuItem(
                        icon: Icons.lock_outline,
                        label: 'Ubah Password',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UbahPasswordCustomerScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _ProfileMenuItem(
                        icon: Icons.info_outline,
                        label: 'Tentang Aplikasi',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TentangAplikasiCustomerScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _ThemeModeContainer(context),
                      const SizedBox(height: 8),
                      _ProfileMenuItem(
                        icon: Icons.logout,
                        label: 'Keluar',
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(color: Colors.black54))),
        const SizedBox(width: 8),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500))),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _ProfileMenuItem(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color ?? Colors.black54),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color ?? Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _BottomNavIcon({
    required this.icon,
    required this.label,
    // ignore: unused_element_parameter
    this.onTap,
    // ignore: unused_element_parameter
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.green[700] : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.green[700] : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _ThemeModeContainer(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final mode = themeProvider.themeMode;
  IconData icon;
  String label;
  switch (mode) {
    case ThemeMode.light:
      icon = Icons.wb_sunny_outlined;
      label = 'Mode Terang';
      break;
    case ThemeMode.dark:
      icon = Icons.nightlight_round;
      label = 'Mode Gelap';
      break;
    default:
      icon = Icons.brightness_auto;
      label = 'Otomatis';
  }
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
    padding: const EdgeInsets.symmetric(horizontal: 0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final selected = await showModalBottomSheet<ThemeMode>(
          context: context,
          builder: (context) => _ThemeModePicker(selected: mode),
        );
        if (selected != null) {
          themeProvider.setTheme(selected);
        }
      },
    ),
  );
}

class _ThemeModePicker extends StatelessWidget {
  final ThemeMode selected;
  const _ThemeModePicker({required this.selected});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.wb_sunny_outlined),
          title: const Text('Mode Terang'),
          selected: selected == ThemeMode.light,
          onTap: () => Navigator.pop(context, ThemeMode.light),
        ),
        ListTile(
          leading: const Icon(Icons.nightlight_round),
          title: const Text('Mode Gelap'),
          selected: selected == ThemeMode.dark,
          onTap: () => Navigator.pop(context, ThemeMode.dark),
        ),
        ListTile(
          leading: const Icon(Icons.brightness_auto),
          title: const Text('Otomatis'),
          selected: selected == ThemeMode.system,
          onTap: () => Navigator.pop(context, ThemeMode.system),
        ),
      ],
    );
  }
}
