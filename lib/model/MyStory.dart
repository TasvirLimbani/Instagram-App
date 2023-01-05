// ignore_for_file: non_constant_identifier_names, unused_label

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyStory {
  String storyUrl = "";
  String storyId = "";
  late DateTime date;
  List likes = [];
  List views = [];
  String uid = "";
  MyStory.fromSnapShort(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map;
    // print(data.toString());
    Timestamp time = data['date'];
    storyUrl = data['storyUrl'];
    storyId = data['storyId'];
    date = time.toDate();
    likes = (data['likes'] as List).map((e) => e.toString()).toList();
    views = (data['Viwes'] as List).map((e) => e.toString()).toList();
    uid = snapshot.id;
  }
}
