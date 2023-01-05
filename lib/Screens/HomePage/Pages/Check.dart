
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/Screens/HomePage/HomeScreen.dart';
import 'package:instagram/Screens/Login.dart';

class Check extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

   Check({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    if (_auth.currentUser != null) {
      return HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
