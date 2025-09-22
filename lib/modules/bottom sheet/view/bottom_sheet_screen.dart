// // // // // // // ignore_for_file: library_private_types_in_public_api

// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // // import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
// // // // // // import 'package:lyrica/modules/home/view/home_screen.dart';
// // // // // // import 'package:lyrica/modules/search%20items/view/search_screen.dart';
// // // // // // import 'package:lyrica/modules/library/view/library_screen.dart';

// // // // // // final GlobalKey<_BottomSheetScreenState> bottomNavKey = GlobalKey();

// // // // // // class BottomSheetScreen extends ConsumerStatefulWidget {
// // // // // //   const BottomSheetScreen({super.key});

// // // // // //   @override
// // // // // //   ConsumerState<BottomSheetScreen> createState() => _BottomSheetScreenState();
// // // // // // }

// // // // // // class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen> {
// // // // // //   int _currentIndex = 0;

// // // // // //   void setTab(int index) {
// // // // // //     setState(() {
// // // // // //       _currentIndex = index;
// // // // // //     });
// // // // // //   }

// // // // // //   final List<Widget> _screens = const [
// // // // // //     HomeScreen("", ""),
// // // // // //     SearchScreen(false),
// // // // // //     LibraryScreen(),
// // // // // //   ];

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       body: IndexedStack(index: _currentIndex, children: _screens),
// // // // // //       bottomNavigationBar: CustomBottomBar(
// // // // // //         currentIndex: _currentIndex,
// // // // // //         onTap: (index) {
// // // // // //           setState(() {
// // // // // //             _currentIndex = index;
// // // // // //           });
// // // // // //         },
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // // // ignore_for_file: library_private_types_in_public_api

// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
// // // // // import 'package:lyrica/modules/home/view/home_screen.dart';
// // // // // import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// // // // // import 'package:lyrica/modules/search%20items/view/search_screen.dart';
// // // // // import 'package:lyrica/modules/library/view/library_screen.dart';

// // // // // final GlobalKey<_BottomSheetScreenState> bottomNavKey = GlobalKey();

// // // // // class BottomSheetScreen extends ConsumerStatefulWidget {
// // // // //   const BottomSheetScreen({super.key});

// // // // //   @override
// // // // //   ConsumerState<BottomSheetScreen> createState() => _BottomSheetScreenState();
// // // // // }

// // // // // class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen> {
// // // // //   int _currentIndex = 0;

// // // // //   void setTab(int index) {
// // // // //     setState(() {
// // // // //       _currentIndex = index;
// // // // //     });
// // // // //   }

// // // // //   final List<Widget> _screens = const [
// // // // //     HomeScreen("", ""),
// // // // //     SearchScreen(false),
// // // // //     LibraryScreen(),
// // // // //   ];

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final currentMusicState = ref.watch(currentMusicProvider);

// // // // //     return Scaffold(
// // // // //       body: IndexedStack(index: _currentIndex, children: _screens),
// // // // //       bottomNavigationBar: Padding(
// // // // //         // Add padding to account for mini player height
// // // // //         padding: EdgeInsets.only(bottom: currentMusicState.isPlaying ? 70 : 0),
// // // // //         child: CustomBottomBar(
// // // // //           currentIndex: _currentIndex,
// // // // //           onTap: (index) {
// // // // //             setState(() {
// // // // //               _currentIndex = index;
// // // // //             });
// // // // //           },
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // ignore_for_file: library_private_types_in_public_api, deprecated_member_use

// // // // import 'dart:ui';

// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // // import 'package:just_audio/just_audio.dart';
// // // // import 'package:lyrica/common/utils/utils.dart';
// // // // import 'package:lyrica/common/widget/app_text.dart';
// // // // import 'package:lyrica/core/constant/app_colors.dart';
// // // // import 'package:lyrica/main.dart';
// // // // import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
// // // // import 'package:lyrica/modules/home/view/home_screen.dart';
// // // // import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// // // // import 'package:lyrica/modules/music%20player/view/music_player.dart';
// // // // import 'package:lyrica/modules/search%20items/view/search_screen.dart';
// // // // import 'package:lyrica/modules/library/view/library_screen.dart';
// // // // import 'package:miniplayer/miniplayer.dart';

// // // // final GlobalKey<_BottomSheetScreenState> bottomSheetKey = GlobalKey();

// // // // class BottomSheetScreen extends ConsumerStatefulWidget {
// // // //   const BottomSheetScreen({super.key});

// // // //   static void expandMiniPlayer() {
// // // //     final state = bottomSheetKey.currentState;
// // // //     state?._expandMiniPlayer();
// // // //   }

// // // //   @override
// // // //   ConsumerState<BottomSheetScreen> createState() => _BottomSheetScreenState();
// // // // }

// // // // class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen> {
// // // //   int _currentIndex = 0;
// // // //   final MiniplayerController _miniplayerController = MiniplayerController();
// // // //   double currentHeight = 70;
// // // //   PanelState _currentPanelState = PanelState.MIN;
// // // //   bool isAnimating = false;

// // // //   void setTab(int index) {
// // // //     setState(() {
// // // //       _currentIndex = index;
// // // //     });
// // // //   }

// // // //   void _expandMiniPlayer() {
// // // //     _miniplayerController.animateToHeight(state: PanelState.MAX);
// // // //     setState(() {
// // // //       _currentPanelState = PanelState.MAX;
// // // //     });
// // // //   }

// // // //   void _minimizeMiniPlayer() {
// // // //     _miniplayerController.animateToHeight(state: PanelState.MIN);
// // // //     setState(() {
// // // //       _currentPanelState = PanelState.MIN;
// // // //       currentHeight = 70;
// // // //     });
// // // //   }

// // // //   void _closeMiniPlayer() {
// // // //     final musicPlayer = getCurrentMusicPlayer(ref);
// // // //     musicPlayer?.stop();
// // // //     ref.read(currentMusicProvider.notifier).stop();
// // // //     _miniplayerController.animateToHeight(state: PanelState.MIN);
// // // //     setState(() {
// // // //       _currentPanelState = PanelState.MIN;
// // // //       currentHeight = 70;
// // // //     });
// // // //   }

// // // //   final List<Widget> _screens = const [
// // // //     HomeScreen("", ""),
// // // //     SearchScreen(false),
// // // //     LibraryScreen(),
// // // //   ];

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _miniplayerController.addListener(() {});
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _miniplayerController.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final currentMusicState = ref.watch(currentMusicProvider);

// // // //     return WillPopScope(
// // // //       onWillPop: () async {
// // // //         if (_currentPanelState == PanelState.MAX) {
// // // //           _minimizeMiniPlayer();
// // // //           return false;
// // // //         } else if (_currentPanelState == PanelState.MIN &&
// // // //             currentMusicState.isPlaying) {
// // // //           return true;
// // // //         }

