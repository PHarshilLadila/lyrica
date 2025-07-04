// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:lyrica/common/utils/utils.dart';
// // import 'package:lyrica/common/widget/app_back_button.dart';
// // import 'package:lyrica/common/widget/app_text.dart';
// // import 'package:lyrica/core/constant/app_colors.dart';
// // import 'package:lyrica/model/music_model.dart';
// // import 'package:simple_gradient_text/simple_gradient_text.dart';
// // import 'package:waveform_flutter/waveform_flutter.dart';

// // final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

// // class MusicPlayer extends ConsumerStatefulWidget {
// //   final List<Results> songList;
// //   final int initialIndex;

// //   const MusicPlayer({
// //     super.key,
// //     required this.songList,
// //     required this.initialIndex,
// //   });

// //   @override
// //   ConsumerState<MusicPlayer> createState() => _MusicPlayerState();
// // }

// // class _MusicPlayerState extends ConsumerState<MusicPlayer> {
// //   late AudioPlayer audioPlayer;
// //   late int currentIndex;
// //   late Stream<PlayerState> playerStateStream;
// //   Stream<Duration> get positionStream => audioPlayer.positionStream;
// //   Stream<Duration?> get durationStream => audioPlayer.durationStream;
// //   final Stream<Amplitude> amplitudeStream = createRandomAmplitudeStream();

// //   @override
// //   void initState() {
// //     super.initState();
// //     audioPlayer = AudioPlayer();
// //     currentIndex = widget.initialIndex;
// //     playerStateStream = audioPlayer.playerStateStream;
// //     _loadSong(currentIndex);
// //   }

// //   // @override
// //   // void didUpdateWidget(covariant MusicPlayer oldWidget) {
// //   //   super.didUpdateWidget(oldWidget);
// //   //   // ignore: unrelated_type_equality_checks
// //   //   if (_loadSong(currentIndex) != oldWidget.songList[currentIndex]) {
// //   //     _nextSong();
// //   //   }
// //   // }

// //   Future<void> _loadSong(int index) async {
// //     await audioPlayer.stop();
// //     final url = widget.songList[index].audio;
// //     if (url != null) {
// //       debugPrint("$url is now playing");
// //       await audioPlayer.setUrl(url);
// //       audioPlayer.play();
// //     }
// //   }

// //   void _playPause() {
// //     if (audioPlayer.playing) {
// //       debugPrint("pause");
// //       audioPlayer.pause();
// //     } else {
// //       debugPrint("play");
// //       audioPlayer.play();
// //     }
// //   }

// //   void _nextSong() {
// //     if (currentIndex < widget.songList.length - 1) {
// //       setState(() {
// //         currentIndex++;
// //         _loadSong(currentIndex);
// //         debugPrint("$currentIndex this is current index playing");
// //       });
// //     }
// //   }

// //   void _previousSong() {
// //     if (currentIndex > 0) {
// //       setState(() {
// //         currentIndex--;
// //         _loadSong(currentIndex);
// //         debugPrint("$currentIndex this is current index playing");
// //       });
// //     }
// //   }

// //   void _seek(double value) {
// //     audioPlayer.seek(Duration(seconds: value.toInt()));
// //     var data = audioPlayer.seek(Duration(seconds: value.toInt()));
// //     debugPrint("$data this is the seek data");
// //   }

// //   String _formatDuration(Duration duration) {
// //     final minutes = duration.inMinutes.toString().padLeft(2, '0');
// //     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
// //     return '$minutes:$seconds';
// //   }

// //   @override
// //   void dispose() {
// //     audioPlayer.stop();
// //     audioPlayer.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final currentSong = widget.songList[currentIndex];

// //     return Container(
// //       decoration: BoxDecoration(gradient: backgroundGradient()),
// //       child: Scaffold(
// //         backgroundColor: const Color.fromARGB(221, 39, 39, 39),
// //         appBar: AppBar(
// //           leading: AppBackButton(),
// //           elevation: 0,
// //           toolbarHeight: 90,
// //           backgroundColor: Colors.transparent,
// //           title: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               AppText(
// //                 textName: "Now Playing",
// //                 fontSize: 20.sp,
// //                 textColor: Color(AppColors.lightText),
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ],
// //           ),
// //         ),
// //         body: SingleChildScrollView(
// //           physics: BouncingScrollPhysics(),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               SizedBox(height: 50.h),

