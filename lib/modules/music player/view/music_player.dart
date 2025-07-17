// // ignore_for_file: deprecated_member_use

// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:external_path/external_path.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lyrica/common/utils/utils.dart';
// import 'package:lyrica/common/widget/app_back_button.dart';
// import 'package:lyrica/common/widget/app_main_button.dart';
// import 'package:lyrica/common/widget/app_text.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/model/music_model.dart';
// import 'package:permission_handler/permission_handler.dart';
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
//   bool _initialCheckDone = false;
//   bool _isSkipping = false;
//   StreamSubscription? _playerStateSubscription;
//   StreamSubscription? _firestoreSubscription;
//   String? currentDownloadTaskId;
//   String? downloadingFileName;
//   StreamSubscription<DownloadTaskStatus>? _downloadStatusSubscription;
//   bool _isDownloading = false;

//   Color _dominantColor = Color(AppColors.blueThird);
//   bool isColorCalculated = false;
//   late Future<Color> colorFuture;

//   @override
//   void initState() {
//     super.initState();

//     audioPlayer = AudioPlayer();
//     currentIndex = widget.initialIndex;
//     playerStateStream = audioPlayer.playerStateStream;
//     _initializePlayer();
//     _listenRewardPoints();
//   }

//   void _initializePlayer() {
//     _playerStateSubscription = audioPlayer.playerStateStream.listen((state) {
//       if (state.processingState == ProcessingState.completed) {
//         _autoPlayNextSong();
//       }

//       if (state.playing && state.processingState == ProcessingState.ready) {
//         _startAmplitudeUpdates();
//       } else {
//         _stopAmplitudeUpdates();
//       }
//     });
//   }

//   void _autoPlayNextSong() {
//     if (!mounted) return;

//     if (currentIndex < widget.songList.length - 1) {
//       final newIndex = currentIndex + 1;

//       setState(() {
//         currentIndex = newIndex;
//       });

//       _loadSong(newIndex, isAutoPlay: true);
//     }
//   }

//   void _startAmplitudeUpdates() {
//     _amplitudeTimer?.cancel();
//     final random = Random();

//     _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
//       if (!mounted) return;
//       final value = random.nextDouble();
//       if (!_amplitudeController.isClosed) {
//         _amplitudeController.add(
//           Amplitude(max: value, min: value / 2, current: value),
//         );
//       }
//     });
//   }

//   void _stopAmplitudeUpdates() {
//     _amplitudeTimer?.cancel();
//     _amplitudeTimer = null;
//   }

//   void _listenRewardPoints() {
//     final user = ref.read(authStateProvider).asData?.value;
//     if (user == null) return;

//     _firestoreSubscription = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .snapshots()
//         .listen((snap) {
//           if (!mounted) return;

//           final points = (snap.data()?['rewardPoints'] ?? 0) as int;

//           setState(() {
//             _currentRewardPoints = points;
//           });

//           if (!_initialCheckDone) {
//             _initialCheckDone = true;
//             if (points > 0) {
//               _loadSong(currentIndex);
//               _startRewardTimer();
//             } else {
//               _stopMusicAndShowDialog();
//             }
//           } else {
//             if (points <= 0 && audioPlayer.playing && !_dialogShown) {
//               _stopMusicAndShowDialog();
//             } else if (points > 0 && _dialogShown) {
//               _dialogShown = false;
//             }
//           }
//         });
//   }

//   void _startRewardTimer() {
//     _rewardTimer?.cancel();
//     _lastDeductedMinute = 0;

//     _rewardTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (!mounted || !audioPlayer.playing || _dialogShown || _isSkipping) {
//         return;
//       }

//       try {
//         final position = audioPlayer.position;
//         final playedMinutes = position.inMinutes;

//         if (playedMinutes > _lastDeductedMinute) {
//           _lastDeductedMinute = playedMinutes;

//           if (_currentRewardPoints > 0) {
//             await _deductRewardPoint();
//           }

//           if (_currentRewardPoints <= 0) {
//             if (!mounted) return;
//             await _stopMusicAndShowDialog();
//           }
//         }
//       } catch (e) {
//         debugPrint('Error in reward timer: $e');
//       }
//     });
//   }

