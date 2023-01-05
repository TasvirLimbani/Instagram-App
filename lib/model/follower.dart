// ignore_for_file: non_constant_identifier_names, unused_label

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FollowerClass {
  // String message = "";
  String uid = "";
  FollowerClass.fromSnapShort(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map;
    uid = snapshot.id;
  }
}