// //               ClipRRect(
// //                 borderRadius: BorderRadius.circular(15),
// //                 child: Image.network(
// //                   currentSong.image ?? "",
// //                   width: 280.w,
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //               SizedBox(height: 10.h),

// //               GradientText(
// //                 currentSong.name ?? "",
// //                 textAlign: TextAlign.center,
// //                 style: GoogleFonts.poppins(fontSize: 24.sp),
// //                 gradientType: GradientType.radial,
// //                 radius: 5.5,
// //                 colors: [
// //                   Color(AppColors.blueLight),
// //                   Color(AppColors.blueThird),
// //                   Color(AppColors.blueLight),
// //                   Color(AppColors.secondaryColor),
// //                 ],
// //               ),
// //               SizedBox(height: 5.h),

// //               AppText(
// //                 textName: "By - ${currentSong.artistName ?? ""}",
// //                 textColor: Colors.white54,
// //                 fontSize: 14.sp,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //               SizedBox(height: 15.h),

// //               // SizedBox(
// //               //   height: 20.h,
// //               //   child: StreamBuilder<Duration>(
// //               //     stream: positionStream,
// //               //     builder: (context, snapshot) {
// //               //       return AnimatedWaveList(
// //               //         stream: amplitudeStream,
// //               //         barBuilder: (animation, amplitude) {
// //               //           return WaveFormBar(
// //               //             amplitude: amplitude,
// //               //             animation: animation,
// //               //             color: Color(AppColors.primaryColor),
// //               //           );
// //               //         },
// //               //       );
// //               //     },
// //               //   ),
// //               // ),
// //               StreamBuilder<Duration>(
// //                 stream: positionStream,
// //                 builder: (context, snapshot) {
// //                   final position = snapshot.data ?? Duration.zero;
// //                   final duration = audioPlayer.duration ?? Duration.zero;

// //                   return Column(
// //                     children: [
// //                       Slider(
// //                         min: 0,
// //                         max: duration.inSeconds.toDouble(),
// //                         value:
// //                             position.inSeconds
// //                                 .clamp(0, duration.inSeconds)
// //                                 .toDouble(),
// //                         onChanged: _seek,
// //                         activeColor: Color(AppColors.primaryColor),
// //                         inactiveColor: Colors.white24,
// //                       ),
// //                       Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             Text(
// //                               _formatDuration(position),
// //                               style: TextStyle(color: Colors.white70),
// //                             ),
// //                             Text(
// //                               _formatDuration(duration),
// //                               style: TextStyle(color: Colors.white70),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   );
// //                 },
// //               ),
// //               SizedBox(height: 20.h),

// //               // Play/Pause and Navigation Buttons
// //               StreamBuilder<PlayerState>(
// //                 stream: playerStateStream,
// //                 builder: (context, snapshot) {
// //                   final playerState = snapshot.data;
// //                   final isPlaying = playerState?.playing ?? false;

// //                   return Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       IconButton(
// //                         icon: FaIcon(FontAwesomeIcons.backward),
// //                         iconSize: 50,
// //                         color: Color.fromARGB(255, 218, 250, 255),
// //                         onPressed: _previousSong,
// //                       ),
// //                       SizedBox(width: 30.w),
// //                       Container(
// //                         decoration: BoxDecoration(
// //                           shape: BoxShape.circle,
// //                           gradient: LinearGradient(
// //                             colors: [
// //                               Color(AppColors.primaryColor),
// //                               Color(AppColors.blueLight),
// //                             ],
// //                           ),
// //                         ),
// //                         child: IconButton(
// //                           icon: Icon(
// //                             isPlaying
// //                                 ? CupertinoIcons.pause_circle
// //                                 : CupertinoIcons.play_circle,
// //                           ),
// //                           iconSize: 50,
// //                           color: Colors.white,
// //                           onPressed: _playPause,
// //                         ),
// //                       ),
// //                       SizedBox(width: 30.w),
// //                       IconButton(
// //                         icon: FaIcon(FontAwesomeIcons.forward),
// //                         iconSize: 50,
// //                         color: Color.fromARGB(255, 218, 250, 255),
// //                         onPressed: _nextSong,
// //                       ),
// //                     ],
// //                   );
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lyrica/common/utils/utils.dart';
// import 'package:lyrica/common/widget/app_back_button.dart';
// import 'package:lyrica/common/widget/app_text.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/model/music_model.dart';
// import 'package:simple_gradient_text/simple_gradient_text.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:lyrica/core/providers/provider.dart';
// import 'package:lyrica/modules/library/view/library_screen.dart';