//   Future<void> _deductRewardPoint() async {
//     final user = ref.read(authStateProvider).asData?.value;
//     if (user == null) return;
//     final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
//     try {
//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         final snapshot = await transaction.get(doc);
//         final current = (snapshot.data()?['rewardPoints'] ?? 0) as int;
//         if (current > 0) {
//           transaction.update(doc, {'rewardPoints': current - 1});
//         }
//       });
//     } catch (e) {
//       debugPrint('Error deducting reward point: $e');
//     }
//   }

//   Future<void> _stopMusicAndShowDialog() async {
//     if (!mounted || _dialogShown) return;

//     _dialogShown = true;
//     try {
//       if (audioPlayer.playing) {
//         await audioPlayer.pause();
//       }
//     } catch (e) {
//       debugPrint('Error stopping music: $e');
//     }

//     _rewardTimer?.cancel();
//     _rewardTimer = null;

//     if (!mounted) return;

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
//               AppText(
//                 textName: "No Reward Points!",
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 textColor: Color(AppColors.primaryColor),
//               ),
//               const SizedBox(height: 12),
//               AppText(
//                 textName:
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
//                 },
//                 icon: const Icon(Icons.card_giftcard, color: Colors.white),
//                 label: AppText(
//                   textName: "Go to Library",
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

//   Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
//     try {
//       await audioPlayer.stop();

//       if (_isSkipping) {
//         _isSkipping = false;
//       }

//       if (!isAutoPlay && _currentRewardPoints <= 0) {
//         _stopMusicAndShowDialog();
//         return;
//       }

//       final url = widget.songList[index].audio;
//       if (url != null) {
//         debugPrint("$url is now playing");
//         await audioPlayer.setUrl(url);
//         await audioPlayer.play();
//         debugPrint('Playing next song automatically');
//       }

//       _lastDeductedMinute = 0;
//     } catch (e) {
//       debugPrint('Error loading song: $e');
//       if (!isAutoPlay && mounted) {
//         showSnackBar(context, 'Error playing song', Colors.red);
//       }
//     }
//   }

//   void _playPause() async {
//     if (_currentRewardPoints <= 0) {
//       _stopMusicAndShowDialog();
//       return;
//     }

//     try {
//       if (audioPlayer.playing) {
//         await audioPlayer.pause();
//       } else {
//         await audioPlayer.play();
//       }
//     } catch (e) {
//       debugPrint('Error in play/pause: $e');
//       if (mounted) {
//         showSnackBar(context, 'Error controlling playback', Colors.red);
//       }
//     }
//   }

//   void _nextSong() {
//     if (currentIndex < widget.songList.length - 1) {
//       final newIndex = currentIndex + 1;

//       if (!mounted) return;
//       setState(() {
//         currentIndex = newIndex;
//         _isSkipping = true;
//       });
//       _loadSong(newIndex);
//     }
//   }

//   void _previousSong() {
//     if (currentIndex > 0) {
//       final newIndex = currentIndex - 1;

//       if (!mounted) return;
//       setState(() {
//         currentIndex = newIndex;
//         _isSkipping = true;
//       });
//       _loadSong(newIndex);
//     }
//   }

//   void _seek(double value) {
//     try {
//       audioPlayer.seek(Duration(seconds: value.toInt()));
//     } catch (e) {
//       debugPrint('Error seeking: $e');
//     }
//   }

//   String _formatDuration(Duration duration) {
//     final minutes = duration.inMinutes.toString().padLeft(2, '0');
//     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }

//   Future<bool> _checkStoragePermission() async {
//     if (Platform.isAndroid) {
//       final androidInfo = await DeviceInfoPlugin().androidInfo;
//       final sdkInt = androidInfo.version.sdkInt;

//       if (sdkInt >= 33) {
//         final audioStatus = await Permission.audio.request();
//         return audioStatus.isGranted;
//       } else if (sdkInt >= 30) {
//         final manageStatus = await Permission.manageExternalStorage.request();
//         return manageStatus.isGranted;
//       } else {
//         final storageStatus = await Permission.storage.request();
//         return storageStatus.isGranted;
//       }
//     }

//     return true;
//   }

//   void _startDownloadWithLoading(String musicUrl, String musicName) async {
//     if (_isDownloading) return;

//     setState(() {
//       _isDownloading = true;
//     });

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => _buildDownloadProgressDialog(),
//     );

//     await _startDownload(musicUrl, musicName);
//   }

