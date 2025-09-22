// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';

class Skewed3DCard extends StatelessWidget {
  final String buttonText;
  final String cardText;
  final String imagePath;
  final void Function()? onButtonPress;
  const Skewed3DCard({
    super.key,
    required this.imagePath,
    required this.cardText,
    required this.buttonText,
    this.onButtonPress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        alignment: Alignment.center,
        transform:
            Matrix4.identity()
              ..setEntry(3, 2, 0.0091)
              ..rotateY(-0.1),
        child: ClipPath(
          clipper: SkewedRoundedClipper(),
          child: Container(
            width: 320.w,
            height: 140.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(AppColors.primaryColor),
                  Color(AppColors.blueLight),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 25,
                  offset: Offset(12, 12),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cardText,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Image.asset(imagePath, width: 75.w, fit: BoxFit.cover),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  AppMainButton(
                    height: 30.h,
                    width: 130.w,
                    onPressed: onButtonPress,
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 33, 43),
                        Color.fromARGB(255, 0, 33, 43),
                        Color.fromARGB(255, 0, 33, 43),
                      ],
                    ),
                    child: AppText(
                      text: buttonText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      textColor: Color(AppColors.whiteBackground),
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SkewedRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double r = 25;
    double offset = 10;
    double topLeftShift = 30;

    Path path = Path();
    path.moveTo(topLeftShift + r, 0);
    path.lineTo(size.width - r, 0);
    path.quadraticBezierTo(size.width, 0, size.width, r);
    path.lineTo(size.width - offset, size.height - r);
    path.quadraticBezierTo(
      size.width - offset - 2,
      size.height,
      size.width - offset - r,
      size.height,
    );
    path.lineTo(r + offset, size.height);
    path.quadraticBezierTo(offset, size.height, offset, size.height - r);
    path.lineTo(topLeftShift, r);
    path.quadraticBezierTo(topLeftShift, 0, topLeftShift + r, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
