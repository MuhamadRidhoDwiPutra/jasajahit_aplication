import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String? id;
  final String userId;
  final String userName;
  final List<Map<String, dynamic>> items; // Multi-item support
  final String status;
  final Timestamp orderDate;
  final double? totalPrice; // Total price for all items
  final String? paymentProofUrl; // URL bukti pembayaran
  final String? paymentProofFileName; // Nama file bukti pembayaran

  Order({
    this.id,
    required this.userId,
    required this.userName,
    required this.items,
    this.status = 'Menunggu Konfirmasi',
    required this.orderDate,
    this.totalPrice,
    this.paymentProofUrl,
    this.paymentProofFileName,
    required orderType,
    required measurements,
    required fabric,
    required model,
    required double price,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'items': items,
      'status': status,
      'orderDate': orderDate,
      'totalPrice': totalPrice,
      'paymentProofUrl': paymentProofUrl,
      'paymentProofFileName': paymentProofFileName,
    };
  }

  factory Order.fromMap(Map<String, dynamic> data, String id) {
    return Order(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      items:
          (data['items'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
      status: data['status'] ?? 'Menunggu Konfirmasi',
      orderDate: data['orderDate'] ?? Timestamp.now(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      paymentProofUrl: data['paymentProofUrl'],
      paymentProofFileName: data['paymentProofFileName'],
      orderType: null,
      measurements: null,
      fabric: null,
      model: null,
      price: (data['totalPrice'] ?? 0).toDouble(),
    );
  }

  // Getter untuk backward compatibility
  get model => items.isNotEmpty ? items.first['model'] : null;
  get fabric => items.isNotEmpty ? items.first['fabric'] : null;
  get measurements => items.isNotEmpty ? items.first['measurements'] : null;
  get price => totalPrice ?? 0.0;
  get orderType => items.isNotEmpty ? items.first['orderType'] : null;
}
