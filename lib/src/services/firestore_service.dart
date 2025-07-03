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
                return Order(
                  id: doc.id,
                  userId: data['userId']?.toString() ?? '',
                  userName: data['userName']?.toString() ?? '-',
                  orderType: data['orderType']?.toString() ?? '-',
                  measurements: data['measurements'] is Map<String, dynamic>
                      ? Map<String, dynamic>.from(data['measurements'])
                      : <String, dynamic>{},
                  fabric: data['fabric']?.toString() ?? '-',
                  model: data['model']?.toString() ?? '-',
                  price: (data['price'] is int)
                      ? (data['price'] as int).toDouble()
                      : (data['price'] is double)
                          ? data['price']
                          : 0.0,
                  status: data['status']?.toString() ?? '-',
                  orderDate: data['orderDate'] ?? fs.Timestamp.now(),
                );
              } catch (e) {
                print('Error mapping order: $e');
                return null;
              }
            })
            .whereType<Order>()
            .toList());
  }
}
