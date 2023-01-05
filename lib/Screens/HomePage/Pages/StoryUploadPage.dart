import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/model/MyStory.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:uuid/uuid.dart';

class StoryUploadPage extends StatefulWidget {
  const StoryUploadPage({Key? key}) : super(key: key);

  @override
  State<StoryUploadPage> createState() => _StoryUploadPageState();
}

class _StoryUploadPageState extends State<StoryUploadPage> {
  final TextUtils _textUtils = TextUtils();
  File? imageFile;
  bool postUpload = false;
  DateTime dateTime = DateTime.now();
  int selectindex = 0;

  Future getImageGallery() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
        Navigator.of(context).pop();
        setState(() {
          postUpload = true;
        });
      }
    });
  }

  Future getImageCamera() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
        Navigator.of(context).pop();
        setState(() {
          postUpload = true;
        });
      }
    });
  }

  Future uploadImage() async {
    String filename = const Uuid().v1();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    int status = 1;
    var ref =
        FirebaseStorage.instance.ref().child(userId).child("$filename.jpg");
    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      setState(() {
        postUpload = false;
      });
      status = 0;
    });
    if (status == 1) {
      String ImageUrl = await uploadTask.ref.getDownloadURL();
      FirebaseQuery.firebaseQuery.addstory({
        "date": dateTime,
        "storyId": ImageUrl.split("-").last,
        "storyUrl": ImageUrl,
        "likes": [],
        "Viwes": [],
      });

      // Timer(Duration(hours: 24), () {
      //   StreamBuilder<List<MyStory>>(
      //     stream: DatabaseService().userStory,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         final data = snapshot.data;
      //         FirebaseQuery.firebaseQuery.deleteStory(data![0].uid);
      //       }
      //       return Container();
      //     },
      //   );
      // });
    }
  }

  @override
  void initState() {
    DatabaseService().User;
    DatabaseService().userPost;
    DatabaseService().userProfile;
    DatabaseService().userReels;
    DatabaseService().userStory;
    DatabaseService().usermessage;
    // TODO: implement initState
    selectindex == 0 ? getImageCamera() : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // body: Stack(
      //   children: [
      //     if(selectindex==0)
      //     if(selectindex==1) getImageGallery(),
      //     // if(selectindex==2) getImageCamera(),
      //   ],
      // ),
      bottomNavigationBar: Container(
        color: Colors.black12,
        child: CarouselSlider(
            items: ["Camera", "Video", "Live", "", ""].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      // decoration: BoxDecoration(
                      //   color: Colors.amber
                      // ),
                      child: Center(child: _textUtils.bold16(i, Colors.white)));
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 50,
              // aspectRatio: 16 / 9,
              viewportFraction: 0.3,

              initialPage: 0,
              // enableInfiniteScroll: true,
              // reverse: false,
              // autoPlay: true,
              // autoPlayInterval: Duration(seconds: 3),
              // autoPlayAnimationDuration: Duration(milliseconds: 800),
              // autoPlayCurve: Curves.fastOutSlowIn,
              // enlargeCenterPage: true,
              onPageChanged: (index, _) {
                setState(() {
                  selectindex = index;
                  selectindex == 0
                      ? getImageCamera()
                      : selectindex == 1
                          ? getImageGallery()
                          : null;
                });
              },
              scrollDirection: Axis.horizontal,
            )),
      ),
    );
  }
}

// List<Widget> items = [
//   TextUtils().bold14("Camera", Colors.white),
//   TextUtils().bold14("Video", Colors.white),
//   TextUtils().bold14("Live", Colors.white),
// ];
