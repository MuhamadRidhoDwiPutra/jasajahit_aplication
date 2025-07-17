import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:jasa_jahit_aplication/src/model/order_model.dart';
import 'package:jasa_jahit_aplication/src/model/kain_model.dart';

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

  Stream<List<Order>> getOrdersByUserId(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              try {
                final data = doc.data();
                return Order.fromMap(data, doc.id);
              } catch (e) {
                print('Error mapping order: $e');
                return null;
              }
            })
            .whereType<Order>()
            .toList());
  }

  // Stream all orders for admin dashboard
  Stream<List<Order>> getAllOrders() {
    return _db
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              try {
                final data = doc.data();
                return Order.fromMap(data, doc.id);
              } catch (e) {
                print('Error mapping order: $e');
                return null;
              }
            })
            .whereType<Order>()
            .toList());
  }

  Stream<List<KainModel>> getKainList() {
    return _db.collection('kain').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => KainModel.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<void> addKain(KainModel kain) async {
    await _db.collection('kain').add(kain.toMap());
  }

  Future<void> updateKain(String id, KainModel kain) async {
    await _db.collection('kain').doc(id).update(kain.toMap());
  }

  Future<void> deleteKain(String id) async {
    await _db.collection('kain').doc(id).delete();
  }
}
