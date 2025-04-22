// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lyrica/core/constant/app_colors.dart';

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

LinearGradient backgroundGradient() {
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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar(
  BuildContext context,
  String message,
  Color bgColor,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 30,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(10),
      backgroundColor: bgColor,
      content: Text(
        message,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(child: CircularProgressIndicator()),
  );
}

void hideLoader(BuildContext context) {
  Navigator.of(context).pop();
}

void showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
