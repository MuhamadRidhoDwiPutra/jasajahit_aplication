import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _fireAuth = FirebaseAuth.instance;

class AuthProvider extends ChangeNotifier {
  final form = GlobalKey<FormState>();

  var islogin = true;
  var enteredEmail = '';
  var enteredPassword = '';

  Future<void> submit() async {
    final isvalid =
        form.currentState != null ? form.currentState!.validate() : true;

    if (!isvalid) {
      return;
    }

    if (form.currentState != null) {
      form.currentState!.save();
    }

    try {
      if (islogin) {
        await _fireAuth.signInWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
      } else {
        await _fireAuth.createUserWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
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
