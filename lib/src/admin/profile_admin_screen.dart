import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/page/login_screen.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';

class ProfileAdminScreen extends StatelessWidget {
  const ProfileAdminScreen({super.key});

  get context => null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        elevation: 1,
        title: Text(
          'Profil Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFDE8500)),
      ),
      body: Center(
        child: Card(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          elevation: 3,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ThemeModeContainer(context),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: isDark
                      ? const Color(0xFF8FBC8F).withOpacity(0.3)
                      : const Color(0xFF8FBC8F).withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 48,
                    color: Color(0xFF8FBC8F),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Admin Jahit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'admin@email.com',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey,
                  ),
                ),
                Divider(
                  height: 32,
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDE8500), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: isDark
                              ? const Color(0xFF2A2A2A)
                              : Colors.white,
                          title: Text(
                            'Konfirmasi Logout',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          content: Text(
                            'Apakah Anda yakin ingin keluar dari aplikasi?',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Logout'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFDE8500),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _ThemeModeContainer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mode = themeProvider.adminThemeMode; // Gunakan adminThemeMode
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
        color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, color: isDark ? Colors.white70 : Colors.grey[700]),
        title: Text(
          label,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? Colors.white70 : Colors.grey[600],
        ),
        onTap: () async {
          final selected = await showModalBottomSheet<ThemeMode>(
            context: context,
            backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            builder: (context) => _ThemeModePicker(selected: mode),
          );
          if (selected != null) {
            themeProvider.setAdminTheme(selected); // Gunakan setAdminTheme
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(
            Icons.wb_sunny_outlined,
            color: isDark ? Colors.white70 : Colors.grey[700],
          ),
          title: Text(
            'Mode Terang',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          selected: selected == ThemeMode.light,
          onTap: () => Navigator.pop(context, ThemeMode.light),
        ),
        ListTile(
          leading: Icon(
            Icons.nightlight_round,
            color: isDark ? Colors.white70 : Colors.grey[700],
          ),
          title: Text(
            'Mode Gelap',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          selected: selected == ThemeMode.dark,
          onTap: () => Navigator.pop(context, ThemeMode.dark),
        ),
        ListTile(
          leading: Icon(
            Icons.brightness_auto,
            color: isDark ? Colors.white70 : Colors.grey[700],
          ),
          title: Text(
            'Otomatis',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          selected: selected == ThemeMode.system,
          onTap: () => Navigator.pop(context, ThemeMode.system),
        ),
      ],
    );
  }
}
