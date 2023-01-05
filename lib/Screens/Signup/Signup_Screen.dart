import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram/Components/TextFromFiled.dart';
import 'package:instagram/Screens/Signup/Password_Screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  String username = "";
  String userInput = "";
  bool nextPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: nextPage
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
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Center(
                    child: Text(
                      "Create username",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      "Choose a username for your new account.\nYou can always change it later.",
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
                      hintText: "Username",
                      controller: _usernameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Username";
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
                          username = value!;
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
                        onPressed: userInput.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  nextPage = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  Timer((const Duration(milliseconds: 600)),
                                      () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PasswordScreen(
                                                  email: username,
                                                )));
                                  });
                                }
                                Timer((const Duration(milliseconds: 700)), () {
                                  setState(() {
                                    nextPage = false;
                                  });
                                });
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
