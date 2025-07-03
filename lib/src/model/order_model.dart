import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String? id;
  final String userId;
  final String userName;
  final String orderType;
  final Map<String, dynamic> measurements;
  final String fabric;
  final String model;
  final double price;
  final String status;
  final Timestamp orderDate;

  Order({
    this.id,
    required this.userId,
    required this.userName,
    required this.orderType,
    required this.measurements,
    this.fabric = 'Katun',
    this.model = 'Model 1',
    this.price = 150000,
    this.status = 'Menunggu Konfirmasi',
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'orderType': orderType,
      'measurements': measurements,
      'fabric': fabric,
      'model': model,
      'price': price,
      'status': status,
      'orderDate': orderDate,
    };
  }
}
 