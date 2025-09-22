// // // // ignore_for_file: deprecated_member_use

// // // import 'package:flutter/cupertino.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:provider/provider.dart' as pd;

// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:just_audio/just_audio.dart';
// // // import 'package:lyrica/common/utils/utils.dart';
// // // import 'package:lyrica/common/widget/app_main_button.dart';
// // // import 'package:lyrica/common/widget/app_text.dart';
// // // import 'package:lyrica/core/constant/app_colors.dart';
// // // import 'package:lyrica/model/music_model.dart';
// // // import 'package:lyrica/modules/library/view/library_screen.dart';
// // // import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:share_plus/share_plus.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';

// // // class MusicPlayer extends ConsumerStatefulWidget {
// // //   final VoidCallback? onMinimize;
// // //   final List<Results> songList;
// // //   final int initialIndex;

// // //   const MusicPlayer({
// // //     super.key,
// // //     required this.songList,
// // //     required this.initialIndex,
// // //     required this.onMinimize,
// // //   });

// // //   @override
// // //   ConsumerState<MusicPlayer> createState() => _MusicPlayerScreenState();
// // // }

// // // class _MusicPlayerScreenState extends ConsumerState<MusicPlayer> {
// // //   String musicShareURL = '';

// // //   // @override
// // //   // void initState() {
// // //   //   super.initState();

// // //   //   Future.delayed(Duration.zero, () {
// // //   //     context.read<FavoriteProvider>().fetchFavorites();
// // //   //   });

// // //   //   final musicPlayer = ref.read(
// // //   //     musicPlayerProvider((
// // //   //       songList: widget.songList,
// // //   //       initialIndex: widget.initialIndex,
// // //   //     )).notifier,
// // //   //   );
// // //   //   musicPlayer.initializeMusic();
// // //   // }

// // //   @override
// // //   void initState() {
// // //     super.initState();

// // //     Future.microtask(() {
// // //       final musicPlayer = ref.read(
// // //         musicPlayerProvider((
// // //           songList: widget.songList,
// // //           initialIndex: widget.initialIndex,
// // //         )).notifier,
// // //       );
// // //       musicPlayer.initializeMusic();
// // //     });

// // //     Future.delayed(Duration.zero, () {
// // //       context.read<FavoriteProvider>().fetchFavorites();
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final musicPlayer = ref.watch(
// // //       musicPlayerProvider((
// // //         songList: widget.songList,
// // //         initialIndex: widget.initialIndex,
// // //       )).notifier,
// // //     );
// // //     final musicPlayerState = ref.watch(
// // //       musicPlayerProvider((
// // //         songList: widget.songList,
// // //         initialIndex: widget.initialIndex,
// // //       )),
// // //     );
// // //     final rewardPointsAsync = ref.watch(rewardPointsProvider);
// // //     if (widget.songList.isEmpty ||
// // //         musicPlayerState.currentIndex < 0 ||
// // //         musicPlayerState.currentIndex >= widget.songList.length) {
// // //       return const Center(child: Text("No songs available"));
// // //     }

// // //     final currentSong = widget.songList[musicPlayerState.currentIndex];

// // //     ref.listen<bool>(
// // //       musicPlayerProvider((
// // //         songList: widget.songList,
// // //         initialIndex: widget.initialIndex,
// // //       )).select((state) => state.showDownloadComplete),
// // //       (previous, next) {
// // //         if (next) {
// // //           Navigator.of(context).pop();
// // //           showDialog(
// // //             context: context,
// // //             barrierDismissible: true,
// // //             builder:
// // //                 (_) => _buildDownloadSuccessDialog(
// // //                   context,
// // //                   musicPlayerState.downloadingFileName ?? "Unknown",
// // //                 ),
// // //           ).then((_) {
// // //             musicPlayer.resetDownloadComplete();
// // //           });
// // //         }
// // //       },
// // //     );

// // //     ref.listen<bool>(dialogShownProvider, (previous, next) {
// // //       if (next) {
// // //         showGeneralDialog(
// // //           context: context,
// // //           barrierDismissible: false,
// // //           barrierLabel: "RewardDialog",
// // //           transitionDuration: const Duration(milliseconds: 300),
// // //           pageBuilder: (_, __, ___) => _buildNoPointsDialog(context, ref),
// // //           transitionBuilder: (context, animation, secondaryAnimation, child) {
// // //             return ScaleTransition(
// // //               scale: CurvedAnimation(
// // //                 parent: animation,
// // //                 curve: Curves.easeOutBack,
// // //               ),
// // //               child: child,
// // //             );
// // //           },
// // //         );
// // //       }
// // //     });

// // //     return Container(
// // //       decoration: BoxDecoration(gradient: backgroundGradient()),

// // //       child: Scaffold(
// // //         // floatingActionButton: FloatingActionButton(
// // //         //   onPressed: () {
// // //         //     if (widget.onMinimize != null) {
// // //         //       widget.onMinimize!();
// // //         //     } else {
// // //         //       Navigator.of(context).pop();
// // //         //     }
// // //         //   },
// // //         //   child: Icon(Icons.minimize, color: Colors.white),
// // //         // ),
// // //         backgroundColor: const Color.fromARGB(197, 0, 43, 53),
// // //         appBar: AppBar(
// // //           // leading: AppBackButton(),
// // //           elevation: 0,
// // //           toolbarHeight: 90,
// // //           backgroundColor: Colors.transparent,
// // //           title: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               AppText(
// // //                 text: "Now Playing",
// // //                 fontSize: 20.sp,
// // //                 textColor: Color(AppColors.lightText),
// // //                 fontWeight: FontWeight.w500,
// // //               ),
// // //             ],
// // //           ),
// // //           actions: [
// // //             Container(
// // //               padding: EdgeInsets.only(right: 16.w, left: 16.w),
// // //               margin: EdgeInsets.only(top: 20.h, bottom: 20.h, right: 12.w),
// // //               decoration: BoxDecoration(
// // //                 color: Color(AppColors.primaryColor),
// // //                 borderRadius: BorderRadius.circular(30),
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: Color(AppColors.primaryColor).withOpacity(0.18),
// // //                     blurRadius: 12,
// // //                     offset: Offset(0, 4),
// // //                   ),
// // //                 ],
// // //               ),
// // //               child: Row(
// // //                 children: [
// // //                   Icon(Icons.stars, color: Colors.white, size: 18),
// // //                   SizedBox(width: 6),
// // //                   rewardPointsAsync.when(
// // //                     data:
// // //                         (points) => AppText(
// // //                           text: "$points",
// // //                           fontWeight: FontWeight.bold,
// // //                           fontSize: 16,
// // //                           textColor: Colors.white,
// // //                         ),
// // //                     loading:
// // //                         () => SizedBox(
// // //                           width: 16,
// // //                           height: 16,
// // //                           child: CircularProgressIndicator(
// // //                             strokeWidth: 2,
// // //                             color: Colors.white,
// // //                           ),
// // //                         ),
// // //                     error:
// // //                         (error, stack) => AppText(
// // //                           text: "0",
// // //                           fontWeight: FontWeight.bold,
// // //                           fontSize: 16,
// // //                           textColor: Colors.white,
// // //                         ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //         body: SingleChildScrollView(
// // //           physics: BouncingScrollPhysics(),
// // //           child: Padding(
// // //             padding: EdgeInsets.all(16.sp),
// // //             child: Column(
// // //               mainAxisAlignment: MainAxisAlignment.start,
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Center(
// // //                   child: TweenAnimationBuilder<double>(
// // //                     tween: Tween(begin: 0.95, end: 1.0),
// // //                     duration: const Duration(milliseconds: 900),
// // //                     curve: Curves.elasticOut,
// // //                     builder: (context, scale, child) {
// // //                       return Transform.scale(
// // //                         scale: scale,
// // //                         child: AnimatedContainer(
// // //                           duration: const Duration(milliseconds: 600),
// // //                           curve: Curves.easeInOut,
// // //                           decoration: BoxDecoration(
// // //                             borderRadius: BorderRadius.circular(24),
// // //                             boxShadow: [
// // //                               BoxShadow(
// // //                                 color: Color(
// // //                                   AppColors.primaryColor,
// // //                                 ).withOpacity(0.25),
// // //                                 blurRadius: 40,
// // //                                 spreadRadius: 8,
// // //                                 offset: Offset(0, 16),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                           child: ClipRRect(
// // //                             borderRadius: BorderRadius.circular(24),
// // //                             child: Image.network(
// // //                               width: 300.w,
// // //                               height: 300.w,
// // //                               currentSong.image ?? "",
// // //                               fit: BoxFit.cover,
// // //                               errorBuilder:
// // //                                   (_, __, ___) =>
// // //                                       Icon(Icons.music_note, size: 100.sp),
// // //                               loadingBuilder: (
// // //                                 context,
// // //                                 child,
// // //                                 loadingProgress,
// // //                               ) {
// // //                                 if (loadingProgress == null) return child;
// // //                                 return Center(
// // //                                   child: CircularProgressIndicator(
// // //                                     value:
// // //                                         loadingProgress.expectedTotalBytes !=
// // //                                                 null
// // //                                             ? loadingProgress
// // //                                                     .cumulativeBytesLoaded /
// // //                                                 loadingProgress
// // //                                                     .expectedTotalBytes!
// // //                                             : null,
// // //                                   ),
// // //                                 );
// // //                               },
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       );
// // //                     },
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 32.h),

// // //                 ShaderMask(
// // //                   shaderCallback: (Rect bounds) {
// // //                     return LinearGradient(
// // //                       colors: [
// // //                         Color(AppColors.blueLight),
// // //                         Color(AppColors.primaryColor),
// // //                         Color(AppColors.secondaryColor),
// // //                       ],
// // //                       begin: Alignment.topLeft,
// // //                       end: Alignment.bottomRight,
// // //                     ).createShader(bounds);
// // //                   },
// // //                   child: Text(
// // //                     currentSong.name ?? "",
// // //                     textAlign: TextAlign.center,
// // //                     maxLines: 2,
// // //                     overflow: TextOverflow.ellipsis,
// // //                     style: GoogleFonts.poppins(
// // //                       fontSize: 28.sp,
// // //                       fontWeight: FontWeight.bold,
// // //                       letterSpacing: 1.2,
// // //                       color: Colors.white,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 2.h),

