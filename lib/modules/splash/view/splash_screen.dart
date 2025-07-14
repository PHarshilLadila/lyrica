import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/constant/app_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.blackBackground),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset(AppImages.logoWithoutBG, height: 180.h)),
          SizedBox(height: 20.h),
          AppText(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            textColor: Color(AppColors.primaryColor),
            textName: AppString.appName,
          ),
          SizedBox(height: 2.h),

          AppText(
            textName: AppString.appTagline,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            textColor: Color(AppColors.blueExtraLight),
          ),
        ],
      ),
    );
  }
}
