// // // // // ignore_for_file: deprecated_member_use
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // // import 'package:lyrica/common/utils/utils.dart';
// // // // import 'package:lyrica/common/widget/app_back_button.dart';
// // // // import 'package:lyrica/common/widget/app_text.dart';
// // // // import 'package:lyrica/core/constant/app_colors.dart';
// // // // import 'package:lyrica/core/constant/app_string.dart';
// // // // import 'package:lyrica/core/providers/provider.dart';
// // // // import 'package:lyrica/model/music_model.dart';
// // // // import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
// // // // import 'package:lyrica/modules/music%20player/view/music_player.dart';
// // // // import 'package:provider/provider.dart';
// // // // import 'package:flutter_animate/flutter_animate.dart';

// // // // class MusicTrackList extends ConsumerWidget {
// // // //   final String? appBarTitle;
// // // //   final int musicType;
// // // //   final String genre;

// // // //   const MusicTrackList(
// // // //     this.appBarTitle, {
// // // //     super.key,
// // // //     required this.musicType,
// // // //     required this.genre,
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context, WidgetRef ref) {
// // // //     final AsyncValue<List<Results>> musicAsyncValue =
// // // //         musicType == 1
// // // //             ? ref.watch(musicDataProvider)
// // // //             : ref.watch(genreMusicProvider(genre));

// // // //     return Container(
// // // //       decoration: BoxDecoration(gradient: backgroundGradient()),
// // // //       child: Scaffold(
// // // //         backgroundColor: const Color.fromARGB(197, 0, 43, 53),
// // // //         appBar: AppBar(
// // // //           leading: const AppBackButton(),
// // // //           elevation: 0,
// // // //           toolbarHeight: 90,
// // // //           backgroundColor: Colors.transparent,
// // // //           title: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               AppText(
// // // //                 text: "$appBarTitle Songs",
// // // //                 fontSize: 20.sp,
// // // //                 textColor: Color(AppColors.lightText),
// // // //                 fontWeight: FontWeight.w500,
// // // //               ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //         body: musicAsyncValue.when(
// // // //           data: (tracks) {
// // // //             return Padding(
// // // //               padding: const EdgeInsets.all(8.0),
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   AppText(
// // // //                     text: "Item Songs",
// // // //                     fontSize: 18.sp,
// // // //                     fontWeight: FontWeight.w500,
// // // //                     textColor: Color(AppColors.lightText),
// // // //                   ).animate().fadeIn(delay: 150.ms),
// // // //                   SizedBox(height: 8.h),
// // // //                   Expanded(
// // // //                     child: ListView.builder(
// // // //                       physics: const BouncingScrollPhysics(),
// // // //                       itemCount: tracks.length,
// // // //                       itemBuilder: (context, index) {
// // // //                         final track = tracks[index];

// // // //                         String? imageUrl =
// // // //                             track.albumImage == ""
// // // //                                 ? AppString.defaultImageLogo
// // // //                                 : track.albumImage;

// // // //                         return Card(
// // // //                               shape: RoundedRectangleBorder(
// // // //                                 borderRadius: BorderRadius.circular(8.sp),
// // // //                               ),
// // // //                               color: const Color.fromARGB(
// // // //                                 255,
// // // //                                 0,
// // // //                                 27,
// // // //                                 31,
// // // //                               ).withOpacity(0.2),
// // // //                               margin: EdgeInsets.only(bottom: 8.h),
// // // //                               child: InkWell(
// // // //                                 borderRadius: BorderRadius.circular(8.sp),

// // // //                                 child: Padding(
// // // //                                   padding: EdgeInsets.symmetric(
// // // //                                     vertical: 8.0,
// // // //                                     horizontal: 8.w,
// // // //                                   ),
// // // //                                   child: Row(
// // // //                                     children: [
// // // //                                       Hero(
// // // //                                         tag: 'album_art_${track.id}',
// // // //                                         child: ClipRRect(
// // // //                                           borderRadius: BorderRadius.circular(
// // // //                                             8.sp,
// // // //                                           ),
// // // //                                           child: Image.network(
// // // //                                             imageUrl ??
// // // //                                                 AppString.defaultMusicLogo,
// // // //                                             fit: BoxFit.cover,
// // // //                                             width: 50.w,
// // // //                                             height: 50.w,
// // // //                                             cacheWidth:
// // // //                                                 (60.w *
// // // //                                                         MediaQuery.of(
// // // //                                                           context,
// // // //                                                         ).devicePixelRatio)
// // // //                                                     .round(),
// // // //                                             cacheHeight:
// // // //                                                 (60.w *
// // // //                                                         MediaQuery.of(
// // // //                                                           context,
// // // //                                                         ).devicePixelRatio)
// // // //                                                     .round(),
// // // //                                             errorBuilder:
// // // //                                                 (context, error, stackTrace) =>
// // // //                                                     Image.asset(
// // // //                                                       AppString
// // // //                                                           .defaultMusicLogo,
// // // //                                                     ),
// // // //                                           ),
// // // //                                         ),
// // // //                                       ),
// // // //                                       SizedBox(width: 12.w),
// // // //                                       Expanded(
// // // //                                         child: Column(
// // // //                                           crossAxisAlignment:
// // // //                                               CrossAxisAlignment.start,
// // // //                                           children: [
// // // //                                             AppText(
// // // //                                               text: track.name ?? 'N/A',
// // // //                                               fontSize: 14.sp,
// // // //                                               fontWeight: FontWeight.bold,
// // // //                                               textColor: Color(
// // // //                                                 AppColors.blueThird,
// // // //                                               ),
// // // //                                               maxLines: 1,
// // // //                                             ),
// // // //                                             SizedBox(height: 4.h),
// // // //                                             AppText(
// // // //                                               text:
// // // //                                                   track.albumName ??
// // // //                                                   'Unknown album name',
// // // //                                               fontSize: 12.sp,
// // // //                                               textColor: Color(
// // // //                                                 AppColors.blueExtraLight,
// // // //                                               ),
// // // //                                               maxLines: 1,
// // // //                                             ),
// // // //                                             AppText(
// // // //                                               text:
// // // //                                                   track.artistName ??
// // // //                                                   "Unknown artist name",
// // // //                                               fontSize: 12.sp,
// // // //                                               textColor: Color(
// // // //                                                 AppColors.blueExtraLight,
// // // //                                               ),
// // // //                                               maxLines: 1,
// // // //                                             ),
// // // //                                           ],
// // // //                                         ),
// // // //                                       ),
// // // //                                       Row(
// // // //                                         children: [
// // // //                                           Column(
// // // //                                             mainAxisAlignment:
// // // //                                                 MainAxisAlignment.center,
// // // //                                             children: [
// // // //                                               IconButton(
// // // //                                                 icon: FaIcon(
// // // //                                                   context
// // // //                                                           .watch<
// // // //                                                             FavoriteProvider
// // // //                                                           >()
// // // //                                                           .isFavorite(
// // // //                                                             track.id ?? "",
// // // //                                                           )
// // // //                                                       ? FontAwesomeIcons
// // // //                                                           .solidHeart
// // // //                                                       : FontAwesomeIcons.heart,
// // // //                                                   size: 20.sp,
// // // //                                                 ),
// // // //                                                 color:
// // // //                                                     context
// // // //                                                             .watch<
// // // //                                                               FavoriteProvider
// // // //                                                             >()
// // // //                                                             .isFavorite(
// // // //                                                               track.id ?? "",
// // // //                                                             )
// // // //                                                         ? Color(
// // // //                                                           AppColors.blueLight,
// // // //                                                         )
// // // //                                                         : Color(
// // // //                                                           AppColors
// // // //                                                               .primaryColor,
// // // //                                                         ),

// // // //                                                 onPressed: () async {
// // // //                                                   final songData = {
// // // //                                                     "id": track.id,
// // // //                                                     "name": track.name,
// // // //                                                     "artistName":
// // // //                                                         track.artistName,
// // // //                                                     "image": track.image,
// // // //                                                     "audio": track.audio,
// // // //                                                     "audioDuration":
// // // //                                                         track.duration,
// // // //                                                     "albumName":
// // // //                                                         track.albumName,
// // // //                                                     "albumImage":
// // // //                                                         track.albumImage,
// // // //                                                     "position": track.position,
// // // //                                                   };
// // // //                                                   context
// // // //                                                       .read<FavoriteProvider>()
// // // //                                                       .toggleFavorite(songData);
// // // //                                                 },
// // // //                                               ),
// // // //                                             ],
// // // //                                           ),
// // // //                                           GestureDetector(
// // // //                                             onTap: () {
// // // //                                               Navigator.push(
// // // //                                                 context,
// // // //                                                 MaterialPageRoute(
// // // //                                                   builder:
// // // //                                                       (context) => MusicPlayer(
// // // //                                                         songList: tracks,
// // // //                                                         initialIndex: index,
// // // //                                                          onMinimize: () {},
// // // //                                                       ),
// // // //                                                 ),
// // // //                                               );
// // // //                                             },
// // // //                                             child: Container(
// // // //                                               width: 35.w,
// // // //                                               height: 35.h,
// // // //                                               decoration: BoxDecoration(
// // // //                                                 gradient: LinearGradient(
// // // //                                                   colors: [
// // // //                                                     Color(
// // // //                                                       AppColors.primaryColor,
// // // //                                                     ),
// // // //                                                     Color(AppColors.blueLight),
// // // //                                                   ],
// // // //                                                   begin: Alignment.topLeft,
// // // //                                                   end: Alignment.bottomRight,
// // // //                                                 ),
// // // //                                                 shape: BoxShape.circle,
// // // //                                                 boxShadow: [
// // // //                                                   BoxShadow(
// // // //                                                     color: Color(
// // // //                                                       AppColors.primaryColor,
// // // //                                                     ).withOpacity(0.4),
// // // //                                                     blurRadius: 14,
// // // //                                                     spreadRadius: 0,
// // // //                                                     offset: Offset(0, 6),
// // // //                                                   ),
// // // //                                                 ],
// // // //                                               ),
// // // //                                               child: Center(
// // // //                                                 child: FaIcon(
// // // //                                                   FontAwesomeIcons.play,
// // // //                                                   color: Colors.white,
// // // //                                                   size: 16.sp,
// // // //                                                 ),
// // // //                                               ),
// // // //                                             ),
// // // //                                           ),
// // // //                                         ],
// // // //                                       ),
// // // //                                     ],
// // // //                                   ),
// // // //                                 ),
// // // //                               ),
// // // //                             )
// // // //                             .animate(delay: (30 * index).ms)
// // // //                             .fadeIn(duration: 150.ms, curve: Curves.easeOut)
// // // //                             .slideX(
// // // //                               begin: 0.2,
// // // //                               duration: 150.ms,
// // // //                               curve: Curves.easeOut,
// // // //                             );
// // // //                       },
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             );
// // // //           },
// // // //           loading: () => Center(child: appLoader()),
// // // //           error:
// // // //               (err, stack) => Center(
// // // //                 child: AppText(
// // // //                   text: 'Error: $err',
// // // //                   textColor: Colors.red,
// // // //                 ).animate().shakeX(duration: 300.ms),
// // // //               ),
// // // //         ),
// // // //       ).animate().fadeIn(duration: 200.ms),
// // // //     );
// // // //   }
// // // // }
// // // // ignore_for_file: deprecated_member_use

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // import 'package:lyrica/common/utils/utils.dart';
// // // import 'package:lyrica/common/widget/app_back_button.dart';
// // // import 'package:lyrica/common/widget/app_text.dart';
// // // import 'package:lyrica/core/constant/app_colors.dart';
// // // import 'package:lyrica/core/constant/app_string.dart';
// // // import 'package:lyrica/core/providers/provider.dart';
// // // import 'package:lyrica/main.dart';
// // // import 'package:lyrica/model/music_model.dart';
// // // import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
// // // import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:flutter_animate/flutter_animate.dart';

// // // class MusicTrackList extends ConsumerWidget {
// // //   final String? appBarTitle;
// // //   final int musicType;
// // //   final String genre;

// // //   const MusicTrackList(
// // //     this.appBarTitle, {
// // //     super.key,
// // //     required this.musicType,
// // //     required this.genre,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context, WidgetRef ref) {
// // //     final AsyncValue<List<Results>> musicAsyncValue =
// // //         musicType == 1
// // //             ? ref.watch(musicDataProvider)
// // //             : ref.watch(genreMusicProvider(genre));

// // //     return Container(
// // //       decoration: BoxDecoration(gradient: backgroundGradient()),
// // //       child: Scaffold(
// // //         backgroundColor: const Color.fromARGB(197, 0, 43, 53),
// // //         appBar: AppBar(
// // //           leading: const AppBackButton(),
// // //           elevation: 0,
// // //           toolbarHeight: 90,
// // //           backgroundColor: Colors.transparent,
// // //           title: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               AppText(
// // //                 text: "$appBarTitle Songs",
// // //                 fontSize: 20.sp,
// // //                 textColor: Color(AppColors.lightText),
// // //                 fontWeight: FontWeight.w500,
// // //               ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
// // //             ],
// // //           ),
// // //         ),
// // //         body: musicAsyncValue.when(
// // //           data: (tracks) {
// // //             return Padding(
// // //               padding: const EdgeInsets.all(8.0),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   AppText(
// // //                     text: "Item Songs",
// // //                     fontSize: 18.sp,
// // //                     fontWeight: FontWeight.w500,
// // //                     textColor: Color(AppColors.lightText),
// // //                   ).animate().fadeIn(delay: 150.ms),
// // //                   SizedBox(height: 8.h),
// // //                   Expanded(
// // //                     child: ListView.builder(
// // //                       physics: const BouncingScrollPhysics(),
// // //                       itemCount: tracks.length,
// // //                       itemBuilder: (context, index) {
// // //                         final track = tracks[index];

// // //                         String? imageUrl =
// // //                             track.albumImage == ""
// // //                                 ? AppString.defaultImageLogo
// // //                                 : track.albumImage;

// // //                         return Card(
// // //                               shape: RoundedRectangleBorder(
// // //                                 borderRadius: BorderRadius.circular(8.sp),
// // //                               ),
// // //                               color: const Color.fromARGB(
// // //                                 255,
// // //                                 0,
// // //                                 27,
// // //                                 31,
// // //                               ).withOpacity(0.2),
// // //                               margin: EdgeInsets.only(bottom: 8.h),
// // //                               child: InkWell(
// // //                                 borderRadius: BorderRadius.circular(8.sp),
// // //                                 onTap: () {
// // //                                   ref
// // //                                       .read(currentMusicProvider.notifier)
// // //                                       .setMusic(track, tracks, index);

// // //                                   final musicPlayer = getCurrentMusicPlayer(
// // //                                     ref,
// // //                                   );
// // //                                   musicPlayer?.playSong(index);

// // //                                   // ✅ Open mini player
// // //                                   AppWithMiniPlayer.expandMiniPlayer(context);
// // //                                 },

// // //                                 child: Padding(
// // //                                   padding: EdgeInsets.symmetric(
// // //                                     vertical: 8.0,
// // //                                     horizontal: 8.w,
// // //                                   ),
// // //                                   child: Row(
// // //                                     children: [
// // //                                       Hero(
// // //                                         tag: 'album_art_${track.id}',
// // //                                         child: ClipRRect(
// // //                                           borderRadius: BorderRadius.circular(
// // //                                             8.sp,
// // //                                           ),
// // //                                           child: Image.network(
// // //                                             imageUrl ??
// // //                                                 AppString.defaultMusicLogo,
// // //                                             fit: BoxFit.cover,
// // //                                             width: 50.w,
// // //                                             height: 50.w,
// // //                                             cacheWidth:
// // //                                                 (60.w *
// // //                                                         MediaQuery.of(
// // //                                                           context,
// // //                                                         ).devicePixelRatio)
// // //                                                     .round(),
// // //                                             cacheHeight:
// // //                                                 (60.w *
// // //                                                         MediaQuery.of(
// // //                                                           context,
// // //                                                         ).devicePixelRatio)
// // //                                                     .round(),
// // //                                             errorBuilder:
// // //                                                 (context, error, stackTrace) =>
// // //                                                     Image.asset(
// // //                                                       AppString
// // //                                                           .defaultMusicLogo,
// // //                                                     ),
// // //                                           ),
// // //                                         ),
// // //                                       ),
// // //                                       SizedBox(width: 12.w),
// // //                                       Expanded(
// // //                                         child: Column(
// // //                                           crossAxisAlignment:
// // //                                               CrossAxisAlignment.start,
// // //                                           children: [
// // //                                             AppText(
// // //                                               text: track.name ?? 'N/A',
// // //                                               fontSize: 14.sp,
// // //                                               fontWeight: FontWeight.bold,
// // //                                               textColor: Color(
// // //                                                 AppColors.blueThird,
// // //                                               ),
// // //                                               maxLines: 1,
// // //                                             ),
// // //                                             SizedBox(height: 4.h),
// // //                                             AppText(
// // //                                               text:
// // //                                                   track.albumName ??
// // //                                                   'Unknown album name',
// // //                                               fontSize: 12.sp,
// // //                                               textColor: Color(
// // //                                                 AppColors.blueExtraLight,
// // //                                               ),
// // //                                               maxLines: 1,
// // //                                             ),
// // //                                             AppText(
// // //                                               text:
// // //                                                   track.artistName ??
// // //                                                   "Unknown artist name",
// // //                                               fontSize: 12.sp,
// // //                                               textColor: Color(
// // //                                                 AppColors.blueExtraLight,
// // //                                               ),
// // //                                               maxLines: 1,
// // //                                             ),
// // //                                           ],
// // //                                         ),
// // //                                       ),
// // //                                       Row(
// // //                                         children: [
// // //                                           Column(
// // //                                             mainAxisAlignment:
// // //                                                 MainAxisAlignment.center,
// // //                                             children: [
// // //                                               IconButton(
// // //                                                 icon: FaIcon(
// // //                                                   context
// // //                                                           .watch<
// // //                                                             FavoriteProvider
// // //                                                           >()
// // //                                                           .isFavorite(
// // //                                                             track.id ?? "",
// // //                                                           )
// // //                                                       ? FontAwesomeIcons
// // //                                                           .solidHeart
// // //                                                       : FontAwesomeIcons.heart,
// // //                                                   size: 20.sp,
// // //                                                 ),
// // //                                                 color:
// // //                                                     context
// // //                                                             .watch<
// // //                                                               FavoriteProvider
// // //                                                             >()
// // //                                                             .isFavorite(
// // //                                                               track.id ?? "",
// // //                                                             )
// // //                                                         ? Color(
// // //                                                           AppColors.blueLight,
// // //                                                         )
// // //                                                         : Color(
// // //                                                           AppColors
// // //                                                               .primaryColor,
// // //                                                         ),

// // //                                                 onPressed: () async {
// // //                                                   final songData = {
// // //                                                     "id": track.id,
// // //                                                     "name": track.name,
// // //                                                     "artistName":
// // //                                                         track.artistName,
// // //                                                     "image": track.image,
// // //                                                     "audio": track.audio,
// // //                                                     "audioDuration":
// // //                                                         track.duration,
// // //                                                     "albumName":
// // //                                                         track.albumName,
// // //                                                     "albumImage":
// // //                                                         track.albumImage,
// // //                                                     "position": track.position,
// // //                                                   };
// // //                                                   context
// // //                                                       .read<FavoriteProvider>()
// // //                                                       .toggleFavorite(songData);
// // //                                                 },
// // //                                               ),
// // //                                             ],
// // //                                           ),
// // //                                           GestureDetector(
// // //                                             onTap: () {
// // //                                               ref
// // //                                                   .read(
// // //                                                     currentMusicProvider
// // //                                                         .notifier,
// // //                                                   )
// // //                                                   .setMusic(
// // //                                                     track,
// // //                                                     tracks,
// // //                                                     index,
// // //                                                   );

// // //                                               final musicPlayer =
// // //                                                   getCurrentMusicPlayer(ref);
// // //                                               musicPlayer?.playSong(index);

// // //                                               // ✅ Open mini player
// // //                                               AppWithMiniPlayer.expandMiniPlayer(
// // //                                                 context,
// // //                                               );
// // //                                             },

// // //                                             child: Container(
// // //                                               width: 35.w,
// // //                                               height: 35.h,
// // //                                               decoration: BoxDecoration(
// // //                                                 gradient: LinearGradient(
// // //                                                   colors: [
// // //                                                     Color(
// // //                                                       AppColors.primaryColor,
// // //                                                     ),
// // //                                                     Color(AppColors.blueLight),
// // //                                                   ],
// // //                                                   begin: Alignment.topLeft,
// // //                                                   end: Alignment.bottomRight,
// // //                                                 ),
// // //                                                 shape: BoxShape.circle,
// // //                                                 boxShadow: [
// // //                                                   BoxShadow(
// // //                                                     color: Color(
// // //                                                       AppColors.primaryColor,
// // //                                                     ).withOpacity(0.4),
// // //                                                     blurRadius: 14,
// // //                                                     spreadRadius: 0,
// // //                                                     offset: Offset(0, 6),
// // //                                                   ),
// // //                                                 ],
// // //                                               ),
// // //                                               child: Center(
// // //                                                 child: FaIcon(
// // //                                                   FontAwesomeIcons.play,
// // //                                                   color: Colors.white,
// // //                                                   size: 16.sp,
// // //                                                 ),
// // //                                               ),
// // //                                             ),
// // //                                           ),
// // //                                         ],
// // //                                       ),
// // //                                     ],
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             )
// // //                             .animate(delay: (30 * index).ms)
// // //                             .fadeIn(duration: 150.ms, curve: Curves.easeOut)
// // //                             .slideX(
// // //                               begin: 0.2,
// // //                               duration: 150.ms,
// // //                               curve: Curves.easeOut,
// // //                             );
// // //                       },
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             );
// // //           },
// // //           loading: () => Center(child: appLoader()),
// // //           error:
// // //               (err, stack) => Center(
// // //                 child: AppText(
// // //                   text: 'Error: $err',
// // //                   textColor: Colors.red,
// // //                 ).animate().shakeX(duration: 300.ms),
// // //               ),
// // //         ),
// // //       ).animate().fadeIn(duration: 200.ms),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:lyrica/common/utils/utils.dart';
// // import 'package:lyrica/common/widget/app_back_button.dart';
// // import 'package:lyrica/common/widget/app_text.dart';
// // import 'package:lyrica/core/constant/app_colors.dart';
// // import 'package:lyrica/core/constant/app_string.dart';
// // import 'package:lyrica/core/providers/provider.dart';
// // import 'package:lyrica/main.dart';
// // import 'package:lyrica/model/music_model.dart';
// // import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
// // import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
// // import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// // import 'package:provider/provider.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart'
// //     as music_player;
// // import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart'
// //     as current_music;

