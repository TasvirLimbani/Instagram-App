import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:instagram/Screens/Profile/Clock.dart';
import 'package:instagram/Screens/Profile/Tearms_of_Use.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/biometricx/biometricx.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:pattern_lock/pattern_lock.dart';

class SettingPage extends StatefulWidget {
  UserData userData;
  SettingPage({Key? key, required this.userData}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  bool privetSwitch = true;
  bool activeSwitch = true;
  bool notificationSwitch = true;
  bool showPassword = false;
  final TextUtils _textUtils = TextUtils();
  late ConfettiController _controllerCenter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: size.height * 0.35,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.blue),
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Neumorphic(
                              curve: Curves.bounceIn,
                              style: const NeumorphicStyle(
                                  color: Colors.blue, depth: -3),
                              child: Container(
                                width: 150,
                                height: 35,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _textUtils.bold14("${widget.userData.name}",
                                        Colors.black),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    widget.userData.verified
                                        ? Icon(Icons.verified,
                                            color: Colors.black, size: 15)
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            Neumorphic(
                              curve: Curves.bounceIn,
                              style: const NeumorphicStyle(
                                  color: Colors.blue, depth: -3),
                              child: Container(
                                width: 150,
                                height: 35,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _textUtils.bold14("Request to verified",
                                        Colors.black),
                                    
                                  ],
                                ),
                              ),
                            ),
                            // Neumorphic(
                            //   curve: Curves.bounceIn,
                            //   style: const NeumorphicStyle(
                            //       color: Colors.blue, depth: -3),
                            //   child: Container(
                            //     width: 180,
                            //     height: 35,
                            //     child: Row(
                            //       //  mainAxisSize: MainAxisSize.min,
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Text(
                            //           "Password : ${showPassword ? widget.userData.password : "*******"}",
                            //           maxLines: 1,
                            //           overflow: TextOverflow.ellipsis,
                            //           style: TextStyle(
                            //               color: Colors.black,
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.bold),
                            //         ),
                            //         SizedBox(
                            //           width: 5,
                            //         ),
                            //         GestureDetector(
                            //             onTap: () {
                            //               showModalBottomSheet<void>(
                            //                 backgroundColor: Colors.transparent,
                            //                 shape: const RoundedRectangleBorder(
                            //                     borderRadius: BorderRadius.only(
                            //                   topLeft: Radius.circular(20),
                            //                   topRight: Radius.circular(20),
                            //                 )),
                            //                 context: context,
                            //                 builder: (BuildContext context) {
                            //                   return biometricx();
                            //                 },
                            //               );

                            //               // setState(() {
                            //               // showDialog(context: context, builder: (context) {
                            //               //   return AlertDialog(
                            //               //     content: PatternLock(
                            //               //     selectedColor: Colors.red,
                            //               //     pointRadius: 8,
                            //               //     showInput: true,
                            //               //     dimension: 3,
                            //               //     relativePadding: 0.7,
                            //               //     selectThreshold: 25,
                            //               //     fillPoints: true,
                            //               //     onInputComplete:
                            //               //         (List<int> input) {
                            //               //       print("pattern is $input");
                            //               //     },
                            //               //     notSelectedColor: Colors.grey
                            //               //   ),
                            //               //   );
                            //               // });
                            //               //   biometricxclass.Auth.CheckBio();
                            //               //   showPassword = !showPassword;
                            //               // });
                            //             },
                            //             child: Icon(
                            //                 showPassword
                            //                     ? Icons.visibility_off
                            //                     : Icons.visibility,
                            //                 size: 18)),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     AnalogClock(),
                        //     Column(
                        //       children: [
                        //          Neumorphic(
                        //           style: const NeumorphicStyle(depth: -3,color: Colors.blue),
                        //           child: SizedBox(width: 100,height: 30,child: Center(child: _textUtils.bold14("Your Birthday", Colors.black),),),
                        //         ),
                        //         SizedBox(height: 5,),
                        //         Neumorphic(
                        //           style: const NeumorphicStyle(depth: -3,color: Colors.blue),
                        //           child: SizedBox(width: 150,height: 30,child: Center(child: _textUtils.bold14("${widget.userData.birthDate.day} / ${month[widget.userData.birthDate.month-1]} / ${widget.userData.birthDate.year}", Colors.black),),),
                        //         ),