// // //                 Row(
// // //                   crossAxisAlignment: CrossAxisAlignment.center,
// // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                   children: [
// // //                     Expanded(
// // //                       flex: 8,
// // //                       child: AppText(
// // //                         text: "By - ${currentSong.artistName ?? ""}",
// // //                         textColor: Colors.white54,
// // //                         fontSize: 14.sp,
// // //                         fontWeight: FontWeight.bold,
// // //                         maxLines: 2,
// // //                       ),
// // //                     ),
// // //                     Spacer(),
// // //                     Expanded(
// // //                       flex: 4,
// // //                       child: Row(
// // //                         children: [
// // //                           IconButton(
// // //                             icon: Icon(CupertinoIcons.share),
// // //                             iconSize: 22.sp,
// // //                             color: Color(AppColors.primaryColor),
// // //                             onPressed: () async {
// // //                               final String songTitle =
// // //                                   currentSong.name ?? "Unknown Song";
// // //                               SharePlus.instance.share(
// // //                                 ShareParams(
// // //                                   title: songTitle,
// // //                                   previewThumbnail: XFile(
// // //                                     currentSong.image ??
// // //                                         "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
// // //                                   ),
// // //                                   uri: Uri.parse(
// // //                                     currentSong.shareurl ??
// // //                                         "https://licensing.jamendo.com/en/in-store?jmm=instore",
// // //                                   ),
// // //                                 ),
// // //                               );
// // //                             },
// // //                           ),

// // //                           // IconButton(
// // //                           //   icon: FaIcon(
// // //                           //     context.watch<FavoriteProvider>().isFavorite(
// // //                           //           currentSong.id ?? "",
// // //                           //         )
// // //                           //         ? FontAwesomeIcons.solidHeart
// // //                           //         : FontAwesomeIcons.heart,
// // //                           //   ),
// // //                           //   iconSize: 20.sp,
// // //                           //   color:
// // //                           //       context.watch<FavoriteProvider>().isFavorite(
// // //                           //             currentSong.id ?? "",
// // //                           //           )
// // //                           //           ? Color(AppColors.blueLight)
// // //                           //           : Color(AppColors.primaryColor),
// // //                           //   onPressed: () async {
// // //                           //     final SharedPreferences preferences =
// // //                           //         await SharedPreferences.getInstance();
// // //                           //     final String? userId = preferences.getString(
// // //                           //       "userUID",
// // //                           //     );
// // //                           //     final songData = {
// // //                           //       "userId": userId,
// // //                           //       "id": currentSong.id,
// // //                           //       "name": currentSong.name,
// // //                           //       "artistName": currentSong.artistName,
// // //                           //       "image": currentSong.image,
// // //                           //       "audio": currentSong.audio,
// // //                           //       "audioDuration": currentSong.duration,
// // //                           //       "albumImage": currentSong.albumImage,
// // //                           //       "albumName": currentSong.albumName,
// // //                           //       "position": currentSong.position,
// // //                           //     };
// // //                           //     context.read<FavoriteProvider>().toggleFavorite(
// // //                           //       songData,
// // //                           //     );
// // //                           //   },
// // //                           // ),
// // //                           pd.Consumer<FavoriteProvider>(
// // //                             builder: (context, favoriteProvider, child) {
// // //                               final isFav = favoriteProvider.isFavorite(
// // //                                 currentSong.id ?? "",
// // //                               );

// // //                               return IconButton(
// // //                                 iconSize: 20.sp,
// // //                                 icon:
// // //                                     favoriteProvider.isLoading
// // //                                         ? SizedBox(
// // //                                           height: 18.sp,
// // //                                           width: 18.sp,
// // //                                           child: CircularProgressIndicator(
// // //                                             strokeWidth: 2,
// // //                                             valueColor: AlwaysStoppedAnimation(
// // //                                               Color(AppColors.blueLight),
// // //                                             ),
// // //                                           ),
// // //                                         )
// // //                                         : FaIcon(
// // //                                           isFav
// // //                                               ? FontAwesomeIcons.solidHeart
// // //                                               : FontAwesomeIcons.heart,
// // //                                           color:
// // //                                               isFav
// // //                                                   ? Color(AppColors.blueLight)
// // //                                                   : Color(
// // //                                                     AppColors.primaryColor,
// // //                                                   ),
// // //                                         ),
// // //                                 onPressed:
// // //                                     favoriteProvider.isLoading
// // //                                         ? null
// // //                                         : () async {
// // //                                           final prefs =
// // //                                               await SharedPreferences.getInstance();
// // //                                           final String? userId = prefs
// // //                                               .getString("userUID");

// // //                                           final songData = {
// // //                                             "userId": userId,
// // //                                             "id": currentSong.id,
// // //                                             "name": currentSong.name,
// // //                                             "artistName":
// // //                                                 currentSong.artistName,
// // //                                             "image": currentSong.image,
// // //                                             "audio": currentSong.audio,
// // //                                             "audioDuration":
// // //                                                 currentSong.duration,
// // //                                             "albumImage":
// // //                                                 currentSong.albumImage,
// // //                                             "albumName": currentSong.albumName,
// // //                                             "position": currentSong.position,
// // //                                           };

// // //                                           context
// // //                                               .read<FavoriteProvider>()
// // //                                               .toggleFavorite(songData);
// // //                                         },
// // //                               );
// // //                             },
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 SizedBox(height: 20.h),

// // //                 StreamBuilder<Duration>(
// // //                   stream: musicPlayer.positionStream,
// // //                   builder: (context, snapshot) {
// // //                     final position = snapshot.data ?? Duration.zero;
// // //                     final duration =
// // //                         musicPlayerState.audioPlayer.duration ?? Duration.zero;

// // //                     return Column(
// // //                       children: [
// // //                         SizedBox(
// // //                           width: double.infinity,
// // //                           child: Slider(
// // //                             year2023: true,
// // //                             mouseCursor: MouseCursor.defer,
// // //                             thumbColor: Color(AppColors.blueLight),
// // //                             min: 0,
// // //                             max: duration.inSeconds.toDouble(),
// // //                             value:
// // //                                 position.inSeconds
// // //                                     .clamp(0, duration.inSeconds)
// // //                                     .toDouble(),
// // //                             onChanged: musicPlayer.seek,
// // //                             padding: EdgeInsets.only(
// // //                               top: 12.h,
// // //                               right: 4.w,
// // //                               left: 4.w,
// // //                               bottom: 4.h,
// // //                             ),
// // //                             activeColor: Color(AppColors.primaryColor),
// // //                             inactiveColor: Color(AppColors.blueExtraLight),
// // //                           ),
// // //                         ),
// // //                         Padding(
// // //                           padding: EdgeInsets.symmetric(
// // //                             horizontal: 8.w,
// // //                             vertical: 6.h,
// // //                           ),
// // //                           child: Row(
// // //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                             children: [
// // //                               AppText(
// // //                                 text: musicPlayer.formatDuration(position),
// // //                                 textColor: Colors.white70,
// // //                               ),
// // //                               AppText(
// // //                                 text: musicPlayer.formatDuration(duration),
// // //                                 textColor: Colors.white70,
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     );
// // //                   },
// // //                 ),
// // //                 SizedBox(height: 8.h),

// // //                 Row(
// // //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //                   children: [
// // //                     IconButton(
// // //                       icon: FaIcon(FontAwesomeIcons.shuffle),
// // //                       iconSize: 25.sp,
// // //                       color: Color(AppColors.primaryColor),
// // //                       onPressed: () {},
// // //                     ),
// // //                     IconButton(
// // //                       icon: FaIcon(FontAwesomeIcons.backward),
// // //                       iconSize: 35.sp,
// // //                       color: Color(AppColors.primaryColor),
// // //                       onPressed: musicPlayer.previousSong,
// // //                     ),
// // //                     // _AnimatedGlow(
// // //                     //   child: Container(
// // //                     //     decoration: BoxDecoration(
// // //                     //       shape: BoxShape.circle,
// // //                     //       gradient: LinearGradient(
// // //                     //         colors: [
// // //                     //           Color(AppColors.primaryColor),
// // //                     //           Color(AppColors.blueLight),
// // //                     //         ],
// // //                     //       ),
// // //                     //     ),
// // //                     //     // child:
// // //                     //   ),
// // //                     // ),
// // //                     StreamBuilder<PlayerState>(
// // //                       stream: musicPlayer.playerStateStream,
// // //                       builder: (context, snapshot) {
// // //                         final playerState = snapshot.data;
// // //                         final isPlaying = playerState?.playing ?? false;
// // //                         return IconButton(
// // //                           icon: Icon(
// // //                             isPlaying
// // //                                 ? CupertinoIcons.pause_circle
// // //                                 : CupertinoIcons.play_circle,
// // //                           ),
// // //                           iconSize: 60,
// // //                           color: Colors.white,
// // //                           onPressed: musicPlayer.playPause,
// // //                         );
// // //                       },
// // //                     ),
// // //                     IconButton(
// // //                       icon: FaIcon(FontAwesomeIcons.forward),
// // //                       iconSize: 35.sp,
// // //                       color: Color(AppColors.primaryColor),
// // //                       onPressed: musicPlayer.nextSong,
// // //                     ),
// // //                     IconButton(
// // //                       icon: const FaIcon(FontAwesomeIcons.download),
// // //                       iconSize: 25.sp,
// // //                       color: Color(AppColors.primaryColor),
// // //                       onPressed: () {
// // //                         final audioUrl = currentSong.audio ?? "";
// // //                         final name = currentSong.name ?? "Unknown";

