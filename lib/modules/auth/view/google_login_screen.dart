// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
 import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/modules/auth/view/login_screen.dart';
import 'package:lyrica/modules/auth/view/register_screen.dart';
import 'package:lyrica/modules/auth/vm/login_controller.dart';
import 'package:lyrica/modules/auth/vm/login_state.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';

class GoogleLoginScreen extends StatefulHookConsumerWidget {
  const GoogleLoginScreen({super.key});

  @override
  ConsumerState<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends ConsumerState<GoogleLoginScreen> {
  void googleAuth() async {
    try {
      final googleAuthResult =
          await ref.read(loginControllerProvider.notifier).googleAuth();

      if (googleAuthResult) {
        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => BottomSheetScreen()),
          (route) => false,
        );
        mySnackBar(
          "Google Authentication Successfully",
          Color(AppColors.successColor),
        );
      } else {
        mySnackBar(
          "Something went to wrong, try again later.",
          Color(AppColors.errorColor),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      mySnackBar(e.toString(), Color(AppColors.errorColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(AppColors.blackBackground),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Image.asset(
                          AppImages.logoWithoutBG,
                          height: 130.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppString.appName,
                      style: GoogleFonts.hiMelody(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(AppColors.primaryColor),
                      ),
                    ),
                    Text(
                      AppString.appTagline,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(AppColors.blueExtraLight),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Text(
                      AppString.loginSlogun,
                      style: GoogleFonts.poppins(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(AppColors.lightText),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    AppMainButton(
                      height: 45.h,
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: const LinearGradient(
                        colors: [Colors.white12, Colors.white12],
                      ),
                      width: double.infinity,
                      onPressed: () {
                        googleAuth();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImages.googleLogo, height: 30.h),
                          SizedBox(width: 10.w),
                          Text(
                            AppString.loginWithGoogle,
                            style: GoogleFonts.poppins(
                              color: Color(AppColors.lightText),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    AppMainButton(
                      height: 45.h,
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: const LinearGradient(
                        colors: [Colors.white12, Colors.white12],
                      ),
                      width: double.infinity,
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImages.facebookLogo, height: 30.h),
                          SizedBox(width: 10.w),
                          Text(
                            AppString.loginWithFacebook,
                            style: GoogleFonts.poppins(
                              color: Color(AppColors.lightText),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    AppMainButton(
                      height: 45.h,
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: const LinearGradient(
                        colors: [Colors.white12, Colors.white12],
                      ),
                      width: double.infinity,
                      onPressed: () {
                        Future.delayed(Duration(seconds: 2));
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomSheetScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.skipLogin,
                            height: 30.h,
                            color: Color(AppColors.secondaryColor),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            AppString.witoutLogin,
                            style: GoogleFonts.poppins(
                              color: Color(AppColors.lightText),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(AppColors.whiteBackground),
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            "or",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(AppColors.whiteBackground),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(AppColors.whiteBackground),
                            thickness: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                             color: Color(AppColors.blueLight).withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 10,
                            offset: const Offset(1, 0),
                          ),
                        ],
                      ),
                      child: AppMainButton(
                        height: 40.h,
                        borderRadius: BorderRadius.circular(25.r),
                        gradient: const LinearGradient(
                          colors: [
                            Color(AppColors.blueLight),
                            Color(AppColors.primaryColor),
                          ],
                        ),
                        width: double.infinity,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            Colors.transparent,
                          ),
                          shadowColor: WidgetStatePropertyAll<Color>(
                            Colors.transparent,
                          ),
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                        ),
                        child: Text(
                          AppString.loginWithPassword,
                          style: GoogleFonts.poppins(
                            color: Color(AppColors.lightText),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppString.dontHaveAccount,
                          style: GoogleFonts.poppins(
                            color: Color(AppColors.lightText),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor: WidgetStatePropertyAll<Color>(
                              Colors.transparent,
                            ),
                          ),
                          child: Text(
                            AppString.signUp,
                            style: GoogleFonts.poppins(
                              color: Color(AppColors.secondaryColor),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (loginState is LoginStateLoading)
         appLoader(),
      ],
    );
  }
}
