// ignore_for_file: non_constant_identifier_names, unused_label

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyReels {
  String reelUrl = "";
  String reelId = "";
  late DateTime date;
  List likes = [];
  List comments = [];
  List views = [];
  String uid = "";
  MyReels.fromSnapShort(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map;
    // print(data.toString());
    Timestamp time = data['date'];
    reelUrl = data['reelUrl'];
    reelId = data['reelId'];
    views = (data['views'] as List).map((e) => e.toString()).toList();
    date = time.toDate();
    likes = (data['likes'] as List).map((e) => e.toString()).toList();
    comments = (data['comments'] as List).map((e) => e.toString()).toList();
    uid = snapshot.id;
  }
}
