import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  bool get isLoggedIn => currentUser != null;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
