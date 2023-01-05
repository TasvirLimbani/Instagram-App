import 'package:flutter/material.dart';
import 'package:instagram/Components/Heartanimating.dart';
import 'package:instagram/Components/ImagePopUp.dart';
import 'package:instagram/Screens/HomePage/Pages/PersnolPhoto.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/model/MyPost.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';

class Posts extends StatefulWidget {
  MyPost myPost;
  UserData? userData;
  Posts({Key? key, required this.myPost, required this.userData})
      : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  TextUtils _textUtils = TextUtils();
  bool isheartanimating = false;
  bool islike = false;
  late DateTime dateTime;
  List likeList = [];
  @override
  Widget build(BuildContext context) {
    dateTime = widget.myPost.date;
    likeList = widget.myPost.likes;
    likeList.contains(widget.userData!.uid) ? islike = true : islike = false;
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
                      child:  CircleAvatar(
                        child: ClipOval(
                          child: Image(
                            height: 50.0,
                            width: 50.0,
                            image: NetworkImage(
                                widget.userData!.profileUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        _textUtils.bold14(widget.userData!.name, Colors.black),
                        widget.userData!.verified
                            ? const Icon(Icons.verified,
                                color: Colors.blue, size: 15)
                            : Container(),
                      ],
                    ),
                    subtitle:
                        _textUtils.normal12("${dateTime.day} " + month[dateTime.month - 1]+", ${dateTime.year}", Colors.grey.shade600),
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
                            return  ImagePopUp(data: widget.myPost, userdata: widget.userData);       },
                        );
                      },
                    ),
                  ),
                  Stack(
                    children: [
                      InkWell(
                        onDoubleTap: () {
                          islike
                              ? likeList.remove(widget.userData!.uid)
                              : likeList.contains(widget.userData!.uid)
                                  ? null
                                  : likeList.add(widget.userData!.uid);
                          FirebaseQuery.firebaseQuery.updatePost(
                              widget.myPost.uid, {"likes": likeList});
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
                              image: NetworkImage(widget.myPost.postUrl),
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
                                        ? likeList.remove(widget.userData!.uid)
                                        : likeList
                                                .contains(widget.userData!.uid)
                                            ? null
                                            : likeList
                                                .add(widget.userData!.uid);
                                    FirebaseQuery.firebaseQuery.updatePost(
                                        widget.myPost.uid, {"likes": likeList});
                                    setState(() {
                                      // isheartanimating = true;
                                      islike = !islike;
                                    });
                                  },
                                ),
                                Text(
                                  '${widget.myPost.likes.length}',
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
                                  '${widget.myPost.comments.length}',
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
