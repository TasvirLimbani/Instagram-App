import 'dart:developer';
import 'dart:io';
import 'dart:ui';

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
import 'package:instagram/Screens/Profile/OptionsBottomSheet.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/model/MyPost.dart';
import 'package:instagram/model/MyReels.dart';
import 'package:instagram/model/MyStory.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final TextUtils _textUtils = TextUtils();

  late TabController tabController;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaddata();
    tabController = TabController(length: 3, vsync: this);
  }

  File? imageFile;
  bool postUpload = false;
  DateTime dateTime = DateTime.now();
  Future getImageGallery() async {
    ImagePicker _picker = ImagePicker();
    await _picker
        .pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    )
        .then((xFile) {
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
      FirebaseQuery.firebaseQuery.addpost({
        "date": dateTime,
        "imageId": ImageUrl.split("-").last,
        "postUrl": ImageUrl,
        "likes": [],
        "comments": [],
      });
      FirebaseQuery.firebaseQuery.updateUser({
        "post": post! + 1,
      });

      log(ImageUrl);
      setState(() {
        postUpload = false;
      });
    }
  }

  Future getReelsGallery() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickVideo(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadReels();
        Navigator.of(context).pop();
        setState(() {
          postUpload = true;
        });
      }
    });
  }

  Future getReelsCamera() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickVideo(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadReels();
        Navigator.of(context).pop();
        setState(() {
          postUpload = true;
        });
      }
    });
  }

  Future uploadReels() async {
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
      FirebaseQuery.firebaseQuery.addreels({
        "date": dateTime,
        "reelId": ImageUrl.split("-").last,
        "reelUrl": ImageUrl,
        "likes": [],
        "views": [],
        "comments": [],
      });
      // FirebaseQuery.firebaseQuery.updateUser({
      //   "post": post! + 1,
      // });

      log(ImageUrl);
      setState(() {
        postUpload = false;
      });
    }
  }

  bool loading = true;
  loaddata() {
    setState(() {
      loading = true;
    });
    DatabaseService().User;
    DatabaseService().userPost;
    DatabaseService().userProfile;
    DatabaseService().userReels;
    DatabaseService().userStory;
    DatabaseService().usermessage;
    setState(() {
      loading = false;
      loading = false;
    });
  }

  Future getImageGalleryStory() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImageStory();
        Navigator.of(context).pop();
        setState(() {
          postUpload = true;
        });
      }
    });
  }

  Future getImageCameraStory() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImageStory();
        Navigator.of(context).pop();
        setState(() {
          postUpload = true;
        });
      }
    });
  }

  Future uploadImageStory() async {
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
      log(ImageUrl);
      setState(() {
        postUpload = false;
      });
    }
  }

  int? post;
  List<MyPost>? postList = [];

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder<UserData>(
            stream: DatabaseService().User,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                return Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      title: Row(
                        children: [
                          Text(
                            data!.email.split("@").first,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          data.verified
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
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              backgroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                              context: context,
                              builder: (BuildContext context) {
                                return OptionsBottomSheet(
                                  userData: data,
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      controller: scrollController,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.805,
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
                                        StreamBuilder<List<MyStory>>(
                                            stream: DatabaseService().userStory,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final storyData = snapshot.data;
                                                return storyData!.isNotEmpty
                                                    ? GestureDetector(
                                                        onLongPress: () {
                                                          showModalBottomSheet<
                                                              void>(
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                            )),
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                height: 100,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        // Navigator.of(context)
                                                                        //     .pop();
                                                                        getImageCameraStory();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            80,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade300,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.camera,
                                                                                color: Colors.black54,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              _textUtils.bold12("Camera", Colors.black54)
                                                                            ]),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        // Navigator.of(context)
                                                                        //     .pop();
                                                                        getImageGalleryStory();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            80,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade300,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.photo,
                                                                                color: Colors.black54,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              _textUtils.bold12("Video", Colors.black54)
                                                                            ]),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return StoryViewPage(
                                                                  myStory:
                                                                      storyData,
                                                                );
                                                              });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                width: 2),
                                                          ),
                                                          child: CircleAvatar(
                                                              radius: 45,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      "${data.profileUrl}")),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return StoryUploadPage();
                                                              });
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            CircleAvatar(
                                                                radius: 45,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        "${data.profileUrl}")),
                                                            Positioned(
                                                                right: 5,
                                                                bottom: 0,
                                                                child:
                                                                    Container(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                2),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              width: 2,
                                                                              color: Colors.white),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .add,
                                                                          size:
                                                                              15,
                                                                          color:
                                                                              Colors.white,
                                                                        )))
                                                          ],
                                                        ),
                                                      );
                                              }
                                              return CircleAvatar(
                                                radius: 45,
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                child: Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                ),
                                              );
                                            }),
                                        const SizedBox(height: 10),
                                        _textUtils.bold16(
                                            data.name, Colors.black)
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
                                                "${data.post}", Colors.black),
                                            const SizedBox(height: 5),
                                            _textUtils.normal14(
                                                "Posts", Colors.black),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            _textUtils.bold20(
                                                "${data.followers > 1000000 ? data.followers.toString().split("0").first + "M" : data.followers > 999 ? data.followers.toString().split("0").first + "K" : data.followers}",
                                                Colors.black),
                                            const SizedBox(height: 5),
                                            _textUtils.normal14(
                                                "Followers", Colors.black)
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            _textUtils.bold20(
                                                "${data.following}",
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
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data.bio.isEmpty
                                      ? Container()
                                      : Text(
                                          data.bio,
                                          style: const TextStyle(
                                              height: 1.8,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.black54),
                                        ),
                                  data.website.isEmpty
                                      ? Container()
                                      : Text(
                                          data.website,
                                          style: TextStyle(
                                              height: 1.5,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.blue.shade300),
                                        ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              child: Row(
                                children: [
                                  Expanded(
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
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: const EdgeInsets.all(8),
                                        child: Center(
                                          child: _textUtils.bold16(
                                              "Edit Profile", Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
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
                            Container(
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
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey),
                                      );
                                    })),
                            const SizedBox(
                              height: 10,
                            ),
                            TabBar(
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
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  StreamBuilder<List<MyPost>>(
                                      stream: DatabaseService().userPost,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          post = snapshot.data!.length;
                                          final postData = snapshot.data;
                                          return postData!.isEmpty
                                              ? postUpload
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet<
                                                            void>(
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                          )),
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                              height: 150,
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    ListTile(
                                                                        title:
                                                                            Center(
                                                                          child: _textUtils.bold16(
                                                                              'Upload With Camera',
                                                                              Colors.black),
                                                                        ),
                                                                        onTap: () =>
                                                                            getImageCamera()),
                                                                    ListTile(
                                                                        title:
                                                                            Center(
                                                                          child: _textUtils.bold16(
                                                                              'Upload With Gallery',
                                                                              Colors.black),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          getImageGallery();
                                                                        })
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(Icons.add,
                                                              size: 30),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          _textUtils.bold16(
                                                              "Add Posts",
                                                              Colors.black),
                                                        ],
                                                      ),
                                                    )
                                              : postUpload
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : GridView.builder(
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
                                                          postData.length + 1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return postData.length >
                                                                index
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) => PersnolPhoto(
                                                                                data: postData,
                                                                                userdata: data,
                                                                              )));
                                                                },
                                                                child: Card(
                                                                  elevation: 2,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child:
                                                                      Container(
                                                                    // margin:
                                                                    //     const EdgeInsets.only(
                                                                    //         top: 2),
                                                                    // decoration: BoxDecoration(
                                                                    //     borderRadius:
                                                                    //         BorderRadius.circular(
                                                                    //             5),
                                                                    //      image: DecorationImage(
                                                                    //          image:
                                                                    //             NetworkImage(postData[index].postUrl),
                                                                    //     //     fit: BoxFit.cover)
                                                                    //         ),
                                                                    child: ClipRRect(
                                                                       borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                      child: Image.network(postData[index].postUrl, fit: BoxFit.cover, frameBuilder:
                                                                          (context,
                                                                              child,
                                                                              frame,
                                                                              wasSynchronouslyLoaded) {
                                                                        return child;
                                                                      }, loadingBuilder:
                                                                          (context,
                                                                              child,
                                                                              loadingProgress) {
                                                                        if (loadingProgress ==
                                                                            null) {
                                                                          return child;
                                                                        } else {
                                                                          return const Center(
                                                                            child:
                                                                                CupertinoActivityIndicator(),
                                                                          );
                                                                        }
                                                                      }),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet<
                                                                      void>(
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                    )),
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return Container(
                                                                        height:
                                                                            150,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: <Widget>[
                                                                              ListTile(
                                                                                  title: Center(
                                                                                    child: _textUtils.bold16('Upload With Camera', Colors.black),
                                                                                  ),
                                                                                  onTap: () => getImageCamera()),
                                                                              ListTile(
                                                                                  title: Center(
                                                                                    child: _textUtils.bold16('Upload With Gallery', Colors.black),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    getImageGallery();
                                                                                  })
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Card(
                                                                  elevation: 2,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              2),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .add_box_outlined,
                                                                          size:
                                                                              30,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              3,
                                                                        ),
                                                                        _textUtils.bold14(
                                                                            "Add Image",
                                                                            Colors.grey),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                      },
                                                    );
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }),

                                  // data.myReels.isEmpty
                                  //     ? Center(
                                  //         child: _textUtils.bold16(
                                  //             "No Reels", Colors.black),
                                  //       )
                                  //     :
                                  StreamBuilder<List<MyReels>>(
                                      stream: DatabaseService().userReels,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          // _betterPlayerController. = BetterPlayerController(BetterPlayerConfiguration(autoPlay: false));
                                          post = snapshot.data!.length;
                                          final reelsData = snapshot.data;
                                          return reelsData!.isEmpty
                                              ? postUpload
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet<
                                                            void>(
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                          )),
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                              height: 150,
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    ListTile(
                                                                        title:
                                                                            Center(
                                                                          child: _textUtils.bold16(
                                                                              'Upload With Camera',
                                                                              Colors.black),
                                                                        ),
                                                                        onTap: () =>
                                                                            getReelsCamera()),
                                                                    ListTile(
                                                                        title:
                                                                            Center(
                                                                          child: _textUtils.bold16(
                                                                              'Upload With Gallery',
                                                                              Colors.black),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          getReelsGallery();
                                                                        })
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(Icons.add,
                                                              size: 30),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          _textUtils.bold16(
                                                              "Add Reels",
                                                              Colors.black),
                                                        ],
                                                      ),
                                                    )
                                              : postUpload
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : GridView.builder(
                                                      padding: EdgeInsets.zero,
                                                      controller:
                                                          scrollController,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 3,
                                                              childAspectRatio:
                                                                  0.7,
                                                              mainAxisSpacing:
                                                                  5,
                                                              crossAxisSpacing:
                                                                  5),
                                                      itemCount:
                                                          reelsData.length + 1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return reelsData
                                                                    .length >
                                                                index
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return ShowReels(
                                                                          myReels:
                                                                              reelsData[index],
                                                                          userData:
                                                                              data,
                                                                        );
                                                                      });
                                                                  // Navigator.of(
                                                                  //         context)
                                                                  //     .push(MaterialPageRoute(
                                                                  //         builder: (context) => ShowReels(
                                                                  //             myReels: reelsData[index],
                                                                  //             userData: data,

                                                                  //             )));
                                                                },
                                                                child: Card(
                                                                  elevation: 2,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  // child: BetterPlayer(controller: _betterPlayerController),
                                                                  //     Container(
                                                                  //   // margin:
                                                                  //   //     const EdgeInsets.only(
                                                                  //   //         top: 2),
                                                                  //   decoration: BoxDecoration(
                                                                  //       borderRadius:
                                                                  //           BorderRadius.circular(
                                                                  //               5),
                                                                  //       image: DecorationImage(
                                                                  //           image:
                                                                  //               NetworkImage(postData[index].postUrl),
                                                                  //           fit: BoxFit.cover)),
                                                                  // ),
                                                                ),
                                                              )
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet<
                                                                      void>(
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                    )),
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return Container(
                                                                        height:
                                                                            150,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: <Widget>[
                                                                              ListTile(
                                                                                  title: Center(
                                                                                    child: _textUtils.bold16('Upload With Camera', Colors.black),
                                                                                  ),
                                                                                  onTap: () => getReelsCamera()),
                                                                              ListTile(
                                                                                  title: Center(
                                                                                    child: _textUtils.bold16('Upload With Gallery', Colors.black),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    getReelsGallery();
                                                                                  })
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Card(
                                                                  elevation: 2,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              2),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .add_box_outlined,
                                                                          size:
                                                                              30,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              3,
                                                                        ),
                                                                        _textUtils.bold14(
                                                                            "Add Reels",
                                                                            Colors.grey),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                      },
                                                    );
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }),

                                  // GridView.builder(
                                  //   controller: scrollController,
                                  //   gridDelegate:
                                  //       const SliverGridDelegateWithFixedCrossAxisCount(
                                  //           crossAxisCount: 3,
                                  //           mainAxisSpacing: 5,
                                  //           crossAxisSpacing: 5),
                                  //   itemCount: 0,
                                  //   itemBuilder: (context, index) {
                                  //     return Container();
                                  //   },
                                  // ),
                                  // data.tagPost.isEmpty
                                  //     ? Center(
                                  //         child: _textUtils.bold16(
                                  //             "No Tags", Colors.black),
                                  //       )
                                  //     :
                                  GridView.builder(
                                    controller: scrollController,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5),
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
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
