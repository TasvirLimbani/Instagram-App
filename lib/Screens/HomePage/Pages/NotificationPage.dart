import 'dart:io';

import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
    

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text("Notification")),
    );
  }
}