// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lyrica/core/constant/app_colors.dart';

SnackBar mySnackBar(String message, Color bgColor) {
  return SnackBar(
    content: Text(message),
    backgroundColor: bgColor,
    action: SnackBarAction(label: message, onPressed: () {}),
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 4),
    elevation: 30,
    margin: EdgeInsets.all(10),
  );
}

Widget appLoader() {
  return Container(
    color: Colors.black.withOpacity(0.6),
    child: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        size: 50,
        color: Color(AppColors.primaryColor),
      ),
    ),
  );
}


LinearGradient backgroundGradient (){
  return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 9, 226, 255),
                Color.fromARGB(255, 9, 193, 218),
              //  Color.fromARGB(255, 8, 137, 146),
                Color(0xff102B2D),
                Color(0xff0E0E0E),
                Color(0xff0E0E0E),

                Color(AppColors.blackBackground),
              ],
            );
}