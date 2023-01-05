import 'package:flutter/material.dart';

class TextUtils {


  Text normal11(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.normal),
    );
  }


  Text normal12(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.normal),
    );
  }

  Text normal14(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 14,  fontWeight: FontWeight.normal),
    );
  }

  Text normal14Ellipsis(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 14,  fontWeight: FontWeight.normal, overflow: TextOverflow.ellipsis),
    );
  }

  Text normal16(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 16,  fontWeight: FontWeight.normal),
    );
  }

  Text normal17(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 17,  fontWeight: FontWeight.normal),
    );
  }

  Text normal18(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 18,  fontWeight: FontWeight.normal),
    );
  }

  Text normal20(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.normal),
    );
  }

  Text bold10(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
    );
  }
  Text bold12(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
    );
  }
  Text bold14(String text, Color color,{TextAlign? textAlign}) {
    return Text(
      text,textAlign:textAlign,
      style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Text bold16(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Text bold18(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 18,  fontWeight: FontWeight.bold),
    );
  }

  Text bold20(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 20,  fontWeight: FontWeight.bold),
    );
  }
}