// final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

// final rewardPointsProvider = StreamProvider<int>((ref) async* {
//   final user = ref.watch(authStateProvider).asData?.value;
//   if (user == null) yield 0;
//   final doc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
//   await for (final snap in doc.snapshots()) {
//     yield (snap.data()?['rewardPoints'] ?? 0) as int;
//   }
// });

// class MusicPlayer extends ConsumerStatefulWidget {
//   final List<Results> songList;
//   final int initialIndex;

//   const MusicPlayer({
//     super.key,
//     required this.songList,
//     required this.initialIndex,
//   });

//   @override
//   ConsumerState<MusicPlayer> createState() => _MusicPlayerState();
// }

// class _MusicPlayerState extends ConsumerState<MusicPlayer> {
//   late AudioPlayer audioPlayer;
//   late int currentIndex;
//   late Stream<PlayerState> playerStateStream;
//   Stream<Duration> get positionStream => audioPlayer.positionStream;
//   Stream<Duration?> get durationStream => audioPlayer.durationStream;
//   Stream<Amplitude> get amplitudeStream => _amplitudeController.stream;

//   final StreamController<Amplitude> _amplitudeController =
//       StreamController<Amplitude>();
//   Timer? _amplitudeTimer;

//   Timer? _rewardTimer;
//   int _lastDeductedMinute = 0;
//   int _currentRewardPoints = 0;
//   bool _dialogShown = false;

//   @override
//   void initState() {
//     super.initState();
//     audioPlayer = AudioPlayer();
//     currentIndex = widget.initialIndex;
//     playerStateStream = audioPlayer.playerStateStream;
//     _loadSong(currentIndex);
//     _listenRewardPoints();
//     _startRewardTimer();
//     audioPlayer.playerStateStream.listen((state) {
//       if (state.playing && state.processingState == ProcessingState.ready) {
//         _startAmplitudeUpdates();
//       } else {
//         _stopAmplitudeUpdates();
//       }
//     });
//   }

//   void _startAmplitudeUpdates() {
//     _amplitudeTimer?.cancel();
//     final random = Random();

//     _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
//       final value = random.nextDouble();
//       _amplitudeController.add(
//         Amplitude(max: value, min: value / 2, current: value),
//       );
//     });
//   }

//   void _stopAmplitudeUpdates() {
//     _amplitudeTimer?.cancel();
//     _amplitudeTimer = null;
//   }

//   void _listenRewardPoints() {
//     final user = ref.read(authStateProvider).asData?.value;
//     if (user == null) return;
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .snapshots()
//         .listen((snap) {
//           final points = (snap.data()?['rewardPoints'] ?? 0) as int;
//           setState(() {
//             _currentRewardPoints = points;
//           });
//           if (points <= 0) {
//             if (audioPlayer.playing && !_dialogShown) {
//               _stopMusicAndShowDialog();
//             }
//           } else {
//             // Reset dialog flag when user earns points again
//             _dialogShown = false;
//           }
//         });
//   }

//   void _startRewardTimer() {
//     _rewardTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (!mounted || !audioPlayer.playing || _dialogShown) return;

//       final position = await audioPlayer.position;
//       final playedMinutes = position.inMinutes;

//       if (!mounted) return; // Double-check again

//       if (playedMinutes > _lastDeductedMinute) {
//         _lastDeductedMinute = playedMinutes;

