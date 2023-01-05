// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:instagram/Components/Toast.dart';
import 'package:instagram/Screens/HomePage/HomeScreen.dart';
import 'package:instagram/Screens/Signup/Signup_Screen.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/Services/Firebase_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dropdownValue = 'English';

  // TextEditingController usernameController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();

  // int buttonColor = 0xff26A9FF;

  bool inputTextNotNull = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String username = "";
  String password = "";
  bool passwordShow = true;
  bool home = false;
@override
  void initState() {
    // TODO: implement initState
        // disableCapture();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double deviseWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: home
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //    Container(
                      // width: MediaQuery.of(context).size.width,
                      // alignment: Alignment.topCenter,
                      // child: DropdownButton<String>(
                      //   dropdownColor: Colors.white,
                      //   value: dropdownValue,
                      //   icon: const Icon(Icons.arrow_drop_down),
                      //   iconSize: 24,
                      //   elevation: 10,
                      //   style: const TextStyle(color: Colors.black),
                      //   underline: Container(),
                      //   onChanged: (newValue) {
                      //     setState(() {
                      //       dropdownValue = newValue!;
                      //     });
                      //   },
                      //   items: <String>['English', 'Arabic', 'Italian', 'French']
                      //       .map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(
                      //         value,
                      //         style: const TextStyle(fontSize: 16),
                      //       ),
                      //     );
                      //   }).toList(),
                      // )),
                      Image.asset(
                        'assets/images/instagram_logo.png',
                        height: deviseWidth * .20,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Container(
                        width: deviseWidth * .90,
                        height: deviseWidth * .14,
                        decoration: const BoxDecoration(
                          color: Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  if (_usernameController.text.length >= 2 &&
                                      _passwordController.text.length >= 2) {
                                    inputTextNotNull = true;
                                  } else {
                                    inputTextNotNull = false;
                                  }
                                });
                              },
                              controller: _usernameController,
                              style: TextStyle(
                                fontSize: deviseWidth * .040,
                              ),
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Phone number , email or username',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviseWidth * .04,
                      ),
                      Container(
                        width: deviseWidth * .90,
                        height: deviseWidth * .14,
                        decoration: const BoxDecoration(
                          color: Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Center(
                                child: TextField(
                                  onChanged: (text) {
                                    setState(() {
                                      if (_usernameController.text.length >= 2 &&
                                          _passwordController.text.length >= 2) {
                                        inputTextNotNull = true;
                                      } else {
                                        inputTextNotNull = false;
                                      }
                                    });
                                  },
                                  controller: _passwordController,
                                  obscureText: passwordShow,
                                  style: TextStyle(
                                    fontSize: deviseWidth * .040,
                                  ),
                                  
                                  decoration: const InputDecoration.collapsed(

                                    hintText: 'Password',
                                  ),
                                ),
                                
                              ),
                            ),
                            Positioned(right: 0,top: 5,child: IconButton(onPressed: (){
                              setState(() {
                                passwordShow=!passwordShow;
                              });
                            }, icon: Icon(!passwordShow?Icons.visibility_off:Icons.visibility,color: Colors.grey,)))
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {},
                                child: const Text("Forgot Password?"))),
                      ),
                      SizedBox(
                        height: 50,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              home = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              try {
                                User? user = await FirebaseHelper.Auth
                                    .LoginwithEmailandPassword(
                                        email: _usernameController.text,
                                        password: _passwordController.text);

                                if (user != null) {
                             
                                  CustomToast().successToast(
                                      context: context,
                                      text: "Login Successfuly");
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()),
                                      (route) => false);
                                }
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  home = false;
                                });
                                print(e.code);
                                switch (e.code) {
                                  case "user-not-found":
                                    setState(() {
                                      home = false;
                                    });
                                    CustomToast().errorToast(
                                        context: context,
                                        text: "No user found for that email.");

                                    break;
                                  case "wrong-password":
                                    setState(() {
                                      home = false;
                                    });
                                    CustomToast().errorToast(
                                        context: context,
                                        text:
                                            "Your email or password is incorrect");
                                    break;
                                  default:
                                    setState(() {
                                      home = false;
                                    });
                                    CustomToast().errorToast(
                                        context: context, text: "${e.message}");
                                }
                              }
                            }
                          },
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: deviseWidth * .040,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(
                            indent: 20,
                            endIndent: 20,
                          )),
                          Text(
                            "OR",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          const Expanded(
                              child: Divider(
                            indent: 20,
                            endIndent: 20,
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/facebook.png',
                            height: deviseWidth * .060,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Login with facebook',
                            style: TextStyle(
                              color: const Color(0xff1877f2),
                              fontSize: deviseWidth * .040,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                            },
                            child: Text(
                              "Sign up.",
                              style: TextStyle(color: Colors.blue.shade400),
                            ),
                          ),
                        ],
                      ), // GradientText(
                      //   "Instagram To Facebook",
                      //   style: TextStyle(fontSize: 13),
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Color(0xff833ab4),
                      //       Color(0xfffd1d1d),
                      //       Color(0xfffcb045),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
    );

    //  Scaffold(
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: ConstrainedBox(
    //         constraints: BoxConstraints(
    //           minHeight: MediaQuery.of(context).size.height - 90,
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Container(
    //                 width: MediaQuery.of(context).size.width,
    //                 alignment: Alignment.topCenter,
    //                 child: DropdownButton<String>(
    //                   dropdownColor: Colors.white70,
    //                   value: dropdownValue,
    //                   icon: const Icon(Icons.arrow_drop_down),
    //                   iconSize: 24,
    //                   elevation: 10,
    //                   style: const TextStyle(color: Colors.black54),
    //                   underline: Container(),
    //                   onChanged: (newValue) {
    //                     setState(() {
    //                       dropdownValue = newValue!;
    //                     });
    //                   },
    //                   items: <String>['English', 'Arabic', 'Italian', 'French']
    //                       .map<DropdownMenuItem<String>>((String value) {
    //                     return DropdownMenuItem<String>(
    //                       value: value,
    //                       child: Text(
    //                         value,
    //                         style: const TextStyle(fontSize: 16),
    //                       ),
    //                     );
    //                   }).toList(),
    //                 )),
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Image.asset(
    //                   'assets/images/instagram_logo.png',
    //                   height: deviseWidth * .20,
    //                 ),
    //                 SizedBox(
    //                   height: deviseWidth * .05,
    //                 ),
    //                 Container(
    //                   width: deviseWidth * .90,
    //                   height: deviseWidth * .14,
    //                   decoration: const BoxDecoration(
    //                     color: Color(0xffE8E8E8),
    //                     borderRadius: BorderRadius.all(Radius.circular(5)),
    //                   ),
    //                   child: Padding(
    //                     padding: const EdgeInsets.symmetric(horizontal: 15),
    //                     child: Center(
    //                       child: TextField(
    //                         onChanged: (text) {
    //                           setState(() {
    //                             if (usernameController.text.length >= 2 &&
    //                                 passwordController.text.length >= 2) {
    //                               inputTextNotNull = true;
    //                             } else {
    //                               inputTextNotNull = false;
    //                             }
    //                           });
    //                         },
    //                         controller: usernameController,
    //                         style: TextStyle(
    //                           fontSize: deviseWidth * .040,
    //                         ),
    //                         decoration: const InputDecoration.collapsed(
    //                           hintText: 'Phone number , email or username',
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: deviseWidth * .04,
    //                 ),
    //                 Container(
    //                   width: deviseWidth * .90,
    //                   height: deviseWidth * .14,
    //                   decoration: const BoxDecoration(
    //                     color: Color(0xffE8E8E8),
    //                     borderRadius:
    //                         const BorderRadius.all(Radius.circular(5)),
    //                   ),
    //                   child: Padding(
    //                     padding: const EdgeInsets.symmetric(horizontal: 15),
    //                     child: Center(
    //                       child: TextField(
    //                         onChanged: (text) {
    //                           setState(() {
    //                             if (usernameController.text.length >= 2 &&
    //                                 passwordController.text.length >= 2) {
    //                               inputTextNotNull = true;
    //                             } else {
    //                               inputTextNotNull = false;
    //                             }
    //                           });
    //                         },
    //                         controller: passwordController,
    //                         obscureText: true,
    //                         style: TextStyle(
    //                           fontSize: deviseWidth * .040,
    //                         ),
    //                         decoration: const InputDecoration.collapsed(
    //                           hintText: 'Password',
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: deviseWidth * .04,
    //                 ),
    //                 inputTextNotNull
    //                     ? GestureDetector(
    //                         onLongPressStart: (s) {
    //                           setState(() {
    //                             buttonColor = 0xff78C9FF;
    //                           });
    //                         },
    //                         onLongPressEnd: (s) {
    //                           setState(() {
    //                             buttonColor = 0xff26A9FF;
    //                           });
    //                         },
    //                         onTap: () {
    //                           print('Log In');
    //                         },
    //                         child: Container(
    //                           width: deviseWidth * .90,
    //                           height: deviseWidth * .14,
    //                           decoration: BoxDecoration(
    //                             color: Color(buttonColor),
    //                             borderRadius: const BorderRadius.all(
    //                                 const Radius.circular(5)),
    //                           ),
    //                           child: Center(
    //                             child: Text(
    //                               'Log In',
    //                               style: TextStyle(
    //                                 color: Colors.white,
    //                                 fontSize: deviseWidth * .040,
    //                                 fontWeight: FontWeight.bold,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       )
    //                     : Container(
    //                         width: deviseWidth * .90,
    //                         height: deviseWidth * .14,
    //                         decoration: const BoxDecoration(
    //                           color: const Color(0xff78C9FF),
    //                           borderRadius: const BorderRadius.all(
    //                               const Radius.circular(5)),
    //                         ),
    //                         child: Center(
    //                           child: Text(
    //                             'Log In',
    //                             style: TextStyle(
    //                               color: Colors.white,
    //                               fontSize: deviseWidth * .040,
    //                               fontWeight: FontWeight.bold,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                 SizedBox(
    //                   height: deviseWidth * .035,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       'Forgot your login details? ',
    //                       style: TextStyle(
    //                         fontSize: deviseWidth * .035,
    //                       ),
    //                     ),
    //                     GestureDetector(
    //                       onTap: () {
    //                         print('Get help');
    //                       },
    //                       child: Text(
    //                         'Get help',
    //                         style: TextStyle(
    //                           fontSize: deviseWidth * .035,
    //                           color: const Color(0xff002588),
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: deviseWidth * .040,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Container(
    //                       height: 1,
    //                       width: deviseWidth * .40,
    //                       color: const Color(0xffA2A2A2),
    //                     ),
    //                     const SizedBox(
    //                       width: 10,
    //                     ),
    //                     Text(
    //                       'OR',
    //                       style: TextStyle(
    //                         fontSize: deviseWidth * .040,
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       width: 10,
    //                     ),
    //                     Container(
    //                       height: 1,
    //                       width: deviseWidth * .40,
    //                       color: const Color(0xffA2A2A2),
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: deviseWidth * .06,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Image.asset(
    //                       'assets/images/facebook.png',
    //                       height: deviseWidth * .060,
    //                     ),
    //                     const SizedBox(
    //                       width: 5,
    //                     ),
    //                     Text(
    //                       'Login with facebook',
    //                       style: TextStyle(
    //                         color: const Color(0xff1877f2),
    //                         fontSize: deviseWidth * .040,
    //                         fontWeight: FontWeight.w800,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             Container(
    //               width: deviseWidth,
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Container(
    //                     width: deviseWidth,
    //                     height: 1,
    //                     color: const Color(0xffA2A2A2),
    //                   ),
    //                   const SizedBox(
    //                     height: 5,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Text(
    //                         "Don't have an account? ",
    //                         style: TextStyle(
    //                           fontSize: deviseWidth * .040,
    //                         ),
    //                       ),
    //                       GestureDetector(
    //                         onTap: () {
    //                           print('Sing up');
    //                         },
    //                         child: Text(
    //                           'Sing up',
    //                           style: TextStyle(
    //                             color: const Color(0xff00258B),
    //                             fontSize: deviseWidth * .040,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
  //  Future<void> disableCapture() async {
  //   //disable screenshots and record screen in current screen
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
}