// // class MusicTrackList extends ConsumerWidget {
// //   final String? appBarTitle;
// //   final int musicType;
// //   final String genre;

// //   const MusicTrackList(
// //     this.appBarTitle, {
// //     super.key,
// //     required this.musicType,
// //     required this.genre,
// //   });

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final AsyncValue<List<Results>> musicAsyncValue =
// //         musicType == 1
// //             ? ref.watch(musicDataProvider)
// //             : ref.watch(genreMusicProvider(genre));

// //     return Container(
// //       decoration: BoxDecoration(gradient: backgroundGradient()),
// //       child: Scaffold(
// //         backgroundColor: const Color.fromARGB(197, 0, 43, 53),
// //         appBar: AppBar(
// //           leading: const AppBackButton(),
// //           elevation: 0,
// //           toolbarHeight: 90,
// //           backgroundColor: Colors.transparent,
// //           title: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               AppText(
// //                 text: "$appBarTitle Songs",
// //                 fontSize: 20.sp,
// //                 textColor: Color(AppColors.lightText),
// //                 fontWeight: FontWeight.w500,
// //               ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
// //             ],
// //           ),
// //         ),
// //         body: musicAsyncValue.when(
// //           data: (tracks) {
// //             return Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   AppText(
// //                     text: "Item Songs",
// //                     fontSize: 18.sp,
// //                     fontWeight: FontWeight.w500,
// //                     textColor: Color(AppColors.lightText),
// //                   ).animate().fadeIn(delay: 150.ms),
// //                   SizedBox(height: 8.h),
// //                   Expanded(
// //                     child: ListView.builder(
// //                       physics: const BouncingScrollPhysics(),
// //                       itemCount: tracks.length,
// //                       itemBuilder: (context, index) {
// //                         final track = tracks[index];

