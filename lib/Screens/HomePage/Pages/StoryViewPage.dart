import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instagram/Components/TextFromFiled.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/model/MyStory.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

final mycontroller = StoryController();

class StoryViewPage extends StatefulWidget {
  List<MyStory> myStory;
  StoryViewPage({Key? key, required this.myStory}) : super(key: key);

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  final TextEditingController _storyController = TextEditingController();
  final TextUtils _textUtils = TextUtils();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            StoryView(
              controller: mycontroller,
              storyItems: widget.myStory
                  .map((e) => StoryItem.pageImage(
                        imageFit: BoxFit.fill,
                        // caption: "Flowers",
                        url: e.storyUrl,
                        controller: mycontroller,
                      ))
                  .toList(),
              // [

              //         :  StoryItem.pageVideo(
              //   imageFit: BoxFit.fill,
              //  widget.myStory.storyUrl,
              //   controller: mycontroller),
              // ],
              inline: false,
              onComplete: () {
                Navigator.pop(context);
              },
            ),
            // _textUtils.bold14("Test_User_", Colors.white),

            //   Container(
            //               // height: 50,
            //               margin: const EdgeInsets.symmetric(horizontal: 0),
            //               decoration: BoxDecoration(
            //                 color: Colors.grey.shade300,
            //                 borderRadius: BorderRadius.circular(30),
            //               ),
            //               child: EditTextFiled(
            //                 textStyle: const TextStyle(
            //                     color: Colors.black,
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.bold),
            //                 hintText: "Message",
            //                 controller: _storyController,
            //                 validator: (value) {
            //                   if (value!.isEmpty) {
            //                     return "Message";
            //                   }
            //                   return null;
            //                 },
            //                 onChanged: (value) {
            //                   setState(() {
            //                     // userInput = value;
            //                   });
            //                 },
            //                 suffix: Row(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     IconButton(
            //                         icon: const Icon(Icons.photo,
            //                             color: Colors.black), onPressed: () {  },
            //                     ),
            //                     IconButton(
            //                         icon: const Icon(Icons.send,
            //                             color: Colors.black), onPressed: () {  },

            //                     ),
            //                   ],
            //                 ),
            //                 padding: const EdgeInsets.symmetric(horizontal: 12),
            //                 style:
            //                     const TextStyle(fontSize: 14, color: Colors.grey),
            //                 border: OutlineInputBorder(
            //                     borderRadius: BorderRadius.circular(30),
            //                     borderSide: BorderSide(
            //                         color: Colors.grey.shade400, width: 1)),
            //                 onSaved: (value) {
            //                   setState(() {
            //                     // username = value!;
            //                   });
            //                 },
            //               ),
            //             ),
          ],
        ),
      ),
    );
  }
}

final List<StoryItem> storyItems = [
  StoryItem.text(
    title: "My First Story",
    backgroundColor: Colors.blue,
    textStyle: TextStyle(
      fontSize: 25,
    ),
  ),
  StoryItem.pageVideo(
      imageFit: BoxFit.fill,
      "https://ak.picdn.net/shutterstock/videos/1063241245/preview/stock-footage-fun-d-cartoon-american-referee-with-a-sign.webm",
      controller: mycontroller),
  StoryItem.pageImage(
    imageFit: BoxFit.fill,
    // caption: "Flowers",
    url:
        "https://images.unsplash.com/photo-1612548403247-aa2873e9422d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHZpZGVvfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
    controller: mycontroller,
  ),
];
