import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/page/login_screen.dart';
// ignore: unused_import
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';

class ProfileAdminScreen extends StatelessWidget {
  const ProfileAdminScreen({super.key});

  get context => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Profil Admin',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
      ),
      body: Center(
        child: Card(
          color: Colors.white,
          elevation: 3,
          margin: const EdgeInsets.all(24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ThemeModeContainer(context),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF8FBC8F).withOpacity(0.2),
                  child: const Icon(Icons.person,
                      size: 48, color: Color(0xFF8FBC8F)),
                ),
                const SizedBox(height: 16),
                const Text('Admin Jahit',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 8),
                const Text('admin@email.com',
                    style: TextStyle(color: Colors.grey)),
                const Divider(height: 32, color: Colors.black12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDE8500),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {/* aksi edit */},
                  child: const Text('Edit Profil',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDE8500), width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                  child: const Text('Logout',
                      style: TextStyle(
                          color: Color(0xFFDE8500),
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildProfileInfoRow({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
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
