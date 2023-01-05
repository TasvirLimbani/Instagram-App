// ignore_for_file: use_build_context_synchronously, avoid_print, avoid_returning_null_for_void
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Components/TextFromFiled.dart';
import 'package:instagram/Screens/Login.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/Services/Firebase_Service.dart';

// ignore: must_be_immutable
class PasswordScreen extends StatefulWidget {
  String email;
  PasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  String password = "";
  String userInput = "";
  String usenameerror = "";
  bool login = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: login
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Center(
                    child: Text(
                      "Create a password",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      "We cam remember the password, so you\nwon't need to enter it on your devices.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: EditTextFiled(
                      hintText: "Password",
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          userInput = value;
                        });
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.grey.shade400, width: 1)),
                      onSaved: (value) {
                        setState(() {
                          password = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        onPressed: userInput.length < 6
                            ? null
                            : () async {
                                setState(() {
                                  login = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  User? user = await FirebaseHelper.Auth
                                      .RagisterwithEmailandPassword(
                                          email: widget.email,
                                          password: password);
                                          
                                  FirebaseQuery.firebaseQuery
                                      .insertuser(user!.uid, {
                                    "email": widget.email,
                                    "password": _passwordController.text,
                                    "post":0,
                                    "followers":0,
                                    "following":0,  
                                    // "my_posts":[],
                                    // "my_reels":[],
                                    // "tag_post":[],
                                    // "highlight":[],
                                    "profile_pic":"https://cdn-icons-png.flaticon.com/512/149/149071.png",
                                    "name":widget.email.split("@").first,
                                    "phone":"",
                                    "bio":"",
                                    "website":"",
                                    "birth_date":DateTime.now() ,
                                    "gender":"",
                                    "verified":false,
                                    "status":"Offline",
                                    "is_public":true,
                                    "show_active_status":true,
                                    "push_notification":true,
                                    
                                  });
                                  if (user != null) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                        (route) => false);
                                  }

                                  //   switch (e.code) {
                                  //     case "The account already exists for that email":
                                  //       setState(() {
                                  //         usenameerror =
                                  //             "The account already exists for that email";
                                  //       });
                                  //       break;
                                  //     case "weak-password":
                                  //       Fluttertoast.showToast(
                                  //         msg: 'Your Password is Week',
                                  //         toastLength: Toast.LENGTH_SHORT,
                                  //         gravity: ToastGravity.BOTTOM,
                                  //       );
                                  //       break;
                                  //     default:
                                  //       Fluttertoast.showToast(
                                  //         msg: e.code,
                                  //         toastLength: Toast.LENGTH_SHORT,
                                  //         gravity: ToastGravity.BOTTOM,
                                  //       );
                                  //   }
                                  // }
                                }
                              },
                        child: const Text("Next"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
