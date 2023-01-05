import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Components/Posts.dart';
import 'package:instagram/Screens/HomePage/Pages/StoryUploadPage.dart';
import 'package:instagram/Screens/HomePage/Pages/StoryViewPage.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/model/MyPost.dart';
import 'package:instagram/model/MyStory.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextUtils _textUtils = TextUtils();
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
            final userdata = snapshot.data;
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      StreamBuilder<List<MyStory>>(
                          stream: DatabaseService().userStory,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final storyData = snapshot.data;
                              return storyData!.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StoryViewPage(myStory: storyData,);
                                            });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(width: 2), 
                                        ),
                                        child: CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                                userdata!.profileUrl, ),),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StoryUploadPage();
                                            });
                                      },
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                  "${userdata!.profileUrl}")),
                                          Positioned(
                                              right: 5,
                                              bottom: 0,
                                              child: Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Colors.white),
                                                    shape: BoxShape.circle,
                                                    color: Colors.blue,
                                                  ),
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 12,
                                                    color: Colors.white,
                                                  )))
                                        ],
                                      ),
                                    );
                            }
                            return Container();
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 8,
                  child: StreamBuilder<List<MyPost>>(
                      stream: DatabaseService().alluserPost('hIOraD9ekxfUzZ0Grf0GiOCsosJ3'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final postData = snapshot.data;
                          return postData!.isEmpty
                              ? Center(
                                  child: _textUtils.bold12(
                                      "No Post", Colors.black),
                                )
                              : ListView.builder(
                                  itemCount: postData.length,
                                  itemBuilder: (context, index) {
                                    return Posts(
                                      myPost: postData[index],
                                      userData: userdata,
                                    );
                                  });
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
