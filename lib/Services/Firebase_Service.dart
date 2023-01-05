// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseHelper {
  FirebaseHelper._();
  static final FirebaseHelper Auth = FirebaseHelper._();

  Future<User?> RagisterwithEmailandPassword(
      {required String email, required String password}) async {
    FirebaseAuth.instance.authStateChanges();

    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: "$email@gmail.com", password: password);
    return userCredential.user;
  }

  Future<User?> LoginwithEmailandPassword(
      {required String email, required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: "$email@gmail.com", password: password);
    return userCredential.user;
  }

  Future<void> logout() async {
  try {
    await FirebaseAuth.instance.signOut();
    FirebaseAuth.instance.userChanges();
  } catch (e) {
    print(e.toString());
  }
}
}
