// ignore_for_file: use_build_context_synchronously

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
import 'package:lyrica/modules/auth/view/login_screen.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final valueProvider = StateProvider<bool?>((ref) => false);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  bool showPassword = false;

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void register(BuildContext context, WidgetRef ref) async {
    showLoader(context);
    final auth = ref.read(authControllerProvider);
    final user = await auth.register(
      userNameController.text,
      emailController.text,
      mobileController.text,
      passwordController.text,
    );
    hideLoader(context);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomSheetScreen()),
      );
      showSnackBar(
        context,
        'Registration successfully..!',
        Color(AppColors.successColor),
      );
    } else {
      showSnackBar(
        context,
        'Registration faield, try again..',
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 35.h),
                  Image.asset(AppImages.logoWithoutBG, height: 130.h),
                  SizedBox(height: 10.h),
                  AppText(
                    textName: AppString.appName,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    textColor: Color(AppColors.primaryColor),
                  ),
                  AppText(
                    textName: AppString.appTagline,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    textColor: Color(AppColors.blueExtraLight),
                  ),
                  SizedBox(height: 20.h),
                  AppText(
                    textName: AppString.registerTitle,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    textColor: Color(AppColors.lightText),
                  ),
                  SizedBox(height: 15.h),

                  // User Name
                  AppCustomTextFormField(
                    textEditingController: userNameController,
                    keyboradType: TextInputType.name,
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
                  ),
                  SizedBox(height: 15.h),

                  // Email
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
                  ),
                  SizedBox(height: 15.h),
                  AppCustomTextFormField(
                    textEditingController: mobileController,
                    keyboradType: TextInputType.number,
                    borderColor: Color(AppColors.primaryColor),
                    enabledColor: Color(AppColors.secondaryColor),
                    fillColor: Colors.white10,
                    focusedColor: Color(AppColors.primaryColor),
                    hintcolors: Color(AppColors.whiteBackground),
                    disabledColor: Color(AppColors.whiteBackground),
                    hintText: AppString.mobileNumber,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10.w, top: 8.h),
                      child: FaIcon(
                        FontAwesomeIcons.phone,
                        color: Color(AppColors.blueExtraLight),
                      ),
                    ),
                    obscureText: false,
                  ),
                  SizedBox(height: 15.h),
                  // Password
                  AppCustomTextFormField(
                    textEditingController: passwordController,
                    keyboradType: TextInputType.visiblePassword,
                    borderColor: Color(AppColors.primaryColor),
                    enabledColor: Color(AppColors.secondaryColor),
                    fillColor: Colors.white10,
                    focusedColor: Color(AppColors.primaryColor),
                    hintcolors: Color(AppColors.whiteBackground),
                    disabledColor: Color(AppColors.whiteBackground),
                    hintText: AppString.password,
                    obscureText: !showPassword,
                    maxline: 1,
                    sufixIcon: IconButton(
                      onPressed: toggleShowPassword,
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Color(AppColors.primaryColor),
                      ),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10.w, top: 8.h),
                      child: FaIcon(
                        FontAwesomeIcons.key,
                        color: Color(AppColors.blueExtraLight),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // Remember me
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
                        value: ref.watch(valueProvider),
                        onChanged: (bool? newValue) {
                          ref.read(valueProvider.notifier).state = newValue;
                        },
                      ),
                      AppText(
                        textName: AppString.remember,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
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
                      register(context, ref);

                      debugPrint("BUTTON CLICKED ---");
                    },

                    child: AppText(
                      textName: AppString.createAccount,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      textColor: Color(AppColors.lightText),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        textName: AppString.haveAccount,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        textColor: Color(AppColors.lightText),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: AppText(
                          textName: AppString.signIn,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          textColor: Color(AppColors.secondaryColor),
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
