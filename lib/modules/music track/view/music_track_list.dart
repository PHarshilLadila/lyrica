// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lyrica/common/utils/utils.dart';
// import 'package:lyrica/common/widget/app_back_button.dart';
// import 'package:lyrica/common/widget/app_text.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/core/constant/app_string.dart';
// import 'package:lyrica/core/providers/provider.dart';
// import 'package:lyrica/model/music_model.dart';
// import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
// import 'package:lyrica/modules/music%20player/view/music_player.dart';
// import 'package:provider/provider.dart';

// class MusicTrackList extends ConsumerWidget {
//   final String? appBarTitle;
//   final int musicType;
//   final String genre;

//   const MusicTrackList(
//     this.appBarTitle, {
//     super.key,
//     required this.musicType,
//     required this.genre,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final AsyncValue<List<Results>> musicAsyncValue =
//         musicType == 1
//             ? ref.watch(musicDataProvider)
//             : ref.watch(genreMusicProvider(genre));

//     return Container(
//       decoration: BoxDecoration(gradient: backgroundGradient()),
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(197, 0, 43, 53),
//         appBar: AppBar(
//           leading: AppBackButton(),
//           elevation: 0,
//           toolbarHeight: 90,
//           backgroundColor: Colors.transparent,
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText(
//                 text: "$appBarTitle Songs",
//                 fontSize: 20.sp,
//                 textColor: Color(AppColors.lightText),
//                 fontWeight: FontWeight.w500,
//               ),
//             ],
//           ),
//         ),
//         body: musicAsyncValue.when(
//           data: (tracks) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppText(
//                     text: "Item Songs",
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w500,
//                     textColor: Color(AppColors.lightText),
//                   ),
//                   SizedBox(height: 8.h),
//                   Expanded(
//                     child: ListView.builder(
//                       physics: ScrollPhysics(),
//                       itemCount: tracks.length,
//                       itemBuilder: (context, index) {
//                         final track = tracks[index];

//                         String formattedTime({required int timeInSecond}) {
//                           int sec = timeInSecond % 60;
//                           int min = (timeInSecond / 60).floor();
//                           String minute = min < 10 ? "0$min" : "$min";
//                           String second = sec < 10 ? "0$sec" : "$sec";
//                           return "$minute : $second";
//                         }

//                         String? imageUrl = track.albumImage;

//                         if (track.albumImage == "") {
//                           imageUrl = AppString.defaultImageLogo;
//                           // "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg";
//                         } else {
//                           imageUrl = track.albumImage;
//                         }
//                         return Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.sp),
//                           ),
//                           color: const Color.fromARGB(
//                             255,
//                             0,
//                             27,
//                             31,
//                           ).withOpacity(0.2),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(vertical: 8.0),
//                             child: ListTile(
//                               tileColor: Colors.transparent,
//                               leading:
//                                   track.albumImage != null
//                                       ? ClipRRect(
//                                         borderRadius: BorderRadius.circular(3),
//                                         child: Image.network(
//                                           imageUrl ??
//                                               AppString.defaultMusicLogo,
//                                           fit: BoxFit.cover,
//                                           width: 60.w,
//                                         ),
//                                       )
//                                       : const Icon(Icons.music_note),
//                               title: AppText(
//                                 text: track.name ?? 'N/A',
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.bold,
//                                 textColor: Color(AppColors.blueThird),
//                               ),
//                               subtitleTextStyle: GoogleFonts.poppins(
//                                 color: Colors.grey,
//                               ),
//                               dense: true,
//                               hoverColor: Colors.transparent,
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             AppText(
//                                               text:
//                                                   track.albumName ??
//                                                   'Unknown album name',
//                                               fontSize: 12.sp,
//                                               textColor: Color(
//                                                 AppColors.blueExtraLight,
//                                               ),
//                                             ),
//                                             AppText(
//                                               text:
//                                                   track.artistName ??
//                                                   "Unknown artist name",
//                                               fontSize: 12.sp,
//                                               textColor: Color(
//                                                 AppColors.blueExtraLight,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Column(
//                                         children: [
//                                           IconButton(
//                                             icon: FaIcon(
//                                               context
//                                                       .watch<FavoriteProvider>()
//                                                       .isFavorite(
//                                                         track.id ?? "",
//                                                       )
//                                                   ? FontAwesomeIcons.solidHeart
//                                                   : FontAwesomeIcons.heart,
//                                             ),
//                                             iconSize: 20.sp,
//                                             color:
//                                                 context
//                                                         .watch<
//                                                           FavoriteProvider
//                                                         >()
//                                                         .isFavorite(
//                                                           track.id ?? "",
//                                                         )
//                                                     ? Color(AppColors.blueLight)
//                                                     : Color(
//                                                       AppColors.primaryColor,
//                                                     ),

//                                             onPressed: () {
//                                               final songData = {
//                                                 "id": track.id,
//                                                 "name": track.name,
//                                                 "artistName": track.artistName,
//                                                 "image": track.image,
//                                                 "audio": track.audio,
//                                                 "audioDuration": track.duration,
//                                                 "albumImage": track.albumImage,
//                                                 "albumName": track.albumName,
//                                                 "position": track.position,
//                                               };
//                                               context
//                                                   .read<FavoriteProvider>()
//                                                   .toggleFavorite(songData);
//                                             },
//                                           ),
//                                           AppText(
//                                             text: formattedTime(
//                                               timeInSecond:
//                                                   track.duration?.toInt() ?? 0,
//                                             ),
//                                             fontSize: 14.sp,
//                                             textColor: Color(
//                                               AppColors.blueLight,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) => MusicPlayer(
//                                           songList: tracks,
//                                           initialIndex: index,
//                                         ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           loading: () => Center(child: appLoader()),
//           error: (err, stack) => Center(child: AppText(text: 'Error: $err')),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MusicTrackList extends ConsumerWidget {
  final String? appBarTitle;
  final int musicType;
  final String genre;

  const MusicTrackList(
    this.appBarTitle, {
    super.key,
    required this.musicType,
    required this.genre,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Results>> musicAsyncValue =
        musicType == 1
            ? ref.watch(musicDataProvider)
            : ref.watch(genreMusicProvider(genre));

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          leading: const AppBackButton(),
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "$appBarTitle Songs",
                fontSize: 20.sp,
                textColor: Color(AppColors.lightText),
                fontWeight: FontWeight.w500,
              ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
            ],
          ),
        ),
        body: musicAsyncValue.when(
          data: (tracks) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: "Item Songs",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    textColor: Color(AppColors.lightText),
                  ).animate().fadeIn(delay: 150.ms),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        final track = tracks[index];

                        // String formattedTime({required int timeInSecond}) {
                        //   int sec = timeInSecond % 60;
                        //   int min = (timeInSecond / 60).floor();
                        //   String minute = min < 10 ? "0$min" : "$min";
                        //   String second = sec < 10 ? "0$sec" : "$sec";
                        //   return "$minute : $second";
                        // }

                        String? imageUrl =
                            track.albumImage == ""
                                ? AppString.defaultImageLogo
                                : track.albumImage;

                        return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.sp),
                              ),
                              color: const Color.fromARGB(
                                255,
                                0,
                                27,
                                31,
                              ).withOpacity(0.2),
                              margin: EdgeInsets.only(bottom: 8.h),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.sp),
                                // onTap: () {
                                //   Navigator.push(
                                //     context,
                                //     PageRouteBuilder(
                                //       pageBuilder:
                                //           (
                                //             context,
                                //             animation,
                                //             secondaryAnimation,
                                //           ) => MusicPlayer(
                                //             songList: tracks,
                                //             initialIndex: index,
                                //           ),
                                //       transitionsBuilder: (
                                //         context,
                                //         animation,
                                //         secondaryAnimation,
                                //         child,
                                //       ) {
                                //         return FadeTransition(
                                //           opacity: animation,
                                //           child: child,
                                //         );
                                //       },
                                //       transitionDuration: const Duration(
                                //         milliseconds: 200,
                                //       ),
                                //     ),
                                //   );
                                // },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 8.w,
                                  ),
                                  child: Row(
                                    children: [
                                      Hero(
                                        tag: 'album_art_${track.id}',
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.sp,
                                          ),
                                          child: Image.network(
                                            imageUrl ??
                                                AppString.defaultMusicLogo,
                                            fit: BoxFit.cover,
                                            width: 50.w,
                                            height: 50.w,
                                            cacheWidth:
                                                (60.w *
                                                        MediaQuery.of(
                                                          context,
                                                        ).devicePixelRatio)
                                                    .round(),
                                            cacheHeight:
                                                (60.w *
                                                        MediaQuery.of(
                                                          context,
                                                        ).devicePixelRatio)
                                                    .round(),
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
                                                      AppString
                                                          .defaultMusicLogo,
                                                    ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text: track.name ?? 'N/A',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              textColor: Color(
                                                AppColors.blueThird,
                                              ),
                                              maxLines: 1,
                                            ),
                                            SizedBox(height: 4.h),
                                            AppText(
                                              text:
                                                  track.albumName ??
                                                  'Unknown album name',
                                              fontSize: 12.sp,
                                              textColor: Color(
                                                AppColors.blueExtraLight,
                                              ),
                                              maxLines: 1,
                                            ),
                                            AppText(
                                              text:
                                                  track.artistName ??
                                                  "Unknown artist name",
                                              fontSize: 12.sp,
                                              textColor: Color(
                                                AppColors.blueExtraLight,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: FaIcon(
                                                  context
                                                          .watch<
                                                            FavoriteProvider
                                                          >()
                                                          .isFavorite(
                                                            track.id ?? "",
                                                          )
                                                      ? FontAwesomeIcons
                                                          .solidHeart
                                                      : FontAwesomeIcons.heart,
                                                  size: 20.sp,
                                                ),
                                                color:
                                                    context
                                                            .watch<
                                                              FavoriteProvider
                                                            >()
                                                            .isFavorite(
                                                              track.id ?? "",
                                                            )
                                                        ? Color(
                                                          AppColors.blueLight,
                                                        )
                                                        : Color(
                                                          AppColors
                                                              .primaryColor,
                                                        ),
                                                onPressed: () {
                                                  final songData = {
                                                    "id": track.id,
                                                    "name": track.name,
                                                    "artistName":
                                                        track.artistName,
                                                    "image": track.image,
                                                    "audio": track.audio,
                                                    "audioDuration":
                                                        track.duration,
                                                    "albumImage":
                                                        track.albumImage,
                                                    "albumName":
                                                        track.albumName,
                                                    "position": track.position,
                                                  };
                                                  context
                                                      .read<FavoriteProvider>()
                                                      .toggleFavorite(songData);
                                                },
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => MusicPlayer(
                                                        songList: tracks,
                                                        initialIndex: index,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 35.w,
                                              height: 35.h,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(
                                                      AppColors.primaryColor,
                                                    ),
                                                    Color(AppColors.blueLight),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(
                                                      AppColors.primaryColor,
                                                    ).withOpacity(0.4),
                                                    blurRadius: 14,
                                                    spreadRadius: 0,
                                                    offset: Offset(0, 6),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.play,
                                                  color: Colors.white,
                                                  size: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .animate(delay: (30 * index).ms)
                            .fadeIn(duration: 150.ms, curve: Curves.easeOut)
                            .slideX(
                              begin: 0.2,
                              duration: 150.ms,
                              curve: Curves.easeOut,
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
                child: AppText(
                  text: 'Error: $err',
                  textColor: Colors.red,
                ).animate().shakeX(duration: 300.ms), // Faster shake
              ),
        ),
      ).animate().fadeIn(duration: 200.ms), // Faster scaffold fade in
    );
  }
}
