import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/theme/dynamic_theme.dart';
import 'home_customer_screen.dart';

import 'status_pesanan_customer_screen.dart';
import 'riwayat_customer_screen.dart';
import 'desain_customer_screen.dart';
import 'package:jasa_jahit_aplication/src/page/login_screen.dart';
import 'ubah_password_customer_screen.dart';
import 'tentang_aplikasi_customer_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_switcher.dart';
import 'package:provider/provider.dart';
import 'package:jasa_jahit_aplication/src/theme/theme_provider.dart';
import 'package:jasa_jahit_aplication/Core/provider/auth_provider.dart'
    as app_auth;
import 'package:firebase_auth/firebase_auth.dart';

class ProfileCustomerScreen extends StatefulWidget {
  const ProfileCustomerScreen({super.key});

  @override
  State<ProfileCustomerScreen> createState() => _ProfileCustomerScreenState();
}

class _ProfileCustomerScreenState extends State<ProfileCustomerScreen> {
  File? _profileImage;
  String _name = '';
  String _username = '';
  String _position = 'Customer';
  String _address = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final authProvider = Provider.of<app_auth.AuthProvider>(
          context,
          listen: false,
        );
        final userData = await authProvider.getUserData(currentUser.uid);

        if (userData != null) {
          setState(() {
            _name = userData['name'] ?? '';
            _username = userData['username'] ?? '';
            _position = userData['position'] ?? 'Customer';
            _address = userData['address'] ?? '';
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFF8FBC8F),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1A1A1A)
          : const Color(0xFF8FBC8F),
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
                                        'assets/avatar_placeholder.png',
                                      )
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
                                  source: ImageSource.gallery,
                                );
                                if (picked != null) {
                                  setState(() {
                                    _profileImage = File(picked.path);
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF2A2A2A)
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDark
                                          ? Colors.black.withOpacity(0.3)
                                          : Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Color(0xFFDE8500),
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: isDark ? Colors.white : Colors.black,
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
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _ProfileInfoRow(label: 'Nama', value: _name),
                            const SizedBox(height: 8),
                            _ProfileInfoRow(
                              label: 'Username',
                              value: _username,
                            ),
                            const SizedBox(height: 8),
                            _ProfileInfoRow(label: 'Posisi', value: _position),
                            const SizedBox(height: 8),
                            _ProfileInfoRow(
                              label: 'Alamat',
                              value: _address.isEmpty
                                  ? 'Belum diisi'
                                  : _address,
                            ),
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
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () async {
                          await showDialog<Map<String, String>>(
                            context: context,
                            builder: (context) {
                              final addressCtrl = TextEditingController(
                                text: _address,
                              );
                              return AlertDialog(
                                backgroundColor: isDark
                                    ? const Color(0xFF2A2A2A)
                                    : Colors.white,
                                title: Text(
                                  'Edit Alamat',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: addressCtrl,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          labelText: 'Alamat',
                                          labelStyle: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.grey[600],
                                          ),
                                          filled: true,
                                          fillColor: isDark
                                              ? const Color(0xFF3A3A3A)
                                              : Colors.grey[100],
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Batal',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFDE8500),
                                    ),
                                    onPressed: () async {
                                      final newAddress = addressCtrl.text
                                          .trim();
                                      try {
                                        final currentUser =
                                            FirebaseAuth.instance.currentUser;
                                        if (currentUser != null) {
                                          final authProvider =
                                              Provider.of<
                                                app_auth.AuthProvider
                                              >(context, listen: false);
                                          await authProvider.updateUserData(
                                            currentUser.uid,
                                            {'address': newAddress},
                                          );

                                          setState(() {
                                            _address = newAddress;
                                          });

                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Alamat berhasil diperbarui!',
                                              ),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Gagal memperbarui alamat: ${e.toString()}',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Simpan'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        label: const Text(
                          'Edit Alamat',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                                  const UbahPasswordCustomerScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _ProfileMenuItem(
                        icon: Icons.info_outline,
                        label: 'Tentang Aplikasi',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TentangAplikasiCustomerScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _ThemeModeContainer(context),
                      const SizedBox(height: 16),
                      _ProfileMenuItem(
                        icon: Icons.logout,
                        label: 'Keluar',
                        onTap: () {
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
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Logout'),
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.of(
                                        context,
                                      ).pop(); // Close dialog
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                color: color ?? (isDark ? Colors.white70 : Colors.black54),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color ?? (isDark ? Colors.white : Colors.black87),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark ? Colors.white54 : Colors.black26,
              ),
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
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final themeProvider = Provider.of<ThemeProvider>(context);
  final mode = themeProvider.customerThemeMode; // Gunakan customerThemeMode
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
    margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    padding: const EdgeInsets.symmetric(horizontal: 0),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
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
          themeProvider.setCustomerTheme(selected); // Gunakan setCustomerTheme
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