                        //       ],
                        //     ),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Neumorphic(
                              curve: Curves.bounceIn,
                              style: const NeumorphicStyle(
                                  color: Colors.blue, depth: -3),
                              child: Container(
                                width: 85,
                                height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _textUtils.bold20("${widget.userData.post}",
                                        Colors.black),
                                    const SizedBox(height: 5),
                                    _textUtils.bold14("Posts", Colors.black),
                                  ],
                                ),
                              ),
                            ),
                            Neumorphic(
                              curve: Curves.bounceIn,
                              style: const NeumorphicStyle(
                                  color: Colors.blue, depth: -3),
                              child: Container(
                                width: 85,
                                height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _textUtils.bold20(
                                        "${widget.userData.followers > 1000000 ? widget.userData.followers.toString().split("0").first + "M" : widget.userData.followers > 999 ? widget.userData.followers.toString().split("0").first + "K" : widget.userData.followers}",
                                        Colors.black),
                                    const SizedBox(height: 5),
                                    _textUtils.bold14("Followers", Colors.black)
                                  ],
                                ),
                              ),
                            ),
                            Neumorphic(
                              // curve: Curves.bounceInOut,
                              style: const NeumorphicStyle(
                                  color: Colors.blue, depth: -3),
                              child: Container(
                                width: 85,
                                height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _textUtils.bold20(
                                        "${widget.userData.following}",
                                        Colors.black),
                                    const SizedBox(height: 5),
                                    _textUtils.bold14("Following", Colors.black)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -60,
                    left: 0,
                    right: 0,
                    child: Stack(
                      children: [
                        Center(
                          child: ConfettiWidget(
                                    confettiController: _controllerCenter,
                                    blastDirectionality:
                                        BlastDirectionality.explosive,
                                    // shouldLoop: true,
                                    colors: const [
                                      Colors.green,
                                      Colors.blue,
                                      Colors.pink,
                                      Colors.orange,
                                      Colors.purple
                                    ],
                                    createParticlePath: drawStar,
                                  ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                                 _controllerCenter.play();
                            },
                            child: Container(
                              height: size.height * 0.17,
                              width: size.height * 0.17,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    offset: const Offset(0, 4),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                  ),
                                  // BoxShadow(
                                  //   color: Color.fromRGBO(0, 0, 0, 0.12),
                                  //   offset: Offset(0, -12),
                                  //   blurRadius: 30,
                                  //   spreadRadius: 0,
                                  // ),
                                  // BoxShadow(
                                  //   color: Color.fromRGBO(0, 0, 0, 0.12),
                                  //   offset: Offset(0, 4),
                                  //   blurRadius: 6,
                                  //   spreadRadius: 0,
                                  // ),
                                  // BoxShadow(
                                  //   color: Color.fromRGBO(0, 0, 0, 0.17),
                                  //   offset: Offset(0, 12),
                                  //   blurRadius: 13,
                                  //   spreadRadius: 0,
                                  // ), // Box Shadow
                                  // BoxShadow(
                                  //   color: Color.fromRGBO(0, 0, 0, 0.09),
                                  //   offset: Offset(0, -3),
                                  //   blurRadius: 5,
                                  //   spreadRadius: 0,
                                  // ),
                                ],
                                color: Colors.white,
                                border: Border.all(
                                  width: 5,
                                  color: Colors.white,
                                ),
                                image: DecorationImage(
                                    image: NetworkImage(widget.userData.profileUrl),
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: _textUtils.bold16("Private account", Colors.black),
                trailing: CupertinoSwitch(
                    activeColor: Colors.blue,
                    value: widget.userData.is_public,
                    onChanged: (value) {
                      setState(() {
                        widget.userData.is_public = value;
                        FirebaseQuery.firebaseQuery.updateUser({
                          "is_public": value,
                        });
                      });
                    }),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
                height: 0,
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                leading: const Icon(Icons.online_prediction),
                title: _textUtils.bold16("Show Activity Status", Colors.black),
                trailing: CupertinoSwitch(
                    activeColor: Colors.blue,
                    value: widget.userData.show_active_status,
                    onChanged: (value) {
                      setState(() {
                        widget.userData.show_active_status = value;
                        FirebaseQuery.firebaseQuery
                            .updateUser({"show_active_status": value});
                      });
                    }),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
                height: 0,
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active),
                title:
                    _textUtils.bold16("Pause All Notification", Colors.black),
                trailing: CupertinoSwitch(
                    activeColor: Colors.blue,
                    value: widget.userData.push_notification,
                    onChanged: (value) {
                      setState(() {
                        widget.userData.push_notification = value;
                        FirebaseQuery.firebaseQuery
                            .updateUser({"push_notification": value});
                      });
                    }),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
                height: 0,
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: _textUtils.bold16("Privacy Policy", Colors.black),
                  trailing: const Icon(Icons.navigate_next_rounded)),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
                height: 0,
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TermsOfUse()));
                },
                  leading: const Icon(Icons.contact_support),
                  title: _textUtils.bold16("Terms of Use", Colors.black),
                  trailing: const Icon(Icons.navigate_next_rounded)),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "assets/images/black.png",
                    width: 25,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  _textUtils.bold14("Meta", Colors.black),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  _textUtils.bold14("Accouns Center", Colors.blue.shade300),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  _textUtils.bold12(
                      "Control settings for connected experiences across\nInstagram, the Facebook app and Messenger, including\nstory and post sharing and logging in.",
                      Colors.grey),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
            ],
          ),
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