//   Widget _buildDownloadProgressDialog() {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             appLoader(),
//             const SizedBox(height: 20),
//             AppText(
//               textName: 'Downloading...',
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//             const SizedBox(height: 10),
//             AppText(
//               textName: 'Please wait while we download your music',
//               fontSize: 14,
//               textColor: Colors.grey,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _startDownload(String musicUrl, String musicName) async {
//     final hasPermission = await _checkStoragePermission();

//     if (!hasPermission) {
//       if (mounted) {
//         Navigator.of(context).pop();
//         showSnackBar(context, 'Storage permission required', Colors.red);
//       }
//       setState(() {
//         _isDownloading = false;
//       });
//       return;
//     }

//     final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
//       ExternalPath.DIRECTORY_DOWNLOAD,
//     );

//     final sanitizedFileName = musicName.replaceAll(
//       RegExp(r'[\\/:*?"<>|]'),
//       "_",
//     );

//     try {
//       final taskId = await FlutterDownloader.enqueue(
//         url: musicUrl,
//         savedDir: downloadPath,
//         fileName: '$sanitizedFileName.mp3',
//         showNotification: true,
//         saveInPublicStorage: true,
//         openFileFromNotification: true,
//       );

//       if (taskId == null) throw Exception("Download failed");

//       setState(() {
//         currentDownloadTaskId = taskId;
//         downloadingFileName = musicName;
//       });

//       Future.doWhile(() async {
//         final tasks = await FlutterDownloader.loadTasksWithRawQuery(
//           query: "SELECT * FROM task WHERE task_id='$taskId'",
//         );

//         if (tasks != null && tasks.isNotEmpty) {
//           final task = tasks.first;
//           if (task.status == DownloadTaskStatus.complete) {
//             if (mounted) {
//               Navigator.of(context).pop();
//               showDialog(
//                 context: context,
//                 barrierDismissible: true,
//                 builder: (_) => _buildDownloadSuccessDialog(sanitizedFileName),
//               );
//             }
//             setState(() {
//               _isDownloading = false;
//             });
//             return false;
//           } else if (task.status == DownloadTaskStatus.failed) {
//             if (mounted) {
//               Navigator.of(context).pop();
//               showDialog(
//                 context: context,
//                 barrierDismissible: true,
//                 builder: (_) => _buildDownloadErrorDialog(),
//               );
//             }
//             setState(() {
//               _isDownloading = false;
//             });
//             return false;
//           }
//         }

//         await Future.delayed(const Duration(milliseconds: 500));
//         return true;
//       });
//     } catch (e) {
//       debugPrint("Download error: $e");
//       if (mounted) {
//         Navigator.of(context).pop();
//         showDialog(
//           context: context,
//           barrierDismissible: true,
//           builder: (_) => _buildDownloadErrorDialog(),
//         );
//       }
//       setState(() {
//         _isDownloading = false;
//       });
//     }
//   }

//   Widget _buildDownloadSuccessDialog(String fileName) {
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
//             // Icon(Icons.done, size: 60, color: Color(AppColors.primaryColor)),
//             const SizedBox(height: 16),
//             AppText(
//               textName: "Download Complete",
//               fontSize: 20,
//               textColor: Colors.black87,
//               fontWeight: FontWeight.w600,
//             ),
//             SizedBox(height: 9.h),
//             AppText(
//               textName:
//                   '"${fileName.length > 20 ? '${fileName.substring(0, 20)}...' : fileName}.mp3"',
//               align: TextAlign.center,
//               fontSize: 16,
//               textColor: Colors.black54,
//             ),
//             SizedBox(height: 2.h),
//             AppText(
//               textName: "has been saved to your Downloads folder",
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
//                 textName: "OK",
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

//   Widget _buildDownloadErrorDialog() {
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
//             Icon(Icons.error_outline, size: 60, color: Colors.red),
//             const SizedBox(height: 16),
//             AppText(
//               textName: "Download Failed",
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               textColor: Colors.black87,
//             ),
//             const SizedBox(height: 8),
//             AppText(
//               textName: "Failed to download the file. Please try again.",
//               align: TextAlign.center,
//               fontSize: 14,
//               textColor: Colors.black54,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//               ),
//               child: AppText(
//                 textName: "OK",
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

//   @override
//   void dispose() {
//     _rewardTimer?.cancel();
//     _amplitudeTimer?.cancel();
//     _playerStateSubscription?.cancel();
//     _firestoreSubscription?.cancel();
//     _downloadStatusSubscription?.cancel();

