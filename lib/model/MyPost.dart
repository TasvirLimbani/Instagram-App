// ignore_for_file: non_constant_identifier_names, unused_label

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyPost {
  String postUrl = "";
  String imageId = "";
  late DateTime date;
  List likes = [];
  List comments = [];
  String uid = "";
  MyPost.fromSnapShort(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map;
    // print(data.toString());
    Timestamp time = data['date'];
    postUrl = data['postUrl'];
    imageId = data['imageId'];
    date = time.toDate();
    likes = (data['likes'] as List).map((e) => e.toString()).toList();
    comments = (data['comments'] as List).map((e) => e.toString()).toList();
    uid = snapshot.id;
  }
}
