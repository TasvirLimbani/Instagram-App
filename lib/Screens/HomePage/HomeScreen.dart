import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:instagram/Screens/HomePage/Pages/Chat/ChatListScreen.dart';
import 'package:instagram/Screens/HomePage/Pages/HomePage.dart';
import 'package:instagram/Screens/HomePage/Pages/NotificationPage.dart';
import 'package:instagram/Screens/HomePage/Pages/ProfilePage.dart';
import 'package:instagram/Screens/HomePage/Pages/ReelsPage.dart';
import 'package:instagram/Screens/HomePage/Pages/SearchPage.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/Services/Firebase_Qurey.dart';
import 'package:instagram/model/UserData.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int pageIndex = 0;
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  SnakeShape snakeShape = SnakeShape.circle;
  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );
  EdgeInsets padding = const EdgeInsets.all(0);
  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;
  int _selectedItemPosition = 0;
  Color selectedColor = Colors.black;
  Color unselectedColor = Colors.blueGrey;

  void setStatus(String status) async {
    FirebaseQuery.firebaseQuery.updateStatus({"status": status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    //  final firebaseMessaging = FCM();
    // firebaseMessaging.setNotifications();
    FirebaseAuth.instance.userChanges();
    DatabaseService().User;
    DatabaseService().userPost;
    DatabaseService().userProfile;
    DatabaseService().userReels;
    DatabaseService().userStory;
    DatabaseService().usermessage;

    load();
    super.initState();
  }

  load() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('${FirebaseAuth.instance.currentUser!.email} = ${fcmToken}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedItemPosition == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              title:
                  Image.asset('assets/images/instagram_logo.png', width: 120),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_box_outlined,
                    color: Colors.black,
                  ),
                ),
                StreamBuilder<UserData>(
                    stream: DatabaseService().User,
                    builder: (context, snapshot) {
                      return IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatListScreen(
                                    userData: snapshot.data,
                                  )));
                        },
                        icon: const Icon(
                          Icons.message_outlined,
                          color: Colors.black,
                        ),
                      );
                    }),
                const SizedBox(
                  width: 8,
                ),
              ],
            )
          : null,
      //    AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: Row(
      //     children: [
      //       Text(
      //         "data!.email".split("@").first,
      //         style: const TextStyle(color: Colors.black),
      //       ),
      //       const SizedBox(
      //         width: 5,
      //       ),
      //       // data.verified
      //       //     ? const Icon(Icons.verified,
      //       //         color: Colors.blue, size: 20)
      //       //     : Container(),
      //     ],
      //   ),
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(
      //         Icons.add_box_outlined,
      //         color: Colors.black,
      //       ),
      //       onPressed: () => print("Add"),
      //     ),
      //     IconButton(
      //       icon: const Icon(
      //         Icons.menu,
      //         color: Colors.black,
      //       ),
      //       onPressed: () => print("Add"),
      //     )
      //   ],
      // ),
      body: Stack(
        children: [
          if (_selectedItemPosition == 0) const HomePage(),
          if (_selectedItemPosition == 1) const SearchPage(),
          if (_selectedItemPosition == 2) const ReelsPage(),
          if (_selectedItemPosition == 3) const NotificationPage(),
          if (_selectedItemPosition == 4) const ProfilePage(),
        ],
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: snakeBarStyle,
        snakeShape: snakeShape,
        shape: bottomBarShape,
        padding: padding,
        snakeViewColor: selectedColor,
        selectedItemColor:
            snakeShape == SnakeShape.indicator ? selectedColor : null,
        unselectedItemColor: Colors.blueGrey,
        showUnselectedLabels: showUnselectedLabels,
        showSelectedLabels: showSelectedLabels,
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() => _selectedItemPosition = index),
        items: [
          BottomNavigationBarItem(
              icon: Icon(_selectedItemPosition == 0
                  ? Icons.home
                  : Icons.home_outlined),
              label: 'tickets'),
          BottomNavigationBarItem(
              icon: Icon(_selectedItemPosition == 1
                  ? Icons.search
                  : Icons.search_outlined),
              label: 'calendar'),
          BottomNavigationBarItem(
              icon: Icon(_selectedItemPosition == 2
                  ? Icons.smart_display
                  : Icons.smart_display_outlined),
              label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(_selectedItemPosition == 3
                  ? Icons.favorite
                  : Icons.favorite_outline),
              label: 'microphone'),
          BottomNavigationBarItem(
              icon: Icon(_selectedItemPosition == 4
                  ? Icons.account_circle
                  : Icons.account_circle_outlined),
              label: 'search')
        ],
      ),
    );

    return StreamBuilder<UserData>(
        stream: DatabaseService().User,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return Scaffold(
              appBar: _selectedItemPosition == 0
                  ? AppBar(
                      backgroundColor: Colors.transparent,
                      title: Image.asset('assets/images/instagram_logo.png',
                          width: 120),
                      elevation: 0,
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_box_outlined,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.message_outlined,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    )
                  : _selectedItemPosition == 4
                      ? AppBar(
                          backgroundColor: Colors.transparent,
                          title: Text(
                            "${data!.email}",
                            style: const TextStyle(color: Colors.black),
                          ),
                          elevation: 0,
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.add_box_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () => print("Add"),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.black,
                              ),
                              onPressed: () => print("Add"),
                            )
                          ],
                        )
                      : null,
              body: Stack(
                children: [
                  if (_selectedItemPosition == 0) const HomePage(),
                  if (_selectedItemPosition == 1) const SearchPage(),
                  if (_selectedItemPosition == 2) const ReelsPage(),
                  if (_selectedItemPosition == 3) const NotificationPage(),
                  if (_selectedItemPosition == 4) ProfilePage(),
                ],
              ),
              bottomNavigationBar: SnakeNavigationBar.color(
                behaviour: snakeBarStyle,
                snakeShape: snakeShape,
                shape: bottomBarShape,
                padding: padding,
                snakeViewColor: selectedColor,
                selectedItemColor:
                    snakeShape == SnakeShape.indicator ? selectedColor : null,
                unselectedItemColor: Colors.blueGrey,
                showUnselectedLabels: showUnselectedLabels,
                showSelectedLabels: showSelectedLabels,
                currentIndex: _selectedItemPosition,
                onTap: (index) => setState(() => _selectedItemPosition = index),
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(_selectedItemPosition == 0
                          ? Icons.home
                          : Icons.home_outlined),
                      label: 'tickets'),
                  BottomNavigationBarItem(
                      icon: Icon(_selectedItemPosition == 1
                          ? Icons.search
                          : Icons.search_outlined),
                      label: 'calendar'),
                  BottomNavigationBarItem(
                      icon: Icon(_selectedItemPosition == 2
                          ? Icons.smart_display
                          : Icons.smart_display_outlined),
                      label: 'home'),
                  BottomNavigationBarItem(
                      icon: Icon(_selectedItemPosition == 3
                          ? Icons.favorite
                          : Icons.favorite_outline),
                      label: 'microphone'),
                  BottomNavigationBarItem(
                      icon: Icon(_selectedItemPosition == 4
                          ? Icons.account_circle
                          : Icons.account_circle_outlined),
                      label: 'search')
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text(snapshot.error.toString())),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
