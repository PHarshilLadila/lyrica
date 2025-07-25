import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';

class HindiMusicList extends ConsumerStatefulWidget {
  const HindiMusicList({super.key});

  @override
  ConsumerState<HindiMusicList> createState() => _HindiMusicListState();
}

class _HindiMusicListState extends ConsumerState<HindiMusicList> {
  @override
  Widget build(BuildContext context) {
    final hindiSongAsync = ref.watch(hindiSongDataProvider);

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(221, 39, 39, 39),

        appBar: AppBar(
          leading: AppBackButton(),
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Hindi Songs",
                fontSize: 20.sp,
                textColor: Color(AppColors.lightText),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        body: hindiSongAsync.when(
          data: (hindiSong) {
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(8.sp),
              physics: ScrollPhysics(),
              itemCount: hindiSong.length,
              itemBuilder: (context, index) {
                final track = hindiSong[index];

                String formattedTime({required int timeInSecond}) {
                  int sec = timeInSecond % 60;
                  int min = (timeInSecond / 60).floor();
                  String minute = min < 10 ? "0$min" : "$min";
                  String second = sec < 10 ? "0$sec" : "$sec";
                  return "$minute : $second";
                }

                String? imageUrl = track.albumImage;

                if (track.albumImage == "") {
                  imageUrl = AppString.defaultImageLogo;
                  // "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg";
                } else {
                  imageUrl = track.albumImage;
                }
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      tileColor: Colors.transparent,
                      leading:
                          track.albumImage != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Image.network(
                                  imageUrl ?? AppString.defaultMusicLogo,
                                  fit: BoxFit.cover,
                                  width: 60.w,
                                ),
                              )
                              : const Icon(Icons.music_note),
                      title: AppText(
                        text: track.name ?? 'N/A',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        textColor: Color(AppColors.blueThird),
                      ),
                      subtitleTextStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                      ),
                      dense: true,
                      hoverColor: Colors.transparent,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text:
                                          track.albumName ??
                                          'Unknown album name',
                                      fontSize: 12.sp,
                                      textColor: Color(
                                        AppColors.blueExtraLight,
                                      ),
                                    ),
                                    AppText(
                                      text:
                                          track.artistName ??
                                          "Unknown artist name",
                                      fontSize: 12.sp,
                                      textColor: Color(
                                        AppColors.blueExtraLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppText(
                                text: formattedTime(
                                  timeInSecond: track.duration?.toInt() ?? 0,
                                ),
                                fontSize: 14.sp,
                                textColor: Color(AppColors.blueLight),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MusicPlayer(
                                  songList: hindiSong,
                                  initialIndex: index,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
          loading: () => Center(child: appLoader()),
          error: (err, stack) => Center(child: AppText(text: 'Error: $err')),
        ),
      ),
    );
  }
}
