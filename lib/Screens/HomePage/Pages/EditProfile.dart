import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Components/Toast.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';
import 'package:uuid/uuid.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextUtils _textUtils = TextUtils();
  File? imageFile;
  bool postUpload = false;
  DateTime dateTime = DateTime.now();
  Future getImageGallery() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
        Navigator.of(context).pop();
        setState(() {
          postUpload = true;
        });
      }
    });
  }

  Future getImageCamera() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
      }
    });
  }

  Future uploadImage() async {
    String filename = const Uuid().v1();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    int status = 1;
    var ref =
        FirebaseStorage.instance.ref().child(userId).child("$filename.jpg");
    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      setState(() {
        postUpload = false;
      });
      status = 0;
    });
    if (status == 1) {
      String ImageUrl = await uploadTask.ref.getDownloadURL();
      FirebaseQuery.firebaseQuery.updateUser({
        "profile_pic": ImageUrl,
      });

      log(ImageUrl);
      setState(() {
        postUpload = false;
      });
    }
  }

  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1949),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        _dateController.text =
            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
      });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String dropdownValue = 'Male';
  bool loading = false;
  

  @override
  void initState() {
        DatabaseService().User;
    DatabaseService().userPost;
    DatabaseService().userProfile;
    DatabaseService().userReels;
    DatabaseService().userStory;
    DatabaseService().usermessage;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: DatabaseService().User,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _nameController.text = snapshot.data!.name.replaceFirst(
                snapshot.data!.name.characters.first,
                snapshot.data!.name.characters.first.toUpperCase());
            _bioController.text =
                snapshot.data!.bio.isEmpty ? "" : snapshot.data!.bio;
            _websiteController.text =
                snapshot.data!.website.isEmpty ? "" : snapshot.data!.website;
            _phoneController.text =
                snapshot.data!.Phone.isEmpty ? "" : snapshot.data!.Phone;

            final data = snapshot.data;
            return loading
                ? Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  )
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      leading: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                                child:
                                    _textUtils.bold14("Cancel", Colors.black)),
                          ),
                        ],
                      ),
                      title: _textUtils.bold16("Edit Profile", Colors.black),
                      centerTitle: true,
                      actions: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });
                            await FirebaseQuery.firebaseQuery.updateUser({
                              "name": _nameController.text,
                              "bio": _bioController.text.isEmpty
                                  ? ""
                                  : _bioController.text,
                              "website": _websiteController.text.isEmpty
                                  ? ""
                                  : _websiteController.text,
                              "phone": _phoneController.text.isEmpty
                                  ? ""
                                  : _phoneController.text,
                              "gender": dropdownValue,
                              "birth_date":selectedDate == DateTime.now()?null:selectedDate,
                            });
                            setState(() {
                              loading = false;
                            });
                            Navigator.of(context).pop();
                            CustomToast().successToast(context: context, text: "Edit Successfully..");
                          },
                          child: Center(
                              child: _textUtils.bold14("Done", Colors.blue)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    body: SingleChildScrollView(
                        child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: postUpload
                              ? const SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      NetworkImage(data!.profileUrl),
                                ),
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet<void>(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 150,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                            title: Center(
                                              child: _textUtils.bold16(
                                                  'Upload With Camera',
                                                  Colors.black),
                                            ),
                                            onTap: () => getImageCamera()),
                                        ListTile(
                                            title: Center(
                                              child: _textUtils.bold16(
                                                  'Upload With Gallery',
                                                  Colors.black),
                                            ),
                                            onTap: () {
                                              getImageGallery();
                                            })
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: _textUtils.bold14(
                              "Change profile photo", Colors.blue),
                        ),
                        const Divider(),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child:
                                      _textUtils.bold16("Name", Colors.black)),
                              const SizedBox(
                                width: 35,
                              ),
                              Expanded(
                                flex: 6,
                                child: TextFormField(
                                  controller: _nameController,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  decoration:
                                      InputDecoration(hintText: data!.name),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child:
                                      _textUtils.bold16("Bio", Colors.black)),
                              const SizedBox(
                                width: 35,
                              ),
                              Expanded(
                                flex: 6,
                                child: TextFormField(
                                  controller: _bioController,
                                  style: TextStyle(
                                      color: snapshot.data!.bio.isEmpty
                                          ? Colors.grey
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: snapshot.data!.Phone.isEmpty
                                          ? FontWeight.bold
                                          : FontWeight.bold),
                                  decoration: InputDecoration(
                                      hintText: data.bio.isEmpty
                                          ? "Enter Bio"
                                          : data.bio),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: _textUtils.bold16(
                                      "Website", Colors.black)),
                              const SizedBox(
                                width: 35,
                              ),
                              Expanded(
                                flex: 6,
                                child: TextFormField(
                                  controller: _websiteController,
                                  style: TextStyle(
                                      color: snapshot.data!.website.isEmpty
                                          ? Colors.grey
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: snapshot.data!.Phone.isEmpty
                                          ? FontWeight.bold
                                          : FontWeight.bold),
                                  decoration: InputDecoration(
                                      hintText: data.website.isEmpty
                                          ? "Enter Website"
                                          : data.website),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child:
                                      _textUtils.bold16("Phone", Colors.black)),
                              const SizedBox(
                                width: 35,
                              ),
                              Expanded(
                                flex: 6,
                                child: TextFormField(
                                  controller: _phoneController,
                                  style: TextStyle(
                                      color: snapshot.data!.Phone.isEmpty
                                          ? Colors.grey
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: snapshot.data!.Phone.isEmpty
                                          ? FontWeight.bold
                                          : FontWeight.bold),
                                  decoration: InputDecoration(
                                      hintText: data.Phone.isEmpty
                                          ? "Enter Phone Number"
                                          : data.Phone),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: _textUtils.bold16(
                                      "Birth Date", Colors.black)),
                              const SizedBox(
                                width: 35,
                              ),
                              Expanded(
                                flex: 6,
                                child: TextFormField(
                                  controller: _dateController,
                                  style: TextStyle(
                                      color: snapshot.data!.birthDate.toString().isEmpty
                                          ? Colors.grey
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: snapshot.data!.birthDate.toString().isEmpty
                                          ? FontWeight.bold
                                          : FontWeight.bold),
                                  decoration: InputDecoration(
                                      suffixIcon: InkWell(
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          child: Icon(Icons.calendar_today)),
                                      hintText: data.birthDate.toString().isEmpty
                                          ? "Enter Birth Date"
                                          : data.birthDate.toString()),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: _textUtils.bold16(
                                      "Gender", Colors.black)),
                              const SizedBox(
                                width: 35,
                              ),
                              Expanded(
                                flex: 6,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  iconSize: 15,
                                  underline: Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      height: 1.5,
                                      color: Colors.grey),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  items: <String>['Male', 'Female']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: _textUtils.bold14(
                                          value, Colors.black),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Image.asset(
                        //   "assets/images/instagram_logo.png",
                        //   width: 200,
                        //   color: Colors.grey.shade300,
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                      ],
                    )));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
