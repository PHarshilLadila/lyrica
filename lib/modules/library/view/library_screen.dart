// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authControllerProvider);

    final userAsync = ref.watch(authStateProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const Center(child: Text("User not found"));

        return Container(
          decoration: BoxDecoration(gradient: backgroundGradient()),

          child: Scaffold(
            backgroundColor: const Color.fromARGB(221, 39, 39, 39),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(AppImages.logoWithoutBG),
                ),
              ),
              elevation: 0,
              toolbarHeight: 90,
              backgroundColor: Colors.transparent,
              title: Text(
                "Your Library",
                style: GoogleFonts.poppins(
                  color: Color(AppColors.lightText),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GoogleLoginScreen(),
                      ),
                    );
                    showSnackBar(
                      context,
                      "Sign out Successfully..!",
                      Color(AppColors.successColor),
                    );
                  },
                  icon: Image.asset(AppImages.barIcon, width: 25.w),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(AppImages.settingIcon, width: 25.w),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GestureDetector(
                    onTap: () async {
                      await auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoogleLoginScreen(),
                        ),
                      );
                      showSnackBar(
                        context,
                        "Sign out Successfully..!",
                        Color(AppColors.successColor),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(106, 29, 178, 183),
                            Color.fromARGB(106, 29, 178, 183),
                            Color.fromARGB(106, 23, 106, 109),
                          ],
                        ),
                        border: Border.all(color: Colors.white54, width: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 12.0,
                            top: 12,
                            bottom: 12,
                            right: 8,
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.signOutAlt,
                            color: Color(AppColors.whiteBackground),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text("library", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 12.h),
                AppMainButton(
                  width: 70.w,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () async {
                    await auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GoogleLoginScreen(),
                      ),
                    );
                    showSnackBar(
                      context,
                      "Sign out Successfully..!",
                      Color(AppColors.successColor),
                    );
                  },
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(AppColors.blueThird),
                      Color(AppColors.blueLight),
                      Color(AppColors.secondaryColor),
                    ],
                  ),
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Color(AppColors.blackBackground)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Center(child: appLoader()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
