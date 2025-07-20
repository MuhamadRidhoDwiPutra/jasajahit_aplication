import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:jasa_jahit_aplication/src/model/order_model.dart'
    as order_model;
import 'package:jasa_jahit_aplication/src/model/kain_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirestoreService {
  final fs.FirebaseFirestore _db = fs.FirebaseFirestore.instance;

  Future<fs.DocumentReference> saveOrder(order_model.Order order) async {
    try {
      final docRef = await _db.collection('orders').add(order.toMap());
      return docRef;
    } catch (e) {
      print('Error saving order: $e');
      rethrow;
    }
  }

  Stream<List<order_model.Order>> getOrdersByUserId(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) {
                try {
                  final data = doc.data();
                  return order_model.Order.fromMap(data, doc.id);
                } catch (e) {
                  print('Error mapping order: $e');
                  return null;
                }
              })
              .whereType<order_model.Order>()
              .toList(),
        );
  }

  // Stream all orders for admin dashboard
  Stream<List<order_model.Order>> getAllOrders() {
    return _db
        .collection('orders')
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) {
                try {
                  final data = doc.data();
                  return order_model.Order.fromMap(data, doc.id);
                } catch (e) {
                  print('Error mapping order: $e');
                  return null;
                }
              })
              .whereType<order_model.Order>()
              .toList(),
        );
  }

  Stream<List<KainModel>> getKainList() {
    return _db
        .collection('kain')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => KainModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
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

  // Upload bukti pembayaran ke Firebase Storage
  Future<String> uploadPaymentProof(File file, String orderId) async {
    try {
      // Validasi file exists dan readable
      if (!await file.exists()) {
        throw Exception('File tidak ditemukan');
      }

      final storage = FirebaseStorage.instance;
      final fileName =
          'payment_proof_${orderId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = storage.ref().child('payment_proofs/$fileName');

      // Upload dengan metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'orderId': orderId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      final uploadTask = ref.putFile(file, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('Payment proof uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading payment proof: $e');
      throw Exception('Gagal upload bukti pembayaran: ${e.toString()}');
    }
  }

  // Update order dengan bukti pembayaran
  Future<void> updateOrderWithPaymentProof(
    String orderId,
    String paymentProofUrl,
    String fileName,
  ) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'paymentProofUrl': paymentProofUrl,
        'paymentProofFileName': fileName,
      });
    } catch (e) {
      print('Error updating order with payment proof: $e');
      rethrow;
    }
  }
}
