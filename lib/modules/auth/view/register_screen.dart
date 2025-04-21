// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
 import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/common/widget/app_text_form_field.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/modules/auth/view/login_screen.dart';
import 'package:lyrica/modules/auth/vm/login_controller.dart';
import 'package:lyrica/modules/auth/vm/login_state.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';

class RegisterScreen extends StatefulHookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<RegisterScreen> {
  final valueProvider = StateProvider<bool?>((ref) => false);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  bool showPassword = false;

  void register() async {
    try {
      final registerResult = await ref
          .read(loginControllerProvider.notifier)
          .register(
            userNameController.text.trim(),
            emailController.text.trim(),
            passwordController.text.trim(),
          );

      if (registerResult) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomSheetScreen()),
          (route) => false,
        );
        mySnackBar("Register Successfully", Color(AppColors.successColor));
      } else {
        mySnackBar(
          "Something went to wrong, Please try again later",
          Color(AppColors.errorColor),
        );
      }
    } catch (e) {
      mySnackBar(e.toString(), Color(AppColors.errorColor));
    }
  }

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword; // Toggle the showPassword flag
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(AppColors.blackBackground),
          body: SafeArea(
            child: Form(
              key: registerFormKey,
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
                      SizedBox(height: 10.h),
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
                      SizedBox(height: 20.h),
                      Text(
                        AppString.registerTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(AppColors.lightText),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      AppCustomTextFormField(
                        textEditingController: userNameController,
                        keyboradType: TextInputType.emailAddress,
                        borderColor: Color(AppColors.primaryColor),
                        enabledColor: Color(AppColors.secondaryColor),
                        fillColor: Colors.white10,
                        focusedColor: Color(AppColors.primaryColor),
                        hintcolors: Color(AppColors.whiteBackground),
                        disabledColor: Color(AppColors.whiteBackground),
                        hintText: AppString.userName,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10.w, top: 8.h),
                          child: FaIcon(
                            FontAwesomeIcons.user,
                            color: Color(AppColors.blueExtraLight),
                          ),
                        ),
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          } else if (!RegExp(
                            r"^[0-9A-Za-z]{6,16}$",
                          ).hasMatch(value)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      AppCustomTextFormField(
                        textEditingController: emailController,
                        keyboradType: TextInputType.emailAddress,
                        borderColor: Color(AppColors.primaryColor),
                        enabledColor: Color(AppColors.secondaryColor),
                        fillColor: Colors.white10,
                        focusedColor: Color(AppColors.primaryColor),
                        hintcolors: Color(AppColors.whiteBackground),
                        disabledColor: Color(AppColors.whiteBackground),
                        hintText: AppString.email,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10.w, top: 8.h),
                          child: FaIcon(
                            FontAwesomeIcons.envelope,
                            color: Color(AppColors.blueExtraLight),
                          ),
                        ),
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          } else if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                          ).hasMatch(value)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      AppCustomTextFormField(
                        textEditingController: passwordController,
                        keyboradType: TextInputType.emailAddress,
                        borderColor: Color(AppColors.primaryColor),
                        enabledColor: Color(AppColors.secondaryColor),
                        fillColor: Colors.white10,
                        hintcolors: Color(AppColors.whiteBackground),
                        focusedColor: Color(AppColors.primaryColor),
                        disabledColor: Color(AppColors.whiteBackground),
                        hintText: AppString.password,
                        obscureText: !showPassword,

                        maxline: 1,
                        sufixIcon: IconButton(
                          onPressed: () {
                            toggleShowPassword();
                          },
                          icon:
                              !showPassword
                                  ? FaIcon(
                                    FontAwesomeIcons.solidEyeSlash,
                                    size: 20,
                                  )
                                  : Icon(Icons.remove_red_eye),
                          color: Color(AppColors.primaryColor),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10.w, top: 8.h),
                          child: FaIcon(
                            FontAwesomeIcons.key,
                            color: Color(AppColors.blueExtraLight),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password should have atleast 8 characters';
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return "Password must contain at least one uppercase letter";
                          }
                          if (!value.contains(RegExp(r'[a-z]'))) {
                            return "Password must contain at least one lowercase  letter";
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return "Password must contain at least one numeric character";
                          }
                          if (!value.contains(
                            RegExp(r'[!@#\$%^&*()<>?/|}{~:]'),
                          )) {
                            return "Password must contain at least one special character";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                    AppColors.blueLight,
                                  ).withOpacity(0.2),
                                  blurRadius: 30,
                                  spreadRadius: 0.1,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Checkbox(
                              checkColor: Color(AppColors.whiteBackground),
                              activeColor: Color(AppColors.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              side: const BorderSide(
                                color: Color.fromARGB(75, 29, 178, 183),
                                width: 1.5,
                              ),
                              value: ref.watch(valueProvider),
                              onChanged: (bool? newValue) {
                                ref.read(valueProvider.notifier).state =
                                    newValue;
                              },
                            ),
                          ),
                          Text(
                            AppString.remember,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(AppColors.whiteBackground),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Color(
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
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: const LinearGradient(
                            colors: [
                              Color(AppColors.blueLight),

                              Color(AppColors.primaryColor),
                            ],
                          ),
                          width: double.infinity,
                          onPressed: () {
                            if (registerFormKey.currentState!.validate()) {
                              register();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                              Colors.transparent,
                            ),
                            shadowColor: WidgetStatePropertyAll<Color>(
                              Colors.transparent,
                            ),
                          ),
                          child: Text(
                            AppString.createAccount,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppString.haveAccount,
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
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              overlayColor: WidgetStatePropertyAll<Color>(
                                Colors.transparent,
                              ),
                            ),
                            child: Text(
                              AppString.signIn,
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
        ),
        if (loginState is LoginStateLoading)
        appLoader(),
      ],
    );
  }
}
