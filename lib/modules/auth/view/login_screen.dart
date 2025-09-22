// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/common/widget/app_text_form_field.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/auth/view/register_screen.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool? value = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loginScreenKey = GlobalKey<FormState>();
  bool showPassword = false;

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void login(BuildContext context, WidgetRef ref) async {
    showLoader(context);
    final auth = ref.read(authControllerProvider);

    final user = await auth.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    hideLoader(context);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomSheetScreen()),
      );
      showAppSnackBar(
        context,
        AppLocalizations.of(context)!.loginSuccess,
        Color(AppColors.successColor),
      );
    } else {
      showAppSnackBar(
        context,
        AppLocalizations.of(context)!.loginFailed,
        Color(AppColors.errorColor),
      );
    }
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
      showAppSnackBar(
        context,
        AppLocalizations.of(context)!.googleSignInSuccess,
        Color(AppColors.successColor),
      );
    } else {
      showAppSnackBar(
        context,
        AppLocalizations.of(context)!.googleSignInFailed,
        Color(AppColors.errorColor),
      );
    }
  }

  Future<void> facebookLogin(BuildContext context) async {
    showLoader(context);
    final auth = ref.read(authControllerProvider);
    final user = await auth.facebookLogin();
    hideLoader(context);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomSheetScreen()),
      );
      showAppSnackBar(
        context,
        AppLocalizations.of(context)!.facebookSignInSuccess,
        Color(AppColors.successColor),
      );
    } else {
      showAppSnackBar(
        context,
        AppLocalizations.of(context)!.facebookSignInFailed,
        Color(AppColors.errorColor),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),

      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
        body: Form(
          autovalidateMode: AutovalidateMode.onUnfocus,
          key: loginScreenKey,
          child: SingleChildScrollView(
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
                  Column(
                    children: [
                      AppText(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        text: AppString.appName,
                        textColor: Color(AppColors.primaryColor),
                      ),
                      AppText(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        text: AppLocalizations.of(context)!.appSlogun,
                        textColor: Color(AppColors.blueExtraLight),
                      ),
                      SizedBox(height: 20.h),
                      AppText(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        text: AppLocalizations.of(context)!.loginToYOurAccount,
                        textColor: Color(AppColors.lightText),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  AppCustomTextFormField(
                    textEditingController: emailController,
                    keyboradType: TextInputType.emailAddress,
                    borderColor: Color(AppColors.primaryColor),
                    enabledColor: Color(AppColors.secondaryColor),
                    fillColor: Colors.white10,
                    focusedColor: Color(AppColors.primaryColor),
                    disabledColor: Color(AppColors.whiteBackground),
                    hintText: AppLocalizations.of(context)!.email,
                    hintcolors: Color(AppColors.whiteBackground),
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
                    hintText: AppLocalizations.of(context)!.password,
                    obscureText: !showPassword,
                    maxline: 1,
                    sufixIcon: IconButton(
                      onPressed: () {
                        toggleShowPassword();
                      },
                      icon:
                          !showPassword
                              ? FaIcon(FontAwesomeIcons.solidEyeSlash, size: 20)
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
                      if (!value.contains(RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
                        return "Password must contain at least one special character";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Color(AppColors.whiteBackground),
                        activeColor: Color(AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        side: const BorderSide(
                          color: Color.fromARGB(75, 29, 178, 183),
                          width: 1.5,
                        ),
                        value: value,
                        onChanged: (bool? newValue) {
                          setState(() {
                            value = newValue;
                          });
                        },
                      ),
                      AppText(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        text: AppLocalizations.of(context)!.rememberMe,
                        textColor: Color(AppColors.whiteBackground),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.h),
                  AppMainButton(
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
                      login(context, ref);
                    },

                    child: AppText(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      text: AppLocalizations.of(context)!.loginWithPassword,
                      textColor: Color(AppColors.lightText),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.center,
                    child: AppText(
                      fontSize: 14.sp,
                      textUnderline: TextDecoration.underline,
                      textColor: Color(AppColors.secondaryColor),
                      fontWeight: FontWeight.w500,
                      text: AppLocalizations.of(context)!.forGotYourPassword,
                      underlineColor: Color(AppColors.secondaryColor),
                    ),
                  ),

                  SizedBox(height: 25.h),
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
                        child: AppText(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          text: AppLocalizations.of(context)!.orCountinueWith,
                          textColor: Colors.white54,
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
                  SizedBox(height: 15.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          googleLogin(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(AppColors.whiteBackground),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              AppImages.googleLogo,
                              height: 25.h,
                              width: 25.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: () {
                          facebookLogin(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(AppColors.whiteBackground),
                          ),
                          child: GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                AppImages.facebookLogo,
                                height: 25.h,
                                width: 25.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(
                        text: AppLocalizations.of(context)!.dontHaveAnAccount,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        textColor: Color(AppColors.lightText),
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
                        child: AppText(
                          text: AppLocalizations.of(context)!.signUp,
                          fontSize: 14.sp,
                          textColor: Color(AppColors.secondaryColor),
                          fontWeight: FontWeight.w500,
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
}
