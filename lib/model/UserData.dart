// ignore_for_file: non_constant_identifier_names, unused_label

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';


class UserData {
  String bio = "";
  String email = "";
  String name = "";
  String Phone = "";
  int followers=0;
  int post=0;
  int following=0;
  bool is_public=true;
  bool show_active_status=true;
  bool push_notification=true;
  String password = "";
  String profileUrl = "";
  bool verified = false;
  String website="";
  String uid="";
  late DateTime birthDate;
  String gender = "";
  String status = "";
  UserData.fromSnapShort(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map;
    // print(data.toString());
    Timestamp date = data['birth_date'];
    email = data['email'];
    bio = data['bio'];
    followers = data['followers'];
    following = data['following'];
    birthDate=date.toDate();
    gender = data['gender'];
    post = data['post'];
    is_public = data['is_public'];
    show_active_status = data['show_active_status'];
    push_notification = data['push_notification'];
    name = data['name'];
    Phone = data['phone'];
    password = data['password'];
    profileUrl = data['profile_pic'];
    verified = data['verified'];
    website = data['website'];
    status = data['status'];
    uid = snapshot.id;
  }
}