//         if (_currentRewardPoints > 0) {
//           await _deductRewardPoint();
//         }

//         if (_currentRewardPoints <= 1) {
//           if (!mounted) return;
//           await _stopMusicAndShowDialog();
//         }
//       }
//     });
//   }

//   Future<void> _deductRewardPoint() async {
//     final user = ref.read(authStateProvider).asData?.value;
//     if (user == null) return;
//     final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
//     await FirebaseFirestore.instance.runTransaction((transaction) async {
//       final snapshot = await transaction.get(doc);
//       final current = (snapshot.data()?['rewardPoints'] ?? 0) as int;
//       if (current > 0) {
//         transaction.update(doc, {'rewardPoints': current - 1});
//       }
//     });
//   }

//   Future<void> _stopMusicAndShowDialog() async {
//     if (!mounted || _dialogShown) return;

//     _dialogShown = true;
//     if (audioPlayer.playing) {
//       await audioPlayer.pause();
//     }
//     if (!mounted) return;

//     // Show dialog only after the current frame completes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       showGeneralDialog(
//         context: context,
//         barrierDismissible: false,
//         barrierLabel: "RewardDialog",
//         transitionDuration: const Duration(milliseconds: 300),
//         pageBuilder: (_, __, ___) => _buildNoPointsDialog(),
//         transitionBuilder: (context, animation, secondaryAnimation, child) {
//           return ScaleTransition(
//             scale: CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeOutBack,
//             ),
//             child: child,
//           );
//         },
//       );
//     });
//   }

//   Widget _buildNoPointsDialog() {
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
//               Text(
//                 "No Reward Points!",
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(AppColors.primaryColor),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 "You need more reward points to play music.\nGo to Library and earn more points by watching ads.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   color: Color(AppColors.darkBlue),
//                 ),
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
//                 },
//                 icon: const Icon(Icons.card_giftcard, color: Colors.white),
//                 label: Text(
//                   "Go to Library",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _loadSong(int index) async {
//     await audioPlayer.stop();

//     // Check reward points before allowing playback
//     if (_currentRewardPoints <= 0) {
//       _stopMusicAndShowDialog();
//       return;
//     }

//     final url = widget.songList[index].audio;
//     if (url != null) {
//       debugPrint("$url is now playing");
//       try {
//         await audioPlayer.setUrl(url);
//         await audioPlayer.play();
//       } catch (e) {
//         debugPrint("Error loading song: $e");
//       }
//     }

//     _lastDeductedMinute = 0;
//     _dialogShown = false;
//   }

//   void _playPause() async {
//     if (_currentRewardPoints <= 0) {
//       _stopMusicAndShowDialog();
//       return;
//     }

//     if (audioPlayer.playing) {
//       await audioPlayer.pause();
//     } else {
//       await audioPlayer.play();
//     }
//   }

//   void _nextSong() {
//     if (currentIndex < widget.songList.length - 1) {
//       setState(() {
//         currentIndex++;
//       });
//       _loadSong(currentIndex);
//     }
//   }

//   void _previousSong() {
//     if (currentIndex > 0) {
//       setState(() {
//         currentIndex--;
//       });
//       _loadSong(currentIndex);
//     }
//   }

//   void _seek(double value) {
//     audioPlayer.seek(Duration(seconds: value.toInt()));
//     var data = audioPlayer.seek(Duration(seconds: value.toInt()));
//     debugPrint("$data this is the seek data");
//   }

//   String _formatDuration(Duration duration) {
//     final minutes = duration.inMinutes.toString().padLeft(2, '0');
//     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }

//   @override
//   void dispose() {
//     _rewardTimer?.cancel();
//     _amplitudeTimer?.cancel();
//     _amplitudeController.close();
//     audioPlayer.stop();
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentSong = widget.songList[currentIndex];
//     final rewardPointsAsync = ref.watch(rewardPointsProvider);

