import 'package:flutter/material.dart';
import 'package:instagram/utils/Text_utils.dart';

import 'heartanimation.dart';

class OptionsScreen extends StatefulWidget {
   bool? isLike;
   OptionsScreen({Key? key, this.isLike}) : super(key: key);
  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  final TextUtils _textUtils = TextUtils();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person, size: 18),
                        radius: 16,
                      ),
                      SizedBox(width: 6),
                      _textUtils.bold14("Test_User_",Colors.white),
                      SizedBox(width: 10),
                      Icon(Icons.verified, size: 15,color: Colors.blue,),
                      SizedBox(width: 6),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 6),
                  _textUtils.bold12("Greeting from instagram 💙❤💛 ..",Colors.white),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 15,
                        color: Colors.white,
                      ),
 _textUtils.bold12("Original Audio - some music track--",Colors.white),                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Heartanimating(
                    isAnimating: widget.isLike!,
                    alwaysAnimated: true,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            widget.isLike = !widget.isLike!;
                          });
                          // !widget.post.liked!
                          //     ? _newsNotifier.like(widget.index)
                          //     : _newsNotifier.dislike(widget.index);
                          //  _update();
                        },
                        child: widget.isLike!
                            ? Icon(
                                Icons.favorite,
                                size: 28,
                                color: Colors.red[900],
                              )
                            : Icon(
                                Icons.favorite_border,
                                size: 28,color: Colors.white,
                              )),
                  ),
                  // _textUtils,
                  SizedBox(height: 20),
                  Icon(Icons.comment_rounded,color: Colors.white,),
_textUtils.bold10("0",Colors.white)    ,              SizedBox(height: 20),
                  Transform(
                    transform: Matrix4.rotationZ(5.8),
                    child: Icon(Icons.send, color: Colors.white,),
                  ),
                  SizedBox(height: 50,),
                  Icon(Icons.more_vert, color: Colors.white,),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
