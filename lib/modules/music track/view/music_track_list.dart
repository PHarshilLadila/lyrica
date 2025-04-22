import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_images.dart';
import 'package:lyrica/core/providers/provider.dart';

class MusicTrackList extends ConsumerWidget {
  const MusicTrackList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicAsyncValue = ref.watch(musicDataProvider);

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
        body: musicAsyncValue.when(
          data: (tracks) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    textName: "Item Songs",
                    fontSize: 18.sp,
                    fontWidth: FontWeight.w500,
                    textColor: Color(AppColors.lightText),
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        final track = tracks[index];
                        formattedTime({required int timeInSecond}) {
                          int sec = timeInSecond % 60;
                          int min = (timeInSecond / 60).floor();
                          String minute =
                              min.toString().length <= 1 ? "0$min" : "$min";
                          String second =
                              sec.toString().length <= 1 ? "0$sec" : "$sec";
                          return "$minute : $second";
                        }

                        return Card(
                          color: Colors.transparent,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            tileColor: Colors.transparent,
                            leading:
                                track.albumImage != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: Image.network(
                                        track.albumImage ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : const Icon(Icons.music_note),
                            title: AppText(
                              textName: track.name ?? 'No Title',
                              fontSize: 14.sp,
                              fontWidth: FontWeight.bold,
                              textColor: Color(AppColors.blueThird),
                            ),
                            subtitleTextStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                            ),

                            dense: true,
                            hoverColor: Colors.transparent,

                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          textName:
                                              track.albumName ??
                                              'Unknown album name',
                                          fontSize: 12.sp,
                                          textColor: Color(
                                            AppColors.blueExtraLight,
                                          ),
                                        ),
                                        AppText(
                                          textName:
                                              track.artistName ??
                                              "Unknown artist name",
                                          fontSize: 12.sp,
                                          textColor: Color(
                                            AppColors.blueExtraLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppText(
                                      textName: formattedTime(
                                        timeInSecond: track.duration!.toInt(),
                                      ),
                                      fontSize: 14.sp,
                                      textColor: Color(AppColors.blueLight),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => Center(child: appLoader()),
          error:
              (err, stack) => Center(
                child: Text('Error: $err', style: GoogleFonts.poppins()),
              ),
        ),
      ),
    );
  }
}