//     try {
//       if (!_amplitudeController.isClosed) {
//         _amplitudeController.close();
//       }
//       audioPlayer.dispose();
//     } catch (e) {
//       debugPrint('Error disposing resources: $e');
//     }

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentSong = widget.songList[currentIndex];
//     final rewardPointsAsync = ref.watch(rewardPointsProvider);

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Color(AppColors.blueThird).withOpacity(0.85),
//             Color(AppColors.primaryColor).withOpacity(0.85),
//             Color(AppColors.blueLight).withOpacity(0.85),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
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
//                 textName: "Now Playing",
//                 fontSize: 20.sp,
//                 textColor: Color(AppColors.lightText),
//                 fontWeight: FontWeight.w500,
//               ),
//             ],
//           ),
//           actions: [
//             Container(
//               padding: EdgeInsets.only(right: 16.w, left: 16.w),
//               margin: EdgeInsets.only(top: 20.h, bottom: 20.h, right: 12.w),
//               decoration: BoxDecoration(
//                 color: Color(AppColors.primaryColor),
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color(AppColors.primaryColor).withOpacity(0.18),
//                     blurRadius: 12,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.stars, color: Colors.white, size: 18),
//                   SizedBox(width: 6),
//                   rewardPointsAsync.when(
//                     data:
//                         (points) => AppText(
//                           textName: "$points",
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           textColor: Colors.white,
//                         ),
//                     loading:
//                         () => SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         ),
//                     error:
//                         (error, stack) => AppText(
//                           textName: "0",
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           textColor: Colors.white,
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.all(16.sp),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: TweenAnimationBuilder<double>(
//                     tween: Tween(begin: 0.95, end: 1.0),
//                     duration: const Duration(milliseconds: 900),
//                     curve: Curves.elasticOut,
//                     builder: (context, scale, child) {
//                       return Transform.scale(
//                         scale: scale,
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 600),
//                           curve: Curves.easeInOut,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(24),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color(
//                                   AppColors.primaryColor,
//                                 ).withOpacity(0.25),
//                                 blurRadius: 40,
//                                 spreadRadius: 8,
//                                 offset: Offset(0, 16),
//                               ),
//                             ],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(24),
//                             child: Image.network(
//                               width: 300.w,
//                               height: 300.w,
//                               currentSong.image ?? "",
//                               fit: BoxFit.cover,
//                               errorBuilder:
//                                   (_, __, ___) =>
//                                       const Icon(Icons.music_note, size: 80),
//                               loadingBuilder: (
//                                 context,
//                                 child,
//                                 loadingProgress,
//                               ) {
//                                 if (loadingProgress == null) return child;
//                                 return Center(
//                                   child: CircularProgressIndicator(
//                                     value:
//                                         loadingProgress.expectedTotalBytes !=
//                                                 null
//                                             ? loadingProgress
//                                                     .cumulativeBytesLoaded /
//                                                 loadingProgress
//                                                     .expectedTotalBytes!
//                                             : null,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 24.h),

