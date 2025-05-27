import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  bool get isLoggedIn => currentUser != null;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
