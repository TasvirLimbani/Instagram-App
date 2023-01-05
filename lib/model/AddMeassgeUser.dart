// ignore_for_file: non_constant_identifier_names, unused_label

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddMeassgeUser {
  // String message = "";
  String uid = "";
  AddMeassgeUser.fromSnapShort(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map;
    // print(data.toString());
    // Timestamp time = data['date'];
    // message = data['message'];
    uid = snapshot.id;
  }
}
