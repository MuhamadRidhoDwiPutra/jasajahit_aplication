import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String? id;
  final String userId;
  final String userName;
  final List<Map<String, dynamic>> items; // Multi-item support
  final String status;
  final Timestamp orderDate;

  Order({
    this.id,
    required this.userId,
    required this.userName,
    required this.items,
    this.status = 'Menunggu Konfirmasi',
    required this.orderDate, required orderType, required measurements, required fabric, required model, required price,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'items': items,
      'status': status,
      'orderDate': orderDate,
    };
  }

  factory Order.fromMap(Map<String, dynamic> data, String id) {
    return Order(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      items: (data['items'] as List?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
      status: data['status'] ?? 'Menunggu Konfirmasi',
      orderDate: data['orderDate'] ?? Timestamp.now(), orderType: null, measurements: null, fabric: null, model: null, price: null,
    );
  }

  get model => null;

  get fabric => null;

  get measurements => null;

  get price => null;

  get orderType => null;
}
