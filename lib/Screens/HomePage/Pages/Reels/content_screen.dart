import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Screens/HomePage/Pages/Reels/options_screen.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:video_player/video_player.dart';

import 'heartanimation.dart';

class ContentScreen extends StatefulWidget {
  final String? src;

  const ContentScreen({Key? key, this.src}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  final TextUtils _textUtils = TextUtils();
  bool _liked = false;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src!);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  bool heart = false;
  bool isheartanimating = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      heart = true;
                      isheartanimating = true;
                    });
                  },
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading...')
                  ],
                ),
          // if (_liked)
          Center(
            child: Heartanimating(
                isAnimating: isheartanimating,
                duration: Duration(milliseconds: 700),
                child: Icon(
                  Icons.favorite,
                  size: isheartanimating ? 80 : 0,
                  color: Colors.white,
                ),
                onEnd: () => setState(() => isheartanimating = false)),
          ),
          OptionsScreen(isLike: heart,)
        ],
      ),
    );
  }
}
