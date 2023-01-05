import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/model/AddMeassgeUser.dart';
import 'package:instagram/model/Meassge.dart';
import 'package:instagram/model/MyPost.dart';
import 'package:instagram/model/MyReels.dart';
import 'package:instagram/model/MyStory.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/model/follower.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userIdKey = "userIdKey";

late SharedPreferences preferences;

class DatabaseService {
  String userId = '';
  // final String? uid;
  // DatabaseService({this.uid});

  getpref() async {
    preferences = await SharedPreferences.getInstance();
    userId = FirebaseAuth.instance.currentUser!.uid;
    log(userId);
  }

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');

  DatabaseService() {
    userId = FirebaseAuth.instance.currentUser!.uid;
  }
  Future userData(
    String email,
    String password,
    int posts,
    int followers,
    int following,
    String profile_pic,
    String bio,
    String website,
    bool verified,
    bool is_public,
  ) async {
    return await userCollection.doc(userId).set({
      'Email': email,
      'Password': password,
      'posts': posts,
      'followers': followers,
      'following': following,
      'profile_pic': profile_pic,
      'bio': bio,
      'website': website,
      'verified': verified,
      'is_public': is_public,
    });
  }
  // Future userPostData(
  //   DateTime date,
  //   String postUrl,
  //   String imageId,
  //   List likes,
  //   List comments,

  // ) async {
  //   return await userPostCollection.doc(uid).set({
  //     'date': date,
  //     'postUrl': postUrl,
  //     'imageId': imageId,
  //     'likes': likes,
  //     'comments': comments,

  //   });
  // }

  Stream<UserData> get User {
    return userCollection.doc(userId).snapshots().map((e) {
      UserData user = UserData.fromSnapShort(e);
      return user;
    });
  }

  Stream<UserData> userinfo(String uid) {
    return userCollection.doc(uid).snapshots().map((e) {
      UserData user = UserData.fromSnapShort(e);
      return user;
    });
  }

  //  Future<UserData> userinfos(String uid)async {
  //   final ma =  await userCollection.doc(uid).get();
  //   return  UserData.fromSnapShort(ma);
  // }
  Stream<List<MyPost>> get userPost {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('MyPosts')
        .orderBy("date")
        .snapshots()
        .map(post);

    // return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('MyPosts').snapshots().map(
    //     (event) => event.docs.map((e) => MyPost.fromSnapShort(e)).toList());
  }

  List<MyPost> post(QuerySnapshot data) {
    return data.docs.map((e) => MyPost.fromSnapShort(e)).toList();
  }

  Stream<List<MyPost>> alluserPost(uid) {
    return userCollection
        .doc(uid)
        .collection('MyPosts')
        .orderBy("date")
        .snapshots()
        .map(allPost);

    // return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('MyPosts').snapshots().map(
    //     (event) => event.docs.map((e) => MyPost.fromSnapShort(e)).toList());
  }

  List<MyPost> allPost(QuerySnapshot data) {
    return data.docs.map((e) => MyPost.fromSnapShort(e)).toList();
  }

  Stream<List<MyPost>> viewPost(String uid) {
    return userCollection
        .doc(uid)
        .collection('MyPosts')
        .orderBy("date")
        .snapshots()
        .map(viewpost);

    // return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('MyPosts').snapshots().map(
    //     (event) => event.docs.map((e) => MyPost.fromSnapShort(e)).toList());
  }

  List<MyPost> viewpost(QuerySnapshot data) {
    return data.docs.map((e) => MyPost.fromSnapShort(e)).toList();
  }

  Stream<List<MyStory>> get userStory {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('MyStory')
        .orderBy("date")
        .snapshots()
        .map(story);

    // return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('MyPosts').snapshots().map(
    //     (event) => event.docs.map((e) => MyPost.fromSnapShort(e)).toList());
  }

  List<MyStory> story(QuerySnapshot data) {
    return data.docs.map((e) => MyStory.fromSnapShort(e)).toList();
  }

  Stream<List<MyReels>> get userReels {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('MyReels')
        .orderBy("date")
        .snapshots()
        .map(reels);

    // return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('MyPosts').snapshots().map(
    //     (event) => event.docs.map((e) => MyPost.fromSnapShort(e)).toList());
  }

  List<MyReels> reels(QuerySnapshot data) {
    return data.docs.map((e) => MyReels.fromSnapShort(e)).toList();
  }

  Stream<List<AddMeassgeUser>> get usermessage {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('MyMessage')
        .snapshots()
        .map(message);

    // return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('MyPosts').snapshots().map(
    //     (event) => event.docs.map((e) => MyPost.fromSnapShort(e)).toList());
  }

  List<AddMeassgeUser> message(QuerySnapshot data) {
    return data.docs.map((e) => AddMeassgeUser.fromSnapShort(e)).toList();
  }

  Stream<List<UserData>> get userProfile {
    return userCollection.snapshots().map(profile);

    // return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('MyPosts').snapshots().map(
    //     (event) => event.docs.map((e) => MyPost.fromSnapShort(e)).toList());
  }

  List<UserData> profile(QuerySnapshot data) {
    return data.docs.map((e) => UserData.fromSnapShort(e)).toList();
  }

  Stream<UserData> meassgeUser(String uid) {
    return userCollection.doc(uid).snapshots().map((e) {
      UserData user = UserData.fromSnapShort(e);
      return user;
    });
  }

  Stream<List<Meassge>> userMeassge(String uid) {
    log(uid);
    return userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('MyMessage')
        .doc(uid)
        .collection("Message")
        .orderBy("date", descending: true)
        .snapshots()
        .map(meassge);

    // return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('MyPosts').snapshots().map(
    //     (event) => event.docs.map((e) => MyPost.fromSnapShort(e)).toList());
  }

  List<Meassge> meassge(QuerySnapshot data) {
    return data.docs.map((e) => Meassge.fromSnapShort(e)).toList();
  }

    Stream<List<FollowerClass>>userFollower (uid) {
    return userCollection
        .doc(uid)
        .collection('Follower')
        .snapshots()
        .map(follower);

    // return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection('MyPosts').snapshots().map(
    //     (event) => event.docs.map((e) => MyPost.fromSnapShort(e)).toList());
  }

  List<FollowerClass> follower(QuerySnapshot data) {
    return data.docs.map((e) => FollowerClass.fromSnapShort(e)).toList();
  }
}
