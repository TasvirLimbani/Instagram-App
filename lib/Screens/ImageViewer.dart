import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class ImageViewer extends StatefulWidget {
  String image;
  ImageViewer({Key? key, required this.image}) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
                // boundaryMargin: EdgeInsets.all(80),
                panEnabled: false,
                scaleEnabled: true,
                minScale: 1.0,
                maxScale: 2.2,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.image), fit: BoxFit.cover),),
                ),),
          ),
           Container(
            margin: EdgeInsets.only(top: 20),
             child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),),
           ),
        ],
      ),
    );
  }
 
}
