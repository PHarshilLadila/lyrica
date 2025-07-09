// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/auth/view/login_screen.dart';
import 'package:lyrica/modules/auth/view/register_screen.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';

class GoogleLoginScreen extends ConsumerStatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  ConsumerState<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends ConsumerState<GoogleLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(221, 39, 39, 39),
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
                  SizedBox(height: 50.h),
                  Center(
                    child: Image.asset(AppImages.logoWithoutBG, height: 130.h),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppString.appName,
                    style: GoogleFonts.hiMelody(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(AppColors.primaryColor),
                    ),
                  ),
                  Text(
                    AppString.appTagline,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(AppColors.blueExtraLight),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    AppString.loginSlogun,
                    style: GoogleFonts.poppins(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(AppColors.lightText),
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
                      googleLogin(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.googleLogo, height: 30.h),
                        SizedBox(width: 10.w),
                        Text(
                          AppString.loginWithGoogle,
                          style: GoogleFonts.poppins(
                            color: const Color(AppColors.lightText),
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
                      // facebookLogin(context);
                      signInWithFacebook(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.facebookLogo, height: 30.h),
                        SizedBox(width: 10.w),
                        Text(
                          AppString.loginWithFacebook,
                          style: GoogleFonts.poppins(
                            color: const Color(AppColors.lightText),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 15.h),
                  // AppMainButton(
                  //   height: 45.h,
                  //   borderRadius: BorderRadius.circular(12.r),
                  //   gradient: const LinearGradient(
                  //     colors: [Colors.white12, Colors.white12],
                  //   ),
                  //   width: double.infinity,
                  //   onPressed: () {
                  //     Navigator.pushAndRemoveUntil(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const BottomSheetScreen(),
                  //       ),
                  //       (route) => false,
                  //     );
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Image.asset(
                  //         AppImages.skipLogin,
                  //         height: 30.h,
                  //         color: const Color(AppColors.secondaryColor),
                  //       ),
                  //       SizedBox(width: 10.w),
                  //       Text(
                  //         AppString.witoutLogin,
                  //         style: GoogleFonts.poppins(
                  //           color: const Color(AppColors.lightText),
                  //           fontSize: 14.sp,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      const Expanded(
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
                            color: const Color(AppColors.whiteBackground),
                          ),
                        ),
                      ),
                      const Expanded(
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
                          color: const Color(
                            AppColors.blueLight,
                          ).withOpacity(0.2),
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
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        AppString.loginWithPassword,
                        style: GoogleFonts.poppins(
                          color: const Color(AppColors.lightText),
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
                          color: const Color(AppColors.lightText),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
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
                            color: const Color(AppColors.secondaryColor),
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
    );
  }

  Future<void> googleLogin(BuildContext context) async {
    showLoader(context);
    final auth = ref.read(authControllerProvider);
    final user = await auth.signInWithGoogle();
    hideLoader(context);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomSheetScreen()),
      );
      showSnackBar(
        context,
        'Google sign-in successfully..!',
        Color(AppColors.successColor),
      );
    } else {
      showSnackBar(
        context,
        'Google sign-in failed. Please try again.',
        Color(AppColors.errorColor),
      );
    }
  }
}

// Future<void> facebookLogin(BuildContext context) async {
//   showLoader(context);

//   try {
//     final LoginResult result = await FacebookAuth.instance.login(
//       permissions: ["public_profile", "email"],
//     );

//     if (result.status == LoginStatus.success) {
//       final accessToken = result.accessToken!;
//       debugPrint('Facebook Access Token: ${accessToken.token}');

//       final userData = await FacebookAuth.instance.getUserData(
//         fields: "email,name,picture.width(200)",
//       );

//       debugPrint('📘 Facebook User Data: $userData');
//       debugPrint('📘📘📘 Facebook User Data:');
//       userData.forEach((key, value) {
//         debugPrint('🔹 $key: $value');
//       });

//       final credential = FacebookAuthProvider.credential(accessToken.token);
//       await FirebaseAuth.instance.signInWithCredential(credential);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const BottomSheetScreen()),
//       );

//       showSnackBar(
//         context,
//         'Facebook sign-in successful!',
//         Color(AppColors.successColor),
//       );
//     } else {
//       debugPrint('Facebook login failed: ${result.status}');
//       showSnackBar(
//         context,
//         'Facebook sign-in failed: ${result.message}',
//         Color(AppColors.errorColor),
//       );
//     }
//   } catch (e) {
//     debugPrint('Facebook login exception: $e');
//     showSnackBar(
//       context,
//       'Something went wrong during Facebook login. $e',

//       Color(AppColors.errorColor),
//     );
//   } finally {
//     hideLoader(context);
//   }
// }
// Future<UserCredential> signInWithFacebook() async {
//   // Trigger the sign-in flow
//   final LoginResult loginResult = await FacebookAuth.instance.login();

//   // Create a credential from the access token
//   final OAuthCredential facebookAuthCredential =
//       FacebookAuthProvider.credential("${loginResult.accessToken?.token}");
//   debugPrint("Facebook Auth Credential: $facebookAuthCredential");

//   // Once signed in, return the UserCredential
//   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
// }

Future<void> signInWithFacebook(BuildContext context) async {
  try {
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
    );

    if (loginResult.status == LoginStatus.success) {
      final accessToken = loginResult.accessToken!;
      debugPrint("✅ Facebook Access Token: ${accessToken.token}");

      final OAuthCredential credential = FacebookAuthProvider.credential(
        accessToken.token,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email,picture.width(200)",
      );

      debugPrint("👤 User: ${userCredential.user?.displayName}");
      debugPrint("📧 Email: ${userData['email']}");
      debugPrint("🖼️ Picture: ${userData['picture']['data']['url']}");

      // Navigate to BottomNavBarScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomSheetScreen()),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ Facebook login successful!")));
    } else {
      debugPrint("❌ Facebook login failed: ${loginResult.status}");
      debugPrint("ℹ️ Message: ${loginResult.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Facebook login failed: ${loginResult.message}"),
        ),
      );
    }
  } catch (e) {
    debugPrint("🔥 Exception during Facebook login: $e");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
  }
}
