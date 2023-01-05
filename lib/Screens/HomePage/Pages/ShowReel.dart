import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/model/MyReels.dart';
import 'package:instagram/model/UserData.dart';
import 'package:video_player/video_player.dart';

class ShowReels extends StatefulWidget {
  MyReels myReels;
  UserData userData;
  ShowReels({Key? key, required this.myReels, required this.userData})
      : super(key: key);

  @override
  State<ShowReels> createState() => _ShowReelsState();
}

class _ShowReelsState extends State<ShowReels> {
   late ChewieController _chewieController;
  late VideoPlayerController _controller;
bool loading = true;
  @override
  void initState() {
        DatabaseService().User;
    DatabaseService().userPost;
    DatabaseService().userProfile;
    DatabaseService().userReels;
    DatabaseService().userStory;
    DatabaseService().usermessage;
    _controller = VideoPlayerController.network(
      widget.myReels.reelUrl,
    )..initialize().then((_) {
        setState(() {loading=false;});
      });

    _chewieController = ChewieController(
      autoInitialize: true,
      autoPlay: true,
      videoPlayerController: _controller,
      // maxScale: MediaQuery.of(context).size.height, 
      allowFullScreen: true,
      aspectRatio: 1,

      fullScreenByDefault: true,
      // showControls: false,
      showControlsOnInitialize: false 
    );
    super.initState();
  }

@override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
  double value = 0;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: loading ? Center(child: CircularProgressIndicator(),):Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
          
      ),
    );
  }
}
