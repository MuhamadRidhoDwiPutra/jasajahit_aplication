import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:jasa_jahit_aplication/src/model/order_model.dart';

class FirestoreService {
  final fs.FirebaseFirestore _db = fs.FirebaseFirestore.instance;

  Future<void> saveOrder(Order order) async {
    try {
      await _db.collection('orders').add(order.toMap());
    } catch (e) {
      print('Error saving order: $e');
      rethrow;
    }
  }
}
