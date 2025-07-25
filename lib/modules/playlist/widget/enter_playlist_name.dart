import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/modules/playlist/music_playlist_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnterPlayListName extends StatefulWidget {
  const EnterPlayListName({super.key});

  @override
  State<EnterPlayListName> createState() => _EnterPlayListNameState();
}

class _EnterPlayListNameState extends State<EnterPlayListName> {
  final TextEditingController _controller = TextEditingController(
    text: "My Playlist",
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),

      child: Scaffold(
        backgroundColor: Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          leading: AppBackButton(),
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  maxLines: 2,
                  text: AppLocalizations.of(context)!.giveYourPlaylistName,
                  fontSize: 20.sp,
                  textColor: Color(AppColors.whiteBackground).withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 30.h),

                TextField(
                  controller: _controller,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Playlist Name',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 24.sp,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  cursorColor: Colors.white,
                ),

                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      Flexible(
                        child: AppMainButton(
                          borderRadius: BorderRadius.circular(8.r),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          height: 40.h,
                          gradient: const LinearGradient(
                            colors: [Colors.transparent, Colors.transparent],
                          ),
                          child: AppText(
                            maxLines: 2,
                            text: AppLocalizations.of(context)!.cancel,
                            fontSize: 16.sp,
                            textColor: Color(
                              AppColors.whiteBackground,
                            ).withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 13.w),
                      Flexible(
                        child: AppMainButton(
                          borderRadius: BorderRadius.circular(8.r),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MusicPlaylistScreen(
                                      playListName: _controller.text.trim(),
                                    ),
                              ),
                            );
                          },
                          height: 40.h,
                          gradient: const LinearGradient(
                            colors: [
                              Color(AppColors.blueLight),
                              Color(AppColors.primaryColor),
                            ],
                          ),
                          child: AppText(
                            maxLines: 2,
                            text: AppLocalizations.of(context)!.createPlaylist,
                            fontSize: 16.sp,
                            textColor: Color(
                              AppColors.whiteBackground,
                            ).withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
