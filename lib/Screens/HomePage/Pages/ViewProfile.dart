// ignore_for_file: iterable_contains_unrelated_type

import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Components/Toast.dart';
import 'package:instagram/Screens/HomePage/Pages/EditProfile.dart';
import 'package:instagram/Screens/HomePage/Pages/PersnolPhoto.dart';
import 'package:instagram/Screens/HomePage/Pages/ShowReel.dart';
import 'package:instagram/Screens/HomePage/Pages/StoryUploadPage.dart';
import 'package:instagram/Screens/HomePage/Pages/StoryViewPage.dart';
import 'package:instagram/Screens/Login.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/model/MyPost.dart';
import 'package:instagram/model/MyReels.dart';
import 'package:instagram/model/MyStory.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/model/follower.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ViewProfile extends StatefulWidget {
  String? uid;
  ViewProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile>
    with SingleTickerProviderStateMixin {
  final TextUtils _textUtils = TextUtils();

  late TabController tabController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    DatabaseService().User;
    DatabaseService().userPost;
    DatabaseService().userProfile;
    DatabaseService().userReels;
    DatabaseService().userStory;
    DatabaseService().usermessage;
    DatabaseService().viewPost(widget.uid.toString());
    super.initState();
    // loaddata();
    tabController = TabController(length: 3, vsync: this);
  }

  // File? imageFile;
  // bool postUpload = false;
  // DateTime dateTime = DateTime.now();
  // Future getImageGallery() async {
  //   ImagePicker _picker = ImagePicker();
  //   await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
  //     if (xFile != null) {
  //       imageFile = File(xFile.path);
  //       uploadImage();
  //       Navigator.of(context).pop();
  //       setState(() {
  //         postUpload = true;
  //       });
  //     }
  //   });
  // }

  // Future getImageCamera() async {
  //   ImagePicker _picker = ImagePicker();
  //   await _picker.pickImage(source: ImageSource.camera).then((xFile) {
  //     if (xFile != null) {
  //       imageFile = File(xFile.path);
  //       uploadImage();
  //       Navigator.of(context).pop();
  //       setState(() {
  //         postUpload = true;
  //       });
  //     }
  //   });
  // }

  // Future uploadImage() async {
  //   String filename = const Uuid().v1();
  //   String userId = FirebaseAuth.instance.currentUser!.uid;
  //   int status = 1;
  //   var ref =
  //       FirebaseStorage.instance.ref().child(userId).child("$filename.jpg");
  //   var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
  //     setState(() {
  //       postUpload = false;
  //     });
  //     status = 0;
  //   });
  //   if (status == 1) {
  //     String ImageUrl = await uploadTask.ref.getDownloadURL();
  //     FirebaseQuery.firebaseQuery.addpost({
  //       "date": dateTime,
  //       "imageId": ImageUrl.split("-").last,
  //       "postUrl": ImageUrl,
  //       "likes": [],
  //       "comments": [],
  //     });
  //     FirebaseQuery.firebaseQuery.updateUser({
  //       "post": post! + 1,
  //     });

  //     log(ImageUrl);
  //     setState(() {
  //       postUpload = false;
  //     });
  //   }
  // }

  // Future getReelsGallery() async {
  //   ImagePicker _picker = ImagePicker();
  //   await _picker.pickVideo(source: ImageSource.gallery).then((xFile) {
  //     if (xFile != null) {
  //       imageFile = File(xFile.path);
  //       uploadReels();
  //       Navigator.of(context).pop();
  //       setState(() {
  //         postUpload = true;
  //       });
  //     }
  //   });
  // }

  // Future getReelsCamera() async {
  //   ImagePicker _picker = ImagePicker();
  //   await _picker.pickVideo(source: ImageSource.camera).then((xFile) {
  //     if (xFile != null) {
  //       imageFile = File(xFile.path);
  //       uploadReels();
  //       Navigator.of(context).pop();
  //       setState(() {
  //         postUpload = true;
  //       });
  //     }
  //   });
  // }

  // Future uploadReels() async {
  //   String filename = const Uuid().v1();
  //   String userId = FirebaseAuth.instance.currentUser!.uid;
  //   int status = 1;
  //   var ref =
  //       FirebaseStorage.instance.ref().child(userId).child("$filename.jpg");
  //   var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
  //     setState(() {
  //       postUpload = false;
  //     });
  //     status = 0;
  //   });
  //   if (status == 1) {
  //     String ImageUrl = await uploadTask.ref.getDownloadURL();
  //     FirebaseQuery.firebaseQuery.addreels({
  //       "date": dateTime,
  //       "reelId": ImageUrl.split("-").last,
  //       "reelUrl": ImageUrl,
  //       "likes": [],
  //       "views": [],
  //       "comments": [],
  //     });
  //     // FirebaseQuery.firebaseQuery.updateUser({
  //     //   "post": post! + 1,
  //     // });

  //     log(ImageUrl);
  //     setState(() {
  //       postUpload = false;
  //     });
  //   }
  // }

  // bool loading = true;
  // loaddata() {
  //   setState(() {
  //     loading = true;
  //   });
  //   DatabaseService().User;
  //   DatabaseService().userPost;
  //   DatabaseService().userStory;
  //   DatabaseService().userReels;
  //   setState(() {
  //     loading = false;
  //     loading = false;
  //   });
  // }

  // Future getImageGalleryStory() async {
  //   ImagePicker _picker = ImagePicker();
  //   await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
  //     if (xFile != null) {
  //       imageFile = File(xFile.path);
  //       uploadImageStory();
  //       Navigator.of(context).pop();
  //       setState(() {
  //         postUpload = true;
  //       });
  //     }
  //   });
  // }

  // Future getImageCameraStory() async {
  //   ImagePicker _picker = ImagePicker();
  //   await _picker.pickImage(source: ImageSource.camera).then((xFile) {
  //     if (xFile != null) {
  //       imageFile = File(xFile.path);
  //       uploadImageStory();
  //       Navigator.of(context).pop();
  //       setState(() {
  //         postUpload = true;
  //       });
  //     }
  //   });
  // }

  // Future uploadImageStory() async {
  //   String filename = const Uuid().v1();
  //   String userId = FirebaseAuth.instance.currentUser!.uid;
  //   int status = 1;
  //   var ref =
  //       FirebaseStorage.instance.ref().child(userId).child("$filename.jpg");
  //   var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
  //     setState(() {
  //       postUpload = false;
  //     });
  //     status = 0;
  //   });
  //   if (status == 1) {
  //     String ImageUrl = await uploadTask.ref.getDownloadURL();
  //     FirebaseQuery.firebaseQuery.addstory({
  //       "date": dateTime,
  //       "storyId": ImageUrl.split("-").last,
  //       "storyUrl": ImageUrl,
  //       "likes": [],
  //       "Viwes": [],
  //     });
  //     log(ImageUrl);
  //     setState(() {
  //       postUpload = false;
  //     });
  //   }
  // }

  // int? post;
  // List<MyPost>? postList = [];
  int following = 0;
  int followers = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<UserData>(
          stream: DatabaseService().userinfo(widget.uid.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final profileData = snapshot.data;
              return Column(
                children: [
                  AppBar(
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    backgroundColor: Colors.transparent,
                    title: Row(
                      children: [
                        Text(
                          profileData!.email.split("@").first,
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        profileData.verified
                            ? const Icon(Icons.verified,
                                color: Colors.blue, size: 20)
                            : Container(),
                      ],
                    ),
                    elevation: 0,
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.add_box_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          CustomToast().successToast(
                              context: context, text: "Logout Successfully");
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                        onPressed: () => print("Add"),
                      )
                    ],
                  ),
                  StreamBuilder<UserData>(
                      stream: DatabaseService().User,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userdata = snapshot.data;
                          following = userdata!.following;
                          followers = profileData.followers;
                          return SingleChildScrollView(
                            controller: scrollController,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.81,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                  radius: 45,
                                                  backgroundImage: NetworkImage(
                                                      "${profileData.profileUrl}")),
                                              const SizedBox(height: 10),
                                              Text(
                                                profileData.name,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  _textUtils.bold20(
                                                      "${profileData.post}",
                                                      Colors.black),
                                                  const SizedBox(height: 5),
                                                  _textUtils.normal14(
                                                      "Posts", Colors.black),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  _textUtils.bold20(
                                                      "${profileData.followers > 1000000 ? profileData.followers.toString().split("0").first + "M" : profileData.followers > 999 ? profileData.followers.toString().split("0").first + "K" : profileData.followers}",
                                                      Colors.black),
                                                  const SizedBox(height: 5),
                                                  _textUtils.normal14(
                                                      "Followers", Colors.black)
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  _textUtils.bold20(
                                                      "${profileData.following}",
                                                      Colors.black),
                                                  const SizedBox(height: 5),
                                                  _textUtils.normal14(
                                                      "Following", Colors.black)
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        profileData.bio.isEmpty
                                            ? Container()
                                            : Text(
                                                profileData.bio,
                                                style: const TextStyle(
                                                    height: 1.8,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                              ),
                                        profileData.website.isEmpty
                                            ? Container()
                                            : Text(
                                                profileData.website,
                                                style: TextStyle(
                                                    height: 1.5,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color:
                                                        Colors.blue.shade300),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Row(
                                      children: [
                                        profileData.uid ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? Expanded(
                                                flex: 8,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const EditProfile()));
                                                  },
                                                  child: Container(
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        // color: Colors.blue,
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Center(
                                                      child: _textUtils.bold16(
                                                        "Edit Profile",
                                                        Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            : Expanded(
                                                flex: 8,
                                                child:
                                                    StreamBuilder<
                                                            List<
                                                                FollowerClass>>(
                                                        stream:
                                                            DatabaseService()
                                                                .userFollower(
                                                                    widget.uid),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            final followerData =
                                                                snapshot.data;
                                                            return followerData!
                                                                    .isEmpty
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      FirebaseQuery
                                                                          .firebaseQuery
                                                                          .follower(
                                                                              profileData.uid.toString()  ,
                                                                              {});
                                                                      FirebaseQuery
                                                                          .firebaseQuery
                                                                          .following(
                                                                              widget.uid.toString(),
                                                                              {});
                                                                      followerData.contains(profileData
                                                                              .uid)
                                                                          ? null
                                                                          : FirebaseQuery
                                                                              .firebaseQuery
                                                                              .updateUser({
                                                                              "following": following + 1
                                                                            });
                                                                      followerData.contains(profileData
                                                                              .uid)
                                                                          ? null
                                                                          : FirebaseQuery
                                                                              .firebaseQuery
                                                                              .secondUserUpdate(profileData.uid, {
                                                                              "followers": following + 1
                                                                            });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          35,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .blue,
                                                                          border:
                                                                              Border.all(color: Colors.blue),
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      child:
                                                                          Center(
                                                                        child: _textUtils.bold16(
                                                                            "Follow",
                                                                            Colors.white),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : followerData.any((element) =>
                                                                        element
                                                                            .uid ==
                                                                        userdata
                                                                            .uid)
                                                                    ? GestureDetector(
                                                                      onTap: (){
                                                                         FirebaseQuery.firebaseQuery.deletefollower(
                                                                              profileData.uid,
                                                                              {});
                                                                          FirebaseQuery.firebaseQuery.deletefollowing(
                                                                              profileData.uid,
                                                                              {});
                                                                          followerData.contains(profileData.uid)
                                                                              ? null
                                                                              : FirebaseQuery.firebaseQuery.updateUser({
                                                                                  "following": following - 1
                                                                                });
                                                                          followerData.contains(profileData.uid)
                                                                              ? null
                                                                              : FirebaseQuery.firebaseQuery.secondUserUpdate(profileData.uid, {
                                                                                  "followers": following - 1
                                                                                });
                                                                      },
                                                                      child: Container(
                                                                          height:
                                                                              35,
                                                                          decoration: BoxDecoration(
                                                                              color:
                                                                                  Colors.grey.shade700,
                                                                              border: Border.all(color: Colors.black),
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          padding:
                                                                              const EdgeInsets.all(8),
                                                                          child:
                                                                              Center(
                                                                            child: _textUtils.bold16(
                                                                                "Following",
                                                                                Colors.white),
                                                                          ),
                                                                        ),
                                                                    )
                                                                    : GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FirebaseQuery.firebaseQuery.follower(
                                                                              profileData.uid,
                                                                              {});
                                                                          FirebaseQuery.firebaseQuery.following(
                                                                              profileData.uid,
                                                                              {});
                                                                          followerData.contains(profileData.uid)
                                                                              ? null
                                                                              : FirebaseQuery.firebaseQuery.updateUser({
                                                                                  "following": following + 1
                                                                                });
                                                                          followerData.contains(profileData.uid)
                                                                              ? null
                                                                              : FirebaseQuery.firebaseQuery.secondUserUpdate(profileData.uid, {
                                                                                  "followers": following + 1
                                                                                });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              35,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              border: Border.all(color: Colors.blue),
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          padding:
                                                                              const EdgeInsets.all(8),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                _textUtils.bold16("Follow", Colors.white),
                                                                          ),
                                                                        ),
                                                                      );
                                                          }
                                                          if (snapshot
                                                              .hasError) {
                                                            return _textUtils
                                                                .bold12(
                                                                    snapshot
                                                                        .error
                                                                        .toString(),
                                                                    Colors
                                                                        .black);
                                                          }
                                                          return Container();
                                                        }),
                                              ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 35,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: const EdgeInsets.all(5),
                                            child: const Icon(
                                              Icons.person_add_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //     margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                                  //     child: Row(
                                  //       children: [
                                  //         Expanded(
                                  //           child: Column(
                                  //             crossAxisAlignment: CrossAxisAlignment.start,
                                  //             mainAxisAlignment: MainAxisAlignment.start,
                                  //             children: [
                                  //               _textUtils.bold14("Story Highlights", Colors.black),
                                  //               const SizedBox(
                                  //                 height: 5,
                                  //               ),
                                  //               _textUtils.normal14("Keep your favourite stories on your profile", Colors.black)
                                  //             ],
                                  //           ),
                                  //           flex: 9,
                                  //         ),
                                  //         const Expanded(
                                  //           child: Icon(
                                  //             Icons.keyboard_arrow_up,
                                  //             color: Colors.black,
                                  //             size: 18,
                                  //           ),
                                  //           flex: 1,
                                  //         )
                                  //       ],
                                  //     )),
                                  // data.highlight.isEmpty
                                  //     ? Container()
                                  //     :
                                  profileData.is_public
                                      ? Container(
                                          height: 70,
                                          margin: const EdgeInsets.only(
                                              left: 0, right: 0, top: 20),
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 1,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  height: 65,
                                                  width: 65,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.grey),
                                                );
                                              }))
                                      : Container(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  profileData.is_public
                                      ? TabBar(
                                          indicatorColor: Colors.black,
                                          indicatorWeight: 0.8,
                                          indicatorPadding: EdgeInsets.zero,
                                          padding: EdgeInsets.zero,
                                          controller: tabController,
                                          tabs: const [
                                            Tab(
                                                icon: Icon(
                                              Icons.grid_on_rounded,
                                              color: Colors.black,
                                            )),
                                            Tab(
                                                icon: Icon(
                                              Icons.smart_display_outlined,
                                              color: Colors.black,
                                            )),
                                            Tab(
                                                icon: Icon(
                                              Icons.person_pin_outlined,
                                              color: Colors.black,
                                            )),
                                          ],
                                        )
                                      : Container(),
                                  profileData.is_public
                                      ? Expanded(
                                          child: TabBarView(
                                            controller: tabController,
                                            children: [
                                              StreamBuilder<List<MyPost>>(
                                                stream: DatabaseService()
                                                    .viewPost(profileData.uid),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    final postData =
                                                        snapshot.data;
                                                    return GridView.builder(
                                                      padding: EdgeInsets.zero,
                                                      controller:
                                                          scrollController,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 3,
                                                              mainAxisSpacing:
                                                                  5,
                                                              crossAxisSpacing:
                                                                  5),
                                                      itemCount:
                                                          postData!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PersnolPhoto(
                                                                              data: postData,
                                                                              userdata: profileData,
                                                                            )));
                                                          },
                                                          child: Card(
                                                              elevation: 2,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Container(
                                                                // margin:
                                                                //     const EdgeInsets.only(
                                                                //         top: 2),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(postData[index]
                                                                            .postUrl),
                                                                        fit: BoxFit
                                                                            .cover)),
                                                              )),
                                                        );
                                                      },
                                                    );
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              ),
                                              Container(),
                                              Container(),
                                            ],
                                          ),
                                        )
                                      : AspectRatio(
                                          aspectRatio: 4 / 3,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          Colors.grey.shade300),
                                                  padding: EdgeInsets.all(15),
                                                  child: Image.network(
                                                    "https://cdn.pixabay.com/photo/2017/06/22/10/04/lock-2430207_1280.png",
                                                    color: Colors.grey,
                                                    scale: 30,
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              _textUtils.bold16(
                                                  "Account Is Privet",
                                                  Colors.black),
                                            ],
                                          )),
                                ],
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget favouriteStoriesWidget() {
    return const Padding(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: CircleAvatar(
        radius: 33,
        backgroundColor: Color(0xFF3E3E3E),
      ),
    );
  }
}


/*
FirebaseQuery.firebaseQuery.follower(profileData.uid,{});
                                            FirebaseQuery.firebaseQuery.following(profileData.uid,{});
                                           data.contains(profileData.uid)?null: FirebaseQuery.firebaseQuery.updateUser({
                                              "following": following+1
                                            });
                                             data.contains(profileData.uid)?null:  FirebaseQuery.firebaseQuery.secondUserUpdate(profileData.uid,{
                                              "followers": following+1
                                            });
*/