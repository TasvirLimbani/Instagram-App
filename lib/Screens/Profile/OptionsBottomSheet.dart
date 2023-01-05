import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Components/Toast.dart';
import 'package:instagram/Screens/Login.dart';
import 'package:instagram/Screens/Profile/Setting.dart';
import 'package:instagram/Services/Firebase_Service.dart';
import 'package:instagram/model/UserData.dart';
import 'package:instagram/utils/Text_utils.dart';

class OptionsBottomSheet extends StatefulWidget {
  UserData userData;
  OptionsBottomSheet({Key? key, required this.userData}) : super(key: key);

  @override
  State<OptionsBottomSheet> createState() => _OptionsBottomSheetState();
}

class _OptionsBottomSheetState extends State<OptionsBottomSheet> {
  final TextUtils _textUtils = TextUtils();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: MediaQuery.of(context).size.height * 0.463,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                ListTile(
                  onTap: (){
                    // Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SettingPage(userData: widget.userData,)));
                  },
                  leading: Icon(Icons.settings),
                  title: _textUtils.bold14("Setting", Colors.black),
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: Icon(Icons.qr_code_2),
                  title: _textUtils.bold14("QR Code", Colors.black),
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: Icon(Icons.bookmark_outline),
                  title: _textUtils.bold14("Saved", Colors.black),
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: Icon(Icons.masks_outlined),
                  title: _textUtils.bold14("COVID-19 Information Center", Colors.black),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color:Colors.redAccent),
            child:ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _textUtils.bold16("Logout", Colors.white),
                      SizedBox(width: 5,),
                      Icon(Icons.logout,color: Colors.white,),
                    ],
                  ),                
                  onTap: () async {
                     FirebaseHelper.Auth
                                    .logout();
                                    
                     Navigator.of(context).pushAndRemoveUntil(
                      
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false);
                            CustomToast().successToast(
                                context: context, text: "Logout Successfully");
                  },
                ),
          ),
        ],
      ),
    );
  }
}