// // // //         return true;
// // // //       },
// // // //       child: Scaffold(
// // // //         key: bottomSheetKey,
// // // //         body: Stack(
// // // //           children: [
// // // //             IndexedStack(index: _currentIndex, children: _screens),
// // // //             if (currentMusicState.isPlaying &&
// // // //                 currentMusicState.currentSong != null)
// // // //               Positioned(
// // // //                 bottom: 1,
// // // //                 left: 0,
// // // //                 right: 0,
// // // //                 child: _buildMiniPlayer(currentMusicState),
// // // //               ),
// // // //           ],
// // // //         ),
// // // //         bottomNavigationBar: CustomBottomBar(
// // // //           currentIndex: _currentIndex,
// // // //           onTap: (index) {
// // // //             setState(() {
// // // //               _currentIndex = index;
// // // //             });
// // // //           },
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildMiniPlayer(CurrentMusicState musicState) {
// // // //     return ClipRRect(
// // // //       borderRadius: BorderRadius.circular(16.r),
// // // //       child: BackdropFilter(
// // // //         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
// // // //         child: Container(
// // // //           decoration: BoxDecoration(
// // // //             color: Color(AppColors.primaryColor).withOpacity(0.8),
// // // //             borderRadius: BorderRadius.circular(16.r),
// // // //           ),
// // // //           child: Miniplayer(
// // // //             backgroundColor: Colors.transparent,
// // // //             controller: _miniplayerController,
// // // //             minHeight: 70,
// // // //             maxHeight: MediaQuery.of(context).size.height,
// // // //             onDismissed: () {
// // // //               _closeMiniPlayer();
// // // //             },
// // // //             builder: (height, percentage) {
// // // //               currentHeight = height;

// // // //               if (height <= 70) {
// // // //                 _currentPanelState = PanelState.MIN;
// // // //                 return _buildCollapsedMiniPlayer(musicState);
// // // //               } else {
// // // //                 _currentPanelState = PanelState.MAX;
// // // //                 return MusicPlayer(
// // // //                   songList: musicState.playlist,
// // // //                   initialIndex: musicState.currentIndex,
// // // //                   onMinimize: _minimizeMiniPlayer,
// // // //                 );
// // // //               }
// // // //             },
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildCollapsedMiniPlayer(CurrentMusicState musicState) {
// // // //     final musicPlayer = getCurrentMusicPlayer(ref);

// // // //     return GestureDetector(
// // // //       onTap: _expandMiniPlayer,
// // // //       onVerticalDragUpdate: (details) {
// // // //         if (details.delta.dy > 5) {}
// // // //       },
// // // //       onVerticalDragEnd: (details) {
// // // //         if (details.velocity.pixelsPerSecond.dy > 100) {
// // // //           _closeMiniPlayer();
// // // //         }
// // // //       },
// // // //       child: ClipRRect(
// // // //         borderRadius: BorderRadius.circular(16.r),
// // // //         child: BackdropFilter(
// // // //           filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
// // // //           child: Container(
// // // //             decoration: BoxDecoration(
// // // //               gradient: LinearGradient(
// // // //                 begin: Alignment.topLeft,
// // // //                 end: Alignment.bottomRight,
// // // //                 colors: [
// // // //                   Color.fromARGB(255, 14, 128, 145),
// // // //                   Color.fromARGB(255, 8, 162, 182),
// // // //                   Color.fromARGB(255, 14, 128, 145),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //             padding: const EdgeInsets.symmetric(horizontal: 16),
// // // //             child: Row(
// // // //               children: [
// // // //                 ClipRRect(
// // // //                   borderRadius: BorderRadius.circular(8),
// // // //                   child: Image.network(
// // // //                     musicState.currentSong!.image ?? "",
// // // //                     width: 40,
// // // //                     height: 40,
// // // //                     fit: BoxFit.cover,
// // // //                     errorBuilder:
// // // //                         (_, __, ___) => const Icon(
// // // //                           Icons.music_note,
// // // //                           color: Colors.white,
// // // //                           size: 40,
// // // //                         ),
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(width: 12),
// // // //                 Expanded(
// // // //                   child: Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     mainAxisAlignment: MainAxisAlignment.center,
// // // //                     children: [
// // // //                       Text(
// // // //                         musicState.currentSong!.name ?? "Unknown",
// // // //                         style: const TextStyle(
// // // //                           color: Colors.white,
// // // //                           fontWeight: FontWeight.bold,
// // // //                         ),
// // // //                         overflow: TextOverflow.ellipsis,
// // // //                         maxLines: 1,
// // // //                       ),
// // // //                       Text(
// // // //                         musicState.currentSong!.artistName ?? "Unknown Artist",
// // // //                         style: const TextStyle(
// // // //                           color: Colors.white70,
// // // //                           fontSize: 12,
// // // //                         ),
// // // //                         overflow: TextOverflow.ellipsis,
// // // //                         maxLines: 1,
// // // //                       ),
// // // //                       if (musicPlayer != null)
// // // //                         StreamBuilder<Duration>(
// // // //                           stream: musicPlayer.positionStream,
// // // //                           builder: (context, snapshot) {
// // // //                             final position = snapshot.data ?? Duration.zero;
// // // //                             final duration =
// // // //                                 musicState.currentSong?.duration != null
// // // //                                     ? Duration(
// // // //                                       seconds:
// // // //                                           musicState.currentSong!.duration!,
// // // //                                     )
// // // //                                     : Duration.zero;

// // // //                             return Column(
// // // //                               children: [
// // // //                                 SizedBox(
// // // //                                   width: double.infinity,
// // // //                                   child: SliderTheme(
// // // //                                     data: SliderTheme.of(context).copyWith(
// // // //                                       thumbShape: SliderComponentShape.noThumb,
// // // //                                       overlayShape:
// // // //                                           SliderComponentShape.noOverlay,
// // // //                                     ),
// // // //                                     child: Slider(
// // // //                                       year2023: true,
// // // //                                       mouseCursor: MouseCursor.defer,
// // // //                                       thumbColor: Color(AppColors.blueLight),

// // // //                                       min: 0,
// // // //                                       max: duration.inSeconds.toDouble(),
// // // //                                       value:
// // // //                                           position.inSeconds
// // // //                                               .clamp(0, duration.inSeconds)
// // // //                                               .toDouble(),
// // // //                                       onChanged: (value) {
// // // //                                         musicPlayer.seek(value);
// // // //                                       },
// // // //                                       padding: EdgeInsets.only(
// // // //                                         top: 12.h,
// // // //                                         right: 4.w,
// // // //                                         left: 4.w,
// // // //                                         bottom: 4.h,
// // // //                                       ),
// // // //                                       activeColor: Color.fromARGB(
// // // //                                         255,
// // // //                                         2,
// // // //                                         71,
// // // //                                         100,
// // // //                                       ),
// // // //                                       inactiveColor: Color(
// // // //                                         AppColors.blueExtraLight,
// // // //                                       ),
// // // //                                     ),
// // // //                                   ),
// // // //                                 ),
// // // //                                 Padding(
// // // //                                   padding: EdgeInsets.symmetric(
// // // //                                     horizontal: 8.w,
// // // //                                     vertical: 6.h,
// // // //                                   ),
// // // //                                   child: Row(
// // // //                                     mainAxisAlignment:
// // // //                                         MainAxisAlignment.spaceBetween,
// // // //                                     children: [
// // // //                                       AppText(
// // // //                                         text: musicPlayer.formatDuration(
// // // //                                           position,
// // // //                                         ),
// // // //                                         textColor: Colors.white70,
// // // //                                       ),
// // // //                                       AppText(
// // // //                                         text: musicPlayer.formatDuration(
// // // //                                           duration,
// // // //                                         ),
// // // //                                         textColor: Colors.white70,
// // // //                                       ),
// // // //                                     ],
// // // //                                   ),
// // // //                                 ),
// // // //                               ],
// // // //                             );
// // // //                           },
// // // //                         ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //                 _buildPlayPauseButton(musicState),
// // // //                 IconButton(
// // // //                   icon: const Icon(Icons.close, color: Colors.white),
// // // //                   onPressed: _closeMiniPlayer,
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildPlayPauseButton(CurrentMusicState musicState) {
// // // //     final musicPlayer = getCurrentMusicPlayer(ref);

// // // //     return StreamBuilder<PlayerState>(
// // // //       stream: musicPlayer?.playerStateStream ?? Stream.empty(),
// // // //       builder: (context, snapshot) {
// // // //         final isPlaying = snapshot.data?.playing ?? false;
// // // //         return IconButton(
// // // //           icon: Icon(
// // // //             isPlaying ? Icons.pause : Icons.play_arrow,
// // // //             color: Colors.white,
// // // //           ),
// // // //           onPressed: () {
// // // //             musicPlayer?.playPause();
// // // //           },
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // // }

// // // import 'dart:math';
// // // import 'dart:ui';

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // import 'package:just_audio/just_audio.dart';
// // // import 'package:lyrica/common/utils/utils.dart';
// // // import 'package:lyrica/common/widget/app_text.dart';
// // // import 'package:lyrica/core/constant/app_colors.dart';
// // // import 'package:lyrica/main.dart';
// // // import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
// // // import 'package:lyrica/modules/home/view/home_screen.dart';
// // // import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// // // import 'package:lyrica/modules/music%20player/view/music_player.dart';
// // // import 'package:lyrica/modules/search%20items/view/search_screen.dart';
// // // import 'package:lyrica/modules/library/view/library_screen.dart';
// // // import 'package:miniplayer/miniplayer.dart';

// // // final GlobalKey<_BottomSheetScreenState> bottomSheetKey = GlobalKey();

// // // class BottomSheetScreen extends ConsumerStatefulWidget {
// // //   const BottomSheetScreen({super.key});

// // //   static void expandMiniPlayer() {
// // //     final state = bottomSheetKey.currentState;
// // //     state?._expandMiniPlayer();
// // //   }

// // //   @override
// // //   ConsumerState<BottomSheetScreen> createState() => _BottomSheetScreenState();
// // // }

// // // class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen>
// // //     with SingleTickerProviderStateMixin {
// // //   int _currentIndex = 0;
// // //   final MiniplayerController _miniplayerController = MiniplayerController();
// // //   double currentHeight = 70;
// // //   PanelState _currentPanelState = PanelState.MIN;
// // //   bool isAnimating = false;
// // //   late AnimationController _waveController;

// // //   void setTab(int index) {
// // //     setState(() {
// // //       _currentIndex = index;
// // //     });
// // //   }

// // //   void _expandMiniPlayer() {
// // //     _miniplayerController.animateToHeight(state: PanelState.MAX);
// // //     setState(() {
// // //       _currentPanelState = PanelState.MAX;
// // //     });
// // //   }

// // //   void _minimizeMiniPlayer() {
// // //     _miniplayerController.animateToHeight(state: PanelState.MIN);
// // //     setState(() {
// // //       _currentPanelState = PanelState.MIN;
// // //       currentHeight = 70;
// // //     });
// // //   }

// // //   void _closeMiniPlayer() {
// // //     final musicPlayer = getCurrentMusicPlayer(ref);
// // //     musicPlayer?.stop();
// // //     ref.read(currentMusicProvider.notifier).stop();
// // //     _miniplayerController.animateToHeight(state: PanelState.MIN);
// // //     setState(() {
// // //       _currentPanelState = PanelState.MIN;
// // //       currentHeight = 70;
// // //     });
// // //   }

// // //   final List<Widget> _screens = [
// // //     HomeScreen("", ""),
// // //     SearchScreen(false),
// // //     LibraryScreen(),
// // //   ];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _miniplayerController.addListener(() {});

// // //     // Initialize wave animation controller
// // //     _waveController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(seconds: 2),
// // //     )..repeat();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _miniplayerController.dispose();
// // //     _waveController.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final currentMusicState = ref.watch(currentMusicProvider);

// // //     return WillPopScope(
// // //       onWillPop: () async {
// // //         if (_currentPanelState == PanelState.MAX) {
// // //           _minimizeMiniPlayer();
// // //           return false;
// // //         } else if (_currentPanelState == PanelState.MIN &&
// // //             currentMusicState.isPlaying) {
// // //           return false;
// // //         }

// // //         return true;
// // //       },
// // //       child: Scaffold(
// // //         key: bottomSheetKey,
// // //         body: Stack(
// // //           children: [
// // //             IndexedStack(index: _currentIndex, children: _screens),
// // //             if (currentMusicState.isPlaying &&
// // //                 currentMusicState.currentSong != null)
// // //               Positioned(
// // //                 bottom: 1,
// // //                 left: 0,
// // //                 right: 0,
// // //                 child: _buildMiniPlayer(currentMusicState),
// // //               ),
// // //           ],
// // //         ),
// // //         bottomNavigationBar: CustomBottomBar(
// // //           currentIndex: _currentIndex,
// // //           onTap: (index) {
// // //             setState(() {
// // //               _currentIndex = index;
// // //             });
// // //           },
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildMiniPlayer(CurrentMusicState musicState) {
// // //     final musicPlayer = getCurrentMusicPlayer(ref);

// // //     return ClipRRect(
// // //       borderRadius: BorderRadius.circular(16.r),
// // //       child: BackdropFilter(
// // //         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
// // //         child: Container(
// // //           decoration: BoxDecoration(
// // //             color: Color(AppColors.primaryColor).withOpacity(0.8),
// // //             borderRadius: BorderRadius.circular(16.r),
// // //           ),
// // //           child: Miniplayer(
// // //             backgroundColor: Colors.transparent,
// // //             controller: _miniplayerController,
// // //             minHeight: 80,
// // //             maxHeight: MediaQuery.of(context).size.height,
// // //             onDismissed: () {
// // //               _closeMiniPlayer();
// // //             },
// // //             builder: (height, percentage) {
// // //               currentHeight = height;

// // //               if (height <= 80) {
// // //                 _currentPanelState = PanelState.MIN;
// // //                 return _buildCollapsedMiniPlayer(musicState);
// // //               } else {
// // //                 _currentPanelState = PanelState.MAX;
// // //                 if (musicPlayer != null) {
// // //                   return MusicPlayer(
// // //                     songList: musicState.playlist,
// // //                     initialIndex: musicState.currentIndex,
// // //                     onMinimize: _minimizeMiniPlayer,
// // //                   );
// // //                 } else {
// // //                   return MusicPlayer(
// // //                     songList: musicState.playlist,
// // //                     initialIndex: musicState.currentIndex,
// // //                     onMinimize: _minimizeMiniPlayer,
// // //                   );
// // //                 }
// // //               }
// // //             },
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildCollapsedMiniPlayer(CurrentMusicState musicState) {
// // //     final musicPlayer = getCurrentMusicPlayer(ref);

// // //     return GestureDetector(
// // //       onTap: _expandMiniPlayer,
// // //       onVerticalDragEnd: (details) {
// // //         if (details.velocity.pixelsPerSecond.dy > 100) {
// // //           _closeMiniPlayer();
// // //         }
// // //       },
// // //       child: ClipRRect(
// // //         borderRadius: BorderRadius.circular(16.r),
// // //         child: Stack(
// // //           children: [
// // //             AnimatedBuilder(
// // //               animation: _waveController,
// // //               builder: (context, child) {
// // //                 return CustomPaint(
// // //                   size: Size(double.infinity, 80),
// // //                   painter: WaveBackgroundPainter(
// // //                     waveValue: _waveController.value,
// // //                     waveColor: const Color.fromARGB(
// // //                       255,
// // //                       2,
// // //                       71,
// // //                       100,
// // //                     ).withOpacity(0.7),
// // //                     backgroundColor: Colors.black.withOpacity(0.2),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //             Padding(
// // //               padding: const EdgeInsets.all(8.0),
// // //               child: Row(
// // //                 children: [
// // //                   ClipRRect(
// // //                     borderRadius: BorderRadius.circular(8),
// // //                     child: Image.network(
// // //                       musicState.currentSong!.image ?? "",
// // //                       width: 40,
// // //                       height: 40,
// // //                       fit: BoxFit.cover,
// // //                       errorBuilder:
// // //                           (_, __, ___) => const Icon(
// // //                             Icons.music_note,
// // //                             color: Colors.white,
// // //                             size: 40,
// // //                           ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 12),
// // //                   Expanded(
// // //                     child: BackdropFilter(
// // //                       filter: ImageFilter.blur(),
// // //                       child: Column(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         children: [
// // //                           SizedBox(height: 6.h),
// // //                           Text(
// // //                             musicState.currentSong!.name ?? "Unknown",
// // //                             style: const TextStyle(
// // //                               color: Colors.white,
// // //                               fontWeight: FontWeight.bold,
// // //                             ),
// // //                             overflow: TextOverflow.ellipsis,
// // //                             maxLines: 1,
// // //                           ),
// // //                           Text(
// // //                             musicState.currentSong!.artistName ??
// // //                                 "Unknown Artist",
// // //                             style: const TextStyle(
// // //                               color: Colors.white70,
// // //                               fontSize: 12,
// // //                             ),
// // //                             overflow: TextOverflow.ellipsis,
// // //                             maxLines: 1,
// // //                           ),
// // //                           SizedBox(height: 6.h),

// // //                           if (musicPlayer != null)
// // //                             StreamBuilder<PlayerState>(
// // //                               stream: musicPlayer.playerStateStream,
// // //                               builder: (context, snapshot) {
// // //                                 final position = snapshot.data ?? Duration.zero;
// // //                                 final duration =
// // //                                     musicState.currentSong?.duration != null
// // //                                         ? Duration(
// // //                                           seconds:
// // //                                               musicState.currentSong!.duration!,
// // //                                         )
// // //                                         : Duration.zero;
// // //                                 final playerState = snapshot.data;
// // //                                 final isPlaying = playerState?.playing ?? false;
// // //                                 final processingState =
// // //                                     playerState?.processingState;
// // //                                 return Column(
// // //                                   children: [
// // //                                     SliderTheme(
// // //                                       data: SliderTheme.of(context).copyWith(
// // //                                         thumbShape:
// // //                                             SliderComponentShape.noThumb,
// // //                                         overlayShape:
// // //                                             SliderComponentShape.noOverlay,
// // //                                       ),
// // //                                       child: StreamBuilder<Duration>(
// // //                                         stream: musicPlayer.positionStream,
// // //                                         builder: (context, positionSnapshot) {
// // //                                           final position =
// // //                                               positionSnapshot.data ??
// // //                                               Duration.zero;
// // //                                           final duration =
// // //                                               musicState
// // //                                                           .currentSong
// // //                                                           ?.duration !=
// // //                                                       null
// // //                                                   ? Duration(
// // //                                                     seconds:
// // //                                                         musicState
// // //                                                             .currentSong!
// // //                                                             .duration!,
// // //                                                   )
// // //                                                   : Duration.zero;

// // //                                           return Slider(
// // //                                             min: 0,
// // //                                             max: duration.inSeconds.toDouble(),
// // //                                             value:
// // //                                                 position.inSeconds
// // //                                                     .clamp(
// // //                                                       0,
// // //                                                       duration.inSeconds,
// // //                                                     )
// // //                                                     .toDouble(),
// // //                                             onChanged: (value) {
// // //                                               musicPlayer.seek(
// // //                                                 Duration(seconds: value.toInt())
// // //                                                     as double,
// // //                                               );
// // //                                             },
// // //                                             activeColor: Color.fromARGB(
// // //                                               255,
// // //                                               2,
// // //                                               71,
// // //                                               100,
// // //                                             ),
// // //                                             inactiveColor: Color(
// // //                                               AppColors.blueExtraLight,
// // //                                             ),
// // //                                           );
// // //                                         },
// // //                                       ),

// // //                                       // Slider(
// // //                                       //   year2023: true,
// // //                                       //   mouseCursor: MouseCursor.defer,
// // //                                       //   thumbColor: Color(AppColors.blueLight),

// // //                                       //   min: 0,
// // //                                       //   max: duration.inSeconds.toDouble(),
// // //                                       //   value:
// // //                                       //       position.inSeconds
// // //                                       //           .clamp(0, duration.inSeconds)
// // //                                       //           .toDouble(),
// // //                                       //   onChanged: (value) {
// // //                                       //     musicPlayer.seek(value);
// // //                                       //   },
// // //                                       //   padding: EdgeInsets.only(
// // //                                       //     top: 12.h,
// // //                                       //     right: 4.w,
// // //                                       //     left: 4.w,
// // //                                       //     bottom: 4.h,
// // //                                       //   ),
// // //                                       //   activeColor: Color.fromARGB(
// // //                                       //     255,
// // //                                       //     2,
// // //                                       //     71,
// // //                                       //     100,
// // //                                       //   ),
// // //                                       //   inactiveColor: Color(
// // //                                       //     AppColors.blueExtraLight,
// // //                                       //   ),
// // //                                       // ),
// // //                                     ),
// // //                                     // Padding(
// // //                                     //   padding: EdgeInsets.symmetric(
// // //                                     //     horizontal: 0.w,
// // //                                     //     vertical: 0.h,
// // //                                     //   ),
// // //                                     //   child: Row(
// // //                                     //     mainAxisAlignment:
// // //                                     //         MainAxisAlignment.spaceBetween,
// // //                                     //     children: [
// // //                                     //       AppText(
// // //                                     //         text: musicPlayer.formatDuration(
// // //                                     //           position,
// // //                                     //         ),
// // //                                     //         textColor: Colors.white70,
// // //                                     //       ),
// // //                                     //       AppText(
// // //                                     //         text: musicPlayer.formatDuration(
// // //                                     //           duration,
// // //                                     //         ),
// // //                                     //         textColor: Colors.white70,
// // //                                     //       ),
// // //                                     //     ],
// // //                                     //   ),
// // //                                     // ),
// // //                                   ],
// // //                                 );
// // //                               },
// // //                             ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   _buildPlayPauseButton(musicState),
// // //                   IconButton(
// // //                     icon: const Icon(Icons.close, color: Colors.white),
// // //                     onPressed: _closeMiniPlayer,
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildPlayPauseButton(CurrentMusicState musicState) {
// // //     final musicPlayer = getCurrentMusicPlayer(ref);

// // //     return StreamBuilder<PlayerState>(
// // //       stream: musicPlayer?.playerStateStream ?? Stream.empty(),
// // //       builder: (context, snapshot) {
// // //         final isPlaying = snapshot.data?.playing ?? false;
// // //         return IconButton(
// // //           icon: Icon(
// // //             isPlaying ? Icons.pause : Icons.play_arrow,
// // //             color: Colors.white,
// // //           ),
// // //           onPressed: () {
// // //             musicPlayer?.playPause();
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // // class WaveBackgroundPainter extends CustomPainter {
// // //   final double waveValue;
// // //   final Color waveColor;
// // //   final Color backgroundColor;

// // //   WaveBackgroundPainter({
// // //     required this.waveValue,
// // //     required this.waveColor,
// // //     required this.backgroundColor,
// // //   });

// // //   @override
// // //   void paint(Canvas canvas, Size size) {
// // //     final width = size.width;
// // //     final height = size.height;

// // //     final bgPaint = Paint()..color = backgroundColor;
// // //     canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

// // //     final wavePaint =
// // //         Paint()
// // //           ..color = waveColor
// // //           ..style = PaintingStyle.fill;

// // //     final path = Path();
// // //     final waveHeight = 2.0;
// // //     final baseLine = height / 3;

// // //     path.moveTo(0, baseLine);

// // //     for (double i = 0; i <= width; i++) {
// // //       final y = baseLine - sin((i / 20) + waveValue * 2 * pi) * waveHeight;
// // //       path.lineTo(i, y);
// // //     }

// // //     path.lineTo(width, height);
// // //     path.lineTo(0, height);
// // //     path.close();

// // //     canvas.drawPath(path, wavePaint);
// // //   }

// // //   @override
// // //   bool shouldRepaint(covariant WaveBackgroundPainter oldDelegate) {
// // //     return oldDelegate.waveValue != waveValue ||
// // //         oldDelegate.waveColor != waveColor ||
// // //         oldDelegate.backgroundColor != backgroundColor;
// // //   }
// // // }

// // // class WaveProgressPainter extends CustomPainter {
// // //   final double progress;
// // //   final double waveValue;
// // //   final Color waveColor;
// // //   final Color backgroundColor;

// // //   WaveProgressPainter({
// // //     required this.progress,
// // //     required this.waveValue,
// // //     required this.waveColor,
// // //     required this.backgroundColor,
// // //   });

// // //   @override
// // //   void paint(Canvas canvas, Size size) {
// // //     final width = size.width;
// // //     final height = size.height;
// // //     final progressWidth = width * progress;

// // //     final backgroundPaint = Paint()..color = backgroundColor;
// // //     canvas.drawRect(Rect.fromLTWH(0, 0, width, height), backgroundPaint);

// // //     final wavePaint =
// // //         Paint()
// // //           ..color = waveColor
// // //           ..style = PaintingStyle.fill;

// // //     final path = Path();
// // //     final waveHeight = 4.0;
// // //     final baseLine = height - 8;

// // //     path.moveTo(0, baseLine);

// // //     for (double i = 0; i < progressWidth; i++) {
// // //       final y = baseLine - sin((i / 20) + waveValue * 2 * pi) * waveHeight;
// // //       path.lineTo(i, y);
// // //     }

// // //     path.lineTo(progressWidth, height);
// // //     path.lineTo(0, height);
// // //     path.close();

// // //     canvas.drawPath(path, wavePaint);
// // //   }

// // //   @override
// // //   bool shouldRepaint(covariant WaveProgressPainter oldDelegate) {
// // //     return oldDelegate.progress != progress ||
// // //         oldDelegate.waveValue != waveValue ||
// // //         oldDelegate.waveColor != waveColor ||
// // //         oldDelegate.backgroundColor != backgroundColor;
// // //   }
// // // }

// // import 'dart:math';
// // import 'dart:ui';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:lyrica/core/constant/app_colors.dart';
// // import 'package:lyrica/main.dart';
// // import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
// // import 'package:lyrica/modules/home/view/home_screen.dart';
// // import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// // import 'package:lyrica/modules/music%20player/view/music_player.dart';
// // import 'package:lyrica/modules/search%20items/view/search_screen.dart';
// // import 'package:lyrica/modules/library/view/library_screen.dart';
// // import 'package:miniplayer/miniplayer.dart';

// // final GlobalKey<_BottomSheetScreenState> bottomSheetKey = GlobalKey();

// // class BottomSheetScreen extends ConsumerStatefulWidget {
// //   const BottomSheetScreen({super.key});

// //   static void expandMiniPlayer() {
// //     final state = bottomSheetKey.currentState;
// //     state?._expandMiniPlayer();
// //   }

// //   @override
// //   ConsumerState<BottomSheetScreen> createState() => _BottomSheetScreenState();
// // }

// // class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen>
// //     with SingleTickerProviderStateMixin {
// //   int _currentIndex = 0;
// //   final MiniplayerController _miniplayerController = MiniplayerController();
// //   double currentHeight = 70;
// //   PanelState _currentPanelState = PanelState.MIN;
// //   bool isAnimating = false;
// //   late AnimationController _waveController;

// //   void setTab(int index) {
// //     setState(() {
// //       _currentIndex = index;
// //     });
// //   }

// //   void _expandMiniPlayer() {
// //     _miniplayerController.animateToHeight(state: PanelState.MAX);
// //     setState(() {
// //       _currentPanelState = PanelState.MAX;
// //     });
// //   }

// //   void _minimizeMiniPlayer() {
// //     _miniplayerController.animateToHeight(state: PanelState.MIN);
// //     setState(() {
// //       _currentPanelState = PanelState.MIN;
// //       currentHeight = 70;
// //     });
// //   }

// //   void _closeMiniPlayer() {
// //     final musicPlayer = getCurrentMusicPlayer(ref);
// //     musicPlayer?.stop();
// //     ref.read(currentMusicProvider.notifier).stop();
// //     _miniplayerController.animateToHeight(state: PanelState.MIN);
// //     setState(() {
// //       _currentPanelState = PanelState.MIN;
// //       currentHeight = 70;
// //     });
// //   }

// //   final List<Widget> _screens = [
// //     HomeScreen("", ""),
// //     SearchScreen(false),
// //     LibraryScreen(),
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _miniplayerController.addListener(() {});

// //     // Initialize wave animation controller
// //     _waveController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 2),
// //     )..repeat();
// //   }

// //   @override
// //   void dispose() {
// //     _miniplayerController.dispose();
// //     _waveController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final currentMusicState = ref.watch(currentMusicProvider);

// //     return WillPopScope(
// //       onWillPop: () async {
// //         if (_currentPanelState == PanelState.MAX) {
// //           _minimizeMiniPlayer();
// //           return false;
// //         } else if (_currentPanelState == PanelState.MIN &&
// //             currentMusicState.isPlaying) {
// //           return false;
// //         }

// //         return true;
// //       },
// //       child: Scaffold(
// //         key: bottomSheetKey,
// //         body: Stack(
// //           children: [
// //             IndexedStack(index: _currentIndex, children: _screens),
// //             if (currentMusicState.isPlaying &&
// //                 currentMusicState.currentSong != null)
// //               Positioned(
// //                 bottom: 1,
// //                 left: 0,
// //                 right: 0,
// //                 child: _buildMiniPlayer(currentMusicState),
// //               ),
// //           ],
// //         ),
// //         bottomNavigationBar: CustomBottomBar(
// //           currentIndex: _currentIndex,
// //           onTap: (index) {
// //             setState(() {
// //               _currentIndex = index;
// //             });
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMiniPlayer(CurrentMusicState musicState) {
// //     final musicPlayer = getCurrentMusicPlayer(ref);

// //     return ClipRRect(
// //       borderRadius: BorderRadius.circular(16.r),
// //       child: BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
// //         child: Container(
// //           decoration: BoxDecoration(
// //             color: Color(AppColors.primaryColor).withOpacity(0.8),
// //             borderRadius: BorderRadius.circular(16.r),
// //           ),
// //           child: Miniplayer(
// //             backgroundColor: Colors.transparent,
// //             controller: _miniplayerController,
// //             minHeight: 80,
// //             maxHeight: MediaQuery.of(context).size.height,
// //             onDismissed: () {
// //               _closeMiniPlayer();
// //             },
// //             builder: (height, percentage) {
// //               currentHeight = height;

// //               if (height <= 80) {
// //                 _currentPanelState = PanelState.MIN;
// //                 return _buildCollapsedMiniPlayer(musicState);
// //               } else {
// //                 _currentPanelState = PanelState.MAX;
// //                 if (musicPlayer != null) {
// //                   return MusicPlayer(
// //                     songList: musicState.playlist,
// //                     initialIndex: musicState.currentIndex,
// //                     onMinimize: _minimizeMiniPlayer,
// //                   );
// //                 } else {
// //                   return MusicPlayer(
// //                     songList: musicState.playlist,
// //                     initialIndex: musicState.currentIndex,
// //                     onMinimize: _minimizeMiniPlayer,
// //                   );
// //                 }
// //               }
// //             },
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildCollapsedMiniPlayer(CurrentMusicState musicState) {
// //     final musicPlayer = getCurrentMusicPlayer(ref);

// //     return GestureDetector(
// //       onTap: _expandMiniPlayer,
// //       onVerticalDragEnd: (details) {
// //         if (details.velocity.pixelsPerSecond.dy > 100) {
// //           _closeMiniPlayer();
// //         }
// //       },
// //       child: ClipRRect(
// //         borderRadius: BorderRadius.circular(16.r),
// //         child: Stack(
// //           children: [
// //             // Wave background progress
// //             StreamBuilder<Duration>(
// //               stream: musicPlayer?.positionStream ?? Stream.empty(),
// //               builder: (context, snapshot) {
// //                 final position = snapshot.data ?? Duration.zero;
// //                 final duration =
// //                     musicState.currentSong?.duration != null
// //                         ? Duration(seconds: musicState.currentSong!.duration!)
// //                         : Duration.zero;

// //                 double progress = 0.0;
// //                 if (duration.inSeconds > 0) {
// //                   progress = position.inSeconds / duration.inSeconds;
// //                 }

// //                 return AnimatedBuilder(
// //                   animation: _waveController,
// //                   builder: (context, child) {
// //                     return CustomPaint(
// //                       size: const Size(double.infinity, 80),
// //                       painter: WaveBackgroundPainter(
// //                         waveValue: _waveController.value,
// //                         progress: progress,
// //                         waveColor: const Color.fromARGB(
// //                           255,
// //                           2,
// //                           71,
// //                           100,
// //                         ).withOpacity(0.7),
// //                         backgroundColor: Colors.black.withOpacity(0.2),
// //                       ),
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //               child: Row(
// //                 children: [
// //                   // Song thumbnail
// //                   ClipRRect(
// //                     borderRadius: BorderRadius.circular(8),
// //                     child: Image.network(
// //                       musicState.currentSong!.image ?? "",
// //                       width: 50,
// //                       height: 50,
// //                       fit: BoxFit.cover,
// //                       errorBuilder:
// //                           (_, __, ___) => const Icon(
// //                             Icons.music_note,
// //                             color: Colors.white,
// //                             size: 40,
// //                           ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   // Song info + progress bar
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Text(
// //                           musicState.currentSong!.name ?? "Unknown",
// //                           style: const TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                           overflow: TextOverflow.ellipsis,
// //                           maxLines: 1,
// //                         ),
// //                         Text(
// //                           musicState.currentSong!.artistName ??
// //                               "Unknown Artist",
// //                           style: const TextStyle(
// //                             color: Colors.white70,
// //                             fontSize: 12,
// //                           ),
// //                           overflow: TextOverflow.ellipsis,
// //                           maxLines: 1,
// //                         ),
// //                         const SizedBox(height: 6),
// //                         if (musicPlayer != null)
// //                           StreamBuilder<Duration>(
// //                             stream: musicPlayer.positionStream,
// //                             builder: (context, snapshot) {
// //                               final position = snapshot.data ?? Duration.zero;
// //                               final duration =
// //                                   musicState.currentSong?.duration != null
// //                                       ? Duration(
// //                                         seconds:
// //                                             musicState.currentSong!.duration!,
// //                                       )
// //                                       : Duration.zero;

// //                               return SliderTheme(
// //                                 data: SliderTheme.of(context).copyWith(
// //                                   trackHeight: 2,
// //                                   thumbShape: const RoundSliderThumbShape(
// //                                     enabledThumbRadius: 6,
// //                                   ),
// //                                   overlayShape: SliderComponentShape.noOverlay,
// //                                 ),
// //                                 child: Slider(
// //                                   value: position.inSeconds.toDouble().clamp(
// //                                     0.0,
// //                                     duration.inSeconds.toDouble(),
// //                                   ),
// //                                   max: duration.inSeconds.toDouble(),
// //                                   activeColor: Colors.white,
// //                                   inactiveColor: Colors.white24,
// //                                   onChanged: (value) {
// //                                     musicPlayer.seek(value);
// //                                   },
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                       ],
// //                     ),
// //                   ),
// //                   // Play / Pause button
// //                   if (musicPlayer != null)
// //                     StreamBuilder<PlayerState>(
// //                       stream: musicPlayer.playerStateStream,
// //                       builder: (context, snapshot) {
// //                         final isPlaying = snapshot.data?.playing ?? false;
// //                         return IconButton(
// //                           icon: Icon(
// //                             isPlaying
// //                                 ? Icons.pause_circle_filled
// //                                 : Icons.play_circle_filled,
// //                             size: 36,
// //                             color: Colors.white,
// //                           ),
// //                           onPressed: () => musicPlayer.playPause(),
// //                         );
// //                       },
// //                     ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPlayPauseButton(CurrentMusicState musicState) {
// //     final musicPlayer = getCurrentMusicPlayer(ref);

// //     return StreamBuilder<PlayerState>(
// //       stream: musicPlayer?.playerStateStream ?? Stream.empty(),
// //       builder: (context, snapshot) {
// //         final isPlaying = snapshot.data?.playing ?? false;
// //         return IconButton(
// //           icon: Icon(
// //             isPlaying ? Icons.pause : Icons.play_arrow,
// //             color: Colors.white,
// //           ),
// //           onPressed: () {
// //             musicPlayer?.playPause();
// //           },
// //         );
// //       },
// //     );
// //   }
// // }

// // class WaveBackgroundPainter extends CustomPainter {
// //   final double waveValue;
// //   final double progress;
// //   final Color waveColor;
// //   final Color backgroundColor;

// //   WaveBackgroundPainter({
// //     required this.waveValue,
// //     required this.progress,
// //     required this.waveColor,
// //     required this.backgroundColor,
// //   });

// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final width = size.width;
// //     final height = size.height;

// //     final bgPaint = Paint()..color = backgroundColor;
// //     canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

// //     final wavePaint =
// //         Paint()
// //           ..color = waveColor
// //           ..style = PaintingStyle.fill;

// //     final path = Path();
// //     final waveHeight = 2.0;
// //     final baseLine = height / 3.5; // Base height for the wave

// //     // Calculate the wave position based on music progress
// //     final progressWidth = width * progress;

// //     path.moveTo(0, baseLine);

// //     for (double i = 0; i <= progressWidth; i++) {
// //       final y = baseLine - sin((i / 20) + waveValue * 2 * pi) * waveHeight;
// //       path.lineTo(i, y);
// //     }

// //     path.lineTo(progressWidth, height);
// //     path.lineTo(0, height);
// //     path.close();

// //     canvas.drawPath(path, wavePaint);
// //   }

// //   @override
// //   bool shouldRepaint(covariant WaveBackgroundPainter oldDelegate) {
// //     return oldDelegate.waveValue != waveValue ||
// //         oldDelegate.progress != progress ||
// //         oldDelegate.waveColor != waveColor ||
// //         oldDelegate.backgroundColor != backgroundColor;
// //   }
// // }

// import 'dart:math';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/main.dart';
// import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
// import 'package:lyrica/modules/home/view/home_screen.dart';
// import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// import 'package:lyrica/modules/music%20player/view/music_player.dart';
// import 'package:lyrica/modules/search%20items/view/search_screen.dart';
// import 'package:lyrica/modules/library/view/library_screen.dart';
// import 'package:miniplayer/miniplayer.dart';

// final GlobalKey<_BottomSheetScreenState> bottomSheetKey = GlobalKey();

// class BottomSheetScreen extends ConsumerStatefulWidget {
//   const BottomSheetScreen({super.key});

//   static void expandMiniPlayer() {
//     final state = bottomSheetKey.currentState;
//     state?._expandMiniPlayer();
//   }

//   @override
//   ConsumerState<BottomSheetScreen> createState() => _BottomSheetScreenState();
// }

// class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen>
//     with SingleTickerProviderStateMixin {
//   int _currentIndex = 0;
//   final MiniplayerController _miniplayerController = MiniplayerController();
//   double currentHeight = 70;
//   PanelState _currentPanelState = PanelState.MIN;
//   bool isAnimating = false;
//   late AnimationController _waveController;

//   void setTab(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   void _expandMiniPlayer() {
//     _miniplayerController.animateToHeight(state: PanelState.MAX);
//     setState(() {
//       _currentPanelState = PanelState.MAX;
//     });
//   }

//   void _minimizeMiniPlayer() {
//     _miniplayerController.animateToHeight(state: PanelState.MIN);
//     setState(() {
//       _currentPanelState = PanelState.MIN;
//       currentHeight = 70;
//     });
//   }

//   void _closeMiniPlayer() {
//     final musicPlayer = getCurrentMusicPlayer(ref);
//     musicPlayer?.stop();
//     ref.read(currentMusicProvider.notifier).stop();
//     _miniplayerController.animateToHeight(state: PanelState.MIN);
//     setState(() {
//       _currentPanelState = PanelState.MIN;
//       currentHeight = 70;
//     });
//   }

//   final List<Widget> _screens = [
//     HomeScreen("", ""),
//     SearchScreen(false),
//     LibraryScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _miniplayerController.addListener(() {});

//     // Initialize wave animation controller
//     _waveController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _miniplayerController.dispose();
//     _waveController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentMusicState = ref.watch(currentMusicProvider);

//     return WillPopScope(
//       onWillPop: () async {
//         if (_currentPanelState == PanelState.MAX) {
//           _minimizeMiniPlayer();
//           return false;
//         } else if (_currentPanelState == PanelState.MIN &&
//             currentMusicState.isPlaying) {
//           return false;
//         }

//         return true;
//       },
//       child: Scaffold(
//         key: bottomSheetKey,
//         body: Stack(
//           children: [
//             IndexedStack(index: _currentIndex, children: _screens),
//             if (currentMusicState.isPlaying &&
//                 currentMusicState.currentSong != null)
//               Positioned(
//                 bottom: 1,
//                 left: 0,
//                 right: 0,
//                 child: _buildMiniPlayer(currentMusicState),
//               ),
//           ],
//         ),
//         bottomNavigationBar: CustomBottomBar(
//           currentIndex: _currentIndex,
//           onTap: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildMiniPlayer(CurrentMusicState musicState) {
//     final musicPlayer = getCurrentMusicPlayer(ref);

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(16.r),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Color(AppColors.primaryColor).withOpacity(0.8),
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           child: Miniplayer(
//             backgroundColor: Colors.transparent,
//             controller: _miniplayerController,
//             minHeight: 80,
//             maxHeight: MediaQuery.of(context).size.height,
//             onDismissed: () {
//               _closeMiniPlayer();
//             },
//             builder: (height, percentage) {
//               currentHeight = height;

//               if (height <= 80) {
//                 _currentPanelState = PanelState.MIN;
//                 return _buildCollapsedMiniPlayer(musicState);
//               } else {
//                 _currentPanelState = PanelState.MAX;
//                 if (musicPlayer != null) {
//                   return MusicPlayer(
//                     songList: musicState.playlist,
//                     initialIndex: musicState.currentIndex,
//                     onMinimize: _minimizeMiniPlayer,
//                   );
//                 } else {
//                   return MusicPlayer(
//                     songList: musicState.playlist,
//                     initialIndex: musicState.currentIndex,
//                     onMinimize: _minimizeMiniPlayer,
//                   );
//                 }
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCollapsedMiniPlayer(CurrentMusicState musicState) {
//     final musicPlayer = getCurrentMusicPlayer(ref);

//     return GestureDetector(
//       onTap: _expandMiniPlayer,
//       onVerticalDragEnd: (details) {
//         if (details.velocity.pixelsPerSecond.dy > 100) {
//           _closeMiniPlayer();
//         }
//       },
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16.r),
//         child: Stack(
//           children: [
//             // Wave background progress
//             StreamBuilder<Duration>(
//               stream: musicPlayer?.positionStream ?? Stream.empty(),
//               builder: (context, snapshot) {
//                 final position = snapshot.data ?? Duration.zero;
//                 final duration =
//                     musicState.currentSong?.duration != null
//                         ? Duration(seconds: musicState.currentSong!.duration!)
//                         : Duration.zero;

//                 double progress = 0.0;
//                 if (duration.inSeconds > 0) {
//                   progress = position.inSeconds / duration.inSeconds;
//                 }

//                 return AnimatedBuilder(
//                   animation: _waveController,
//                   builder: (context, child) {
//                     return CustomPaint(
//                       size: const Size(double.infinity, 80),
//                       painter: WaveBackgroundPainter(
//                         waveValue: _waveController.value,
//                         progress: progress,
//                         waveColor: const Color.fromARGB(
//                           255,
//                           2,
//                           71,
//                           100,
//                         ).withOpacity(0.7),
//                         backgroundColor: Colors.black.withOpacity(0.2),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               child: Row(
//                 children: [
//                   // Song thumbnail
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       musicState.currentSong!.image ?? "",
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                       errorBuilder:
//                           (_, __, ___) => const Icon(
//                             Icons.music_note,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // Song info + progress bar
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           musicState.currentSong!.name ?? "Unknown",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                         Text(
//                           musicState.currentSong!.artistName ??
//                               "Unknown Artist",
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 12,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                         const SizedBox(height: 6),
//                         if (musicPlayer != null)
//                           StreamBuilder<Duration>(
//                             stream: musicPlayer.positionStream,
//                             builder: (context, snapshot) {
//                               final position = snapshot.data ?? Duration.zero;
//                               final duration =
//                                   musicState.currentSong?.duration != null
//                                       ? Duration(
//                                         seconds:
//                                             musicState.currentSong!.duration!,
//                                       )
//                                       : Duration.zero;

//                               return SliderTheme(
//                                 data: SliderTheme.of(context).copyWith(
//                                   trackHeight: 2,
//                                   thumbShape: const RoundSliderThumbShape(
//                                     enabledThumbRadius: 6,
//                                   ),
//                                   overlayShape: SliderComponentShape.noOverlay,
//                                 ),
//                                 child: Slider(
//                                   value: position.inSeconds.toDouble().clamp(
//                                     0.0,
//                                     duration.inSeconds.toDouble(),
//                                   ),
//                                   max: duration.inSeconds.toDouble(),
//                                   activeColor: Colors.white,
//                                   inactiveColor: Colors.white24,
//                                   onChanged: (value) {
//                                     musicPlayer.seek(value);
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                       ],
//                     ),
//                   ),
//                   // Play / Pause button
//                   if (musicPlayer != null)
//                     StreamBuilder<PlayerState>(
//                       stream: musicPlayer.playerStateStream,
//                       builder: (context, snapshot) {
//                         final isPlaying = snapshot.data?.playing ?? false;
//                         return IconButton(
//                           icon: Icon(
//                             isPlaying
//                                 ? Icons.pause_circle_filled
//                                 : Icons.play_circle_filled,
//                             size: 36,
//                             color: Colors.white,
//                           ),
//                           onPressed: () => musicPlayer.playPause(),
//                         );
//                       },
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPlayPauseButton(CurrentMusicState musicState) {
//     final musicPlayer = getCurrentMusicPlayer(ref);

//     return StreamBuilder<PlayerState>(
//       stream: musicPlayer?.playerStateStream ?? Stream.empty(),
//       builder: (context, snapshot) {
//         final isPlaying = snapshot.data?.playing ?? false;
//         return IconButton(
//           icon: Icon(
//             isPlaying ? Icons.pause : Icons.play_arrow,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             musicPlayer?.playPause();
//           },
//         );
//       },
//     );
//   }
// }

// class WaveBackgroundPainter extends CustomPainter {
//   final double waveValue;
//   final double progress;
//   final Color waveColor;
//   final Color backgroundColor;

//   WaveBackgroundPainter({
//     required this.waveValue,
//     required this.progress,
//     required this.waveColor,
//     required this.backgroundColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final width = size.width;
//     final height = size.height;

//     final bgPaint = Paint()..color = backgroundColor;
//     canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

//     final wavePaint =
//         Paint()
//           ..color = waveColor
//           ..style = PaintingStyle.fill;

//     final path = Path();
//     final waveHeight = 2.0;
//     final baseLine = height / 3.5; // Base height for the wave

//     // Calculate the wave position based on music progress
//     final progressWidth = width * progress;

//     path.moveTo(0, baseLine);

//     for (double i = 0; i <= progressWidth; i++) {
//       final y = baseLine - sin((i / 20) + waveValue * 2 * pi) * waveHeight;
//       path.lineTo(i, y);
//     }

//     path.lineTo(progressWidth, height);
//     path.lineTo(0, height);
//     path.close();

//     canvas.drawPath(path, wavePaint);
//   }

//   @override
//   bool shouldRepaint(covariant WaveBackgroundPainter oldDelegate) {
//     return oldDelegate.waveValue != waveValue ||
//         oldDelegate.progress != progress ||
//         oldDelegate.waveColor != waveColor ||
//         oldDelegate.backgroundColor != backgroundColor;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
import 'package:lyrica/modules/home/view/home_screen.dart';
import 'package:lyrica/modules/search%20items/view/search_screen.dart';
import 'package:lyrica/modules/library/view/library_screen.dart';

final bottomSheetKey = GlobalKey<_BottomSheetScreenState>();

class BottomSheetScreen extends ConsumerStatefulWidget {
  const BottomSheetScreen({super.key});

  @override
  ConsumerState<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen> {
  int _currentIndex = 0;

  void setTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = [
    HomeScreen("", ""),
    SearchScreen(false),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: bottomSheetKey,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