// // //                         if (audioUrl.isNotEmpty) {
// // //                           musicPlayer.startDownloadWithLoading(audioUrl, name);
// // //                           _buildDownloadSuccessDialog(context, audioUrl);
// // //                         }
// // //                       },
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 SizedBox(height: 30.h),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildNoPointsDialog(BuildContext context, WidgetRef ref) {
// // //     return Center(
// // //       child: Material(
// // //         color: Colors.transparent,
// // //         child: Container(
// // //           width: 320,
// // //           padding: const EdgeInsets.all(24),
// // //           decoration: BoxDecoration(
// // //             color: Color(AppColors.whiteBackground),
// // //             borderRadius: BorderRadius.circular(32),
// // //             boxShadow: [
// // //               BoxShadow(
// // //                 color: Color(AppColors.primaryColor).withOpacity(0.18),
// // //                 blurRadius: 32,
// // //                 offset: const Offset(0, 12),
// // //               ),
// // //             ],
// // //           ),
// // //           child: Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               Image.asset("assets/image/rewardIcon.png", height: 80),
// // //               const SizedBox(height: 16),
// // //               AppText(
// // //                 text: "No Reward Points!",
// // //                 fontSize: 24,
// // //                 fontWeight: FontWeight.bold,
// // //                 textColor: Color(AppColors.primaryColor),
// // //               ),
// // //               const SizedBox(height: 12),
// // //               AppText(
// // //                 text:
// // //                     "You need more reward points to play music.\nGo to Library and earn more points by watching ads.",
// // //                 align: TextAlign.center,
// // //                 fontSize: 16,
// // //                 textColor: Color(AppColors.darkBlue),
// // //               ),
// // //               const SizedBox(height: 24),
// // //               ElevatedButton.icon(
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: Color(AppColors.primaryColor),
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(18),
// // //                   ),
// // //                   elevation: 0,
// // //                 ),
// // //                 onPressed: () {
// // //                   Navigator.of(context).pop();
// // //                   Navigator.of(context).pushReplacement(
// // //                     MaterialPageRoute(builder: (_) => const LibraryScreen()),
// // //                   );
// // //                   ref.read(dialogShownProvider.notifier).state = false;
// // //                 },
// // //                 icon: const Icon(Icons.card_giftcard, color: Colors.white),
// // //                 label: AppText(
// // //                   text: "Go to Library",
// // //                   fontWeight: FontWeight.bold,
// // //                   textColor: Colors.white,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDownloadSuccessDialog(BuildContext context, String fileName) {
// // //     return Dialog(
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
// // //       elevation: 0,
// // //       backgroundColor: Colors.transparent,
// // //       child: Container(
// // //         padding: const EdgeInsets.all(24),
// // //         decoration: BoxDecoration(
// // //           color: Colors.white,
// // //           borderRadius: BorderRadius.circular(24),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.black.withOpacity(0.2),
// // //               blurRadius: 24,
// // //               offset: const Offset(0, 8),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             FaIcon(
// // //               FontAwesomeIcons.checkCircle,
// // //               size: 60,
// // //               color: Color(AppColors.primaryColor),
// // //             ),
// // //             const SizedBox(height: 16),
// // //             AppText(
// // //               text: "Download Complete",
// // //               fontSize: 20,
// // //               textColor: Colors.black87,
// // //               fontWeight: FontWeight.w600,
// // //             ),
// // //             SizedBox(height: 9.h),
// // //             AppText(
// // //               text:
// // //                   '"${fileName.length > 20 ? '${fileName.substring(0, 20)}...' : fileName}.mp3"',
// // //               align: TextAlign.center,
// // //               fontSize: 16,
// // //               textColor: Colors.black54,
// // //             ),
// // //             SizedBox(height: 2.h),
// // //             AppText(
// // //               text: "has been saved to your Downloads folder",
// // //               align: TextAlign.center,
// // //               fontSize: 14,
// // //               textColor: Colors.black54,
// // //             ),
// // //             const SizedBox(height: 24),
// // //             AppMainButton(
// // //               onPressed: () => Navigator.of(context).pop(),
// // //               gradient: LinearGradient(
// // //                 colors: [
// // //                   Color(AppColors.blueLight),
// // //                   Color(AppColors.primaryColor),
// // //                 ],
// // //               ),
// // //               child: AppText(
// // //                 text: "OK",
// // //                 fontWeight: FontWeight.bold,
// // //                 fontSize: 16,
// // //                 textColor: Colors.white,
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _AnimatedGlow extends StatefulWidget {
// // //   final Widget child;
// // //   const _AnimatedGlow({required this.child});

// // //   @override
// // //   State<_AnimatedGlow> createState() => _AnimatedGlowState();
// // // }

// // // class _AnimatedGlowState extends State<_AnimatedGlow>
// // //     with SingleTickerProviderStateMixin {
// // //   late AnimationController _controller;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _controller = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(milliseconds: 1200),
// // //     )..repeat(reverse: true);
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _controller.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return AnimatedBuilder(
// // //       animation: _controller,
// // //       builder: (context, child) {
// // //         final glow = 18.0 + 12.0 * _controller.value;
// // //         return Container(
// // //           decoration: BoxDecoration(
// // //             boxShadow: [
// // //               BoxShadow(
// // //                 color: Color(AppColors.primaryColor).withOpacity(0.5),
// // //                 blurRadius: glow,
// // //                 spreadRadius: 1,
// // //               ),
// // //             ],
// // //             shape: BoxShape.circle,
// // //           ),
// // //           child: widget.child,
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // // ignore_for_file: deprecated_member_use

// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:lyrica/common/utils/utils.dart';
// // import 'package:lyrica/common/widget/app_main_button.dart';
// // import 'package:lyrica/common/widget/app_text.dart';
// // import 'package:lyrica/core/constant/app_colors.dart';
// // import 'package:lyrica/model/music_model.dart';
// // import 'package:lyrica/modules/library/view/library_screen.dart';
// // import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
// // import 'package:provider/provider.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:file_picker/file_picker.dart';

// // class MusicPlayer extends ConsumerStatefulWidget {
// //   final VoidCallback? onMinimize;
// //   final List<Results> songList;
// //   final int initialIndex;

// //   const MusicPlayer({
// //     super.key,
// //     required this.songList,
// //     required this.initialIndex,
// //     required this.onMinimize,
// //   });

// //   @override
// //   ConsumerState<MusicPlayer> createState() => _MusicPlayerScreenState();
// // }

// // class _MusicPlayerScreenState extends ConsumerState<MusicPlayer> {
// //   String musicShareURL = '';
// //   bool _isLoadingDeviceSongs = false;
// //   List<String> _deviceSongs = [];
// //   int _currentDeviceSongIndex = -1;
// //   final AudioPlayer _deviceAudioPlayer = AudioPlayer();

// //   @override
// //   void initState() {
// //     super.initState();

// //     Future.microtask(() {
// //       final musicPlayer = ref.read(
// //         musicPlayerProvider((
// //           songList: widget.songList,
// //           initialIndex: widget.initialIndex,
// //         )).notifier,
// //       );
// //       musicPlayer.initializeMusic();
// //     });

// //     Future.delayed(Duration.zero, () {
// //       context.read<FavoriteProvider>().fetchFavorites();
// //     });

// //     // Initialize device audio player listeners
// //     _deviceAudioPlayer.playerStateStream.listen((playerState) {});
// //     _deviceAudioPlayer.positionStream.listen((position) {});
// //     _deviceAudioPlayer.durationStream.listen((duration) {});
// //   }

// //   @override
// //   void dispose() {
// //     _deviceAudioPlayer.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _loadSongsFromDevice() async {
// //     setState(() {
// //       _isLoadingDeviceSongs = true;
// //     });

// //     try {
// //       // Request storage permission
// //       final status = await Permission.storage.request();
// //       if (!status.isGranted) {
// //         throw Exception('Storage permission denied');
// //       }

// //       // Pick audio files
// //       FilePickerResult? result = await FilePicker.platform.pickFiles(
// //         type: FileType.audio,
// //         allowMultiple: true,
// //       );

// //       if (result != null && result.files.isNotEmpty) {
// //         _deviceSongs =
// //             result.files
// //                 .map((file) => file.path!)
// //                 .where((path) => path != null)
// //                 .toList();

// //         if (_deviceSongs.isNotEmpty) {
// //           await _playDeviceSong(0);
// //         }
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(SnackBar(content: Text('Failed to load songs: $e')));
// //     } finally {
// //       setState(() {
// //         _isLoadingDeviceSongs = false;
// //       });
// //     }
// //   }

// //   Future<void> _playDeviceSong(int index) async {
// //     if (index < 0 || index >= _deviceSongs.length) return;

// //     setState(() {
// //       _currentDeviceSongIndex = index;
// //     });

// //     final songPath = _deviceSongs[index];

// //     try {
// //       await _deviceAudioPlayer.stop();
// //       await _deviceAudioPlayer.setAudioSource(
// //         AudioSource.uri(Uri.file(songPath)),
// //       );
// //       await _deviceAudioPlayer.play();
// //     } catch (e) {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(SnackBar(content: Text('Failed to play song: $e')));
// //     }
// //   }

// //   Future<void> _playPauseDeviceSong() async {
// //     if (_deviceAudioPlayer.playing) {
// //       await _deviceAudioPlayer.pause();
// //     } else {
// //       await _deviceAudioPlayer.play();
// //     }
// //   }

// //   Future<void> _nextDeviceSong() async {
// //     if (_currentDeviceSongIndex < _deviceSongs.length - 1) {
// //       await _playDeviceSong(_currentDeviceSongIndex + 1);
// //     }
// //   }

// //   Future<void> _previousDeviceSong() async {
// //     if (_currentDeviceSongIndex > 0) {
// //       await _playDeviceSong(_currentDeviceSongIndex - 1);
// //     }
// //   }

// //   String _getFileName(String path) {
// //     return path.split('/').last;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final musicPlayer = ref.watch(
// //       musicPlayerProvider((
// //         songList: widget.songList,
// //         initialIndex: widget.initialIndex,
// //       )).notifier,
// //     );
// //     final musicPlayerState = ref.watch(
// //       musicPlayerProvider((
// //         songList: widget.songList,
// //         initialIndex: widget.initialIndex,
// //       )),
// //     );
// //     final rewardPointsAsync = ref.watch(rewardPointsProvider);

// //     // Check if we're playing device songs or online songs
// //     final bool isPlayingDeviceSongs = _deviceSongs.isNotEmpty;

// //     if (!isPlayingDeviceSongs &&
// //         (widget.songList.isEmpty ||
// //             musicPlayerState.currentIndex < 0 ||
// //             musicPlayerState.currentIndex >= widget.songList.length)) {
// //       return _buildNoSongsUI();
// //     }

// //     final currentSong =
// //         isPlayingDeviceSongs
// //             ? Results(
// //               name: _getFileName(_deviceSongs[_currentDeviceSongIndex]),
// //               artistName: "Local Device",
// //             )
// //             : widget.songList[musicPlayerState.currentIndex];

// //     ref.listen<bool>(
// //       musicPlayerProvider((
// //         songList: widget.songList,
// //         initialIndex: widget.initialIndex,
// //       )).select((state) => state.showDownloadComplete),
// //       (previous, next) {
// //         if (next) {
// //           Navigator.of(context).pop();
// //           showDialog(
// //             context: context,
// //             barrierDismissible: true,
// //             builder:
// //                 (_) => _buildDownloadSuccessDialog(
// //                   context,
// //                   musicPlayerState.downloadingFileName ?? "Unknown",
// //                 ),
// //           ).then((_) {
// //             musicPlayer.resetDownloadComplete();
// //           });
// //         }
// //       },
// //     );

// //     ref.listen<bool>(dialogShownProvider, (previous, next) {
// //       if (next) {
// //         showGeneralDialog(
// //           context: context,
// //           barrierDismissible: false,
// //           barrierLabel: "RewardDialog",
// //           transitionDuration: const Duration(milliseconds: 300),
// //           pageBuilder: (_, __, ___) => _buildNoPointsDialog(context, ref),
// //           transitionBuilder: (context, animation, secondaryAnimation, child) {
// //             return ScaleTransition(
// //               scale: CurvedAnimation(
// //                 parent: animation,
// //                 curve: Curves.easeOutBack,
// //               ),
// //               child: child,
// //             );
// //           },
// //         );
// //       }
// //     });

// //     return Column(
// //       children: [
// //         Container(height: 80, decoration: BoxDecoration(color: Colors.black)),
// //         Expanded(
// //           child: Container(
// //             decoration: BoxDecoration(gradient: backgroundGradient()),
// //             child: Scaffold(
// //               backgroundColor: const Color.fromARGB(197, 0, 43, 53),
// //               appBar: AppBar(
// //                 elevation: 0,
// //                 toolbarHeight: 90,
// //                 backgroundColor: Colors.transparent,
// //                 title: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     AppText(
// //                       text: "Now Playing",
// //                       fontSize: 20.sp,
// //                       textColor: Color(AppColors.lightText),
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                     if (isPlayingDeviceSongs)
// //                       AppText(
// //                         text: "Local Device",
// //                         fontSize: 14.sp,
// //                         textColor: Colors.white54,
// //                       ),
// //                   ],
// //                 ),
// //                 actions: [
// //                   if (!isPlayingDeviceSongs) // Only show points for online songs
// //                     Container(
// //                       padding: EdgeInsets.only(right: 16.w, left: 16.w),
// //                       margin: EdgeInsets.only(
// //                         top: 20.h,
// //                         bottom: 20.h,
// //                         right: 12.w,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: Color(AppColors.primaryColor),
// //                         borderRadius: BorderRadius.circular(30),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Color(
// //                               AppColors.primaryColor,
// //                             ).withOpacity(0.18),
// //                             blurRadius: 12,
// //                             offset: Offset(0, 4),
// //                           ),
// //                         ],
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           Icon(Icons.stars, color: Colors.white, size: 18),
// //                           SizedBox(width: 6),
// //                           rewardPointsAsync.when(
// //                             data:
// //                                 (points) => AppText(
// //                                   text: "$points",
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 16,
// //                                   textColor: Colors.white,
// //                                 ),
// //                             loading:
// //                                 () => SizedBox(
// //                                   width: 16,
// //                                   height: 16,
// //                                   child: CircularProgressIndicator(
// //                                     strokeWidth: 2,
// //                                     color: Colors.white,
// //                                   ),
// //                                 ),
// //                             error:
// //                                 (error, stack) => AppText(
// //                                   text: "0",
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 16,
// //                                   textColor: Colors.white,
// //                                 ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   // Add button to load device songs
// //                   IconButton(
// //                     icon: Icon(Icons.folder_open, color: Colors.white),
// //                     onPressed: _loadSongsFromDevice,
// //                   ),
// //                 ],
// //               ),
// //               body: SingleChildScrollView(
// //                 physics: BouncingScrollPhysics(),
// //                 child: Padding(
// //                   padding: EdgeInsets.all(16.sp),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.start,
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Center(
// //                         child: TweenAnimationBuilder<double>(
// //                           tween: Tween(begin: 0.95, end: 1.0),
// //                           duration: const Duration(milliseconds: 900),
// //                           curve: Curves.elasticOut,
// //                           builder: (context, scale, child) {
// //                             return Transform.scale(
// //                               scale: scale,
// //                               child: AnimatedContainer(
// //                                 duration: const Duration(milliseconds: 600),
// //                                 curve: Curves.easeInOut,
// //                                 decoration: BoxDecoration(
// //                                   borderRadius: BorderRadius.circular(24),
// //                                   boxShadow: [
// //                                     BoxShadow(
// //                                       color: Color(
// //                                         AppColors.primaryColor,
// //                                       ).withOpacity(0.25),
// //                                       blurRadius: 40,
// //                                       spreadRadius: 8,
// //                                       offset: Offset(0, 16),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 child: ClipRRect(
// //                                   borderRadius: BorderRadius.circular(24),
// //                                   child:
// //                                       isPlayingDeviceSongs
// //                                           ? Container(
// //                                             width: 300.w,
// //                                             height: 300.w,
// //                                             color: Color(
// //                                               AppColors.primaryColor,
// //                                             ),
// //                                             child: Icon(
// //                                               Icons.music_note,
// //                                               size: 100.sp,
// //                                               color: Colors.white,
// //                                             ),
// //                                           )
// //                                           : Image.network(
// //                                             width: 300.w,
// //                                             height: 300.w,
// //                                             currentSong.image ?? "",
// //                                             fit: BoxFit.cover,
// //                                             errorBuilder:
// //                                                 (_, __, ___) => Icon(
// //                                                   Icons.music_note,
// //                                                   size: 100.sp,
// //                                                 ),
// //                                             loadingBuilder: (
// //                                               context,
// //                                               child,
// //                                               loadingProgress,
// //                                             ) {
// //                                               if (loadingProgress == null)
// //                                                 return child;
// //                                               return Center(
// //                                                 child: CircularProgressIndicator(
// //                                                   value:
// //                                                       loadingProgress
// //                                                                   .expectedTotalBytes !=
// //                                                               null
// //                                                           ? loadingProgress
// //                                                                   .cumulativeBytesLoaded /
// //                                                               loadingProgress
// //                                                                   .expectedTotalBytes!
// //                                                           : null,
// //                                                 ),
// //                                               );
// //                                             },
// //                                           ),
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),
// //                       SizedBox(height: 32.h),

// //                       ShaderMask(
// //                         shaderCallback: (Rect bounds) {
// //                           return LinearGradient(
// //                             colors: [
// //                               Color(AppColors.blueLight),
// //                               Color(AppColors.primaryColor),
// //                               Color(AppColors.secondaryColor),
// //                             ],
// //                             begin: Alignment.topLeft,
// //                             end: Alignment.bottomRight,
// //                           ).createShader(bounds);
// //                         },
// //                         child: Text(
// //                           currentSong.name ?? "",
// //                           textAlign: TextAlign.center,
// //                           maxLines: 2,
// //                           overflow: TextOverflow.ellipsis,
// //                           style: GoogleFonts.poppins(
// //                             fontSize: 28.sp,
// //                             fontWeight: FontWeight.bold,
// //                             letterSpacing: 1.2,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(height: 2.h),

// //                       Row(
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Expanded(
// //                             flex: 8,
// //                             child: AppText(
// //                               text: "By - ${currentSong.artistName ?? ""}",
// //                               textColor: Colors.white54,
// //                               fontSize: 14.sp,
// //                               fontWeight: FontWeight.bold,
// //                               maxLines: 2,
// //                             ),
// //                           ),
// //                           Spacer(),
// //                           if (!isPlayingDeviceSongs)
// //                             Expanded(
// //                               flex: 4,
// //                               child: Row(
// //                                 children: [
// //                                   IconButton(
// //                                     icon: Icon(CupertinoIcons.share),
// //                                     iconSize: 22.sp,
// //                                     color: Color(AppColors.primaryColor),
// //                                     onPressed: () async {
// //                                       final String songTitle =
// //                                           currentSong.name ?? "Unknown Song";
// //                                       SharePlus.instance.share(
// //                                         ShareParams(
// //                                           title: songTitle,
// //                                           previewThumbnail: XFile(
// //                                             currentSong.image ??
// //                                                 "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
// //                                           ),
// //                                           uri: Uri.parse(
// //                                             currentSong.shareurl ??
// //                                                 "https://licensing.jamendo.com/en/in-store?jmm=instore",
// //                                           ),
// //                                         ),
// //                                       );
// //                                     },
// //                                   ),

// //                                   IconButton(
// //                                     icon:
// //                                         context
// //                                                 .watch<FavoriteProvider>()
// //                                                 .isLoading(currentSong.id ?? "")
// //                                             ? SizedBox(
// //                                               height: 18.sp,
// //                                               width: 18.sp,
// //                                               child:
// //                                                   const CircularProgressIndicator(
// //                                                     strokeWidth: 2,
// //                                                   ),
// //                                             )
// //                                             : FaIcon(
// //                                               context
// //                                                       .watch<FavoriteProvider>()
// //                                                       .isFavorite(
// //                                                         currentSong.id ?? "",
// //                                                       )
// //                                                   ? FontAwesomeIcons.solidHeart
// //                                                   : FontAwesomeIcons.heart,
// //                                             ),
// //                                     iconSize: 20.sp,
// //                                     color:
// //                                         context
// //                                                 .watch<FavoriteProvider>()
// //                                                 .isFavorite(
// //                                                   currentSong.id ?? "",
// //                                                 )
// //                                             ? Color(AppColors.blueLight)
// //                                             : Color(AppColors.primaryColor),
// //                                     onPressed: () async {
// //                                       final SharedPreferences preferences =
// //                                           await SharedPreferences.getInstance();
// //                                       final String? userId = preferences
// //                                           .getString("userUID");

// //                                       final songData = {
// //                                         "userId": userId,
// //                                         "id": currentSong.id,
// //                                         "name": currentSong.name,
// //                                         "artistName": currentSong.artistName,
// //                                         "image": currentSong.image,
// //                                         "audio": currentSong.audio,
// //                                         "audioDuration": currentSong.duration,
// //                                         "albumImage": currentSong.albumImage,
// //                                         "albumName": currentSong.albumName,
// //                                         "position": currentSong.position,
// //                                       };

// //                                       context
// //                                           .read<FavoriteProvider>()
// //                                           .toggleFavorite(songData);
// //                                     },
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 20.h),

// //                       StreamBuilder<Duration>(
// //                         stream: musicPlayer.positionStream,
// //                         builder: (context, snapshot) {
// //                           final position = snapshot.data ?? Duration.zero;
// //                           final duration =
// //                               musicPlayerState.audioPlayer.duration ??
// //                               Duration.zero;

// //                           return Column(
// //                             children: [
// //                               SizedBox(
// //                                 width: double.infinity,
// //                                 child: Slider(
// //                                   year2023: true,
// //                                   mouseCursor: MouseCursor.defer,
// //                                   thumbColor: Color(AppColors.blueLight),
// //                                   min: 0,
// //                                   max: duration.inSeconds.toDouble(),
// //                                   value:
// //                                       position.inSeconds
// //                                           .clamp(0, duration.inSeconds)
// //                                           .toDouble(),
// //                                   onChanged: musicPlayer.seek,
// //                                   padding: EdgeInsets.only(
// //                                     top: 12.h,
// //                                     right: 4.w,
// //                                     left: 4.w,
// //                                     bottom: 4.h,
// //                                   ),
// //                                   activeColor: Color(AppColors.primaryColor),
// //                                   inactiveColor: Color(
// //                                     AppColors.blueExtraLight,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Padding(
// //                                 padding: EdgeInsets.symmetric(
// //                                   horizontal: 8.w,
// //                                   vertical: 6.h,
// //                                 ),
// //                                 child: Row(
// //                                   mainAxisAlignment:
// //                                       MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     AppText(
// //                                       text: musicPlayer.formatDuration(
// //                                         position,
// //                                       ),
// //                                       textColor: Colors.white70,
// //                                     ),
// //                                     AppText(
// //                                       text: musicPlayer.formatDuration(
// //                                         duration,
// //                                       ),
// //                                       textColor: Colors.white70,
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           );
// //                         },
// //                       ),

// //                       SizedBox(height: 8.h),

// //                       // Player controls
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                         children: [
// //                           IconButton(
// //                             icon: FaIcon(FontAwesomeIcons.shuffle),
// //                             iconSize: 25.sp,
// //                             color: Color(AppColors.primaryColor),
// //                             onPressed: () {},
// //                           ),
// //                           IconButton(
// //                             icon: FaIcon(FontAwesomeIcons.backward),
// //                             iconSize: 35.sp,
// //                             color: Color(AppColors.primaryColor),
// //                             onPressed:
// //                                 isPlayingDeviceSongs
// //                                     ? _previousDeviceSong
// //                                     : musicPlayer.previousSong,
// //                           ),
// //                           StreamBuilder<PlayerState>(
// //                             stream: musicPlayer.playerStateStream,
// //                             builder: (context, snapshot) {
// //                               final playerState = snapshot.data;
// //                               final isPlaying = playerState?.playing ?? false;
// //                               return IconButton(
// //                                 icon: Icon(
// //                                   isPlaying
// //                                       ? CupertinoIcons.pause_circle
// //                                       : CupertinoIcons.play_circle,
// //                                 ),
// //                                 iconSize: 60,
// //                                 color: Colors.white,
// //                                 onPressed: musicPlayer.playPause,
// //                               );
// //                             },
// //                           ),
// //                           IconButton(
// //                             icon: FaIcon(FontAwesomeIcons.forward),
// //                             iconSize: 35.sp,
// //                             color: Color(AppColors.primaryColor),
// //                             onPressed:
// //                                 isPlayingDeviceSongs
// //                                     ? _nextDeviceSong
// //                                     : musicPlayer.nextSong,
// //                           ),
// //                           if (!isPlayingDeviceSongs) // Only show download for online songs
// //                             IconButton(
// //                               icon: const FaIcon(FontAwesomeIcons.download),
// //                               iconSize: 25.sp,
// //                               color: Color(AppColors.primaryColor),
// //                               onPressed: () {
// //                                 final audioUrl = currentSong.audio ?? "";
// //                                 final name = currentSong.name ?? "Unknown";

// //                                 if (audioUrl.isNotEmpty) {
// //                                   musicPlayer.startDownloadWithLoading(
// //                                     audioUrl,
// //                                     name,
// //                                   );
// //                                   _buildDownloadSuccessDialog(
// //                                     context,
// //                                     audioUrl,
// //                                   );
// //                                 }
// //                               },
// //                             ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 30.h),

// //                       // Device songs list if available
// //                       if (_deviceSongs.isNotEmpty) ...[
// //                         Divider(color: Colors.white54),
// //                         SizedBox(height: 16.h),
// //                         AppText(
// //                           text: "Device Songs",
// //                           fontSize: 18.sp,
// //                           fontWeight: FontWeight.bold,
// //                           textColor: Colors.white,
// //                         ),
// //                         SizedBox(height: 8.h),
// //                         Container(
// //                           height: 200.h,
// //                           child: ListView.builder(
// //                             itemCount: _deviceSongs.length,
// //                             itemBuilder: (context, index) {
// //                               final songPath = _deviceSongs[index];
// //                               final fileName = _getFileName(songPath);

// //                               return ListTile(
// //                                 leading: Icon(
// //                                   Icons.music_note,
// //                                   color: Colors.white,
// //                                 ),
// //                                 title: Text(
// //                                   fileName,
// //                                   style: TextStyle(color: Colors.white),
// //                                   maxLines: 1,
// //                                   overflow: TextOverflow.ellipsis,
// //                                 ),
// //                                 trailing:
// //                                     index == _currentDeviceSongIndex
// //                                         ? Icon(
// //                                           Icons.equalizer,
// //                                           color: Color(AppColors.primaryColor),
// //                                         )
// //                                         : null,
// //                                 onTap: () => _playDeviceSong(index),
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDeviceSongProgress() {
// //     return StreamBuilder<Duration>(
// //       stream: _deviceAudioPlayer.positionStream,
// //       builder: (context, positionSnapshot) {
// //         final position = positionSnapshot.data ?? Duration.zero;

// //         return StreamBuilder<Duration?>(
// //           stream: _deviceAudioPlayer.durationStream,
// //           builder: (context, durationSnapshot) {
// //             final duration = durationSnapshot.data ?? Duration.zero;

// //             return _buildProgressBar(position, duration, (value) {
// //               _deviceAudioPlayer.seek(Duration(seconds: value.toInt()));
// //             });
// //           },
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildProgressBar(
// //     Duration position,
// //     Duration duration,
// //     Function(double)? onChanged,
// //   ) {
// //     return Column(
// //       children: [
// //         SizedBox(
// //           width: double.infinity,
// //           child: Slider(
// //             year2023: true,
// //             mouseCursor: MouseCursor.defer,
// //             thumbColor: Color(AppColors.blueLight),
// //             min: 0,
// //             max: duration.inSeconds.toDouble(),
// //             value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
// //             onChanged: onChanged,
// //             padding: EdgeInsets.only(
// //               top: 12.h,
// //               right: 4.w,
// //               left: 4.w,
// //               bottom: 4.h,
// //             ),
// //             activeColor: Color(AppColors.primaryColor),
// //             inactiveColor: Color(AppColors.blueExtraLight),
// //           ),
// //         ),
// //         Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               AppText(
// //                 text: _formatDuration(position),
// //                 textColor: Colors.white70,
// //               ),
// //               AppText(
// //                 text: _formatDuration(duration),
// //                 textColor: Colors.white70,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   String _formatDuration(Duration duration) {
// //     String twoDigits(int n) => n.toString().padLeft(2, "0");
// //     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
// //     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
// //     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
// //   }

// //   Widget _buildNoSongsUI() {
// //     return Container(
// //       decoration: BoxDecoration(gradient: backgroundGradient()),
// //       child: Scaffold(
// //         backgroundColor: const Color.fromARGB(197, 0, 43, 53),
// //         appBar: AppBar(
// //           elevation: 0,
// //           toolbarHeight: 90,
// //           backgroundColor: Colors.transparent,
// //           title: AppText(
// //             text: "Now Playing",
// //             fontSize: 20.sp,
// //             textColor: Color(AppColors.lightText),
// //             fontWeight: FontWeight.w500,
// //           ),
// //           actions: [
// //             IconButton(
// //               icon: Icon(Icons.folder_open, color: Colors.white),
// //               onPressed: _loadSongsFromDevice,
// //             ),
// //           ],
// //         ),
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(Icons.music_note, size: 64, color: Colors.white54),
// //               SizedBox(height: 16),
// //               AppText(
// //                 text: "No songs available",
// //                 fontSize: 18,
// //                 textColor: Colors.white54,
// //               ),
// //               SizedBox(height: 16),
// //               ElevatedButton(
// //                 onPressed: _loadSongsFromDevice,
// //                 child: Text("Load Songs from Device"),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Color(AppColors.primaryColor),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildNoPointsDialog(BuildContext context, WidgetRef ref) {
// //     return Center(
// //       child: Material(
// //         color: Colors.transparent,
// //         child: Container(
// //           width: 320,
// //           padding: const EdgeInsets.all(24),
// //           decoration: BoxDecoration(
// //             color: Color(AppColors.whiteBackground),
// //             borderRadius: BorderRadius.circular(32),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Color(AppColors.primaryColor).withOpacity(0.18),
// //                 blurRadius: 32,
// //                 offset: const Offset(0, 12),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Image.asset("assets/image/rewardIcon.png", height: 80),
// //               const SizedBox(height: 16),
// //               AppText(
// //                 text: "No Reward Points!",
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.bold,
// //                 textColor: Color(AppColors.primaryColor),
// //               ),
// //               const SizedBox(height: 12),
// //               AppText(
// //                 text:
// //                     "You need more reward points to play music.\nGo to Library and earn more points by watching ads.",
// //                 align: TextAlign.center,
// //                 fontSize: 16,
// //                 textColor: Color(AppColors.darkBlue),
// //               ),
// //               const SizedBox(height: 24),
// //               ElevatedButton.icon(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Color(AppColors.primaryColor),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(18),
// //                   ),
// //                   elevation: 0,
// //                 ),
// //                 onPressed: () {
// //                   Navigator.of(context).pop();
// //                   Navigator.of(context).pushReplacement(
// //                     MaterialPageRoute(builder: (_) => const LibraryScreen()),
// //                   );
// //                   ref.read(dialogShownProvider.notifier).state = false;
// //                 },
// //                 icon: const Icon(Icons.card_giftcard, color: Colors.white),
// //                 label: AppText(
// //                   text: "Go to Library",
// //                   fontWeight: FontWeight.bold,
// //                   textColor: Colors.white,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildDownloadSuccessDialog(BuildContext context, String fileName) {
// //     return Dialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
// //       elevation: 0,
// //       backgroundColor: Colors.transparent,
// //       child: Container(
// //         padding: const EdgeInsets.all(24),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(24),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.2),
// //               blurRadius: 24,
// //               offset: const Offset(0, 8),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             FaIcon(
// //               FontAwesomeIcons.checkCircle,
// //               size: 60,
// //               color: Color(AppColors.primaryColor),
// //             ),
// //             const SizedBox(height: 16),
// //             AppText(
// //               text: "Download Complete",
// //               fontSize: 20,
// //               textColor: Colors.black87,
// //               fontWeight: FontWeight.w600,
// //             ),
// //             SizedBox(height: 9.h),
// //             AppText(
// //               text:
// //                   '"${fileName.length > 20 ? '${fileName.substring(0, 20)}...' : fileName}.mp3"',
// //               align: TextAlign.center,
// //               fontSize: 16,
// //               textColor: Colors.black54,
// //             ),
// //             SizedBox(height: 2.h),
// //             AppText(
// //               text: "has been saved to your Downloads folder",
// //               align: TextAlign.center,
// //               fontSize: 14,
// //               textColor: Colors.black54,
// //             ),
// //             const SizedBox(height: 24),
// //             AppMainButton(
// //               onPressed: () => Navigator.of(context).pop(),
// //               gradient: LinearGradient(
// //                 colors: [
// //                   Color(AppColors.blueLight),
// //                   Color(AppColors.primaryColor),
// //                 ],
// //               ),
// //               child: AppText(
// //                 text: "OK",
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 16,
// //                 textColor: Colors.white,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _AnimatedGlow extends StatefulWidget {
// //   final Widget child;
// //   const _AnimatedGlow({required this.child});

// //   @override
// //   State<_AnimatedGlow> createState() => _AnimatedGlowState();
// // }

// // class _AnimatedGlowState extends State<_AnimatedGlow>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1200),
// //     )..repeat(reverse: true);
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: _controller,
// //       builder: (context, child) {
// //         final glow = 18.0 + 12.0 * _controller.value;
// //         return Container(
// //           decoration: BoxDecoration(
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Color(AppColors.primaryColor).withOpacity(0.5),
// //                 blurRadius: glow,
// //                 spreadRadius: 1,
// //               ),
// //             ],
// //             shape: BoxShape.circle,
// //           ),
// //           child: widget.child,
// //         );
// //       },
// //     );
// //   }
// // }
// // music_player_screen.dart - FIXED VERSION

// // ignore_for_file: unnecessary_null_comparison, deprecated_member_use

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:lyrica/common/utils/utils.dart';
// import 'package:lyrica/common/widget/app_main_button.dart';
// import 'package:lyrica/common/widget/app_text.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/model/music_model.dart';
// import 'package:lyrica/modules/library/view/library_screen.dart';
// import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MusicPlayer extends ConsumerStatefulWidget {
//   final VoidCallback? onMinimize;
//   final List<Results> songList;
//   final int initialIndex;

//   const MusicPlayer({
//     super.key,
//     required this.songList,
//     required this.initialIndex,
//     required this.onMinimize,
//   });

//   @override
//   ConsumerState<MusicPlayer> createState() => _MusicPlayerScreenState();
// }

// class _MusicPlayerScreenState extends ConsumerState<MusicPlayer> {
//   String musicShareURL = '';
//   bool isLoadingDeviceSongs = false;
//   List<String> _deviceSongs = [];
//   int _currentDeviceSongIndex = -1;
//   final AudioPlayer _deviceAudioPlayer = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();

//     // FIXED: Initialize music player properly
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeMusicPlayer();
//     });

//     // Initialize device audio player listeners
//     _deviceAudioPlayer.playerStateStream.listen((playerState) {});
//     _deviceAudioPlayer.positionStream.listen((position) {});
//     _deviceAudioPlayer.durationStream.listen((duration) {});
//   }

//   void _initializeMusicPlayer() {
//     try {
//       final musicPlayer = ref.read(
//         musicPlayerProvider((
//           songList: widget.songList,
//           initialIndex: widget.initialIndex,
//         )).notifier,
//       );

//       // Initialize the music player
//       musicPlayer.initializeMusic();

//       // Fetch favorites
//       context.read<FavoriteProvider>().fetchFavorites();
//     } catch (e) {
//       debugPrint('Error initializing music player: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _deviceAudioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // FIXED: Watch the music player state properly
//     final musicPlayerAsync = ref.watch(
//       musicPlayerProvider((
//         songList: widget.songList,
//         initialIndex: widget.initialIndex,
//       )),
//     );

//     final musicPlayer = ref.watch(
//       musicPlayerProvider((
//         songList: widget.songList,
//         initialIndex: widget.initialIndex,
//       )).notifier,
//     );

//     final rewardPointsAsync = ref.watch(rewardPointsProvider);
//     final bool isPlayingDeviceSongs = _deviceSongs.isNotEmpty;

//     // Show loading or error state
//     if (!isPlayingDeviceSongs &&
//         (widget.songList.isEmpty ||
//             musicPlayerAsync.currentIndex < 0 ||
//             musicPlayerAsync.currentIndex >= widget.songList.length)) {
//       return _buildNoSongsUI();
//     }

//     final currentSong = widget.songList[musicPlayerAsync.currentIndex];

//     // FIXED: Listen to download complete state
//     ref.listen<bool>(
//       musicPlayerProvider((
//         songList: widget.songList,
//         initialIndex: widget.initialIndex,
//       )).select((state) => state.showDownloadComplete),
//       (previous, next) {
//         if (next) {
//           Navigator.of(context).pop();
//           showDialog(
//             context: context,
//             barrierDismissible: true,
//             builder:
//                 (_) => _buildDownloadSuccessDialog(
//                   context,
//                   musicPlayerAsync.downloadingFileName ?? "Unknown",
//                 ),
//           ).then((_) {
//             musicPlayer.resetDownloadComplete();
//           });
//         }
//       },
//     );

//     // FIXED: Listen to dialog state properly
//     ref.listen<bool>(dialogShownProvider, (previous, next) {
//       if (next && previous != next) {
//         showGeneralDialog(
//           context: context,
//           barrierDismissible: false,
//           barrierLabel: "RewardDialog",
//           transitionDuration: const Duration(milliseconds: 300),
//           pageBuilder: (_, __, ___) => _buildNoPointsDialog(context, ref),
//           transitionBuilder: (context, animation, secondaryAnimation, child) {
//             return ScaleTransition(
//               scale: CurvedAnimation(
//                 parent: animation,
//                 curve: Curves.easeOutBack,
//               ),
//               child: child,
//             );
//           },
//         );
//       }
//     });

//     return Column(
//       children: [
//         Container(height: 80, decoration: BoxDecoration(color: Colors.black)),
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(gradient: backgroundGradient()),
//             child: Scaffold(
//               backgroundColor: const Color.fromARGB(197, 0, 43, 53),
//               appBar: AppBar(
//                 elevation: 0,
//                 toolbarHeight: 90,
//                 backgroundColor: Colors.transparent,
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppText(
//                       text: "Now Playing",
//                       fontSize: 20.sp,
//                       textColor: Color(AppColors.lightText),
//                       fontWeight: FontWeight.w500,
//                     ),
//                     if (isPlayingDeviceSongs)
//                       AppText(
//                         text: "Local Device",
//                         fontSize: 14.sp,
//                         textColor: Colors.white54,
//                       ),
//                   ],
//                 ),
//                 actions: [
//                   if (!isPlayingDeviceSongs)
//                     Container(
//                       padding: EdgeInsets.only(right: 16.w, left: 16.w),
//                       margin: EdgeInsets.only(
//                         top: 20.h,
//                         bottom: 20.h,
//                         right: 12.w,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Color(AppColors.primaryColor),
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(
//                               AppColors.primaryColor,
//                             ).withOpacity(0.18),
//                             blurRadius: 12,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.stars, color: Colors.white, size: 18),
//                           SizedBox(width: 6),
//                           rewardPointsAsync.when(
//                             data:
//                                 (points) => AppText(
//                                   text: "$points",
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   textColor: Colors.white,
//                                 ),
//                             loading:
//                                 () => SizedBox(
//                                   width: 16,
//                                   height: 16,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                             error:
//                                 (error, stack) => AppText(
//                                   text: "0",
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   textColor: Colors.white,
//                                 ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//               body: SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: EdgeInsets.all(16.sp),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: TweenAnimationBuilder<double>(
//                           tween: Tween(begin: 0.95, end: 1.0),
//                           duration: const Duration(milliseconds: 900),
//                           curve: Curves.elasticOut,
//                           builder: (context, scale, child) {
//                             return Transform.scale(
//                               scale: scale,
//                               child: AnimatedContainer(
//                                 duration: const Duration(milliseconds: 600),
//                                 curve: Curves.easeInOut,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(24),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(
//                                         AppColors.primaryColor,
//                                       ).withOpacity(0.25),
//                                       blurRadius: 40,
//                                       spreadRadius: 8,
//                                       offset: Offset(0, 16),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(24),
//                                   child:
//                                       isPlayingDeviceSongs
//                                           ? Container(
//                                             width: 300.w,
//                                             height: 300.w,
//                                             color: Color(
//                                               AppColors.primaryColor,
//                                             ),
//                                             child: Icon(
//                                               Icons.music_note,
//                                               size: 100.sp,
//                                               color: Colors.white,
//                                             ),
//                                           )
//                                           : Image.network(
//                                             width: 300.w,
//                                             height: 300.w,
//                                             currentSong.image ?? "",
//                                             fit: BoxFit.cover,
//                                             errorBuilder:
//                                                 (_, __, ___) => Container(
//                                                   width: 300.w,
//                                                   height: 300.w,
//                                                   color: Color(
//                                                     AppColors.primaryColor,
//                                                   ),
//                                                   child: Icon(
//                                                     Icons.music_note,
//                                                     size: 100.sp,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                             loadingBuilder: (
//                                               context,
//                                               child,
//                                               loadingProgress,
//                                             ) {
//                                               if (loadingProgress == null) {
//                                                 return child;
//                                               }
//                                               return SizedBox(
//                                                 width: 300.w,
//                                                 height: 300.w,
//                                                 child: Center(
//                                                   child: CircularProgressIndicator(
//                                                     value:
//                                                         loadingProgress
//                                                                     .expectedTotalBytes !=
//                                                                 null
//                                                             ? loadingProgress
//                                                                     .cumulativeBytesLoaded /
//                                                                 loadingProgress
//                                                                     .expectedTotalBytes!
//                                                             : null,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 32.h),

//                       ShaderMask(
//                         shaderCallback: (Rect bounds) {
//                           return LinearGradient(
//                             colors: [
//                               Color(AppColors.blueLight),
//                               Color(AppColors.primaryColor),
//                               Color(AppColors.secondaryColor),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ).createShader(bounds);
//                         },
//                         child: Text(
//                           currentSong.name ?? "Unknown Song",
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.poppins(
//                             fontSize: 28.sp,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1.2,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 2.h),

//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             flex: 8,
//                             child: AppText(
//                               text:
//                                   "By - ${currentSong.artistName ?? "Unknown Artist"}",
//                               textColor: Colors.white54,
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.bold,
//                               maxLines: 2,
//                             ),
//                           ),
//                           Spacer(),
//                           if (!isPlayingDeviceSongs)
//                             Expanded(
//                               flex: 4,
//                               child: Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(CupertinoIcons.share),
//                                     iconSize: 22.sp,
//                                     color: Color(AppColors.primaryColor),
//                                     onPressed: () async {
//                                       final String songTitle =
//                                           currentSong.name ?? "Unknown Song";
//                                       SharePlus.instance.share(
//                                         ShareParams(
//                                           title: songTitle,
//                                           previewThumbnail: XFile(
//                                             currentSong.image ??
//                                                 "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
//                                           ),
//                                           uri: Uri.parse(
//                                             currentSong.shareurl ??
//                                                 "https://licensing.jamendo.com/en/in-store?jmm=instore",
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   IconButton(
//                                     icon:
//                                         context
//                                                 .watch<FavoriteProvider>()
//                                                 .isLoading(currentSong.id ?? "")
//                                             ? SizedBox(
//                                               height: 18.sp,
//                                               width: 18.sp,
//                                               child:
//                                                   const CircularProgressIndicator(
//                                                     strokeWidth: 2,
//                                                   ),
//                                             )
//                                             : FaIcon(
//                                               context
//                                                       .watch<FavoriteProvider>()
//                                                       .isFavorite(
//                                                         currentSong.id ?? "",
//                                                       )
//                                                   ? FontAwesomeIcons.solidHeart
//                                                   : FontAwesomeIcons.heart,
//                                             ),
//                                     iconSize: 20.sp,
//                                     color:
//                                         context
//                                                 .watch<FavoriteProvider>()
//                                                 .isFavorite(
//                                                   currentSong.id ?? "",
//                                                 )
//                                             ? Color(AppColors.blueLight)
//                                             : Color(AppColors.primaryColor),
//                                     onPressed: () async {
//                                       final SharedPreferences preferences =
//                                           await SharedPreferences.getInstance();
//                                       final String? userId = preferences
//                                           .getString("userUID");

//                                       final songData = {
//                                         "userId": userId,
//                                         "id": currentSong.id,
//                                         "name": currentSong.name,
//                                         "artistName": currentSong.artistName,
//                                         "image": currentSong.image,
//                                         "audio": currentSong.audio,
//                                         "audioDuration": currentSong.duration,
//                                         "albumImage": currentSong.albumImage,
//                                         "albumName": currentSong.albumName,
//                                         "position": currentSong.position,
//                                       };

//                                       context
//                                           .read<FavoriteProvider>()
//                                           .toggleFavorite(songData);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       ),
//                       SizedBox(height: 20.h),

//                       // FIXED: Progress bar for both online and device songs
//                       if (isPlayingDeviceSongs)
//                         _buildDeviceSongProgress()
//                       else
//                         StreamBuilder<Duration>(
//                           stream: musicPlayer.positionStream,
//                           builder: (context, snapshot) {
//                             final position = snapshot.data ?? Duration.zero;
//                             final duration =
//                                 musicPlayerAsync.audioPlayer.duration ??
//                                 Duration.zero;

//                             return _buildProgressBar(position, duration, (
//                               value,
//                             ) {
//                               musicPlayer.seek(value);
//                             });
//                           },
//                         ),

//                       SizedBox(height: 8.h),

//                       // FIXED: Player controls
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                             icon: FaIcon(FontAwesomeIcons.shuffle),
//                             iconSize: 25.sp,
//                             color: Color(AppColors.primaryColor),
//                             onPressed: () {},
//                           ),
//                           IconButton(
//                             icon: FaIcon(FontAwesomeIcons.backward),
//                             iconSize: 35.sp,
//                             color: Color(AppColors.primaryColor),
//                             onPressed: musicPlayer.previousSong,
//                           ),
//                           StreamBuilder<PlayerState>(
//                             stream: musicPlayer.playerStateStream,
//                             builder: (context, snapshot) {
//                               final playerState = snapshot.data;
//                               final playing = playerState?.playing ?? false;
//                               final processingState =
//                                   playerState?.processingState;

//                               if (processingState == ProcessingState.loading ||
//                                   processingState ==
//                                       ProcessingState.buffering) {
//                                 return SizedBox(
//                                   height: 60,
//                                   width: 60,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(18.0),
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 3,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 );
//                               } else if (playing) {
//                                 return IconButton(
//                                   icon: const Icon(CupertinoIcons.pause_circle),
//                                   iconSize: 60,
//                                   color: Colors.white,
//                                   onPressed: musicPlayer.playPause,
//                                 );
//                               } else {
//                                 return IconButton(
//                                   icon: const Icon(CupertinoIcons.play_circle),
//                                   iconSize: 60,
//                                   color: Colors.white,
//                                   onPressed: musicPlayer.playPause,
//                                 );
//                               }
//                             },
//                           ),

//                           IconButton(
//                             icon: FaIcon(FontAwesomeIcons.forward),
//                             iconSize: 35.sp,
//                             color: Color(AppColors.primaryColor),
//                             onPressed: musicPlayer.nextSong,
//                           ),
//                           if (!isPlayingDeviceSongs)
//                             IconButton(
//                               icon: const FaIcon(FontAwesomeIcons.download),
//                               iconSize: 25.sp,
//                               color: Color(AppColors.primaryColor),
//                               onPressed: () {
//                                 final audioUrl = currentSong.audio ?? "";
//                                 final name = currentSong.name ?? "Unknown";

//                                 if (audioUrl.isNotEmpty) {
//                                   musicPlayer.startDownloadWithLoading(
//                                     audioUrl,
//                                     name,
//                                   );
//                                   _buildDownloadSuccessDialog(context, name);
//                                 }
//                               },
//                             ),
//                         ],
//                       ),
//                       SizedBox(height: 30.h),

//                       // Device songs list if available
//                       if (_deviceSongs.isNotEmpty) ...[
//                         Divider(color: Colors.white54),
//                         SizedBox(height: 16.h),
//                         AppText(
//                           text: "Device Songs",
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                           textColor: Colors.white,
//                         ),
//                         SizedBox(height: 8.h),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDeviceSongProgress() {
//     return StreamBuilder<Duration>(
//       stream: _deviceAudioPlayer.positionStream,
//       builder: (context, positionSnapshot) {
//         final position = positionSnapshot.data ?? Duration.zero;

//         return StreamBuilder<Duration?>(
//           stream: _deviceAudioPlayer.durationStream,
//           builder: (context, durationSnapshot) {
//             final duration = durationSnapshot.data ?? Duration.zero;

//             return _buildProgressBar(position, duration, (value) {
//               _deviceAudioPlayer.seek(Duration(seconds: value.toInt()));
//             });
//           },
//         );
//       },
//     );
//   }

//   Widget _buildProgressBar(
//     Duration position,
//     Duration duration,
//     Function(double)? onChanged,
//   ) {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           child: Slider(
//             year2023: true,
//             mouseCursor: MouseCursor.defer,
//             thumbColor: Color(AppColors.blueLight),
//             min: 0,
//             max: duration.inSeconds.toDouble(),
//             value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
//             onChanged: onChanged,
//             padding: EdgeInsets.only(
//               top: 12.h,
//               right: 4.w,
//               left: 4.w,
//               bottom: 4.h,
//             ),
//             activeColor: Color(AppColors.primaryColor),
//             inactiveColor: Color(AppColors.blueExtraLight),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               AppText(
//                 text: _formatDuration(position),
//                 textColor: Colors.white70,
//               ),
//               AppText(
//                 text: _formatDuration(duration),
//                 textColor: Colors.white70,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   Widget _buildNoSongsUI() {
//     return Container(
//       decoration: BoxDecoration(gradient: backgroundGradient()),
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(197, 0, 43, 53),
//         appBar: AppBar(
//           elevation: 0,
//           toolbarHeight: 90,
//           backgroundColor: Colors.transparent,
//           title: AppText(
//             text: "Now Playing",
//             fontSize: 20.sp,
//             textColor: Color(AppColors.lightText),
//             fontWeight: FontWeight.w500,
//           ),
//           actions: [],
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.music_note, size: 64, color: Colors.white54),
//               SizedBox(height: 16),
//               AppText(
//                 text: "No songs available",
//                 fontSize: 18,
//                 textColor: Colors.white54,
//               ),
//               SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNoPointsDialog(BuildContext context, WidgetRef ref) {
//     return Center(
//       child: Material(
//         color: Colors.transparent,
//         child: Container(
//           width: 320,
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Color(AppColors.whiteBackground),
//             borderRadius: BorderRadius.circular(32),
//             boxShadow: [
//               BoxShadow(
//                 color: Color(AppColors.primaryColor).withOpacity(0.18),
//                 blurRadius: 32,
//                 offset: const Offset(0, 12),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset("assets/image/rewardIcon.png", height: 80),
//               const SizedBox(height: 16),
//               AppText(
//                 text: "No Reward Points!",
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 textColor: Color(AppColors.primaryColor),
//               ),
//               const SizedBox(height: 12),
//               AppText(
//                 text:
//                     "You need more reward points to play music.\nGo to Library and earn more points by watching ads.",
//                 align: TextAlign.center,
//                 fontSize: 16,
//                 textColor: Color(AppColors.darkBlue),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(AppColors.primaryColor),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                   elevation: 0,
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (_) => const LibraryScreen()),
//                   );
//                   ref.read(dialogShownProvider.notifier).state = false;
//                 },
//                 icon: const Icon(Icons.card_giftcard, color: Colors.white),
//                 label: AppText(
//                   text: "Go to Library",
//                   fontWeight: FontWeight.bold,
//                   textColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDownloadSuccessDialog(BuildContext context, String fileName) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 24,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             FaIcon(
//               FontAwesomeIcons.checkCircle,
//               size: 60,
//               color: Color(AppColors.primaryColor),
//             ),
//             const SizedBox(height: 16),
//             AppText(
//               text: "Download Complete",
//               fontSize: 20,
//               textColor: Colors.black87,
//               fontWeight: FontWeight.w600,
//             ),
//             SizedBox(height: 9.h),
//             AppText(
//               text:
//                   '"${fileName.length > 20 ? '${fileName.substring(0, 20)}...' : fileName}.mp3"',
//               align: TextAlign.center,
//               fontSize: 16,
//               textColor: Colors.black54,
//             ),
//             SizedBox(height: 2.h),
//             AppText(
//               text: "has been saved to your Downloads folder",
//               align: TextAlign.center,
//               fontSize: 14,
//               textColor: Colors.black54,
//             ),
//             const SizedBox(height: 24),
//             AppMainButton(
//               onPressed: () => Navigator.of(context).pop(),
//               gradient: LinearGradient(
//                 colors: [
//                   Color(AppColors.blueLight),
//                   Color(AppColors.primaryColor),
//                 ],
//               ),
//               child: AppText(
//                 text: "OK",
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 textColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/library/view/library_screen.dart';
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  final VoidCallback? onMinimize;
  final List<Results> songList;
  final int initialIndex;

  const MusicPlayer({
    super.key,
    required this.songList,
    required this.initialIndex,
    required this.onMinimize,
  });

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayer> {
  String musicShareURL = '';
  bool isLoadingDeviceSongs = false;
  final List<String> _deviceSongs = [];
  // int _currentDeviceSongIndex = -1;

  @override
  void initState() {
    super.initState();

    // FIXED: Initialize music player properly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMusicPlayer();
    });
  }

  void _initializeMusicPlayer() {
    try {
      final musicPlayer = ref.read(
        musicPlayerProvider((
          songList: widget.songList,
          initialIndex: widget.initialIndex,
        )).notifier,
      );

      // Initialize the music player
      musicPlayer.initializeMusic();

      // Fetch favorites
      context.read<FavoriteProvider>().fetchFavorites();
    } catch (e) {
      debugPrint('Error initializing music player: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIXED: Watch the music player state properly
    final musicPlayerAsync = ref.watch(
      musicPlayerProvider((
        songList: widget.songList,
        initialIndex: widget.initialIndex,
      )),
    );

    final musicPlayer = ref.watch(
      musicPlayerProvider((
        songList: widget.songList,
        initialIndex: widget.initialIndex,
      )).notifier,
    );

    final rewardPointsAsync = ref.watch(rewardPointsProvider);
    final bool isPlayingDeviceSongs = _deviceSongs.isNotEmpty;

    // Show loading or error state
    if (!isPlayingDeviceSongs &&
        (widget.songList.isEmpty ||
            musicPlayerAsync.currentIndex < 0 ||
            musicPlayerAsync.currentIndex >= widget.songList.length)) {
      return _buildNoSongsUI();
    }

    final currentSong = widget.songList[musicPlayerAsync.currentIndex];

    // FIXED: Listen to download complete state
    ref.listen<bool>(
      musicPlayerProvider((
        songList: widget.songList,
        initialIndex: widget.initialIndex,
      )).select((state) => state.showDownloadComplete),
      (previous, next) {
        if (next) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: true,
            builder:
                (_) => _buildDownloadSuccessDialog(
                  context,
                  musicPlayerAsync.downloadingFileName ?? "Unknown",
                ),
          ).then((_) {
            musicPlayer.resetDownloadComplete();
          });
        }
      },
    );

    // FIXED: Listen to dialog state properly
    ref.listen<bool>(dialogShownProvider, (previous, next) {
      if (next && previous != next) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: "RewardDialog",
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => _buildNoPointsDialog(context, ref),
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
              child: child,
            );
          },
        );
      }
    });

    return Column(
      children: [
        Container(height: 80, decoration: BoxDecoration(color: Colors.black)),
        Expanded(
          child: Container(
            decoration: BoxDecoration(gradient: backgroundGradient()),
            child: Scaffold(
              backgroundColor: const Color.fromARGB(197, 0, 43, 53),
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 90,
                backgroundColor: Colors.transparent,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Now Playing",
                      fontSize: 20.sp,
                      textColor: Color(AppColors.lightText),
                      fontWeight: FontWeight.w500,
                    ),
                    if (isPlayingDeviceSongs)
                      AppText(
                        text: "Local Device",
                        fontSize: 14.sp,
                        textColor: Colors.white54,
                      ),
                  ],
                ),
                actions: [
                  if (!isPlayingDeviceSongs)
                    Container(
                      padding: EdgeInsets.only(right: 16.w, left: 16.w),
                      margin: EdgeInsets.only(
                        top: 20.h,
                        bottom: 20.h,
                        right: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: Color(AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Color(
                              AppColors.primaryColor,
                            ).withOpacity(0.18),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.stars, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          rewardPointsAsync.when(
                            data:
                                (points) => AppText(
                                  text: "$points",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  textColor: Colors.white,
                                ),
                            loading:
                                () => SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                            error:
                                (error, stack) => AppText(
                                  text: "0",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  textColor: Colors.white,
                                ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.95, end: 1.0),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.elasticOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(
                                        AppColors.primaryColor,
                                      ).withOpacity(0.25),
                                      blurRadius: 40,
                                      spreadRadius: 8,
                                      offset: Offset(0, 16),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child:
                                      isPlayingDeviceSongs
                                          ? Container(
                                            width: 300.w,
                                            height: 300.w,
                                            color: Color(
                                              AppColors.primaryColor,
                                            ),
                                            child: Icon(
                                              Icons.music_note,
                                              size: 100.sp,
                                              color: Colors.white,
                                            ),
                                          )
                                          : Image.network(
                                            width: 300.w,
                                            height: 300.w,
                                            currentSong.image ?? "",
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (_, __, ___) => Container(
                                                  width: 300.w,
                                                  height: 300.w,
                                                  color: Color(
                                                    AppColors.primaryColor,
                                                  ),
                                                  child: Icon(
                                                    Icons.music_note,
                                                    size: 100.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return SizedBox(
                                                width: 300.w,
                                                height: 300.w,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    value:
                                                        loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 32.h),

                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [
                              Color(AppColors.blueLight),
                              Color(AppColors.primaryColor),
                              Color(AppColors.secondaryColor),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: Text(
                          currentSong.name ?? "Unknown Song",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 8,
                            child: AppText(
                              text:
                                  "By - ${currentSong.artistName ?? "Unknown Artist"}",
                              textColor: Colors.white54,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              maxLines: 2,
                            ),
                          ),
                          Spacer(),
                          if (!isPlayingDeviceSongs)
                            Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(CupertinoIcons.share),
                                    iconSize: 22.sp,
                                    color: Color(AppColors.primaryColor),
                                    onPressed: () async {
                                      final String songTitle =
                                          currentSong.name ?? "Unknown Song";
                                      SharePlus.instance.share(
                                        ShareParams(
                                          title: songTitle,
                                          previewThumbnail: XFile(
                                            currentSong.image ??
                                                "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
                                          ),
                                          uri: Uri.parse(
                                            currentSong.shareurl ??
                                                "https://licensing.jamendo.com/en/in-store?jmm=instore",
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon:
                                        context
                                                .watch<FavoriteProvider>()
                                                .isLoading(currentSong.id ?? "")
                                            ? SizedBox(
                                              height: 18.sp,
                                              width: 18.sp,
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                            )
                                            : FaIcon(
                                              context
                                                      .watch<FavoriteProvider>()
                                                      .isFavorite(
                                                        currentSong.id ?? "",
                                                      )
                                                  ? FontAwesomeIcons.solidHeart
                                                  : FontAwesomeIcons.heart,
                                            ),
                                    iconSize: 20.sp,
                                    color:
                                        context
                                                .watch<FavoriteProvider>()
                                                .isFavorite(
                                                  currentSong.id ?? "",
                                                )
                                            ? Color(AppColors.blueLight)
                                            : Color(AppColors.primaryColor),
                                    onPressed: () async {
                                      final SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      final String? userId = preferences
                                          .getString("userUID");

                                      final songData = {
                                        "userId": userId,
                                        "id": currentSong.id,
                                        "name": currentSong.name,
                                        "artistName": currentSong.artistName,
                                        "image": currentSong.image,
                                        "audio": currentSong.audio,
                                        "audioDuration": currentSong.duration,
                                        "albumImage": currentSong.albumImage,
                                        "albumName": currentSong.albumName,
                                        "position": currentSong.position,
                                      };

                                      context
                                          .read<FavoriteProvider>()
                                          .toggleFavorite(songData);
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // FIXED: Progress bar for both online and device songs
                      StreamBuilder<Duration>(
                        stream: musicPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final duration =
                              musicPlayerAsync.audioPlayer.duration ??
                              Duration.zero;

                          return _buildProgressBar(position, duration, (value) {
                            musicPlayer.seek(value);
                          });
                        },
                      ),

                      SizedBox(height: 8.h),

                      // FIXED: Player controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.shuffle),
                            iconSize: 25.sp,
                            color: Color(AppColors.primaryColor),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.backward),
                            iconSize: 35.sp,
                            color: Color(AppColors.primaryColor),
                            onPressed: musicPlayer.previousSong,
                          ),
                          StreamBuilder<PlayerState>(
                            stream: musicPlayer.playerStateStream,
                            builder: (context, snapshot) {
                              final playerState = snapshot.data;
                              final playing = playerState?.playing ?? false;
                              final processingState =
                                  playerState?.processingState;

                              if (processingState == ProcessingState.loading ||
                                  processingState ==
                                      ProcessingState.buffering) {
                                return SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              } else if (playing) {
                                return IconButton(
                                  icon: const Icon(CupertinoIcons.pause_circle),
                                  iconSize: 60,
                                  color: Colors.white,
                                  onPressed: musicPlayer.playPause,
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(CupertinoIcons.play_circle),
                                  iconSize: 60,
                                  color: Colors.white,
                                  onPressed: musicPlayer.playPause,
                                );
                              }
                            },
                          ),

                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.forward),
                            iconSize: 35.sp,
                            color: Color(AppColors.primaryColor),
                            onPressed: musicPlayer.nextSong,
                          ),
                          if (!isPlayingDeviceSongs)
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.download),
                              iconSize: 25.sp,
                              color: Color(AppColors.primaryColor),
                              onPressed: () {
                                final audioUrl = currentSong.audio ?? "";
                                final name = currentSong.name ?? "Unknown";

                                if (audioUrl.isNotEmpty) {
                                  musicPlayer.startDownloadWithLoading(
                                    audioUrl,
                                    name,
                                  );
                                  _buildDownloadSuccessDialog(context, name);
                                }
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: 30.h),

                      // Device songs list if available
                      if (_deviceSongs.isNotEmpty) ...[
                        Divider(color: Colors.white54),
                        SizedBox(height: 16.h),
                        AppText(
                          text: "Device Songs",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: 8.h),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    Duration position,
    Duration duration,
    Function(double)? onChanged,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Slider(
            year2023: true,
            mouseCursor: MouseCursor.defer,
            thumbColor: Color(AppColors.blueLight),
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.clamp(0, duration.inSeconds).toDouble(),
            onChanged: onChanged,
            padding: EdgeInsets.only(
              top: 12.h,
              right: 4.w,
              left: 4.w,
              bottom: 4.h,
            ),
            activeColor: Color(AppColors.primaryColor),
            inactiveColor: Color(AppColors.blueExtraLight),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: _formatDuration(position),
                textColor: Colors.white70,
              ),
              AppText(
                text: _formatDuration(duration),
                textColor: Colors.white70,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildNoSongsUI() {
    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          title: AppText(
            text: "Now Playing",
            fontSize: 20.sp,
            textColor: Color(AppColors.lightText),
            fontWeight: FontWeight.w500,
          ),
          actions: [],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.music_note, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              AppText(
                text: "No songs available",
                fontSize: 18,
                textColor: Colors.white54,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoPointsDialog(BuildContext context, WidgetRef ref) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(AppColors.whiteBackground),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Color(AppColors.primaryColor).withOpacity(0.18),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/image/rewardIcon.png", height: 80),
              const SizedBox(height: 16),
              AppText(
                text: "No Reward Points!",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                textColor: Color(AppColors.primaryColor),
              ),
              const SizedBox(height: 12),
              AppText(
                text:
                    "You need more reward points to play music.\nGo to Library and earn more points by watching ads.",
                align: TextAlign.center,
                fontSize: 16,
                textColor: Color(AppColors.darkBlue),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LibraryScreen()),
                  );
                  ref.read(dialogShownProvider.notifier).state = false;
                },
                icon: const Icon(Icons.card_giftcard, color: Colors.white),
                label: AppText(
                  text: "Go to Library",
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadSuccessDialog(BuildContext context, String fileName) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.checkCircle,
              size: 60,
              color: Color(AppColors.primaryColor),
            ),
            const SizedBox(height: 16),
            AppText(
              text: "Download Complete",
              fontSize: 20,
              textColor: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 9.h),
            AppText(
              text:
                  '"${fileName.length > 20 ? '${fileName.substring(0, 20)}...' : fileName}.mp3"',
              align: TextAlign.center,
              fontSize: 16,
              textColor: Colors.black54,
            ),
            SizedBox(height: 2.h),
            AppText(
              text: "has been saved to your Downloads folder",
              align: TextAlign.center,
              fontSize: 14,
              textColor: Colors.black54,
            ),
            const SizedBox(height: 24),
            AppMainButton(
              onPressed: () => Navigator.of(context).pop(),
              gradient: LinearGradient(
                colors: [
                  Color(AppColors.blueLight),
                  Color(AppColors.primaryColor),
                ],
              ),
              child: AppText(
                text: "OK",
                fontWeight: FontWeight.bold,
                fontSize: 16,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
