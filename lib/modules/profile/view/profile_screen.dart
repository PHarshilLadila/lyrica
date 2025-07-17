import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/providers/provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModelAsync = ref.watch(userModelProvider);

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 90,
          leading: BackButton(),
          title: AppText(
            textName: "Your Profile",
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            textColor: Color(AppColors.lightText),
          ),
          actions: [
            IconButton(
              icon: Image.asset(AppImages.barIcon, width: 25.w),
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset(AppImages.settingIcon, width: 25.w),
              onPressed: () {},
            ),
            SizedBox(width: 12.w),
          ],
        ),
        body: userModelAsync.when(
          data: (userModel) {
            final profileImage =
                (userModel?.image.isNotEmpty == true)
                    ? userModel!.image
                    : AppImages.avatar;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 160.w,
                              height: 160.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(
                                      AppColors.primaryColor,
                                    ).withOpacity(0.6),
                                    Color(AppColors.blueLight).withOpacity(0.4),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 25,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child:
                                  (profileImage.startsWith("http") ||
                                          profileImage.startsWith("https"))
                                      ? Image.network(
                                        profileImage,
                                        width: 140.w,
                                        height: 140.w,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => Image.asset(
                                              AppImages.avatar,
                                              width: 140.w,
                                              height: 140.w,
                                            ),
                                      )
                                      : Image.asset(
                                        profileImage,
                                        width: 140.w,
                                        height: 140.w,
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          children: [
                            AppText(
                              textName: "Hey, ${userModel!.username} 👋",
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                            ),
                            const SizedBox(height: 6),
                            AppText(
                              textName: userModel.email,
                              textColor: Colors.white70,
                              fontSize: 15.sp,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white.withOpacity(0.05),
                              border: Border.all(
                                color: Colors.white12,
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  textName: "Profile Details",
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  textColor: Colors.white,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoTile("Username", userModel.username),
                                const SizedBox(height: 10),
                                _buildInfoTile("Email", userModel.email),
                                const SizedBox(height: 10),
                                _buildInfoTile("Mobile", userModel.mobile),
                                const SizedBox(height: 10),
                                _buildInfoTile("UID", userModel.uid),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => Center(child: appLoader()),
          error:
              (e, _) => Center(
                child: AppText(
                  textName: "Error loading profile: $e",
                  textColor: Colors.redAccent,
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textName: title,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          textColor: Colors.white70,
        ),
        const SizedBox(height: 4),
        AppText(
          textName: value.isNotEmpty ? value : "N/A",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
