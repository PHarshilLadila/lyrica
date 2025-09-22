import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/modules/playlist/view%20playlist/view_playlist_screen.dart';
import 'package:lyrica/modules/playlist/widget/enter_playlist_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height ?? 0.30.sh,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 1, 49, 58),
                Color.fromARGB(255, 3, 94, 119),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

void showPlaylistOptionsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return AppBottomSheet(
        title: AppLocalizations.of(context)!.myPlayList,
        child: Row(
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EnterPlayListName(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/play_list_one.png",
                        color: const Color(AppColors.whiteBackground),
                        height: 45.h,
                      ),
                      SizedBox(height: 8.h),
                      AppText(
                        text: AppLocalizations.of(context)!.createPlaylist,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        textColor: const Color(AppColors.whiteBackground),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPlaylistScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.headphones,
                        size: 45.sp,
                        color: const Color(AppColors.whiteBackground),
                      ),
                      SizedBox(height: 8.h),
                      AppText(
                        text: AppLocalizations.of(context)!.playPlaylist,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        textColor: const Color(AppColors.whiteBackground),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
