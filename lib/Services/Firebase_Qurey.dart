import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram/Services/Firebase.dart';

class FirebaseQuery {
  FirebaseQuery._();
  static final FirebaseQuery firebaseQuery = FirebaseQuery._();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();
String userId = FirebaseAuth.instance.currentUser!.uid;

//User
  Future<void> insertuser(String userId, Map<String, dynamic> data) async {
    firebaseFirestore.collection('User').doc(userId).set(data);
  }
  Future<void> updateUser( Map<String, dynamic> data) async {
    firebaseFirestore.collection('User').doc(userId).update(data);
  }


// Post
  Future<void> addpost(Map<String, dynamic> data) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('MyPosts')
        .add(data);
  }
  Future<void> updatePost(String uid,Map<String, dynamic> data) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('MyPosts')
        .doc(uid).update(data);
  }
  Future<void> deletePost(String uid,) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('MyPosts')
        .doc(uid).delete();
  }


  // Story 
    Future<void> addstory(Map<String, dynamic> data) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('MyStory')
        .add(data);
  }
    Future<void> deleteStory(String uid) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('MyStory')
        .doc(uid).delete();
  }


  // Reels
    Future<void> addreels(Map<String, dynamic> data) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('MyReels')
        .add(data);
  }

  // status
    Future<void> updateStatus(Map<String, dynamic> data) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .update(data);
  }

  //message
     Future<void> addmeassge({required String uid,required Map<String, dynamic> data}) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('MyMessage').doc(uid).set(data);
  }
   Future<void> sendMeassge({required String uid,required Map<String, dynamic> data}) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('MyMessage').doc(uid)
        .collection("Message").add(data);
  }
   Future<void> usersendMeassge({required String userid,required String uid,required Map<String, dynamic> data}) async {
    firebaseFirestore
        .collection('User')
        .doc(userid)
        .collection('MyMessage').doc(uid)
        .collection("Message").add(data);
  }
   Future<void> updateMeassge({required String uid,required String meaasgeuid,required Map<String, dynamic> data}) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('MyMessage').doc(uid)
        .collection("Message").doc(meaasgeuid).update(data);
  }

  // follower
  Future<void> follower(String uid,Map<String, dynamic> data) async {
    firebaseFirestore
        .collection('User')
        .doc(uid)
        .collection('Follower')
        .doc(userId).set(data);
  }
  Future<void> deletefollower(String uid,Map<String, dynamic> data) async {
    firebaseFirestore
        .collection('User')
        .doc(uid)
        .collection('Follower')
        .doc(userId).delete();
  }

  //following
  Future<void> following(String uid,Map<String, dynamic> data) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('Following')
        .doc(uid).set(data);
  }

  Future<void> deletefollowing(String uid,Map<String, dynamic> data) async {
    firebaseFirestore
        .collection('User')
        .doc(userId)
        .collection('Following')
        .doc(uid).delete();
  }

  //otheruserupdate
   Future<void> secondUserUpdate(String uid,Map<String, dynamic> data) async {
    firebaseFirestore
        .collection('User')
        .doc(uid)
       .update(data);
  }
}