//                 ShaderMask(
//                   shaderCallback: (Rect bounds) {
//                     return LinearGradient(
//                       colors: [
//                         Color(AppColors.blueLight),
//                         Color(AppColors.primaryColor),
//                         Color(AppColors.secondaryColor),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ).createShader(bounds);
//                   },
//                   child: Text(
//                     currentSong.name ?? "",
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(
//                       fontSize: 28.sp,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.2,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 2.h),

//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     AppText(
//                       textName: "By - ${currentSong.artistName ?? ""}",
//                       textColor: Colors.white54,
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           icon: FaIcon(FontAwesomeIcons.share),
//                           iconSize: 20.sp,
//                           color: Color(AppColors.primaryColor),
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon: FaIcon(FontAwesomeIcons.heart),
//                           iconSize: 20.sp,
//                           color: Color(AppColors.primaryColor),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),

//                 StreamBuilder<Duration>(
//                   stream: positionStream,
//                   builder: (context, snapshot) {
//                     final position = snapshot.data ?? Duration.zero;
//                     final duration = audioPlayer.duration ?? Duration.zero;
//                     // final percent =
//                     //     duration.inSeconds == 0
//                     //         ? 0.0
//                     //         : position.inSeconds / duration.inSeconds;

//                     return Column(
//                       children: [
//                         SizedBox(
//                           width: double.infinity,
//                           child: Slider(
//                             year2023: true,
//                             mouseCursor: MouseCursor.defer,
//                             thumbColor: Color(AppColors.blueLight),
//                             min: 0,
//                             max: duration.inSeconds.toDouble(),
//                             value:
//                                 position.inSeconds
//                                     .clamp(0, duration.inSeconds)
//                                     .toDouble(),
//                             onChanged: _seek,
//                             padding: EdgeInsets.only(
//                               top: 12.h,
//                               right: 4.w,
//                               left: 4.w,
//                               bottom: 4.h,
//                             ),
//                             activeColor: Color(AppColors.primaryColor),
//                             inactiveColor: Color(AppColors.blueExtraLight),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 8.w,
//                             vertical: 6.h,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               AppText(
//                                 textName: _formatDuration(position),
//                                 textColor: Colors.white70,
//                               ),
//                               AppText(
//                                 textName: _formatDuration(duration),
//                                 textColor: Colors.white70,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 SizedBox(height: 8.h),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     IconButton(
//                       icon: FaIcon(FontAwesomeIcons.shuffle),
//                       iconSize: 25.sp,
//                       color: Color(AppColors.primaryColor),
//                       onPressed: () {},
//                     ),
//                     IconButton(
//                       icon: FaIcon(FontAwesomeIcons.backward),
//                       iconSize: 35.sp,
//                       color: Color(AppColors.primaryColor),
//                       onPressed: _previousSong,
//                     ),
//                     _AnimatedGlow(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             colors: [
//                               Color(AppColors.primaryColor),
//                               Color(AppColors.blueLight),
//                             ],
//                           ),
//                         ),
//                         child: StreamBuilder<PlayerState>(
//                           stream: playerStateStream,
//                           builder: (context, snapshot) {
//                             final playerState = snapshot.data;
//                             final isPlaying = playerState?.playing ?? false;
//                             return IconButton(
//                               icon: Icon(
//                                 isPlaying
//                                     ? CupertinoIcons.pause_circle
//                                     : CupertinoIcons.play_circle,
//                               ),
//                               iconSize: 60,
//                               color: Colors.white,
//                               onPressed: _playPause,
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: FaIcon(FontAwesomeIcons.forward),
//                       iconSize: 35.sp,
//                       color: Color(AppColors.primaryColor),
//                       onPressed: _nextSong,
//                     ),
//                     IconButton(
//                       icon: const FaIcon(FontAwesomeIcons.arrowDown),
//                       iconSize: 25.sp,
//                       color: Color(AppColors.primaryColor),
//                       onPressed: () {
//                         final audioUrl = currentSong.audio ?? "";
//                         final name = currentSong.name ?? "Unknown";

//                         if (audioUrl.isNotEmpty) {
//                           _startDownloadWithLoading(audioUrl, name);
//                         } else {
//                           showSnackBar(
//                             context,
//                             'No download URL available',
//                             Colors.red,
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30.h),
//               ],
//             ),
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

// class _AnimatedGlow extends StatefulWidget {
//   final Widget child;
//   const _AnimatedGlow({required this.child});

//   @override
//   State<_AnimatedGlow> createState() => _AnimatedGlowState();
// }

