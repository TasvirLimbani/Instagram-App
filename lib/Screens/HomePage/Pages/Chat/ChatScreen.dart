import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Components/TextFromFiled.dart';
import 'package:instagram/Components/Toast.dart';
import 'package:instagram/Screens/HomePage/Pages/EditProfile.dart';
import 'package:instagram/Screens/HomePage/Pages/ProfilePage.dart';
import 'package:instagram/Screens/HomePage/Pages/ViewProfile.dart';
import 'package:instagram/Screens/ImageViewer.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/model/Meassge.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;


class ChatScreen extends StatefulWidget {
  UserData userData;
  ChatScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextUtils _textUtils = TextUtils();
  final TextEditingController _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  File? imageFile;
  bool loadimage = false;
  bool swipeOpen = false;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker
        .pickImage(source: ImageSource.gallery, imageQuality: 20)
        .then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String filename = const Uuid().v1();
    int status = 1;
    // await FirebaseQuery.firebaseQuery
    //     .sendMeassge(uid: widget.userData.uid, data: {
    //   "date": DateTime.now(),
    //   "meassge": "",
    //   // "postUrl": ImageUrl,
    //   "like": false,
    //   "sender": FirebaseAuth.instance.currentUser!.email!.split("@").first,
    //   "type": "text",
    //   // "comments": [],
    //   // "sender":"test"                               // "comments": [],
    // });
    setState(() {
      loadimage = true;
    });
    var ref = FirebaseStorage.instance
        .ref()
        .child(widget.userData.uid)
        .child("$filename.jpg");
    var uploadTask = await ref
        .putFile(
      imageFile!,
    )
        .catchError((error) async {
      // await _firestore
      //     .collection('chatroom')
      //     .doc(widget.chatRoomId)
      //     .collection('chats')
      //     .doc(filename)
      //     .delete();
      status = 0;
    });
    if (status == 1) {
      String ImageUrl = await uploadTask.ref.getDownloadURL();
      await FirebaseQuery.firebaseQuery
          .sendMeassge(uid: widget.userData.uid, data: {
        "date": DateTime.now(),
        "meassge": ImageUrl,
        "like": false,
        "sender": FirebaseAuth.instance.currentUser!.email!.split("@").first,
        "type": "img",
      });
      await FirebaseQuery.firebaseQuery.usersendMeassge(
          data: {
            "date": DateTime.now(),
            "meassge": ImageUrl,
            // "postUrl": ImageUrl,
            "like": false,
            "type": "img",
            "sender": FirebaseAuth.instance.currentUser!.email!
                .split("@")
                .first, // "comments": [],
            // "sender":"test"                               // "comments": [],
          },
          uid: FirebaseAuth.instance.currentUser!.uid,
          userid: widget.userData.uid);
      setState(() {
        loadimage = false;
      });
      print(ImageUrl);
    }
    //
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseService().User;
    DatabaseService().userPost;
    DatabaseService().userProfile;
    DatabaseService().userReels;
    DatabaseService().userStory;
    DatabaseService().usermessage;
    // jumpScrool();
  }

  jumpScrool() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // List meassge = [];

  String postStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
          ),
          titleSpacing: 0,
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewProfile(uid: widget.userData.uid)));
            },
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.userData.profileUrl),
                    ),
                    widget.userData.show_active_status
                        ? widget.userData.status == "Online"
                            ? Positioned(
                                bottom: 0,
                                right: -2,
                                child: Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.lightGreen,
                                      border: Border.all(
                                          width: 2, color: Colors.white)),
                                ),
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                  ],
                ),
                //  SizedBox(width: 10,),
                SizedBox(
                  width: 160,
                  child: ListTile(
                    title: Row(
                      children: [
                        _textUtils.bold16(widget.userData.email, Colors.black),
                        const SizedBox(
                          width: 5,
                        ),
                        // widget.userData!.verified
                        // ?
                        widget.userData.verified
                            ? const Icon(Icons.verified,
                                color: Colors.blue, size: 20)
                            : Container(),
                        // : Container(),],),
                      ],
                    ),
                    subtitle:
                        _textUtils.bold12(widget.userData.name, Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.call_outlined,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.videocam_outlined,
                color: Colors.black,
                size: 30,
              ),
            ),
          ],
        ),
        body: StreamBuilder<UserData>(
            stream: DatabaseService().User,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userdata = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        // onHorizontalDragEnd: (dragEndDetails) {
                        //   if (dragEndDetails.primaryVelocity! < 0) {
                        //     // Page forwards
                        //     print('Move page forwards');
                        //     // _goForward();
                        //     setState(() {
                        //       padding=100;
                        //     });
                        //   }
                        //   else if (dragEndDetails.primaryVelocity! > 0) {
                        //     // Page backwards
                        //     print('Move page backwards');
                        //     setState(() {
                        //       padding=3;
                        //     });
                        //     // _goBack();
                        //   }
                        // },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 130,
                          child: StreamBuilder<List<Meassge>>(
                              stream: DatabaseService()
                                  .userMeassge(widget.userData.uid),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // log(snapshot.data![0].sender + " " +widget.userData.email);
                                  // log(snapshot.data![1].sender + " " +widget.userData.email);
                                  // log(snapshot.data![2].sender + " "+ widget.userData.email);
                                  // log(snapshot.data![3].sender + " "+ widget.userData.email);
                                  // log(snapshot.data![4].sender + " "+ widget.userData.email);
                                  final data = snapshot.data;

                                  return loadimage
                                      ? Container(
                                          height: 250,
                                          width: 180,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: data!.length + 1,
                                          controller: _scrollController,
                                          reverse: true,
                                          shrinkWrap: true,
                                          //    physics: const BouncingScrollPhysics(),
                                          itemBuilder: ((context, index) {
                                            return index == data.length
                                                ? SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            2,
                                                    child: Column(
                                                      // mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 45,
                                                              backgroundImage:
                                                                  NetworkImage(widget
                                                                      .userData
                                                                      .profileUrl),
                                                            ),
                                                            widget.userData
                                                                    .show_active_status
                                                                ? widget.userData
                                                                            .status ==
                                                                        "Online"
                                                                    ? Positioned(
                                                                        bottom:
                                                                            0,
                                                                        right:
                                                                            8,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              18,
                                                                          width:
                                                                              18,
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Colors.lightGreen,
                                                                              border: Border.all(width: 2, color: Colors.white)),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        height:
                                                                            0,
                                                                        width:
                                                                            0,
                                                                      )
                                                                : Container(
                                                                    height: 0,
                                                                    width: 0,
                                                                  ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            _textUtils.bold14(
                                                                widget.userData
                                                                    .name,
                                                                Colors.black),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            // widget.userData!.verified
                                                            // ?
                                                            widget.userData
                                                                    .verified
                                                                ? const Icon(
                                                                    Icons
                                                                        .verified,
                                                                    color: Colors
                                                                        .blue,
                                                                    size: 16)
                                                                : Container(),
                                                            // const Icon(
                                                            //   Icons.fiber_manual_record,
                                                            //   size: 8,
                                                            //   color: Colors.grey,
                                                            // ),

                                                            // _textUtils.bold14("Instagram", Colors.grey),
                                                            // : Container(),],),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        _textUtils.bold12(
                                                            "Followers: ${widget.userData.followers} || Following: ${widget.userData.following}",
                                                            Colors.grey),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        _textUtils.bold12(
                                                            "You don't follow each other on This App",
                                                            Colors.grey),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          height: 30,
                                                          child: ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (context) => ViewProfile(
                                                                              uid: widget.userData.uid,
                                                                            )));
                                                              },
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      elevation:
                                                                          2,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(30.0),
                                                                        // side: BorderSide(color: Colors.red),
                                                                      ),
                                                                      primary: Colors
                                                                          .grey
                                                                          .shade600),
                                                              child: _textUtils.bold12(
                                                                  'View Profile',
                                                                  Colors
                                                                      .white)),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : data.length > index
                                                    ? Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        //  (_chatProvider
                                                        //             .chatList[index].appType ==
                                                        //         "marchant")
                                                        //     ? Alignment.centerRight
                                                        //     : Alignment.centerLeft,
                                                        child: Align(
                                                          alignment: data[index]
                                                                      .sender !=
                                                                  widget
                                                                      .userData
                                                                      .email
                                                              ? Alignment
                                                                  .centerRight
                                                              : Alignment
                                                                  .centerLeft,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        3),
                                                            child: Column(
                                                              crossAxisAlignment: data[
                                                                              index]
                                                                          .sender !=
                                                                      widget
                                                                          .userData
                                                                          .email
                                                                  ? CrossAxisAlignment
                                                                      .end
                                                                  : CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  mainAxisAlignment: data[index].sender !=
                                                                          widget
                                                                              .userData
                                                                              .email
                                                                      ? MainAxisAlignment
                                                                          .end
                                                                      : MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    data[index].sender !=
                                                                            widget.userData.email
                                                                        ? Container()
                                                                        : CircleAvatar(
                                                                            radius:
                                                                                17,
                                                                            backgroundImage:
                                                                                NetworkImage(widget.userData.profileUrl),
                                                                          ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    GestureDetector(
                                                                      onDoubleTap:
                                                                          () {
                                                                        FirebaseQuery.firebaseQuery.updateMeassge(
                                                                            uid:
                                                                                widget.userData.uid,
                                                                            meaasgeuid: data[index].uid,
                                                                            data: {
                                                                              "like": true,
                                                                            });
                                                                      },
                                                                      child: data[index].type ==
                                                                              "text"
                                                                          ? Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: swipeOpen ? 0 : 0),
                                                                              child: GestureDetector(
                                                                                onHorizontalDragUpdate: (v) {
                                                                                  if (v.delta.dx.isNegative) {
                                                                                    setState(() {
                                                                                      swipeOpen = false;
                                                                                    });
                                                                                  } else {
                                                                                    setState(() {
                                                                                      swipeOpen = true;
                                                                                    });
                                                                                  }
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    Stack(
                                                                                      clipBehavior: Clip.none,
                                                                                      children: [
                                                                                          Container(
                                                                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5, minWidth: 10),
                                                                                              margin: const EdgeInsets.symmetric(vertical: 3),
                                                                                              // width: MediaQuery.of(context)
                                                                                              //         .size
                                                                                              //         .width /
                                                                                              //     1.5,
                                                                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: data[index].sender != widget.userData.email ? const BorderRadius.only(topRight: Radius.circular(13), bottomLeft: Radius.circular(13), topLeft: Radius.circular(13)) : const BorderRadius.only(topRight: Radius.circular(13), topLeft: Radius.circular(13), bottomRight: Radius.circular(13)),
                                                                                                color: data[index].sender != widget.userData.email ? const Color(0xff4b6057) : Colors.grey.shade300,
                                                                                              ),
                                                                                              child: _textUtils.bold14(data[index].meassge, data[index].sender != widget.userData.email ? Colors.white : Colors.black)),
                                                                                        data[index].like
                                                                                            ? data[index].sender != widget.userData.email
                                                                                                ? Positioned(
                                                                                                    bottom: -8,
                                                                                                    left: 5,
                                                                                                    child: GestureDetector(
                                                                                                      onTap: () {
                                                                                                        FirebaseQuery.firebaseQuery.updateMeassge(uid: widget.userData.uid, meaasgeuid: data[index].uid, data: {
                                                                                                          "like": false,
                                                                                                        });
                                                                                                      },
                                                                                                      child: Stack(
                                                                                                        children: [
                                                                                                          const Icon(
                                                                                                            Icons.favorite,
                                                                                                            color: Colors.white,
                                                                                                            size: 18,
                                                                                                          ),
                                                                                                          Positioned(
                                                                                                            right: 0,
                                                                                                            left: 0,
                                                                                                            top: 0,
                                                                                                            bottom: 0,
                                                                                                            child: Icon(
                                                                                                              Icons.favorite,
                                                                                                              color: Colors.red.shade300,
                                                                                                              size: 15,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ))
                                                                                                : Positioned(
                                                                                                    bottom: -8,
                                                                                                    right: 5,
                                                                                                    child: GestureDetector(
                                                                                                      onTap: () {
                                                                                                        FirebaseQuery.firebaseQuery.updateMeassge(uid: widget.userData.uid, meaasgeuid: data[index].uid, data: {
                                                                                                          "like": false,
                                                                                                        });
                                                                                                      },
                                                                                                      child: Stack(children: [
                                                                                                        const Icon(
                                                                                                          Icons.favorite,
                                                                                                          color: Colors.white,
                                                                                                          size: 18,
                                                                                                        ),
                                                                                                        Positioned(
                                                                                                          right: 0,
                                                                                                          left: 0,
                                                                                                          top: 0,
                                                                                                          bottom: 0,
                                                                                                          child: Icon(
                                                                                                            Icons.favorite,
                                                                                                            color: Colors.red.shade300,
                                                                                                            size: 15,
                                                                                                          ),
                                                                                                        )
                                                                                                      ]),
                                                                                                    ))
                                                                                            : Container(),
                                                                                      ],
                                                                                    ),
                                                                                     !swipeOpen
                  ? Container(margin: EdgeInsets.symmetric(horizontal: 5),child: _textUtils.bold12("${timeago.format(data[index].date)}", Colors.black))
                  : Container()
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Stack(
                                                                              clipBehavior: Clip.none,
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onLongPress: data[index].type == "img"
                                                                                      ? () {
                                                                                          showModalBottomSheet<void>(
                                                                                            backgroundColor: Colors.grey.shade300,
                                                                                            shape: const RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.only(
                                                                                              topLeft: Radius.circular(20),
                                                                                              topRight: Radius.circular(20),
                                                                                            )),
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return Container(
                                                                                                height: 230,
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                      height: 8,
                                                                                                    ),
                                                                                                    _textUtils.bold14("${data[index].sender} Send You At ${data[index].date.hour}:${data[index].date.minute}:${data[index].date.second}", Colors.black),
                                                                                                    SizedBox(
                                                                                                      height: 8,
                                                                                                    ),
                                                                                                    Container(height: 150, width: 150, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: NetworkImage(data[index].meassge), fit: BoxFit.cover))),
                                                                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                                                                      TextButton.icon(
                                                                                                          onPressed: () {
                                                                                                            _saveNetworkImage(data[index].meassge);
                                                                                                            Navigator.of(context).pop();
                                                                                                          },
                                                                                                          icon: Icon(Icons.download, color: Colors.black, size: 17),
                                                                                                          label: _textUtils.bold14("Download", Colors.black)),
                                                                                                      TextButton.icon(
                                                                                                          onPressed: () {
                                                                                                            data[index].like
                                                                                                                ? FirebaseQuery.firebaseQuery.updateMeassge(uid: widget.userData.uid, meaasgeuid: data[index].uid, data: {
                                                                                                                    "like": false,
                                                                                                                  })
                                                                                                                : FirebaseQuery.firebaseQuery.updateMeassge(uid: widget.userData.uid, meaasgeuid: data[index].uid, data: {
                                                                                                                    "like": true,
                                                                                                                  });
                                                                                                            Navigator.of(context).pop();
                                                                                                          },
                                                                                                          icon: Icon(data[index].like ? Icons.favorite : Icons.favorite_border_outlined, color: data[index].like ? Colors.red.shade300 : Colors.black, size: 17),
                                                                                                          label: _textUtils.bold14(data[index].like ? "Liked" : "Like", Colors.black)),
                                                                                                    ]),
                                                                                                  ],
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                          );
                                                                                        }
                                                                                      : null,
                                                                                  onTap: data[index].type == "img"
                                                                                      ? () async {
                                                                                          Navigator.of(context).push(MaterialPageRoute(
                                                                                              builder: (context) => ImageViewer(
                                                                                                    image: data[index].meassge,
                                                                                                  )));
                                                                                          // showDialog(
                                                                                          //     context: context,
                                                                                          //     builder: (context) => AlertDialog(
                                                                                          //       // insetPadding: EdgeInsets.zero,
                                                                                          //       contentPadding: EdgeInsets.all(5),
                                                                                          //       // insetPadding: EdgeInsets.zero,
                                                                                          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                                                                          //           content: InteractiveViewer(
                                                                                          //               boundaryMargin: EdgeInsets.all(80),
                                                                                          //               panEnabled: false,
                                                                                          //               scaleEnabled: true,
                                                                                          //               minScale: 1.0,
                                                                                          //               maxScale: 2.2,
                                                                                          //               child: Container(height: 250,width: 250,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),image: DecorationImage(image: NetworkImage(data[index].meassge),fit: BoxFit.cover)),)),
                                                                                          //         ));
                                                                                        }
                                                                                      : null,
                                                                                  child: Container(
                                                                                    height: 250,
                                                                                    width: 180,
                                                                                    // constraints: BoxConstraints(
                                                                                    //     maxWidth: MediaQuery.of(context).size.width /
                                                                                    //         1.5,
                                                                                    //     minWidth:
                                                                                    //         10),

                                                                                    margin: const EdgeInsets.symmetric(vertical: 3),
                                                                                    // width: MediaQuery.of(context)
                                                                                    //         .size
                                                                                    //         .width /
                                                                                    //     1.5,
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: data[index].sender != widget.userData.email ? const BorderRadius.only(topRight: Radius.circular(13), bottomLeft: Radius.circular(13), topLeft: Radius.circular(13)) : const BorderRadius.only(topRight: Radius.circular(13), topLeft: Radius.circular(13), bottomRight: Radius.circular(13)),
                                                                                      color: data[index].sender != widget.userData.email ? const Color(0xff4b6057) : Colors.grey.shade300,
                                                                                    ),
                                                                                    child: ClipRRect(
                                                                                      borderRadius: data[index].sender != widget.userData.email ? const BorderRadius.only(topRight: Radius.circular(13), bottomLeft: Radius.circular(13), topLeft: Radius.circular(13)) : const BorderRadius.only(topRight: Radius.circular(13), topLeft: Radius.circular(13), bottomRight: Radius.circular(13)),
                                                                                      child: Image.network(data[index].meassge, fit: BoxFit.cover, frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                                                        return child;
                                                                                      }, loadingBuilder: (context, child, loadingProgress) {
                                                                                        if (loadingProgress == null) {
                                                                                          return child;
                                                                                        } else {
                                                                                          return const Center(
                                                                                            child: CupertinoActivityIndicator(),
                                                                                          );
                                                                                        }
                                                                                      }),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                data[index].like
                                                                                    ? data[index].sender != widget.userData.email
                                                                                        ? Positioned(
                                                                                            bottom: -8,
                                                                                            left: 5,
                                                                                            child: GestureDetector(
                                                                                              onTap: () {
                                                                                                FirebaseQuery.firebaseQuery.updateMeassge(uid: widget.userData.uid, meaasgeuid: data[index].uid, data: {
                                                                                                  "like": false,
                                                                                                });
                                                                                              },
                                                                                              child: Stack(
                                                                                                children: [
                                                                                                  const Icon(
                                                                                                    Icons.favorite,
                                                                                                    color: Colors.white,
                                                                                                    size: 18,
                                                                                                  ),
                                                                                                  Positioned(
                                                                                                    right: 0,
                                                                                                    left: 0,
                                                                                                    top: 0,
                                                                                                    bottom: 0,
                                                                                                    child: Icon(
                                                                                                      Icons.favorite,
                                                                                                      color: Colors.red.shade300,
                                                                                                      size: 15,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ))
                                                                                        : Positioned(
                                                                                            bottom: -8,
                                                                                            right: 5,
                                                                                            child: GestureDetector(
                                                                                              onTap: () {
                                                                                                FirebaseQuery.firebaseQuery.updateMeassge(uid: widget.userData.uid, meaasgeuid: data[index].uid, data: {
                                                                                                  "like": false,
                                                                                                });
                                                                                              },
                                                                                              child: Stack(children: [
                                                                                                const Icon(
                                                                                                  Icons.favorite,
                                                                                                  color: Colors.white,
                                                                                                  size: 18,
                                                                                                ),
                                                                                                Positioned(
                                                                                                  right: 0,
                                                                                                  left: 0,
                                                                                                  top: 0,
                                                                                                  bottom: 0,
                                                                                                  child: Icon(
                                                                                                    Icons.favorite,
                                                                                                    color: Colors.red.shade300,
                                                                                                    size: 15,
                                                                                                  ),
                                                                                                )
                                                                                              ]),
                                                                                            ))
                                                                                    : Container(),
                                                                              ],
                                                                            ),
                                                                          
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    data[index].sender !=
                                                                            widget.userData.email
                                                                        ? CircleAvatar(
                                                                            radius:
                                                                                17,
                                                                            backgroundImage:
                                                                                NetworkImage(userdata!.profileUrl),
                                                                          )
                                                                        : Container(),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ))
                                                    : Container();
                                          }));
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                        ),
                      ),
                      Container(
                        // height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: EditTextFiled(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          hintText: "Message",
                          controller: _messageController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Message";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              // userInput = value;
                            });
                          },
                          suffix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.photo,
                                      color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      getImage();
                                    });
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.send,
                                      color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      _messageController.text.isEmpty
                                          ? null
                                          : FirebaseQuery.firebaseQuery
                                              .sendMeassge(
                                                  uid: widget.userData.uid,
                                                  data: {
                                                  "date": DateTime.now(),
                                                  "meassge":
                                                      _messageController.text,
                                                  // "postUrl": ImageUrl,
                                                  "like": false,
                                                  "sender": userdata!.email,
                                                  "type": "text",
                                                  // "comments": [],
                                                  // "sender":"test"                               // "comments": [],
                                                });
                                      FirebaseQuery.firebaseQuery
                                          .usersendMeassge(
                                              data: {
                                            "date": DateTime.now(),
                                            "meassge": _messageController.text,
                                            // "postUrl": ImageUrl,
                                            "like": false,
                                            "type": "text",
                                            "sender": userdata!
                                                .email // "comments": [],
                                            // "sender":"test"                               // "comments": [],
                                          },
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              userid: widget.userData.uid);

                                      _messageController.clear();
                                    });
                                  }),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade400, width: 1)),
                          onSaved: (value) {
                            setState(() {
                              // username = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }));
  }

  void _saveNetworkImage(String imageUrl) async {
    String path = imageUrl;
    GallerySaver.saveImage(path).then((bool? success) {
      success!
          ? CustomToast()
              .successToast(context: context, text: "Image Save Successfully")
          : CustomToast().errorToast(context: context, text: "Image Not Save");

      setState(() {
        print('Image is saved');
      });
    });
  }
}
