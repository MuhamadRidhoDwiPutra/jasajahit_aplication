import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireAuth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class AuthProvider extends ChangeNotifier {
  final form = GlobalKey<FormState>();

  var islogin = true;
  var enteredEmail = '';
  var enteredPassword = '';
  var enteredName = '';

  Future<void> submit() async {
    final isvalid = form.currentState != null
        ? form.currentState!.validate()
        : true;

    if (!isvalid) {
      return;
    }

    if (form.currentState != null) {
      form.currentState!.save();
    }

    try {
      if (islogin) {
        await _fireAuth.signInWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
      } else {
        // Create user account
        final userCredential = await _fireAuth.createUserWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );

        // Save user data to Firestore dengan data yang benar
        if (userCredential.user != null) {
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
                'name': enteredName, // Nama asli user
                'username':
                    enteredName, // Username menggunakan nama, bukan email
                'email': enteredEmail, // Email tersimpan terpisah
                'position': 'Customer',
                'address': 'Alamat belum diisi', // Default address
                'createdAt': FieldValue.serverTimestamp(),
                'updatedAt': FieldValue.serverTimestamp(),
              });
        }
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw Exception(e.message ?? 'Terjadi kesalahan autentikasi');
      } else {
        throw Exception('Terjadi kesalahan: $e');
      }
    }

    notifyListeners();
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user data: $e');
      throw Exception('Gagal mengupdate data user');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _fireAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw Exception(e.message ?? 'Gagal mengirim email reset password');
      } else {
        throw Exception('Terjadi kesalahan: $e');
      }
    }
  }

  Future<void> sendEmailVerification() async {
    final user = _fireAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  bool get isEmailVerified {
    final user = _fireAuth.currentUser;
    return user?.emailVerified ?? false;
  }
}
