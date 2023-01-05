import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram/Components/Toast.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/model/MyPost.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ImagePopUp extends StatefulWidget {
  MyPost data;
  UserData? userdata;
  ImagePopUp({Key? key, required this.data, required this.userdata})
      : super(key: key);

  @override
  State<ImagePopUp> createState() => _ImagePopUpState();
}

class _ImagePopUpState extends State<ImagePopUp> {
  final TextUtils _textUtils = TextUtils();
  bool downloading = false;
  var progressString = "";
  double progressInt = 0;

  Future<void> shareFile() async {
    Dio dio = Dio();
    final imgUrl = Uri.parse(widget.data.postUrl);
    try {
      var dir = await getExternalStorageDirectory();
      log("path ${dir!.path}");
      String imgPath =
          "${dir.path}/${widget.data.postUrl.split("-").first.split("|")}.jpg";
      await dio.download(imgUrl.toString(),
          "${dir.path}/${widget.data.postUrl.split("-").first.split("|")}.jpg",
          onReceiveProgress: (rec, total) {
        // print("Rec: $rec , Total: $total");
        setState(() {
          progressInt = ((rec / total) * 100);
          log("$progressInt");
        });
        progressInt == 100
            ? Share.shareFiles(['$imgPath'],
                text:
                    'User ==> ${widget.userdata!.name} Creat Post \n Post Likes ==> ${widget.data.likes.length} Likes \n Post Comments ${widget.data.comments.length} Comments')
            : null;
      });
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  Color color = Colors.black;
  int selectindex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:    widget.userdata!.uid == FirebaseAuth.instance.currentUser!.uid? MediaQuery.of(context).size.height * 0.31: MediaQuery.of(context).size.height * 0.135,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  downloading = true;
                  shareFile();
                },
                child: Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: downloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black54,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              const Icon(
                                Icons.ios_share,
                                color: Colors.black54,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              _textUtils.bold12("Share", Colors.black54)
                            ]),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();

                  Clipboard.setData(ClipboardData(text: widget.data.postUrl));
                  CustomToast().successToast(
                      context: context, text: "Copy Successfully..");
                },
                child: Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.link,
                          color: Colors.black54,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        _textUtils.bold12("Copy", Colors.black54)
                      ]),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(
                              child:
                                  _textUtils.bold14("QR code", Colors.black)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _textUtils.bold14(
                                    textAlign: TextAlign.center,
                                    "People can scan this QR code with\ntheir smartphone's camera to see\nthis post.",
                                    Colors.grey.shade400),
                              ],
                            ),
                          ],
                          content: StatefulBuilder(
                            builder: (BuildContext context,
                                void Function(void Function()) setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: QrImage(
                                      foregroundColor: color,
                                      dataModuleStyle: QrDataModuleStyle(
                                          dataModuleShape:
                                              QrDataModuleShape.circle,
                                          color: color),
                                      data: widget.data.postUrl,
                                      version: QrVersions.auto,

                                      size: 150,
                                      // embeddedImage: AssetImage("assets/images/instagram.png"),
                                      // embeddedImageStyle:
                                      // QrEmbeddedImageStyle(size: Size(50, 50)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 200,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: colors.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                color = colors[index];
                                                selectindex = index;
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(4),
                                              height: 32,
                                              width: 32,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: selectindex == index
                                                      ? Border.all(
                                                          width: 2,
                                                          color: Colors.black)
                                                      : null),
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: colors[index],
                                                    border: selectindex == index
                                                        ? Border.all(
                                                            width: 2,
                                                            color: Colors.white)
                                                        : null),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      });
                },
                child: Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_2,
                          color: Colors.black54,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        _textUtils.bold12("QR Code", Colors.black54)
                      ]),
                ),
              ),
            ],
          ),
          widget.userdata!.uid == FirebaseAuth.instance.currentUser!.uid
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.edit_note_rounded,
                              color: Colors.black54,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            _textUtils.bold12("Edit", Colors.black54)
                          ]),
                    ),
                    Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.archive,
                              color: Colors.black54,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            _textUtils.bold12("Archive", Colors.black54)
                          ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: Center(
                                    child: _textUtils.bold16(
                                        "Delete Post", Colors.black)),
                                content: StatefulBuilder(
                                  builder: (BuildContext context,
                                      void Function(void Function()) setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 200,
                                          width: 200,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      widget.data.postUrl),
                                                  fit: BoxFit.fill)),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(0.0),
                                          height:
                                              30.0, //MediaQuery.of(context).size.width * .08,
                                          width:
                                              90.0, //MediaQuery.of(context).size.width * .3,
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              LayoutBuilder(builder:
                                                  (context, constraints) {
                                                print(constraints);
                                                return Container(
                                                  height: constraints.maxHeight,
                                                  width: constraints.maxHeight,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              }),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: _textUtils.bold14(
                                                    "No!", Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          FirebaseQuery.firebaseQuery
                                              .deletePost(widget.data.uid);
                                          FirebaseQuery.firebaseQuery
                                              .updateUser({
                                            "post": widget.userdata!.post - 1
                                          });
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(0.0),
                                          height:
                                              30.0, //MediaQuery.of(context).size.width * .08,
                                          width:
                                              90.0, //MediaQuery.of(context).size.width * .3,
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              LayoutBuilder(builder:
                                                  (context, constraints) {
                                                print(constraints);
                                                return Container(
                                                  height: constraints.maxHeight,
                                                  width: constraints.maxHeight,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              }),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: _textUtils.bold14(
                                                    "yes!", Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.red.shade400,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              _textUtils.bold12("Delete", Colors.red.shade400),
                            ]),
                      ),
                    ),
                  ],
                )
              : Container(),
          // ListTile(
          //   title: _textUtils.bold14(
          //       "Copy Link", Colors.black),
          // ),
          // ListTile(
          //   title: _textUtils.bold14(
          //       "Hide Like Count", Colors.black),
          // ),
          // ListTile(
          //   title: _textUtils.bold14(
          //       "Delete Post", Colors.red),
          // ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

List colors = [
  Colors.black,
  Colors.red.shade400,
  Colors.amber.shade400,
  Colors.blue.shade400,
  Colors.purple.shade400,
  Colors.green.shade400,
];
