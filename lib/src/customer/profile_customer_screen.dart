import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/page/login_screen.dart';

class ProfileCustomerScreen extends StatelessWidget {
  const ProfileCustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FBC8F),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Icon profile
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_circle,
                    size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            // Form Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        _ProfileField(label: 'Nama'),
                        const SizedBox(height: 12),
                        _ProfileField(label: 'Username'),
                        const SizedBox(height: 12),
                        _ProfileField(label: 'No. telepon'),
                        const SizedBox(height: 12),
                        _ProfileField(label: 'Email'),
                        const SizedBox(height: 12),
                        _ProfileField(label: 'Alamat'),
                        const SizedBox(height: 60), // Space for logout button
                      ],
                    ),
                    // Logout button kanan bawah
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.orange[700],
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _BottomNavIcon(icon: Icons.home, label: 'Icon menu beranda'),
            _BottomNavIcon(icon: Icons.message, label: 'Icon menu Pesan'),
            _BottomNavIcon(
                icon: Icons.local_shipping, label: 'Icon pelacak pesanan'),
            _BottomNavIcon(icon: Icons.history, label: 'Icon menu riwayat'),
            _BottomNavIcon(icon: Icons.person, label: 'Icon menu profile'),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  const _ProfileField({required this.label});

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

class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BottomNavIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      ],
    );
  }
}
