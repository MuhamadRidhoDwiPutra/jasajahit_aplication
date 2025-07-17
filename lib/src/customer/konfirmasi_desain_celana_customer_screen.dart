import 'package:flutter/material.dart';
import 'package:jasa_jahit_aplication/src/model/order_model.dart';
import 'package:jasa_jahit_aplication/src/customer/konfirmasi_desain_baju_customer_screen.dart';

class KonfirmasiDesainCelanaCustomerScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final List<Map<String, dynamic>> items;
  final String status;
  final bool isDark;

  const KonfirmasiDesainCelanaCustomerScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.items,
    this.status = 'Menunggu Konfirmasi',
    this.isDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KonfirmasiPesananCustomerScreen(
      userId: userId,
      userName: userName,
      items: items,
      status: status,
      isDark: isDark,
    );
  }
}
