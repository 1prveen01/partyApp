import 'package:flutter/material.dart';
class AppWidget {
  static TextStyle appBarTextStyle(){
    return const TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight:FontWeight.w500,
    );
  }

  static TextStyle boldFeildTextStyle(){
    return const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 28,
    );
  }

  static TextStyle lightFeildTextStyle(){
    return const TextStyle(
        color: Colors.grey,
        fontSize: 20,
        fontWeight: FontWeight.w400);
  }

}