//     return Container(
//       decoration: BoxDecoration(gradient: backgroundGradient()),
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(221, 39, 39, 39),
//         appBar: AppBar(
//           leading: AppBackButton(),
//           elevation: 0,
//           toolbarHeight: 90,
//           backgroundColor: Colors.transparent,
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText(
//                 textName: "Now Playing",
//                 fontSize: 20.sp,
//                 textColor: Color(AppColors.lightText),
//                 fontWeight: FontWeight.w500,
//               ),
//             ],
//           ),
//           actions: [
//             rewardPointsAsync.when(
//               data:
//                   (points) => Container(
//                     margin: const EdgeInsets.only(right: 18, top: 18),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Color(AppColors.primaryColor),
//                       borderRadius: BorderRadius.circular(30),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color(
//                             AppColors.primaryColor,
//                           ).withOpacity(0.18),
//                           blurRadius: 12,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.stars, color: Colors.white, size: 18),
//                         SizedBox(width: 6),
//                         Text(
//                           "$points",
//                           style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               loading:
//                   () => Padding(
//                     padding: const EdgeInsets.only(right: 18, top: 18),
//                     child: SizedBox(
//                       width: 24,
//                       height: 24,
//                       child: CircularProgressIndicator(
//                         color: Color(AppColors.primaryColor),
//                         strokeWidth: 2,
//                       ),
//                     ),
//                   ),
//               error: (e, _) => SizedBox.shrink(),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 50.h),

//               ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: Image.network(
//                   currentSong.image ?? "",
//                   width: 280.w,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(height: 10.h),

//               GradientText(
//                 currentSong.name ?? "",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(fontSize: 24.sp),
//                 gradientType: GradientType.radial,
//                 radius: 5.5,
//                 colors: [
//                   Color(AppColors.blueLight),
//                   Color(AppColors.blueThird),
//                   Color(AppColors.blueLight),
//                   Color(AppColors.secondaryColor),
//                 ],
//               ),
//               SizedBox(height: 5.h),

//               AppText(
//                 textName: "By - ${currentSong.artistName ?? ""}",
//                 textColor: Colors.white54,
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//               SizedBox(height: 15.h),

//               SizedBox(
//                 height: 100,
//                 width: double.infinity,
//                 child: StreamBuilder<Amplitude>(
//                   stream: amplitudeStream,
//                   builder: (context, snapshot) {
//                     final amp = snapshot.data?.max ?? 0.0;
//                     return CustomPaint(
//                       painter: WaveformPainter(amplitude: amp),
//                     );
//                   },
//                 ),
//               ),

//               StreamBuilder<Duration>(
//                 stream: positionStream,
//                 builder: (context, snapshot) {
//                   final position = snapshot.data ?? Duration.zero;
//                   final duration = audioPlayer.duration ?? Duration.zero;

//                   return Column(
//                     children: [
//                       Slider(
//                         min: 0,
//                         max: duration.inSeconds.toDouble(),
//                         value:
//                             position.inSeconds
//                                 .clamp(0, duration.inSeconds)
//                                 .toDouble(),
//                         onChanged: _seek,
//                         activeColor: Color(AppColors.primaryColor),
//                         inactiveColor: Colors.white24,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               _formatDuration(position),
//                               style: TextStyle(color: Colors.white70),
//                             ),
//                             Text(
//                               _formatDuration(duration),
//                               style: TextStyle(color: Colors.white70),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               SizedBox(height: 20.h),

//               // Play/Pause and Navigation Buttons
//               StreamBuilder<PlayerState>(
//                 stream: playerStateStream,
//                 builder: (context, snapshot) {
//                   final playerState = snapshot.data;
//                   final isPlaying = playerState?.playing ?? false;

//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: FaIcon(FontAwesomeIcons.backward),
//                         iconSize: 50,
//                         color: Color.fromARGB(255, 218, 250, 255),
//                         onPressed: _previousSong,
//                       ),
//                       SizedBox(width: 30.w),
//                       Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             colors: [
//                               Color(AppColors.primaryColor),
//                               Color(AppColors.blueLight),
//                             ],
//                           ),
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             isPlaying
//                                 ? CupertinoIcons.pause_circle
//                                 : CupertinoIcons.play_circle,
//                           ),
//                           iconSize: 50,
//                           color: Colors.white,
//                           onPressed: _playPause,
//                         ),
//                       ),
//                       SizedBox(width: 30.w),
//                       IconButton(
//                         icon: FaIcon(FontAwesomeIcons.forward),
//                         iconSize: 50,
//                         color: Color.fromARGB(255, 218, 250, 255),
//                         onPressed: _nextSong,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Amplitude {
//   final double min;
//   final double max;
//   final double? current;

//   Amplitude({required this.min, required this.max, this.current});
// }

// Stream<Amplitude> createRandomAmplitudeStream() async* {
//   final random = Random();
//   while (true) {
//     await Future.delayed(const Duration(milliseconds: 60));
//     final value = random.nextDouble();
//     yield Amplitude(max: value, min: value / 2, current: value);
//   }
// }

// class WaveformPainter extends CustomPainter {
//   final double amplitude;
//   final int barCount;

//   WaveformPainter({required this.amplitude, this.barCount = 40});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint =
//         Paint()
//           ..color = Colors.cyanAccent
//           ..strokeCap = StrokeCap.round
//           ..style = PaintingStyle.fill;

//     final barWidth = size.width / (barCount * 1.5);
//     final gap = barWidth / 2;
//     final centerY = size.height / 2;

//     for (int i = 0; i < barCount; i++) {
//       final normalized = sin(
//         (i + DateTime.now().millisecondsSinceEpoch / 100) * 0.15,
//       );
//       final barHeight = (amplitude * size.height * 0.8 * normalized.abs())
//           .clamp(4, size.height);

//       final x = i * (barWidth + gap);
//       final y = centerY - barHeight / 2;

//       final rect = RRect.fromRectAndRadius(
//         Rect.fromLTWH(x, y, barWidth, barHeight.toDouble()),
//         Radius.circular(barWidth / 2),
//       );

//       canvas.drawRRect(rect, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant WaveformPainter oldDelegate) =>
//       oldDelegate.amplitude != amplitude;
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/modules/library/view/library_screen.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

final rewardPointsProvider = StreamProvider<int>((ref) async* {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) yield 0;
  final doc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
  await for (final snap in doc.snapshots()) {
    yield (snap.data()?['rewardPoints'] ?? 0) as int;
  }
});

