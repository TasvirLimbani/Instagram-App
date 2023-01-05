import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Components/Heartanimating.dart';
import 'package:instagram/Components/ImagePopUp.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/Services/Firebase_Service.dart';
import 'package:instagram/model/MyPost.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class PersnolPhoto extends StatefulWidget {
  List<MyPost>? data;
  UserData userdata;
  PersnolPhoto({Key? key, this.data, required this.userdata}) : super(key: key);

  @override
  State<PersnolPhoto> createState() => _PersnolPhotoState();
}

class _PersnolPhotoState extends State<PersnolPhoto> {
  TextUtils _textUtils = TextUtils();
  @override
  void initState() {
    DatabaseService().User;
    DatabaseService().userPost;
    DatabaseService().userProfile;
    DatabaseService().userReels;
    DatabaseService().userStory;
    DatabaseService().usermessage;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _textUtils.bold14(widget.userdata.name, Colors.black),
                  widget.userdata.verified
                      ? const Icon(Icons.verified, color: Colors.blue, size: 13)
                      : Container(),
                ],
              ),
              _textUtils.bold12("Posts", Colors.black54),
            ],
          )),
      body: ListView.builder(
          itemCount: widget.data!.length,
          itemBuilder: (context, index) {
            return PersnolPost(
              data: widget.data![index],
              userdata: widget.userdata,
            );
          }),
    );
  }
}

class PersnolPost extends StatefulWidget {
  MyPost data;
  UserData userdata;
  PersnolPost({Key? key, required this.data, required this.userdata})
      : super(key: key);

  @override
  State<PersnolPost> createState() => _PersnolPostState();
}

class _PersnolPostState extends State<PersnolPost> {
  TextUtils _textUtils = TextUtils();
  bool isheartanimating = false;
  bool islike = false;
  late DateTime dateTime;
  List likeList = [];
  @override
  Widget build(BuildContext context) {
    dateTime = widget.data.date;
    likeList = widget.data.likes;
    likeList.contains(widget.userdata.uid) ? islike = true : islike = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: double.infinity,
        height: 530.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 5),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image(
                            height: 50.0,
                            width: 50.0,
                            image:
                                NetworkImage("${widget.userdata.profileUrl}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        _textUtils.bold14(widget.userdata.name, Colors.black),
                        widget.userdata.verified
                            ? const Icon(Icons.verified,
                                color: Colors.blue, size: 15)
                            : Container(),
                      ],
                    ),
                    subtitle: _textUtils.bold12(
                        "${timeago.format(widget.data.date)}", Colors.black),
                    // Text("${dateTime.day} " + month[dateTime.month - 1]),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_horiz),
                      color: Colors.black,
                      onPressed: () {
                        showModalBottomSheet<void>(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                          context: context,
                          builder: (BuildContext context) {
                            return ImagePopUp(
                                data: widget.data, userdata: widget.userdata);
                          },
                        );
                      },
                    ),
                  ),
                  Stack(
                    children: [
                      InkWell(
                        onDoubleTap: () {
                          islike
                              ? likeList.remove(widget.userdata.uid)
                              : likeList.contains(widget.userdata.uid)
                                  ? null
                                  : likeList.add(widget.userdata.uid);
                          FirebaseQuery.firebaseQuery
                              .updatePost(widget.data.uid, {"likes": likeList});
                          setState(() {
                            isheartanimating = true;
                            islike = !islike;
                          });
                        },
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => ViewPostScreen(
                          //       post: posts[index],
                          //     ),
                          //   ),
                          // );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          width: double.infinity,
                          // height: widget.myPost.postUrl.length*1.9,
                          height: 370,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            // boxShadow: const [
                            //   BoxShadow(
                            //     color: Colors.black45,
                            //     offset: Offset(0, 5),
                            //     blurRadius: 8.0,
                            //   ),
                            // ],
                            image: DecorationImage(
                              image: NetworkImage(widget.data.postUrl),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Heartanimating(
                            isAnimating: isheartanimating,
                            duration: const Duration(milliseconds: 700),
                            child: Icon(
                              Icons.favorite,
                              size: isheartanimating ? 80 : 0,
                              color: islike ? Colors.blueGrey : Colors.black26,
                            ),
                            onEnd: () =>
                                setState(() => isheartanimating = false)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                      islike
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          islike ? Colors.red.shade300 : null),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    islike
                                        ? likeList.remove(widget.userdata.uid)
                                        : likeList.contains(widget.userdata.uid)
                                            ? null
                                            : likeList.add(widget.userdata.uid);
                                    FirebaseQuery.firebaseQuery.updatePost(
                                        widget.data.uid, {"likes": likeList});
                                    setState(() {
                                      // isheartanimating = true;
                                      islike = !islike;
                                    });
                                  },
                                ),
                                Text(
                                  '${widget.data.likes.length}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20.0),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.chat),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) => ViewPostScreen(
                                    //       post: posts[index],
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                ),
                                Text(
                                  '${widget.data.comments.length}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          iconSize: 30.0,
                          onPressed: () => print('Save post'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List month = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
