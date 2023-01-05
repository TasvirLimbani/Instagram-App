// ignore_for_file: non_constant_identifier_names, unused_label

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Meassge {
  String meassge = "";
  String sender = "";
  String type = "";
  late DateTime date;
  bool like =false;
  // List comments = [];
  String uid = "";
  Meassge.fromSnapShort(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map;
    // print(data.toString());
    Timestamp time = data['date'];
    meassge = data['meassge'];
    sender = data['sender'];
    date = time.toDate();
    like =data['like'];
    type =data['type'];
    // comments = (data['comments'] as List).map((e) => e.toString()).toList();
    uid = snapshot.id;
  }
}
