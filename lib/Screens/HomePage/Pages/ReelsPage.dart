import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instagram/Screens/HomePage/Pages/Reels/home_page.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:video_player/video_player.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  @override
  Widget build(BuildContext context) {
    return ReelsHomePage();
  }
}

// class ReelsWidget extends StatefulWidget {
//   const ReelsWidget({Key? key}) : super(key: key);

//   @override
//   State<ReelsWidget> createState() => _ReelsWidgetState();
// }

// class _ReelsWidgetState extends State<ReelsWidget> {
//   final TextUtils _textUtils = TextUtils();

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Container(
//       margin: EdgeInsets.only(bottom: 15),
//       width: size.width,
//       height: size.height * 0.9,
//       decoration: BoxDecoration(
//         color: Colors.black12,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Stack(
//         children: [
//           Align(
//             child: Container(
//               width: double.infinity,
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 // color: Colors.black12,
//                 // image: DecorationImage(image: NetworkImage("https://www.pexels.com/video/portrait-of-a-woman-talking-over-the-phone-3205789/")),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(30),
//                       child: VideoPlayer(_controller)),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black12,
//                       // image: DecorationImage(image: NetworkImage("https://www.pexels.com/video/portrait-of-a-woman-talking-over-the-phone-3205789/")),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 10,
//             left: 15,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                     radius: 20,
//                     backgroundImage: NetworkImage(
//                         "https://images.unsplash.com/photo-1488161628813-04466f872be2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fHBlb3BsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60")),
//                 SizedBox(width: 10),
//                 _textUtils.bold14("Tezt_User_", Colors.white),
//                 SizedBox(width: 10),
//                 Icon(
//                   Icons.verified,
//                   color: Colors.blue,
//                   size: 17,
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 70,
//             right: 5,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: const [
//                 Icon(
//                   Icons.favorite_outline,
//                   color: Colors.white,
//                   size: 35,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Icon(
//                   Icons.comment_bank_outlined,
//                   color: Colors.white,
//                   size: 35,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Icon(
//                   Icons.ios_share_rounded,
//                   color: Colors.white,
//                   size: 35,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