class MusicPlayer extends ConsumerStatefulWidget {
  final List<Results> songList;
  final int initialIndex;

  const MusicPlayer({
    super.key,
    required this.songList,
    required this.initialIndex,
  });

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends ConsumerState<MusicPlayer> {
  late AudioPlayer audioPlayer;
  late int currentIndex;
  late Stream<PlayerState> playerStateStream;
  Stream<Duration> get positionStream => audioPlayer.positionStream;
  Stream<Duration?> get durationStream => audioPlayer.durationStream;
  Stream<Amplitude> get amplitudeStream => _amplitudeController.stream;

  final StreamController<Amplitude> _amplitudeController =
      StreamController<Amplitude>();
  Timer? _amplitudeTimer;

  Timer? _rewardTimer;
  int _lastDeductedMinute = 0;
  int _currentRewardPoints = 0;
  bool _dialogShown = false;
  bool _initialCheckDone = false;
  bool _isSkipping = false;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _firestoreSubscription;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    currentIndex = widget.initialIndex;
    playerStateStream = audioPlayer.playerStateStream;
    _initializePlayer();
    _listenRewardPoints();
  }

  void _initializePlayer() {
    _playerStateSubscription = audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _autoPlayNextSong();
      }

      if (state.playing && state.processingState == ProcessingState.ready) {
        _startAmplitudeUpdates();
      } else {
        _stopAmplitudeUpdates();
      }
    });
  }

  void _autoPlayNextSong() {
    if (!mounted) return;

    if (currentIndex < widget.songList.length - 1) {
      setState(() {
        currentIndex++;
      });
      _loadSong(currentIndex, isAutoPlay: true);
    }
  }

  void _startAmplitudeUpdates() {
    _amplitudeTimer?.cancel();
    final random = Random();

    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      if (!mounted) return;
      final value = random.nextDouble();
      if (!_amplitudeController.isClosed) {
        _amplitudeController.add(
          Amplitude(max: value, min: value / 2, current: value),
        );
      }
    });
  }

  void _stopAmplitudeUpdates() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
  }

  void _listenRewardPoints() {
    final user = ref.read(authStateProvider).asData?.value;
    if (user == null) return;

    _firestoreSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snap) {
          if (!mounted) return;

          final points = (snap.data()?['rewardPoints'] ?? 0) as int;

          setState(() {
            _currentRewardPoints = points;
          });

          if (!_initialCheckDone) {
            _initialCheckDone = true;
            if (points > 0) {
              _loadSong(currentIndex);
              _startRewardTimer();
            } else {
              _stopMusicAndShowDialog();
            }
          } else {
            if (points <= 0 && audioPlayer.playing && !_dialogShown) {
              _stopMusicAndShowDialog();
            } else if (points > 0 && _dialogShown) {
              _dialogShown = false;
            }
          }
        });
  }

  void _startRewardTimer() {
    _rewardTimer?.cancel();
    _lastDeductedMinute = 0;

    _rewardTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted || !audioPlayer.playing || _dialogShown || _isSkipping)
        return;

      try {
        final position = await audioPlayer.position;
        final playedMinutes = position.inMinutes;

        if (playedMinutes > _lastDeductedMinute) {
          _lastDeductedMinute = playedMinutes;

          if (_currentRewardPoints > 0) {
            await _deductRewardPoint();
          }

          if (_currentRewardPoints <= 0) {
            if (!mounted) return;
            await _stopMusicAndShowDialog();
          }
        }
      } catch (e) {
        debugPrint('Error in reward timer: $e');
      }
    });
  }

  Future<void> _deductRewardPoint() async {
    final user = ref.read(authStateProvider).asData?.value;
    if (user == null) return;
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(doc);
        final current = (snapshot.data()?['rewardPoints'] ?? 0) as int;
        if (current > 0) {
          transaction.update(doc, {'rewardPoints': current - 1});
        }
      });
    } catch (e) {
      debugPrint('Error deducting reward point: $e');
    }
  }

  Future<void> _stopMusicAndShowDialog() async {
    if (!mounted || _dialogShown) return;

    _dialogShown = true;
    try {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
      }
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }

    _rewardTimer?.cancel();
    _rewardTimer = null;

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: "RewardDialog",
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => _buildNoPointsDialog(),
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
    });
  }

  Widget _buildNoPointsDialog() {
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
              Text(
                "No Reward Points!",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(AppColors.primaryColor),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "You need more reward points to play music.\nGo to Library and earn more points by watching ads.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(AppColors.darkBlue),
                ),
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
                  // bottomNavKey.currentState?.setTab(2);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LibraryScreen()),
                  );
                },
                icon: const Icon(Icons.card_giftcard, color: Colors.white),
                label: Text(
                  "Go to Library",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
    try {
      await audioPlayer.stop();

      // Reset skipping flag if it was set
      if (_isSkipping) {
        _isSkipping = false;
      }

      // Check reward points before allowing playback (except for auto-play)
      if (!isAutoPlay && _currentRewardPoints <= 0) {
        _stopMusicAndShowDialog();
        return;
      }

      final url = widget.songList[index].audio;
      if (url != null) {
        debugPrint("$url is now playing");
        await audioPlayer.setUrl(url);
        await audioPlayer.play();
      }

      _lastDeductedMinute = 0;
    } catch (e) {
      debugPrint('Error loading song: $e');
      if (!isAutoPlay && mounted) {
        showSnackBar(context, 'Error playing song', Colors.red);
      }
    }
  }

  void _playPause() async {
    if (_currentRewardPoints <= 0) {
      _stopMusicAndShowDialog();
      return;
    }

    try {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error in play/pause: $e');
      if (mounted) {
        showSnackBar(context, 'Error controlling playback', Colors.red);
      }
    }
  }

  void _nextSong() {
    if (currentIndex < widget.songList.length - 1) {
      if (!mounted) return;
      setState(() {
        currentIndex++;
        _isSkipping = true; // Set flag to indicate manual skip
      });
      _loadSong(currentIndex);
    }
  }

  void _previousSong() {
    if (currentIndex > 0) {
      if (!mounted) return;
      setState(() {
        currentIndex--;
        _isSkipping = true; // Set flag to indicate manual skip
      });
      _loadSong(currentIndex);
    }
  }

  void _seek(double value) {
    try {
      audioPlayer.seek(Duration(seconds: value.toInt()));
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _rewardTimer?.cancel();
    _amplitudeTimer?.cancel();
    _playerStateSubscription?.cancel();
    _firestoreSubscription?.cancel();

    try {
      if (!_amplitudeController.isClosed) {
        _amplitudeController.close();
      }
      audioPlayer.dispose();
    } catch (e) {
      debugPrint('Error disposing resources: $e');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songList[currentIndex];
    final rewardPointsAsync = ref.watch(rewardPointsProvider);

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
                textName: "Now Playing",
                fontSize: 20.sp,
                textColor: Color(AppColors.lightText),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 24, top: 24),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Color(AppColors.primaryColor),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color(AppColors.primaryColor).withOpacity(0.18),
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
                        (points) => Text(
                          "$points",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
                        (error, stack) => Text(
                          "0",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  currentSong.image ?? "",
                  width: 280.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10.h),
              GradientText(
                currentSong.name ?? "",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 24.sp),
                gradientType: GradientType.radial,
                radius: 5.5,
                colors: [
                  Color(AppColors.blueLight),
                  Color(AppColors.blueThird),
                  Color(AppColors.blueLight),
                  Color(AppColors.secondaryColor),
                ],
              ),
              SizedBox(height: 5.h),
              AppText(
                textName: "By - ${currentSong.artistName ?? ""}",
                textColor: Colors.white54,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: StreamBuilder<Amplitude>(
                  stream: amplitudeStream,
                  builder: (context, snapshot) {
                    final amp = snapshot.data?.max ?? 0.0;
                    return CustomPaint(
                      painter: WaveformPainter(amplitude: amp),
                    );
                  },
                ),
              ),
              StreamBuilder<Duration>(
                stream: positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = audioPlayer.duration ?? Duration.zero;

                  return Column(
                    children: [
                      Slider(
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        value:
                            position.inSeconds
                                .clamp(0, duration.inSeconds)
                                .toDouble(),
                        onChanged: _seek,
                        activeColor: Color(AppColors.primaryColor),
                        inactiveColor: Colors.white24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),
              StreamBuilder<PlayerState>(
                stream: playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final isPlaying = playerState?.playing ?? false;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.backward),
                        iconSize: 50,
                        color: Color.fromARGB(255, 218, 250, 255),
                        onPressed: _previousSong,
                      ),
                      SizedBox(width: 30.w),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(AppColors.primaryColor),
                              Color(AppColors.blueLight),
                            ],
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isPlaying
                                ? CupertinoIcons.pause_circle
                                : CupertinoIcons.play_circle,
                          ),
                          iconSize: 50,
                          color: Colors.white,
                          onPressed: _playPause,
                        ),
                      ),
                      SizedBox(width: 30.w),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.forward),
                        iconSize: 50,
                        color: Color.fromARGB(255, 218, 250, 255),
                        onPressed: _nextSong,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Amplitude {
  final double min;
  final double max;
  final double? current;

  Amplitude({required this.min, required this.max, this.current});
}

class WaveformPainter extends CustomPainter {
  final double amplitude;
  final int barCount;

  WaveformPainter({required this.amplitude, this.barCount = 40});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.cyanAccent
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.fill;

    final barWidth = size.width / (barCount * 1.5);
    final gap = barWidth / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final normalized = sin(
        (i + DateTime.now().millisecondsSinceEpoch / 100) * 0.15,
      );
      final barHeight = (amplitude * size.height * 0.8 * normalized.abs())
          .clamp(4, size.height);

      final x = i * (barWidth + gap);
      final y = centerY - barHeight / 2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight.toDouble()),
        Radius.circular(barWidth / 2),
      );

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) =>
      oldDelegate.amplitude != amplitude;
}