// //                         String? imageUrl =
// //                             track.albumImage == ""
// //                                 ? AppString.defaultImageLogo
// //                                 : track.albumImage;

// //                         return Card(
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(8.sp),
// //                               ),
// //                               color: const Color.fromARGB(
// //                                 255,
// //                                 0,
// //                                 27,
// //                                 31,
// //                               ).withOpacity(0.2),
// //                               margin: EdgeInsets.only(bottom: 8.h),
// //                               child: InkWell(
// //                                 borderRadius: BorderRadius.circular(8.sp),
// //                                 onTap: () {
// //                                   _playSong(ref, tracks, index, context);
// //                                 },
// //                                 child: Padding(
// //                                   padding: EdgeInsets.symmetric(
// //                                     vertical: 8.0,
// //                                     horizontal: 8.w,
// //                                   ),
// //                                   child: Row(
// //                                     children: [
// //                                       Hero(
// //                                         tag: 'album_art_${track.id}',
// //                                         child: ClipRRect(
// //                                           borderRadius: BorderRadius.circular(
// //                                             8.sp,
// //                                           ),
// //                                           child: Image.network(
// //                                             imageUrl ??
// //                                                 AppString.defaultMusicLogo,
// //                                             fit: BoxFit.cover,
// //                                             width: 50.w,
// //                                             height: 50.w,
// //                                             cacheWidth:
// //                                                 (60.w *
// //                                                         MediaQuery.of(
// //                                                           context,
// //                                                         ).devicePixelRatio)
// //                                                     .round(),
// //                                             cacheHeight:
// //                                                 (60.w *
// //                                                         MediaQuery.of(
// //                                                           context,
// //                                                         ).devicePixelRatio)
// //                                                     .round(),
// //                                             errorBuilder:
// //                                                 (context, error, stackTrace) =>
// //                                                     Image.asset(
// //                                                       AppString
// //                                                           .defaultMusicLogo,
// //                                                     ),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       SizedBox(width: 12.w),
// //                                       Expanded(
// //                                         child: Column(
// //                                           crossAxisAlignment:
// //                                               CrossAxisAlignment.start,
// //                                           children: [
// //                                             AppText(
// //                                               text: track.name ?? 'N/A',
// //                                               fontSize: 14.sp,
// //                                               fontWeight: FontWeight.bold,
// //                                               textColor: Color(
// //                                                 AppColors.blueThird,
// //                                               ),
// //                                               maxLines: 1,
// //                                             ),
// //                                             SizedBox(height: 4.h),
// //                                             AppText(
// //                                               text:
// //                                                   track.albumName ??
// //                                                   'Unknown album name',
// //                                               fontSize: 12.sp,
// //                                               textColor: Color(
// //                                                 AppColors.blueExtraLight,
// //                                               ),
// //                                               maxLines: 1,
// //                                             ),
// //                                             AppText(
// //                                               text:
// //                                                   track.artistName ??
// //                                                   "Unknown artist name",
// //                                               fontSize: 12.sp,
// //                                               textColor: Color(
// //                                                 AppColors.blueExtraLight,
// //                                               ),
// //                                               maxLines: 1,
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                       Row(
// //                                         children: [
// //                                           Column(
// //                                             mainAxisAlignment:
// //                                                 MainAxisAlignment.center,
// //                                             children: [
// //                                               IconButton(
// //                                                 icon: FaIcon(
// //                                                   context
// //                                                           .watch<
// //                                                             FavoriteProvider
// //                                                           >()
// //                                                           .isFavorite(
// //                                                             track.id ?? "",
// //                                                           )
// //                                                       ? FontAwesomeIcons
// //                                                           .solidHeart
// //                                                       : FontAwesomeIcons.heart,
// //                                                   size: 20.sp,
// //                                                 ),
// //                                                 color:
// //                                                     context
// //                                                             .watch<
// //                                                               FavoriteProvider
// //                                                             >()
// //                                                             .isFavorite(
// //                                                               track.id ?? "",
// //                                                             )
// //                                                         ? Color(
// //                                                           AppColors.blueLight,
// //                                                         )
// //                                                         : Color(
// //                                                           AppColors
// //                                                               .primaryColor,
// //                                                         ),

// //                                                 onPressed: () async {
// //                                                   final songData = {
// //                                                     "id": track.id,
// //                                                     "name": track.name,
// //                                                     "artistName":
// //                                                         track.artistName,
// //                                                     "image": track.image,
// //                                                     "audio": track.audio,
// //                                                     "audioDuration":
// //                                                         track.duration,
// //                                                     "albumName":
// //                                                         track.albumName,
// //                                                     "albumImage":
// //                                                         track.albumImage,
// //                                                     "position": track.position,
// //                                                   };
// //                                                   context
// //                                                       .read<FavoriteProvider>()
// //                                                       .toggleFavorite(songData);
// //                                                 },
// //                                               ),
// //                                             ],
// //                                           ),
// //                                           GestureDetector(
// //                                             onTap: () {
// //                                               _playSong(
// //                                                 ref,
// //                                                 tracks,
// //                                                 index,
// //                                                 context,
// //                                               );
// //                                             },
// //                                             child: Container(
// //                                               width: 35.w,
// //                                               height: 35.h,
// //                                               decoration: BoxDecoration(
// //                                                 gradient: LinearGradient(
// //                                                   colors: [
// //                                                     Color(
// //                                                       AppColors.primaryColor,
// //                                                     ),
// //                                                     Color(AppColors.blueLight),
// //                                                   ],
// //                                                   begin: Alignment.topLeft,
// //                                                   end: Alignment.bottomRight,
// //                                                 ),
// //                                                 shape: BoxShape.circle,
// //                                                 boxShadow: [
// //                                                   BoxShadow(
// //                                                     color: Color(
// //                                                       AppColors.primaryColor,
// //                                                     ).withOpacity(0.4),
// //                                                     blurRadius: 14,
// //                                                     spreadRadius: 0,
// //                                                     offset: Offset(0, 6),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                               child: Center(
// //                                                 child: FaIcon(
// //                                                   FontAwesomeIcons.play,
// //                                                   color: Colors.white,
// //                                                   size: 16.sp,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             )
// //                             .animate(delay: (30 * index).ms)
// //                             .fadeIn(duration: 150.ms, curve: Curves.easeOut)
// //                             .slideX(
// //                               begin: 0.2,
// //                               duration: 150.ms,
// //                               curve: Curves.easeOut,
// //                             );
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //           loading: () => Center(child: appLoader()),
// //           error:
// //               (err, stack) => Center(
// //                 child: AppText(
// //                   text: 'Error: $err',
// //                   textColor: Colors.red,
// //                 ).animate().shakeX(duration: 300.ms),
// //               ),
// //         ),
// //       ).animate().fadeIn(duration: 200.ms),
// //     );
// //   }

// //   void _playSong(
// //     WidgetRef ref,
// //     List<Results> tracks,
// //     int index,
// //     BuildContext context,
// //   ) {
// //     try {
// //       // First update the current music state using the alias
// //       ref
// //           .read(current_music.currentMusicProvider.notifier)
// //           .setMusic(tracks[index], tracks, index);

// //       // Then get or create the music player using the alias
// //       final musicPlayer = _getOrCreateMusicPlayer(ref, tracks, index);

// //       if (musicPlayer != null) {
// //         // Use the public method instead of private _loadSong
// //         musicPlayer.playSong(index);

// //         // Expand the mini player
// //         WidgetsBinding.instance.addPostFrameCallback((_) {
// //           BottomSheetScreen.expandMiniPlayer();
// //         });
// //       }
// //     } catch (e) {
// //       debugPrint("Error playing song: $e");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error playing song: ${e.toString()}')),
// //       );
// //     }
// //   }

// //   MusicPlayerNotifier? _getOrCreateMusicPlayer(
// //     WidgetRef ref,
// //     List<Results> tracks,
// //     int index,
// //   ) {
// //     try {
// //       // Try to get the active player first
// //       final activePlayer = ref.read(activeMusicPlayerProvider);

// //       // If we have an active player for the same playlist, use it
// //       if (activePlayer != null &&
// //           activePlayer.mounted &&
// //           listEquals(activePlayer.songList, tracks)) {
// //         return activePlayer;
// //       }

// //       // If no active player or different playlist, create a new one
// //       return _createNewMusicPlayer(ref, tracks, index);
// //     } catch (e) {
// //       debugPrint("Error getting music player: $e");
// //       return null;
// //     }
// //   }

// //   MusicPlayerNotifier? _createNewMusicPlayer(
// //     WidgetRef ref,
// //     List<Results> tracks,
// //     int index,
// //   ) {
// //     try {
// //       final providerFamily = musicPlayerProvider((
// //         songList: tracks,
// //         initialIndex: index,
// //       ));

// //       // Create new provider by reading it
// //       final newNotifier = ref.read(providerFamily.notifier);

// //       // Set this as the active player
// //       ref.read(activeMusicPlayerProvider.notifier).state = newNotifier;

// //       // Initialize the music player safely after a delay
// //       // Future.delayed(const Duration(milliseconds: 100), () {
// //       //   if (newNotifier.mounted) {
// //       //     // Update current music state safely
// //       //     ref
// //       //         .read(currentMusicProvider.notifier)
// //       //         .setMusic(tracks[index], tracks, index);

// //       //     // Load and play the song
// //       //     newNotifier._loadSong(index);
// //       //   }
// //       // });

// //       return newNotifier;
// //     } catch (e) {
// //       debugPrint("Error creating music player: $e");
// //       return null;
// //     }
// //   }
// // }

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:lyrica/common/utils/utils.dart';
// import 'package:lyrica/common/widget/app_back_button.dart';
// import 'package:lyrica/common/widget/app_text.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/core/constant/app_string.dart';
// import 'package:lyrica/core/providers/provider.dart';
// import 'package:lyrica/main.dart';
// import 'package:lyrica/model/music_model.dart';
// import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
// import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
// import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart'
//     as music_player;
// import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart'
//     as current_music;

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
//           leading: const AppBackButton(),
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
//               ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
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
//                   ).animate().fadeIn(delay: 150.ms),
//                   SizedBox(height: 8.h),
//                   Expanded(
//                     child: ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: tracks.length,
//                       itemBuilder: (context, index) {
//                         final track = tracks[index];

//                         String? imageUrl =
//                             track.albumImage == ""
//                                 ? AppString.defaultImageLogo
//                                 : track.albumImage;

//                         return Card(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.sp),
//                               ),
//                               color: const Color.fromARGB(
//                                 255,
//                                 0,
//                                 27,
//                                 31,
//                               ).withOpacity(0.2),
//                               margin: EdgeInsets.only(bottom: 8.h),
//                               child: InkWell(
//                                 borderRadius: BorderRadius.circular(8.sp),
//                                 onTap: () {
//                                   _playSong(ref, tracks, index, context);
//                                 },
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: 8.0,
//                                     horizontal: 8.w,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Hero(
//                                         tag: 'album_art_${track.id}',
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(
//                                             8.sp,
//                                           ),
//                                           child: Image.network(
//                                             imageUrl ??
//                                                 AppString.defaultMusicLogo,
//                                             fit: BoxFit.cover,
//                                             width: 50.w,
//                                             height: 50.w,
//                                             cacheWidth:
//                                                 (60.w *
//                                                         MediaQuery.of(
//                                                           context,
//                                                         ).devicePixelRatio)
//                                                     .round(),
//                                             cacheHeight:
//                                                 (60.w *
//                                                         MediaQuery.of(
//                                                           context,
//                                                         ).devicePixelRatio)
//                                                     .round(),
//                                             errorBuilder:
//                                                 (context, error, stackTrace) =>
//                                                     Image.asset(
//                                                       AppString
//                                                           .defaultMusicLogo,
//                                                     ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 12.w),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             AppText(
//                                               text: track.name ?? 'N/A',
//                                               fontSize: 14.sp,
//                                               fontWeight: FontWeight.bold,
//                                               textColor: Color(
//                                                 AppColors.blueThird,
//                                               ),
//                                               maxLines: 1,
//                                             ),
//                                             SizedBox(height: 4.h),
//                                             AppText(
//                                               text:
//                                                   track.albumName ??
//                                                   'Unknown album name',
//                                               fontSize: 12.sp,
//                                               textColor: Color(
//                                                 AppColors.blueExtraLight,
//                                               ),
//                                               maxLines: 1,
//                                             ),
//                                             AppText(
//                                               text:
//                                                   track.artistName ??
//                                                   "Unknown artist name",
//                                               fontSize: 12.sp,
//                                               textColor: Color(
//                                                 AppColors.blueExtraLight,
//                                               ),
//                                               maxLines: 1,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Row(
//                                         children: [
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               IconButton(
//                                                 icon: FaIcon(
//                                                   context
//                                                           .watch<
//                                                             FavoriteProvider
//                                                           >()
//                                                           .isFavorite(
//                                                             track.id ?? "",
//                                                           )
//                                                       ? FontAwesomeIcons
//                                                           .solidHeart
//                                                       : FontAwesomeIcons.heart,
//                                                   size: 20.sp,
//                                                 ),
//                                                 color:
//                                                     context
//                                                             .watch<
//                                                               FavoriteProvider
//                                                             >()
//                                                             .isFavorite(
//                                                               track.id ?? "",
//                                                             )
//                                                         ? Color(
//                                                           AppColors.blueLight,
//                                                         )
//                                                         : Color(
//                                                           AppColors
//                                                               .primaryColor,
//                                                         ),

//                                                 onPressed: () async {
//                                                   final songData = {
//                                                     "id": track.id,
//                                                     "name": track.name,
//                                                     "artistName":
//                                                         track.artistName,
//                                                     "image": track.image,
//                                                     "audio": track.audio,
//                                                     "audioDuration":
//                                                         track.duration,
//                                                     "albumName":
//                                                         track.albumName,
//                                                     "albumImage":
//                                                         track.albumImage,
//                                                     "position": track.position,
//                                                   };
//                                                   context
//                                                       .read<FavoriteProvider>()
//                                                       .toggleFavorite(songData);
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                           GestureDetector(
//                                             onTap: () {
//                                               _playSong(
//                                                 ref,
//                                                 tracks,
//                                                 index,
//                                                 context,
//                                               );
//                                             },
//                                             child: Container(
//                                               width: 35.w,
//                                               height: 35.h,
//                                               decoration: BoxDecoration(
//                                                 gradient: LinearGradient(
//                                                   colors: [
//                                                     Color(
//                                                       AppColors.primaryColor,
//                                                     ),
//                                                     Color(AppColors.blueLight),
//                                                   ],
//                                                   begin: Alignment.topLeft,
//                                                   end: Alignment.bottomRight,
//                                                 ),
//                                                 shape: BoxShape.circle,
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: Color(
//                                                       AppColors.primaryColor,
//                                                     ).withOpacity(0.4),
//                                                     blurRadius: 14,
//                                                     spreadRadius: 0,
//                                                     offset: Offset(0, 6),
//                                                   ),
//                                                 ],
//                                               ),
//                                               child: Center(
//                                                 child: FaIcon(
//                                                   FontAwesomeIcons.play,
//                                                   color: Colors.white,
//                                                   size: 16.sp,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                             .animate(delay: (30 * index).ms)
//                             .fadeIn(duration: 150.ms, curve: Curves.easeOut)
//                             .slideX(
//                               begin: 0.2,
//                               duration: 150.ms,
//                               curve: Curves.easeOut,
//                             );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           loading: () => Center(child: appLoader()),
//           error:
//               (err, stack) => Center(
//                 child: AppText(
//                   text: 'Error: $err',
//                   textColor: Colors.red,
//                 ).animate().shakeX(duration: 300.ms),
//               ),
//         ),
//       ).animate().fadeIn(duration: 200.ms),
//     );
//   }

//   // FIXED: Complete rewrite of _playSong method with proper synchronization
//   void _playSong(
//     WidgetRef ref,
//     List<Results> tracks,
//     int index,
//     BuildContext context,
//   ) async {
//     // FIXED: Store context in a local variable to check if it's mounted
//     final localContext = context;

//     try {
//       debugPrint('Playing song: ${tracks[index].name} at index $index');

//       // FIXED: Step 1 - Update current music state FIRST
//       ref
//           .read(current_music.currentMusicProvider.notifier)
//           .setMusic(tracks[index], tracks, index);

//       // FIXED: Step 2 - Set audio handler with the current song
//       await audioHandler.setCurrentSong(tracks[index]);

//       // FIXED: Step 3 - Create and initialize music player
//       final musicPlayerFamily = music_player.musicPlayerProvider((
//         songList: tracks,
//         initialIndex: index,
//       ));

//       // FIXED: Wait for player to be properly initialized
//       await Future.delayed(const Duration(milliseconds: 100));

//       final musicPlayer = ref.read(musicPlayerFamily.notifier);

//       // FIXED: Step 4 - Initialize the music player
//       musicPlayer.initializeMusic();

//       // FIXED: Step 5 - Start playing through audio handler
//       await audioHandler.play();

//       debugPrint('Successfully started playing: ${tracks[index].name}');

//       // FIXED: Check if widget is still mounted before showing SnackBar
//       if (mounted) {
//         ScaffoldMessenger.of(localContext).showSnackBar(
//           SnackBar(
//             content: Text('Playing: ${tracks[index].name}'),
//             duration: const Duration(seconds: 1),
//             backgroundColor: Color(AppColors.primaryColor),
//           ),
//         );
//       }

//       // FIXED: Step 6 - Expand mini player with mounted check
//       if (mounted) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) {
//             Future.delayed(const Duration(milliseconds: 200), () {
//               if (mounted) {
//                 BottomSheetScreen.expandMiniPlayer();
//               }
//             });
//           }
//         });
//       }
//     } catch (e) {
//       debugPrint("Error playing song: $e");

//       // FIXED: Check if widget is still mounted before showing error
//       if (mounted) {
//         ScaffoldMessenger.of(localContext).showSnackBar(
//           SnackBar(
//             content: Text('Error playing song: ${e.toString()}'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }

// ignore_for_file: deprecated_member_use

//   // FIXED: Removed old methods and replaced with simplified approach
//   // The old _getOrCreateMusicPlayer and _createNewMusicPlayer methods
//   // were causing synchronization issues, so we're using a direct approach
// }

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
import 'package:lyrica/main.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart'
    as music_player;
import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart'
    as current_music;

class MusicTrackList extends ConsumerStatefulWidget {
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
  ConsumerState<MusicTrackList> createState() => _MusicTrackListState();
}

class _MusicTrackListState extends ConsumerState<MusicTrackList> {
  // Add this flag to track if the widget is mounted
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Results>> musicAsyncValue =
        widget.musicType == 1
            ? ref.watch(musicDataProvider)
            : ref.watch(genreMusicProvider(widget.genre));

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
                text: "${widget.appBarTitle} Songs",
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
                                onTap: () {
                                  _playSong(tracks, index);
                                },
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
                                                onPressed: () async {
                                                  final songData = {
                                                    "id": track.id,
                                                    "name": track.name,
                                                    "artistName":
                                                        track.artistName,
                                                    "image": track.image,
                                                    "audio": track.audio,
                                                    "audioDuration":
                                                        track.duration,
                                                    "albumName":
                                                        track.albumName,
                                                    "albumImage":
                                                        track.albumImage,
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
                                              _playSong(tracks, index);
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
                                                    offset: const Offset(0, 6),
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
                ).animate().shakeX(duration: 300.ms),
              ),
        ),
      ).animate().fadeIn(duration: 200.ms),
    );
  }

  // FIXED: _playSong method with proper mounted checks
  void _playSong(List<Results> tracks, int index) async {
    try {
      debugPrint('Playing song: ${tracks[index].name} at index $index');

      // FIXED: Step 1 - Update current music state FIRST
      ref
          .read(current_music.currentMusicProvider.notifier)
          .setMusic(tracks[index], tracks, index);

      // FIXED: Step 2 - Set audio handler with the current song
      await audioHandler.setCurrentSong(tracks[index]);

      // FIXED: Step 3 - Create and initialize music player
      final musicPlayerFamily = music_player.musicPlayerProvider((
        songList: tracks,
        initialIndex: index,
      ));

      // FIXED: Wait for player to be properly initialized
      await Future.delayed(const Duration(milliseconds: 100));

      final musicPlayer = ref.read(musicPlayerFamily.notifier);

      // FIXED: Step 4 - Initialize the music player
      musicPlayer.initializeMusic();

      // FIXED: Step 5 - Start playing through audio handler
      await audioHandler.play();

      debugPrint('Successfully started playing: ${tracks[index].name}');

      // FIXED: Check if widget is still mounted before showing SnackBar
      if (_isMounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playing: ${tracks[index].name}'),
            duration: const Duration(seconds: 1),
            backgroundColor: Color(AppColors.primaryColor),
          ),
        );
      }

      // FIXED: Expand mini player using the global key
      if (_isMounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isMounted) {
            // Access the MainWithMiniPlayer state and expand the player
            final mainState = MainWithMiniPlayer.globalKey.currentState;
            if (mainState != null) {
              mainState.expandMiniPlayer();
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error playing song: $e");

      // FIXED: Check if widget is still mounted before showing error
      if (_isMounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error playing song: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
