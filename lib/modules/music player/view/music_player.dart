import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class MusicPlayer extends StatefulWidget {
  final Results results;
  const MusicPlayer({super.key, required this.results});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                textName: "Musics",
                fontSize: 20.sp,
                textColor: Color(AppColors.lightText),
                fontWidth: FontWeight.w500,
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(widget.results.image ?? ""),
            ),
            Center(
              child: GradientText(
                widget.results.name ?? "",
                style: TextStyle(fontSize: 24.sp),
                gradientType: GradientType.radial,
                radius: 5.5,
                colors: [
                  Color(AppColors.blueLight),
                  Color(AppColors.blueThird),
                  Color(AppColors.blueLight),
                  Color(AppColors.secondaryColor),
                ],
              ),
            ),
            Center(
              child: AppText(
                textName: "By - ${widget.results.artistName ?? ""}",
                textColor: Colors.white54,
                fontSize: 14.sp,
                fontWidth: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
