// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lyrica/common/utils/utils.dart';
// import 'package:lyrica/common/widget/app_text.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/core/constant/app_string.dart';
// import 'package:lyrica/model/music_model.dart';

// class RecommendedSongs extends StatefulWidget {
//   final AsyncValue<List<Results>> musicAsyncValue;

//   const RecommendedSongs({super.key, required this.musicAsyncValue});

//   @override
//   State<RecommendedSongs> createState() => _RecommendedSongsState();
// }

// class _RecommendedSongsState extends State<RecommendedSongs> {
//   List<Results> shuffledTracks = [];

//   void shuffleTracks(List<Results> tracks) {
//     setState(() {
//       shuffledTracks = [...tracks]..shuffle();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.musicAsyncValue.when(
//       data: (tracks) {
//         final shuffledTracks = [...tracks]..shuffle();
//         final limitedTracks = shuffledTracks.take(10).toList();

//         return SizedBox(
//           height: MediaQuery.of(context).size.height / 1.5,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     AppText(
//                       textName: "Recommended Songs",
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                       textColor: Color(AppColors.lightText),
//                     ),
//                     IconButton(
//                       onPressed: () => shuffleTracks(tracks),
//                       icon: Icon(
//                         Icons.refresh,
//                         color: Color(AppColors.whiteBackground),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8.h),
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: const ScrollPhysics(),
//                     itemCount: limitedTracks.length,
//                     itemBuilder: (context, index) {
//                       final track = limitedTracks[index];

//                       String formattedTime({required int timeInSecond}) {
//                         int sec = timeInSecond % 60;
//                         int min = (timeInSecond / 60).floor();
//                         String minute = min < 10 ? "0$min" : "$min";
//                         String second = sec < 10 ? "0$sec" : "$sec";
//                         return "$minute : $second";
//                       }

//                       String? imageUrl =
//                           (track.albumImage == "")
//                               ? AppString.defaultImageLogo
//                               : track.albumImage;

//                       return Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.sp),
//                         ),
//                         color: const Color.fromARGB(
//                           255,
//                           0,
//                           27,
//                           31,
//                         ).withOpacity(0.2),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             tileColor: Colors.transparent,
//                             leading:
//                                 track.albumImage != null
//                                     ? ClipRRect(
//                                       borderRadius: BorderRadius.circular(3),
//                                       child: Image.network(
//                                         imageUrl ?? AppString.defaultMusicLogo,
//                                         fit: BoxFit.cover,
//                                         width: 60.w,
//                                       ),
//                                     )
//                                     : const Icon(Icons.music_note),
//                             title: AppText(
//                               textName: track.name ?? 'N/A',
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.bold,
//                               textColor: Color(AppColors.blueThird),
//                             ),
//                             subtitleTextStyle: GoogleFonts.poppins(
//                               color: Colors.grey,
//                             ),
//                             dense: true,
//                             hoverColor: Colors.transparent,
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           AppText(
//                                             textName:
//                                                 "${track.name ?? 'Unknown track'} (${formattedTime(timeInSecond: track.duration?.toInt() ?? 0)})",
//                                             fontSize: 12.sp,
//                                             textColor: Color(
//                                               AppColors.blueExtraLight,
//                                             ),
//                                           ),
//                                           AppText(
//                                             textName:
//                                                 track.artistName ??
//                                                 "Unknown artist name",
//                                             fontSize: 12.sp,
//                                             textColor: Color(
//                                               AppColors.blueExtraLight,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     IconButton(
//                                       onPressed: () {},
//                                       icon: Icon(
//                                         CupertinoIcons.add_circled,
//                                         color: Color(AppColors.blueLight),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       loading: () => Center(child: appLoader()),
//       error: (err, stack) => Center(child: AppText(textName: 'Error: $err')),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/playlist/provider/playlist_provider.dart';

class RecommendedSongs extends ConsumerWidget {
  final AsyncValue<List<Results>> musicAsyncValue;

  const RecommendedSongs({super.key, required this.musicAsyncValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return musicAsyncValue.when(
      data: (tracks) {
        final shuffledTracks = [...tracks]..shuffle();
        final limitedTracks = shuffledTracks.take(10).toList();

        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      textName: "Recommended Songs",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      textColor: Color(AppColors.lightText),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.refresh,
                        color: Color(AppColors.whiteBackground),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: limitedTracks.length,
                    itemBuilder: (context, index) {
                      final track = limitedTracks[index];

                      String formattedTime({required int timeInSecond}) {
                        int sec = timeInSecond % 60;
                        int min = (timeInSecond / 60).floor();
                        String minute = min < 10 ? "0$min" : "$min";
                        String second = sec < 10 ? "0$sec" : "$sec";
                        return "$minute : $second";
                      }

                      String? imageUrl =
                          (track.albumImage == "")
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                              textName: track.name ?? 'N/A',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            textName:
                                                "${track.name ?? 'Unknown track'} (${formattedTime(timeInSecond: track.duration?.toInt() ?? 0)})",
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
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ref
                                            .read(playlistProvider.notifier)
                                            .addSong(track);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Added ${track.name} to playlist',
                                            ),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        CupertinoIcons.add_circled,
                                        color: Color(AppColors.blueLight),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Center(child: appLoader()),
      error: (err, stack) => Center(child: AppText(textName: 'Error: $err')),
    );
  }
}
