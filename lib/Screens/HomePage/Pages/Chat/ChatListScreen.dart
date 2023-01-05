import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Screens/HomePage/Pages/Chat/ChatScreen.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/Services/SearchService.dart';
import 'package:instagram/model/AddMeassgeUser.dart';
import 'package:instagram/model/MyPost.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';

class ChatListScreen extends StatefulWidget {
  UserData? userData;
  ChatListScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextUtils _textUtils = TextUtils();
  TextEditingController _SearchController = TextEditingController();
  String Search = "";
  bool isLoading = false;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // var queryResultset = [];
  // List<UserData> teamSearchStore = [];

  // initialSearch(value) {
  //   if (value.length == 0) {
  //     queryResultset = [];
  //     teamSearchStore = [];
  //   }

  //   if (queryResultset.isEmpty && value.length == 1) {
  //     SearchService()
  //         .SearchbyName(searchField: value)
  //         .then((QuerySnapshot snapshot) {

  //       for (int i = 0; i < snapshot.docs.length; i++) {
  //         queryResultset.add(snapshot.docs[i]);
  //          if (snapshot.docs[i]['name'].toString().contains(value)) {
  //          teamSearchStore.add(UserData.fromSnapShort(snapshot.docs[i]));

  //       }
  //       }
  //     });
  //   } else {
  //     teamSearchStore = [];
  //     queryResultset.forEach((element) {

  //       if (element['name'].toString().contains(value)) {
  //          teamSearchStore.add(UserData.fromSnapShort(element));

  //       }
  //     });
  //     setState(() {

  //         });
  //   }
  //    print('name sss = ${teamSearchStore.length}');
  // }

  @override
  void initState() {
    DatabaseService().User;
    DatabaseService().userPost;
    DatabaseService().userProfile;
    DatabaseService().userReels;
    DatabaseService().userStory;
    DatabaseService().usermessage;
    widget.userData;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
        title: Row(
          children: [
            _textUtils.bold16(widget.userData!.name, Colors.black),
            const SizedBox(
              width: 5,
            ),
            widget.userData!.verified
                ? const Icon(Icons.verified, color: Colors.blue, size: 20)
                : Container(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8),
              //   child: CupertinoSearchTextField(
              //     controller: _SearchController,
              //     onChanged: (val) {
              //       setState(() {
              //         // initialSearch(val);
              //       });
              //     },
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: FirestoreSearchBar(
                  tag: 'UserSearch',
                ),
              ),

              Expanded(
                child: FirestoreSearchResults.builder(
                  tag: 'UserSearch',
                  firestoreCollectionName: 'User',
                  searchBy: 'name',
                  initialBody: StreamBuilder<List<AddMeassgeUser>>(
                    stream: DatabaseService().usermessage,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<UserData>(
                                stream: DatabaseService()
                                    .userinfo(snapshot.data![index].uid),
                                builder: (context, snapshot1) {
                                  if (snapshot.hasData) {
                                    final data = snapshot1.data;
                                    return ListTile(
                                      // leading:CircleAvatar(radius: 20,backgroundImage: NetworkImage(snapshot.data.length),),
                                      leading: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                                NetworkImage(data?.profileUrl ?? "https://thumbs.gfycat.com/SpitefulElectricHoopoe-max-1mb.gif"),
                                          ),
                                       data?.show_active_status==true?  data?.status=="Online" ? Positioned(
                                            bottom: 0,right: 0,
                                            child: Container(
                                              height: 15,
                                              width: 15,
                                              decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.lightGreen,border: Border.all(width: 2,color: Colors.white)),
                                            ),
                                          ):Container(height: 0,width: 0,):Container(height: 0,width: 0,),
                                        ],
                                      ),
                                      title: Row(
                                        children: [
                                          _textUtils.bold14(
                                             data?.email ?? "", Colors.black),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                         data?.verified ?? false
                                              ? const Icon(Icons.verified,
                                                  color: Colors.blue, size: 15)
                                              : Container(),
                                        ],
                                      ),
                                      subtitle: _textUtils.bold12(
                                         data?.name ?? "", Colors.grey),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.camera_alt_outlined),
                                        onPressed: () {},
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                      userData: data!,
                                                    )));
                                      },
                                    );
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                });
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  dataListFromSnapshot: DatabaseService().profile,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<UserData> dataList = snapshot.data;
                      if (dataList.isEmpty) {
                        return const Center(
                          child: Text('No Results Returned'),
                        );
                      }
                      return ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            final UserData data = dataList[index];
                            return UserTile(userdata: data);
                          });
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text('No Results Returned'),
                        );
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
              // Expanded(
              //   child: ListView.builder(
              //       physics: const BouncingScrollPhysics(),
              //       shrinkWrap: true,
              //       itemBuilder: (context, index) {
              //         return ListTile(
              //           onTap: () {
              //             Navigator.of(context).push(MaterialPageRoute(
              //                 builder: (context) => const ChatScreen()));
              //           },
              //           leading: _textUtils.bold12("$index", Colors.black),
              //         );
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  UserData userdata;
  UserTile({Key? key, required this.userdata}) : super(key: key);
  final TextUtils _textUtils = TextUtils();

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          log(userdata.uid);
          FirebaseQuery.firebaseQuery.addmeassge(uid: userdata.uid, data: {});
          // FirebaseQuery.firebaseQuery.sendMeassge(uid: userdata.uid, data: {
          //   "date":DateTime.now(),"meassge":"","sender":"","like":false,
          // });
        },
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(userdata.profileUrl),
        ),
        title: Row(
          children: [
            _textUtils.bold14(userdata.email, Colors.black),
            const SizedBox(
              width: 5,
            ),
            userdata.verified
                ? const Icon(Icons.verified, color: Colors.blue, size: 15)
                : Container(),
          ],
        ),
        subtitle: _textUtils.bold12(userdata.name, Colors.grey),
        trailing: IconButton(
          icon: const Icon(Icons.camera_alt_outlined),
          onPressed: () {
            //  FirebaseQuery.firebaseQuery
            //   .addmeassge(uid: "${userdata.uid}",);
          },
        ));
  }
}