// class _AnimatedGlowState extends State<_AnimatedGlow>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final glow = 18.0 + 12.0 * _controller.value;
//         return Container(
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Color(AppColors.primaryColor).withOpacity(0.5),
//                 blurRadius: glow,
//                 spreadRadius: 1,
//               ),
//             ],
//             shape: BoxShape.circle,
//           ),
//           child: widget.child,
//         );
//       },
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/library/view/library_screen.dart';
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  final List<Results> songList;
  final int initialIndex;

  const MusicPlayer({
    super.key,
    required this.songList,
    required this.initialIndex,
  });

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterDownloader.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayer = ref.watch(
      musicPlayerProvider((
        songList: widget.songList,
        initialIndex: widget.initialIndex,
      )).notifier,
    );
    final musicPlayerState = ref.watch(
      musicPlayerProvider((
        songList: widget.songList,
        initialIndex: widget.initialIndex,
      )),
    );
    final rewardPointsAsync = ref.watch(rewardPointsProvider);
    final currentSong = widget.songList[musicPlayerState.currentIndex];
    final isFavorite = ref.watch(
      favoriteProvider.select(
        (favorites) => favorites.contains(
          widget.songList[musicPlayerState.currentIndex].id,
        ),
      ),
    );

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
                  musicPlayerState.downloadingFileName ?? "Unknown",
                ),
          ).then((_) {
            musicPlayer.resetDownloadComplete();
          });
        }
      },
    );

    ref.listen<bool>(dialogShownProvider, (previous, next) {
      if (next) {
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

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),

      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
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
              padding: EdgeInsets.only(right: 16.w, left: 16.w),
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h, right: 12.w),
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
                        (points) => AppText(
                          textName: "$points",
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
                          textName: "0",
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
                            child: Image.network(
                              width: 300.w,
                              height: 300.w,
                              currentSong.image ?? "",
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Icon(Icons.music_note, size: 80),
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
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
                    currentSong.name ?? "",
                    textAlign: TextAlign.center,
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
                    AppText(
                      textName: "By - ${currentSong.artistName ?? ""}",
                      textColor: Colors.white54,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(CupertinoIcons.share),
                          iconSize: 22.sp,
                          color: Color(AppColors.primaryColor),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: FaIcon(
                            isFavorite
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                          ),
                          iconSize: 20.sp,
                          color:
                              isFavorite
                                  ? Color(AppColors.blueLight)
                                  : Color(AppColors.primaryColor),

                          onPressed: () {
                            ref
                                .read(favoriteProvider.notifier)
                                .toggleFavorite(currentSong.id ?? "");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                StreamBuilder<Duration>(
                  stream: musicPlayer.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration =
                        musicPlayerState.audioPlayer.duration ?? Duration.zero;

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
                            value:
                                position.inSeconds
                                    .clamp(0, duration.inSeconds)
                                    .toDouble(),
                            onChanged: musicPlayer.seek,
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 6.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                textName: musicPlayer.formatDuration(position),
                                textColor: Colors.white70,
                              ),
                              AppText(
                                textName: musicPlayer.formatDuration(duration),
                                textColor: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8.h),

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
                    _AnimatedGlow(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(AppColors.primaryColor),
                              Color(AppColors.blueLight),
                            ],
                          ),
                        ),
                        child: StreamBuilder<PlayerState>(
                          stream: musicPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final isPlaying = playerState?.playing ?? false;
                            return IconButton(
                              icon: Icon(
                                isPlaying
                                    ? CupertinoIcons.pause_circle
                                    : CupertinoIcons.play_circle,
                              ),
                              iconSize: 60,
                              color: Colors.white,
                              onPressed: musicPlayer.playPause,
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.forward),
                      iconSize: 35.sp,
                      color: Color(AppColors.primaryColor),
                      onPressed: musicPlayer.nextSong,
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.arrowDown),
                      iconSize: 25.sp,
                      color: Color(AppColors.primaryColor),
                      onPressed: () {
                        final audioUrl = currentSong.audio ?? "";
                        final name = currentSong.name ?? "Unknown";

                        if (audioUrl.isNotEmpty) {
                          musicPlayer.startDownloadWithLoading(audioUrl, name);
                          _buildDownloadSuccessDialog(context, audioUrl);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
              ],
            ),
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
                textName: "No Reward Points!",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                textColor: Color(AppColors.primaryColor),
              ),
              const SizedBox(height: 12),
              AppText(
                textName:
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
                  textName: "Go to Library",
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
              textName: "Download Complete",
              fontSize: 20,
              textColor: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 9.h),
            AppText(
              textName:
                  '"${fileName.length > 20 ? '${fileName.substring(0, 20)}...' : fileName}.mp3"',
              align: TextAlign.center,
              fontSize: 16,
              textColor: Colors.black54,
            ),
            SizedBox(height: 2.h),
            AppText(
              textName: "has been saved to your Downloads folder",
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
                textName: "OK",
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

class _AnimatedGlow extends StatefulWidget {
  final Widget child;
  const _AnimatedGlow({required this.child});

  @override
  State<_AnimatedGlow> createState() => _AnimatedGlowState();
}

class _AnimatedGlowState extends State<_AnimatedGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glow = 18.0 + 12.0 * _controller.value;
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(AppColors.primaryColor).withOpacity(0.5),
                blurRadius: glow,
                spreadRadius: 1,
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: widget.child,
        );
      },
    );
  }
}
