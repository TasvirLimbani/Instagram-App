import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/Screens/HomePage/Pages/Chat/ChatListScreen.dart';
import 'package:instagram/Screens/HomePage/Pages/ViewProfile.dart';
import 'package:instagram/Services/Firebase.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
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
              initialBody: Expanded(
                child: GridView.custom(
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: [
                      QuiltedGridTile(2, 2),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 2),
                    ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://picsum.photos/500/500?random=$index'),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                ),
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
                        return searchUserTile(userdata: data);
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
        ],
      ),
    );
  }
}

class searchUserTile extends StatelessWidget {
  UserData userdata;
  searchUserTile({Key? key, required this.userdata}) : super(key: key);
  final TextUtils _textUtils = TextUtils();

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewProfile(uid: userdata.uid)));
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


// StaggeredGridView.countBuilder(
//           crossAxisCount: 4,
//           itemCount: 15,
//           itemBuilder: (BuildContext context, int index) => new Container(
//               height: 120.0,
//               width: 120.0,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage('https://picsum.photos/500/500?random=$index'),
//                   fit: BoxFit.fill,
//                 ),
//                 shape: BoxShape.rectangle,
//               ),
//              ),
//           staggeredTileBuilder: (int index) =>
//               new StaggeredTile.count(2, index.isEven ? 3 : 2),
//           mainAxisSpacing: 4.0,
//           crossAxisSpacing: 4.0,
//         ),

