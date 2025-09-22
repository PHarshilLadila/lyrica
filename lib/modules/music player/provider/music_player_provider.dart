// // // // import 'dart:async';
// // // // import 'dart:io';
// // // // import 'dart:math';
// // // // import 'package:audio_service/audio_service.dart';
// // // // import 'package:device_info_plus/device_info_plus.dart';
// // // // import 'package:external_path/external_path.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_downloader/flutter_downloader.dart';
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:just_audio/just_audio.dart';
// // // // import 'package:lyrica/model/music_model.dart';
// // // // import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// // // // import 'package:permission_handler/permission_handler.dart';
// // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // import 'package:lyrica/core/providers/provider.dart';

// // // // @pragma('vm:entry-point')
// // // // void downloadCallback(String? id, DownloadTaskStatus status, int progress) {
// // // //   if (id == null) return;
// // // //   final container = ProviderContainer();
// // // //   container.read(downloadProgressProvider(id).notifier).state = progress;
// // // // }

// // // // final downloadProgressProvider = StateProvider.family<int, String>(
// // // //   (ref, taskId) => 0,
// // // // );

// // // // class MusicPlayerState {
// // // //   final AudioPlayer audioPlayer;
// // // //   final int currentIndex;
// // // //   final bool isDownloading;
// // // //   final bool isSkipping;
// // // //   final bool dialogShown;
// // // //   final bool showDownloadComplete;
// // // //   final int lastDeductedMinute;
// // // //   final int currentRewardPoints;
// // // //   final String? currentDownloadTaskId;
// // // //   final String? downloadingFileName;

// // // //   MusicPlayerState({
// // // //     required this.audioPlayer,
// // // //     required this.currentIndex,
// // // //     this.isDownloading = false,
// // // //     this.isSkipping = false,
// // // //     this.dialogShown = false,
// // // //     this.showDownloadComplete = false,
// // // //     this.lastDeductedMinute = 0,
// // // //     this.currentRewardPoints = 0,
// // // //     this.currentDownloadTaskId,
// // // //     this.downloadingFileName,
// // // //   });

// // // //   MusicPlayerState copyWith({
// // // //     AudioPlayer? audioPlayer,
// // // //     int? currentIndex,
// // // //     bool? isDownloading,
// // // //     bool? isSkipping,
// // // //     bool? dialogShown,
// // // //     bool? showDownloadComplete,
// // // //     int? lastDeductedMinute,
// // // //     int? currentRewardPoints,
// // // //     String? currentDownloadTaskId,
// // // //     String? downloadingFileName,
// // // //   }) {
// // // //     return MusicPlayerState(
// // // //       audioPlayer: audioPlayer ?? this.audioPlayer,
// // // //       currentIndex: currentIndex ?? this.currentIndex,
// // // //       isDownloading: isDownloading ?? this.isDownloading,
// // // //       isSkipping: isSkipping ?? this.isSkipping,
// // // //       dialogShown: dialogShown ?? this.dialogShown,
// // // //       showDownloadComplete: showDownloadComplete ?? this.showDownloadComplete,
// // // //       lastDeductedMinute: lastDeductedMinute ?? this.lastDeductedMinute,
// // // //       currentRewardPoints: currentRewardPoints ?? this.currentRewardPoints,
// // // //       currentDownloadTaskId:
// // // //           currentDownloadTaskId ?? this.currentDownloadTaskId,
// // // //       downloadingFileName: downloadingFileName ?? this.downloadingFileName,
// // // //     );
// // // //   }
// // // // }

// // // // class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
// // // //   final List<Results> songList;
// // // //   final int initialIndex;
// // // //   final Ref ref;
// // // //   bool _mounted = true;
// // // //   bool _disposed = false;

// // // //   bool get isDisposed => _disposed;

// // // //   bool get mounted => _mounted;
// // // //   bool get isNotifierMounted {
// // // //     try {
// // // //       final currentState = state;
// // // //       return _mounted && currentState != null;
// // // //     } catch (e) {
// // // //       return false;
// // // //     }
// // // //   }

// // // //   late Stream<PlayerState> playerStateStream;
// // // //   final StreamController<Amplitude> _amplitudeController =
// // // //       StreamController<Amplitude>();

// // // //   Timer? _amplitudeTimer;
// // // //   Timer? _rewardTimer;
// // // //   bool _initialCheckDone = false;
// // // //   bool _isInitialized = false;

// // // //   StreamSubscription? _playerStateSubscription;
// // // //   StreamSubscription? _firestoreSubscription;

// // // //   MusicPlayerNotifier({
// // // //     required this.songList,
// // // //     required this.initialIndex,
// // // //     required this.ref,
// // // //   }) : super(
// // // //          MusicPlayerState(
// // // //            audioPlayer: AudioPlayer(),
// // // //            currentIndex: initialIndex,
// // // //          ),
// // // //        ) {
// // // //     try {
// // // //       playerStateStream = state.audioPlayer.playerStateStream;
// // // //       _initializePlayer();
// // // //       _listenRewardPoints();

// // // //       // Initialize the audio player properly
// // // //       WidgetsBinding.instance.addPostFrameCallback((_) {
// // // //         _isInitialized = true;
// // // //         initializeMusic();
// // // //       });
// // // //     } catch (e) {
// // // //       debugPrint('Error initializing MusicPlayerNotifier: $e');
// // // //       state = state.copyWith(audioPlayer: AudioPlayer());
// // // //       playerStateStream = state.audioPlayer.playerStateStream;
// // // //     }
// // // //   }

// // // //   Future<void> stop() async {
// // // //     try {
// // // //       await state.audioPlayer.stop();
// // // //       ref.read(currentMusicProvider.notifier).stop();
// // // //     } catch (e) {
// // // //       debugPrint('Error stopping music: $e');
// // // //     }
// // // //   }

// // // //   // Add this method to check if the provider is mounted before using it
// // // //   bool isMusicPlayerMounted(WidgetRef ref, List<Results> tracks, int index) {
// // // //     try {
// // // //       final providerFamily = musicPlayerProvider((
// // // //         songList: tracks,
// // // //         initialIndex: index,
// // // //       ));

// // // //       if (!ref.exists(providerFamily)) {
// // // //         return false;
// // // //       }

// // // //       final notifier = ref.read(providerFamily.notifier);
// // // //       // Check if the notifier is mounted (you might need to add this to your MusicPlayerNotifier)
// // // //       return notifier.mounted;
// // // //     } catch (e) {
// // // //       return false;
// // // //     }
// // // //   }

// // // //   // In MusicPlayerNotifier class
// // // //   Future<void> playSong(int index) async {
// // // //     await _loadSong(index);
// // // //   }

// // // //   Future<void> playSongDirectly(
// // // //     Results song,
// // // //     List<Results> playlist,
// // // //     int index,
// // // //   ) async {
// // // //     try {
// // // //       // Update current music state
// // // //       ref.read(currentMusicProvider.notifier).setMusic(song, playlist, index);

// // // //       // Load and play the song
// // // //       await _loadSong(index);
// // // //     } catch (e) {
// // // //       debugPrint('Error playing song directly: $e');
// // // //     }
// // // //   }

// // // //   void initializeMusic() {
// // // //     if (!_isInitialized &&
// // // //         songList.isNotEmpty &&
// // // //         initialIndex >= 0 &&
// // // //         initialIndex < songList.length) {
// // // //       // Use Future.microtask to defer the state update
// // // //       Future.microtask(() {
// // // //         ref
// // // //             .read(currentMusicProvider.notifier)
// // // //             .setMusic(songList[initialIndex], songList, initialIndex);
// // // //       });
// // // //       _isInitialized = true;
// // // //     }
// // // //   }

// // // //   Stream<Duration> get positionStream {
// // // //     return safeAccess(() => state.audioPlayer.positionStream) ??
// // // //         const Stream<Duration>.empty();
// // // //   }

// // // //   Stream<Duration?> get durationStream {
// // // //     if (!mounted) {
// // // //       return const Stream<Duration?>.empty();
// // // //     }
// // // //     return state.audioPlayer.durationStream;
// // // //   }

// // // //   Stream<Amplitude> get amplitudeStream {
// // // //     if (!mounted || _amplitudeController.isClosed) {
// // // //       return const Stream<Amplitude>.empty();
// // // //     }
// // // //     return _amplitudeController.stream;
// // // //   }

// // // //   void _initializePlayer() {
// // // //     _handleAudioPlayerErrors();
// // // //     _playerStateSubscription = state.audioPlayer.playerStateStream.listen((
// // // //       state,
// // // //     ) {
// // // //       if (state.processingState == ProcessingState.completed) {
// // // //         _autoPlayNextSong();
// // // //       }

// // // //       if (state.playing && state.processingState == ProcessingState.ready) {
// // // //         _startAmplitudeUpdates();
// // // //       } else {
// // // //         _stopAmplitudeUpdates();
// // // //       }
// // // //     });
// // // //   }

// // // //   void _autoPlayNextSong() {
// // // //     if (state.currentIndex < songList.length - 1) {
// // // //       final newIndex = state.currentIndex + 1;
// // // //       state = state.copyWith(currentIndex: newIndex);
// // // //       _loadSong(newIndex, isAutoPlay: true);
// // // //     }
// // // //   }

// // // //   void _startAmplitudeUpdates() {
// // // //     _amplitudeTimer?.cancel();
// // // //     final random = Random();

// // // //     _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
// // // //       final value = random.nextDouble();
// // // //       if (!_amplitudeController.isClosed) {
// // // //         _amplitudeController.add(
// // // //           Amplitude(max: value, min: value / 2, current: value),
// // // //         );
// // // //       }
// // // //     });
// // // //   }

// // // //   void _stopAmplitudeUpdates() {
// // // //     _amplitudeTimer?.cancel();
// // // //     _amplitudeTimer = null;
// // // //   }

// // // //   void _listenRewardPoints() {
// // // //     final user = ref.read(authStateProvider).asData?.value;
// // // //     if (user == null) return;

// // // //     _firestoreSubscription = FirebaseFirestore.instance
// // // //         .collection('users')
// // // //         .doc(user.uid)
// // // //         .snapshots()
// // // //         .listen((snap) {
// // // //           final points = (snap.data()?['rewardPoints'] ?? 0) as int;

// // // //           state = state.copyWith(currentRewardPoints: points);

// // // //           if (!_initialCheckDone) {
// // // //             _initialCheckDone = true;
// // // //             if (points > 0) {
// // // //               _loadSong(state.currentIndex);
// // // //               _startRewardTimer();
// // // //             } else {
// // // //               _stopMusicAndShowDialog();
// // // //             }
// // // //           } else {
// // // //             if (points <= 0 &&
// // // //                 state.audioPlayer.playing &&
// // // //                 !state.dialogShown) {
// // // //               _stopMusicAndShowDialog();
// // // //             } else if (points > 0 && state.dialogShown) {
// // // //               state = state.copyWith(dialogShown: false);
// // // //             }
// // // //           }
// // // //         });
// // // //   }

// // // //   void _startRewardTimer() {
// // // //     _rewardTimer?.cancel();
// // // //     state = state.copyWith(lastDeductedMinute: 0);

// // // //     _rewardTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
// // // //       if (!state.audioPlayer.playing || state.dialogShown || state.isSkipping) {
// // // //         return;
// // // //       }

// // // //       try {
// // // //         final position = state.audioPlayer.position;
// // // //         final playedMinutes = position.inMinutes;

// // // //         if (playedMinutes > state.lastDeductedMinute) {
// // // //           state = state.copyWith(lastDeductedMinute: playedMinutes);

// // // //           if (state.currentRewardPoints > 0) {
// // // //             await _deductRewardPoint();
// // // //           }

// // // //           if (state.currentRewardPoints <= 0) {
// // // //             await _stopMusicAndShowDialog();
// // // //           }
// // // //         }
// // // //       } catch (e) {
// // // //         debugPrint('Error in reward timer: $e');
// // // //       }
// // // //     });
// // // //   }

// // // //   Future<void> _deductRewardPoint() async {
// // // //     final user = ref.read(authStateProvider).asData?.value;
// // // //     if (user == null) return;
// // // //     final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
// // // //     try {
// // // //       await FirebaseFirestore.instance.runTransaction((transaction) async {
// // // //         final snapshot = await transaction.get(doc);
// // // //         final current = (snapshot.data()?['rewardPoints'] ?? 0) as int;
// // // //         if (current > 0) {
// // // //           transaction.update(doc, {'rewardPoints': current - 1});
// // // //         }
// // // //       });
// // // //     } catch (e) {
// // // //       debugPrint('Error deducting reward point: $e');
// // // //     }
// // // //   }

// // // //   Future<void> _stopMusicAndShowDialog() async {
// // // //     if (state.dialogShown) return;

// // // //     state = state.copyWith(dialogShown: true);
// // // //     try {
// // // //       if (state.audioPlayer.playing) {
// // // //         await state.audioPlayer.pause();
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error stopping music: $e');
// // // //     }

// // // //     _rewardTimer?.cancel();
// // // //     _rewardTimer = null;
// // // //   }

// // // //   // Add these methods to your MusicPlayerNotifier class
// // // //   Future<void> play() async {
// // // //     if (!isNotifierMounted) return;

// // // //     if (state.currentRewardPoints <= 0) {
// // // //       _stopMusicAndShowDialog();
// // // //       return;
// // // //     }

// // // //     try {
// // // //       if (AudioService.running) {
// // // //         await AudioService.play();
// // // //       } else {
// // // //         await state.audioPlayer.play();
// // // //       }
// // // //       ref.read(currentMusicProvider.notifier).setPlaying(true);
// // // //     } catch (e) {
// // // //       debugPrint('Error playing music: $e');
// // // //     }
// // // //   }

// // // //   Future<void> pause() async {
// // // //     if (!isNotifierMounted) return;

// // // //     try {
// // // //       if (AudioService.running) {
// // // //         await AudioService.pause();
// // // //       } else {
// // // //         await state.audioPlayer.pause();
// // // //       }
// // // //       ref.read(currentMusicProvider.notifier).setPlaying(false);
// // // //     } catch (e) {
// // // //       debugPrint('Error pausing music: $e');
// // // //     }
// // // //   }

// // // //   // Also add this method to get the AudioPlayer instance
// // // //   AudioPlayer getAudioPlayer() {
// // // //     return state.audioPlayer;
// // // //   }

// // // //   // Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
// // // //   //   try {
// // // //   //     await state.audioPlayer.stop();

// // // //   //     if (state.isSkipping) {
// // // //   //       state = state.copyWith(isSkipping: false);
// // // //   //     }

// // // //   //     if (!isAutoPlay && state.currentRewardPoints <= 0) {
// // // //   //       _stopMusicAndShowDialog();
// // // //   //       return;
// // // //   //     }

// // // //   //     final url = songList[index].audio;
// // // //   //     if (url != null) {
// // // //   //       debugPrint("$url is now playing");
// // // //   //       await state.audioPlayer.setUrl(url);
// // // //   //       await state.audioPlayer.play();
// // // //   //       debugPrint('Playing next song automatically');
// // // //   //     }

// // // //   //     state = state.copyWith(lastDeductedMinute: 0);
// // // //   //   } catch (e) {
// // // //   //     debugPrint('Error loading song: $e');
// // // //   //   }
// // // //   // }
// // // //   // Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
// // // //   //   try {
// // // //   //     await state.audioPlayer.stop();

// // // //   //     if (state.isSkipping) {
// // // //   //       state = state.copyWith(isSkipping: false);
// // // //   //     }

// // // //   //     if (!isAutoPlay && state.currentRewardPoints <= 0) {
// // // //   //       _stopMusicAndShowDialog();
// // // //   //       return;
// // // //   //     }

// // // //   //     final url = songList[index].audio;
// // // //   //     if (url != null) {
// // // //   //       debugPrint("$url is now playing");
// // // //   //       await state.audioPlayer.setUrl(url);

// // // //   //       // Update the current music state
// // // //   //       ref
// // // //   //           .read(currentMusicProvider.notifier)
// // // //   //           .setMusic(songList[index], songList, index);

// // // //   //       if (isAutoPlay || state.currentRewardPoints > 0) {
// // // //   //         await state.audioPlayer.play();
// // // //   //         debugPrint('Playing next song automatically');
// // // //   //       }
// // // //   //     }

// // // //   //     state = state.copyWith(lastDeductedMinute: 0);
// // // //   //   } catch (e) {
// // // //   //     debugPrint('Error loading song: $e');
// // // //   //   }
// // // //   // }

// // // //   //--------------------
// // // //   // Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
// // // //   //   if (!_mounted) {
// // // //   //     debugPrint('MusicPlayerNotifier is disposed, skipping _loadSong');
// // // //   //     return;
// // // //   //   }

// // // //   //   try {
// // // //   //     // Check if audio player is properly initialized
// // // //   //     if (state.audioPlayer == null) {
// // // //   //       debugPrint('Audio player is null, reinitializing...');
// // // //   //       state = state.copyWith(audioPlayer: AudioPlayer());
// // // //   //       _initializePlayer();
// // // //   //     }

// // // //   //     // Stop current playback if any
// // // //   //     try {
// // // //   //       await state.audioPlayer.stop();
// // // //   //     } catch (e) {
// // // //   //       debugPrint('Error stopping audio: $e');
// // // //   //     }

// // // //   //     if (state.isSkipping) {
// // // //   //       state = state.copyWith(isSkipping: false);
// // // //   //     }

// // // //   //     if (!isAutoPlay && state.currentRewardPoints <= 0) {
// // // //   //       _stopMusicAndShowDialog();
// // // //   //       return;
// // // //   //     }

// // // //   //     final song = songList[index];
// // // //   //     final url = song.audio;

// // // //   //     // Check if URL is valid
// // // //   //     if (url == null || url.isEmpty) {
// // // //   //       debugPrint('Error: Audio URL is null or empty for song: ${song.name}');
// // // //   //       return;
// // // //   //     }

// // // //   //     debugPrint("$url is now playing");

// // // //   //     // Set the URL and handle potential errors
// // // //   //     try {
// // // //   //       await state.audioPlayer.setUrl(url);
// // // //   //     } catch (e) {
// // // //   //       debugPrint('Error setting URL: $e');
// // // //   //       // Reinitialize audio player if there's an error
// // // //   //       state = state.copyWith(audioPlayer: AudioPlayer());
// // // //   //       _initializePlayer();
// // // //   //       return;
// // // //   //     }

// // // //   //     // Update the current music state
// // // //   //     ref.read(currentMusicProvider.notifier).setMusic(song, songList, index);

// // // //   //     if (isAutoPlay || state.currentRewardPoints > 0) {
// // // //   //       try {
// // // //   //         await state.audioPlayer.play();
// // // //   //         debugPrint('Playing song at index: $index');
// // // //   //       } catch (e) {
// // // //   //         debugPrint('Error playing song: $e');
// // // //   //       }
// // // //   //     }

// // // //   //     state = state.copyWith(lastDeductedMinute: 0);
// // // //   //   } catch (e) {
// // // //   //     debugPrint('Error loading song: $e');
// // // //   //     debugPrint(
// // // //   //       'Audio player state: ${state.audioPlayer != null ? "initialized" : "null"}',
// // // //   //     );
// // // //   //   }
// // // //   // }
// // // //   //----------------------

// // // //   Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
// // // //     if (!_mounted) {
// // // //       debugPrint('MusicPlayerNotifier is disposed, skipping _loadSong');
// // // //       return;
// // // //     }

// // // //     try {
// // // //       // Stop current playback
// // // //       try {
// // // //         await state.audioPlayer.stop();
// // // //       } catch (e) {
// // // //         debugPrint('Error stopping audio: $e');
// // // //       }

// // // //       if (state.isSkipping) {
// // // //         state = state.copyWith(isSkipping: false);
// // // //       }

// // // //       if (!isAutoPlay && state.currentRewardPoints <= 0) {
// // // //         _stopMusicAndShowDialog();
// // // //         return;
// // // //       }

// // // //       final song = songList[index];
// // // //       final url = song.audio;

// // // //       if (url == null || url.isEmpty) {
// // // //         debugPrint('Error: Audio URL is null or empty for song: ${song.name}');
// // // //         return;
// // // //       }

// // // //       debugPrint("$url is now playing");

// // // //       // Update AudioService with the new playlist and song
// // // //       await AudioService.customAction('set_playlist', {
// // // //         'songs': songList,
// // // //         'index': index,
// // // //       });

// // // //       // Update the current music state
// // // //       ref.read(currentMusicProvider.notifier).setMusic(song, songList, index);

// // // //       if (isAutoPlay || state.currentRewardPoints > 0) {
// // // //         try {
// // // //           await AudioService.play();
// // // //           debugPrint('Playing song through AudioService');
// // // //         } catch (e) {
// // // //           debugPrint('Error playing song through AudioService: $e');
// // // //           // Fallback to local player
// // // //           try {
// // // //             await state.audioPlayer.setUrl(url);
// // // //             await state.audioPlayer.play();
// // // //             debugPrint('Playing song through local player');
// // // //           } catch (e) {
// // // //             debugPrint('Error playing song through local player: $e');
// // // //           }
// // // //         }
// // // //       }

// // // //       state = state.copyWith(lastDeductedMinute: 0);
// // // //     } catch (e) {
// // // //       debugPrint('Error loading song: $e');
// // // //     }
// // // //   }

// // // //   void _handleAudioPlayerErrors() {
// // // //     state.audioPlayer.playbackEventStream.listen(
// // // //       (event) {},
// // // //       onError: (e) {
// // // //         debugPrint('Audio player error: $e');
// // // //         // Reinitialize audio player on error
// // // //         state = state.copyWith(audioPlayer: AudioPlayer());
// // // //         _initializePlayer();
// // // //       },
// // // //     );
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     if (_disposed) return;
// // // //     _disposed = true;

// // // //     _mounted = false;

// // // //     _rewardTimer?.cancel();
// // // //     _amplitudeTimer?.cancel();
// // // //     _playerStateSubscription?.cancel();
// // // //     _firestoreSubscription?.cancel();

// // // //     try {
// // // //       if (!_amplitudeController.isClosed) {
// // // //         _amplitudeController.close();
// // // //       }
// // // //       AudioService.stop();

// // // //       // Only dispose audio player if it's still valid
// // // //       state.audioPlayer.dispose();
// // // //     } catch (e) {
// // // //       debugPrint('Error disposing resources: $e');
// // // //     }

// // // //     super.dispose();
// // // //   }

// // // //   T? safeAccess<T>(T Function() action) {
// // // //     if (_disposed) return null;
// // // //     try {
// // // //       return action();
// // // //     } catch (e) {
// // // //       return null;
// // // //     }
// // // //   }

// // // //   Future<void> playPause() async {
// // // //     if (!isNotifierMounted) return;

// // // //     if (state.currentRewardPoints <= 0) {
// // // //       _stopMusicAndShowDialog();
// // // //       return;
// // // //     }

// // // //     try {
// // // //       if (AudioService.playbackState.playing) {
// // // //         await AudioService.pause();
// // // //       } else {
// // // //         await AudioService.play();
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error in play/pause: $e');
// // // //       // Fallback to local player
// // // //       if (state.audioPlayer.playing) {
// // // //         await state.audioPlayer.pause();
// // // //       } else {
// // // //         await state.audioPlayer.play();
// // // //       }
// // // //     }
// // // //   }

// // // //   void nextSong() {
// // // //     if (!isNotifierMounted) return;

// // // //     if (state.currentIndex < songList.length - 1) {
// // // //       final newIndex = state.currentIndex + 1;
// // // //       state = state.copyWith(currentIndex: newIndex, isSkipping: true);
// // // //       _loadSong(newIndex);
// // // //     }
// // // //   }

// // // //   void previousSong() {
// // // //     if (state.currentIndex > 0) {
// // // //       final newIndex = state.currentIndex - 1;
// // // //       state = state.copyWith(currentIndex: newIndex, isSkipping: true);
// // // //       _loadSong(newIndex);
// // // //     }
// // // //   }

// // // //   void seek(double value) {
// // // //     try {
// // // //       state.audioPlayer.seek(Duration(seconds: value.toInt()));
// // // //     } catch (e) {
// // // //       debugPrint('Error seeking: $e');
// // // //     }
// // // //   }

// // // //   String formatDuration(Duration duration) {
// // // //     final minutes = duration.inMinutes.toString().padLeft(2, '0');
// // // //     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
// // // //     return '$minutes:$seconds';
// // // //   }

// // // //   Future<bool> _checkStoragePermission() async {
// // // //     if (Platform.isAndroid) {
// // // //       final androidInfo = await DeviceInfoPlugin().androidInfo;
// // // //       final sdkInt = androidInfo.version.sdkInt;

// // // //       if (sdkInt >= 33) {
// // // //         final audioStatus = await Permission.audio.request();
// // // //         return audioStatus.isGranted;
// // // //       } else if (sdkInt >= 30) {
// // // //         final manageStatus = await Permission.manageExternalStorage.request();
// // // //         return manageStatus.isGranted;
// // // //       } else {
// // // //         final storageStatus = await Permission.storage.request();
// // // //         return storageStatus.isGranted;
// // // //       }
// // // //     }
// // // //     return true;
// // // //   }

// // // //   Future<void> startDownloadWithLoading(
// // // //     String musicUrl,
// // // //     String musicName,
// // // //   ) async {
// // // //     if (state.isDownloading) return;

// // // //     state = state.copyWith(isDownloading: true);
// // // //     await _startDownload(musicUrl, musicName);
// // // //   }

// // // //   Future<void> _startDownload(String musicUrl, String musicName) async {
// // // //     final hasPermission = await _checkStoragePermission();

// // // //     if (!hasPermission) {
// // // //       state = state.copyWith(isDownloading: false);
// // // //       return;
// // // //     }

// // // //     final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
// // // //       ExternalPath.DIRECTORY_DOWNLOAD,
// // // //     );

// // // //     final sanitizedFileName = musicName.replaceAll(
// // // //       RegExp(r'[\\/:*?"<>|]'),
// // // //       "_",
// // // //     );

// // // //     try {
// // // //       final taskId = await FlutterDownloader.enqueue(
// // // //         url: musicUrl,
// // // //         savedDir: downloadPath,
// // // //         fileName: '$sanitizedFileName.mp3',
// // // //         showNotification: true,
// // // //         saveInPublicStorage: true,
// // // //         openFileFromNotification: true,
// // // //       );

// // // //       if (taskId == null) throw Exception("Download failed");

// // // //       state = state.copyWith(
// // // //         currentDownloadTaskId: taskId,
// // // //         downloadingFileName: musicName,
// // // //       );
// // // //     } catch (e) {
// // // //       debugPrint("Download error: $e");
// // // //       state = state.copyWith(isDownloading: false);
// // // //     }
// // // //   }

// // // //   void resetDownloadComplete() {
// // // //     state = state.copyWith(showDownloadComplete: false);
// // // //   }

// // // //   // @override
// // // //   // void dispose() {
// // // //   //   ref.read(currentMusicProvider.notifier).stop();

// // // //   //   _rewardTimer?.cancel();
// // // //   //   _amplitudeTimer?.cancel();
// // // //   //   _playerStateSubscription?.cancel();
// // // //   //   _firestoreSubscription?.cancel();

// // // //   //   try {
// // // //   //     if (!_amplitudeController.isClosed) {
// // // //   //       _amplitudeController.close();
// // // //   //     }
// // // //   //     state.audioPlayer.dispose();
// // // //   //   } catch (e) {
// // // //   //     debugPrint('Error disposing resources: $e');
// // // //   //   }

// // // //   //   super.dispose();
// // // //   // }
// // // // }

// // // // // final musicPlayerProvider = StateNotifierProvider.autoDispose.family<
// // // // //   MusicPlayerNotifier,
// // // // //   MusicPlayerState,
// // // // //   ({List<Results> songList, int initialIndex})
// // // // // >((ref, args) {
// // // // //   return MusicPlayerNotifier(
// // // // //     songList: args.songList,
// // // // //     initialIndex: args.initialIndex,
// // // // //     ref: ref,
// // // // //   )..addListener((state) {
// // // // //     if (state.dialogShown) {
// // // // //       ref.read(dialogShownProvider.notifier).state = true;
// // // // //     }
// // // // //   });
// // // // // });// music_player_provider.dart
// // // // // music_player_provider.dart
// // // // // music_player_provider.dart
// // // // final musicPlayerProvider = StateNotifierProvider.autoDispose.family<
// // // //   MusicPlayerNotifier,
// // // //   MusicPlayerState,
// // // //   ({List<Results> songList, int initialIndex})
// // // // >((ref, args) {
// // // //   final notifier = MusicPlayerNotifier(
// // // //     songList: args.songList,
// // // //     initialIndex: args.initialIndex,
// // // //     ref: ref,
// // // //   );
// // // //   // Add auto-dispose logic
// // // //   // ref.onDispose(() {
// // // //   //   if (notifier.mounted) {
// // // //   //     notifier.dispose();
// // // //   //   }
// // // //   // });

// // // //   return notifier;
// // // // });
// // // // final dialogShownProvider = StateProvider<bool>((ref) => false);

// // // // class Amplitude {
// // // //   final double min;
// // // //   final double max;
// // // //   final double? current;

// // // //   Amplitude({required this.min, required this.max, this.current});
// // // // }

// // // // // class FavoriteProvider with ChangeNotifier {
// // // // //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // // // //   final FirebaseAuth _auth = FirebaseAuth.instance;

// // // // //   List<Map<String, dynamic>> _favorites = [];

// // // // //   List<Map<String, dynamic>> get favorites => _favorites;

// // // // //   Future<void> fetchFavorites() async {
// // // // //     try {
// // // // //       final user = _auth.currentUser;
// // // // //       if (user == null) return;

// // // // //       final snapshot =
// // // // //           await _firestore
// // // // //               .collection('users')
// // // // //               .doc(user.uid)
// // // // //               .collection('favorites')
// // // // //               .get();

// // // // //       _favorites = snapshot.docs.map((doc) => doc.data()).toList();
// // // // //       notifyListeners();
// // // // //     } catch (e) {
// // // // //       debugPrint('Error fetching favorites: $e');
// // // // //     }
// // // // //   }

// // // // //   Future<void> toggleFavorite(Map<String, dynamic> song) async {
// // // // //     try {
// // // // //       final user = _auth.currentUser;
// // // // //       if (user == null) return;

// // // // //       final favoritesRef = _firestore
// // // // //           .collection('users')
// // // // //           .doc(user.uid)
// // // // //           .collection('favorites')
// // // // //           .doc(song['id'].toString());

// // // // //       final doc = await favoritesRef.get();

// // // // //       if (doc.exists) {
// // // // //         await favoritesRef.delete();
// // // // //         _favorites.removeWhere((s) => s['id'] == song['id']);
// // // // //       } else {
// // // // //         await favoritesRef.set(song);
// // // // //         _favorites.add(song);
// // // // //       }

// // // // //       notifyListeners();
// // // // //     } catch (e) {
// // // // //       debugPrint('Error toggling favorite: $e');
// // // // //     }
// // // // //   }

// // // // //   bool isFavorite(String id) {
// // // // //     return _favorites.any((s) => s['id'] == id);
// // // // //   }
// // // // // }
// // // // // class FavoriteProvider with ChangeNotifier {
// // // // //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // // // //   final FirebaseAuth _auth = FirebaseAuth.instance;

// // // // //   List<Map<String, dynamic>> _favorites = [];
// // // // //   bool _isLoading = false;

// // // // //   List<Map<String, dynamic>> get favorites => _favorites;
// // // // //   bool get isLoading => _isLoading;

// // // // //   void _setLoading(bool value) {
// // // // //     _isLoading = value;
// // // // //     notifyListeners();
// // // // //   }

// // // // //   Future<void> fetchFavorites() async {
// // // // //     try {
// // // // //       final user = _auth.currentUser;
// // // // //       if (user == null) return;

// // // // //       _setLoading(true);
// // // // //       final snapshot =
// // // // //           await _firestore
// // // // //               .collection('users')
// // // // //               .doc(user.uid)
// // // // //               .collection('favorites')
// // // // //               .get();

// // // // //       _favorites = snapshot.docs.map((doc) => doc.data()).toList();
// // // // //     } catch (e) {
// // // // //       debugPrint('Error fetching favorites: $e');
// // // // //     } finally {
// // // // //       _setLoading(false);
// // // // //     }
// // // // //   }

// // // // //   Future<void> toggleFavorite(Map<String, dynamic> song) async {
// // // // //     try {
// // // // //       final user = _auth.currentUser;
// // // // //       if (user == null) return;

// // // // //       _setLoading(true);

// // // // //       final favoritesRef = _firestore
// // // // //           .collection('users')
// // // // //           .doc(user.uid)
// // // // //           .collection('favorites')
// // // // //           .doc(song['id'].toString());

// // // // //       final doc = await favoritesRef.get();

// // // // //       if (doc.exists) {
// // // // //         await favoritesRef.delete();
// // // // //         _favorites.removeWhere((s) => s['id'] == song['id']);
// // // // //       } else {
// // // // //         await favoritesRef.set(song);
// // // // //         _favorites.add(song);
// // // // //       }
// // // // //     } catch (e) {
// // // // //       debugPrint('Error toggling favorite: $e');
// // // // //     } finally {
// // // // //       _setLoading(false);
// // // // //     }
// // // // //   }

// // // // //   bool isFavorite(String id) {
// // // // //     return _favorites.any((s) => s['id'] == id);
// // // // //   }
// // // // // }
// // // // class FavoriteProvider with ChangeNotifier {
// // // //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // // //   final FirebaseAuth _auth = FirebaseAuth.instance;

// // // //   List<Map<String, dynamic>> _favorites = [];
// // // //   Set<String> _loadingSongIds = {}; // track which song is being processed

// // // //   List<Map<String, dynamic>> get favorites => _favorites;
// // // //   bool isLoading(String songId) => _loadingSongIds.contains(songId);

// // // //   Future<void> fetchFavorites() async {
// // // //     try {
// // // //       final user = _auth.currentUser;
// // // //       if (user == null) return;

// // // //       final snapshot =
// // // //           await _firestore
// // // //               .collection('users')
// // // //               .doc(user.uid)
// // // //               .collection('favorites')
// // // //               .get();

// // // //       _favorites = snapshot.docs.map((doc) => doc.data()).toList();
// // // //       notifyListeners();
// // // //     } catch (e) {
// // // //       debugPrint('Error fetching favorites: $e');
// // // //     }
// // // //   }

// // // //   Future<void> toggleFavorite(Map<String, dynamic> song) async {
// // // //     try {
// // // //       final user = _auth.currentUser;
// // // //       if (user == null) return;

// // // //       _loadingSongIds.add(song['id']);
// // // //       notifyListeners();

// // // //       final favoritesRef = _firestore
// // // //           .collection('users')
// // // //           .doc(user.uid)
// // // //           .collection('favorites')
// // // //           .doc(song['id'].toString());

// // // //       final doc = await favoritesRef.get();

// // // //       if (doc.exists) {
// // // //         await favoritesRef.delete();
// // // //         _favorites.removeWhere((s) => s['id'] == song['id']);
// // // //       } else {
// // // //         await favoritesRef.set(song);
// // // //         _favorites.add(song);
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint('Error toggling favorite: $e');
// // // //     } finally {
// // // //       _loadingSongIds.remove(song['id']);
// // // //       notifyListeners();
// // // //     }
// // // //   }

// // // //   bool isFavorite(String id) {
// // // //     return _favorites.any((s) => s['id'] == id);
// // // //   }
// // // // }

// // // // final activeMusicPlayerProvider = StateProvider<MusicPlayerNotifier?>(
// // // //   (ref) => null,
// // // // );

// // // // // Update the getCurrentMusicPlayer function:

// // // // MusicPlayerNotifier? getCurrentMusicPlayer(WidgetRef ref) {
// // // //   try {
// // // //     final currentMusicState = ref.read(currentMusicProvider);

// // // //     if (currentMusicState.playlist.isEmpty ||
// // // //         currentMusicState.currentSong == null) {
// // // //       return null;
// // // //     }

// // // //     // Try to get the active player first
// // // //     final activePlayer = ref.read(activeMusicPlayerProvider);
// // // //     if (activePlayer != null && activePlayer.mounted) {
// // // //       return activePlayer;
// // // //     }

// // // //     // If no active player, create a new one
// // // //     final providerFamily = musicPlayerProvider((
// // // //       songList: currentMusicState.playlist,
// // // //       initialIndex: currentMusicState.currentIndex,
// // // //     ));

// // // //     if (!ref.exists(providerFamily)) {
// // // //       return null;
// // // //     }

// // // //     final notifier = ref.read(providerFamily.notifier);
// // // //     if (!notifier.mounted) return null;

// // // //     // Check if the notifier is still mounted before using it
// // // //     if (!notifier.mounted) {
// // // //       return null;
// // // //     }

// // // //     // Set this as the active player
// // // //     ref.read(activeMusicPlayerProvider.notifier).state = notifier;

// // // //     return notifier;
// // // //   } catch (e) {
// // // //     debugPrint("Error getting music player: $e");
// // // //     return null;
// // // //   }
// // // // }
// // // // music_player_provider.dart - FIXED VERSION

// // // import 'dart:async';
// // // import 'dart:io';
// // // import 'dart:math';
// // // import 'package:device_info_plus/device_info_plus.dart';
// // // import 'package:external_path/external_path.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_downloader/flutter_downloader.dart';
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:just_audio/just_audio.dart';
// // // import 'package:lyrica/model/music_model.dart';
// // // import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:lyrica/core/providers/provider.dart';

// // // @pragma('vm:entry-point')
// // // void downloadCallback(String? id, DownloadTaskStatus status, int progress) {
// // //   if (id == null) return;
// // //   final container = ProviderContainer();
// // //   container.read(downloadProgressProvider(id).notifier).state = progress;
// // // }

// // // final downloadProgressProvider = StateProvider.family<int, String>(
// // //   (ref, taskId) => 0,
// // // );

// // // class MusicPlayerState {
// // //   final AudioPlayer audioPlayer;
// // //   final int currentIndex;
// // //   final bool isDownloading;
// // //   final bool isSkipping;
// // //   final bool dialogShown;
// // //   final bool showDownloadComplete;
// // //   final int lastDeductedMinute;
// // //   final int currentRewardPoints;
// // //   final String? currentDownloadTaskId;
// // //   final String? downloadingFileName;
// // //   final bool isInitialized;

// // //   MusicPlayerState({
// // //     required this.audioPlayer,
// // //     required this.currentIndex,
// // //     this.isDownloading = false,
// // //     this.isSkipping = false,
// // //     this.dialogShown = false,
// // //     this.showDownloadComplete = false,
// // //     this.lastDeductedMinute = 0,
// // //     this.currentRewardPoints = 0,
// // //     this.currentDownloadTaskId,
// // //     this.downloadingFileName,
// // //     this.isInitialized = false,
// // //   });

// // //   MusicPlayerState copyWith({
// // //     AudioPlayer? audioPlayer,
// // //     int? currentIndex,
// // //     bool? isDownloading,
// // //     bool? isSkipping,
// // //     bool? dialogShown,
// // //     bool? showDownloadComplete,
// // //     int? lastDeductedMinute,
// // //     int? currentRewardPoints,
// // //     String? currentDownloadTaskId,
// // //     String? downloadingFileName,
// // //     bool? isInitialized,
// // //   }) {
// // //     return MusicPlayerState(
// // //       audioPlayer: audioPlayer ?? this.audioPlayer,
// // //       currentIndex: currentIndex ?? this.currentIndex,
// // //       isDownloading: isDownloading ?? this.isDownloading,
// // //       isSkipping: isSkipping ?? this.isSkipping,
// // //       dialogShown: dialogShown ?? this.dialogShown,
// // //       showDownloadComplete: showDownloadComplete ?? this.showDownloadComplete,
// // //       lastDeductedMinute: lastDeductedMinute ?? this.lastDeductedMinute,
// // //       currentRewardPoints: currentRewardPoints ?? this.currentRewardPoints,
// // //       currentDownloadTaskId:
// // //           currentDownloadTaskId ?? this.currentDownloadTaskId,
// // //       downloadingFileName: downloadingFileName ?? this.downloadingFileName,
// // //       isInitialized: isInitialized ?? this.isInitialized,
// // //     );
// // //   }
// // // }

// // // class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
// // //   final List<Results> songList;
// // //   final int initialIndex;
// // //   final Ref ref;
// // //   bool _mounted = true;
// // //   bool _disposed = false;

// // //   bool get isDisposed => _disposed;
// // //   bool get mounted => _mounted;

// // //   bool get isNotifierMounted {
// // //     try {
// // //       final currentState = state;
// // //       return _mounted && currentState != null;
// // //     } catch (e) {
// // //       return false;
// // //     }
// // //   }

// // //   late Stream<PlayerState> playerStateStream;
// // //   final StreamController<Amplitude> _amplitudeController =
// // //       StreamController<Amplitude>();

// // //   Timer? _amplitudeTimer;
// // //   Timer? _rewardTimer;
// // //   bool _initialCheckDone = false;

// // //   StreamSubscription? _playerStateSubscription;
// // //   StreamSubscription? _firestoreSubscription;

// // //   MusicPlayerNotifier({
// // //     required this.songList,
// // //     required this.initialIndex,
// // //     required this.ref,
// // //   }) : super(
// // //          MusicPlayerState(
// // //            audioPlayer: AudioPlayer(),
// // //            currentIndex: initialIndex,
// // //          ),
// // //        ) {
// // //     try {
// // //       playerStateStream = state.audioPlayer.playerStateStream;
// // //       _initializePlayer();
// // //       _listenRewardPoints();
// // //     } catch (e) {
// // //       debugPrint('Error initializing MusicPlayerNotifier: $e');
// // //       state = state.copyWith(audioPlayer: AudioPlayer());
// // //       playerStateStream = state.audioPlayer.playerStateStream;
// // //     }
// // //   }

// // //   // Initialize music - FIXED
// // //   void initializeMusic() {
// // //     if (songList.isNotEmpty &&
// // //         initialIndex >= 0 &&
// // //         initialIndex < songList.length) {
// // //       // Update current music state immediately
// // //       ref
// // //           .read(currentMusicProvider.notifier)
// // //           .setMusic(songList[initialIndex], songList, initialIndex);

// // //       // Mark as initialized and load the song
// // //       state = state.copyWith(isInitialized: true);

// // //       // Load the initial song after a brief delay to ensure everything is set up
// // //       Future.delayed(const Duration(milliseconds: 100), () {
// // //         if (mounted) {
// // //           _loadSong(initialIndex);
// // //         }
// // //       });
// // //     }
// // //   }

// // //   Stream<Duration> get positionStream {
// // //     return safeAccess(() => state.audioPlayer.positionStream) ??
// // //         const Stream<Duration>.empty();
// // //   }

// // //   Stream<Duration?> get durationStream {
// // //     if (!mounted) return const Stream<Duration?>.empty();
// // //     return state.audioPlayer.durationStream;
// // //   }

// // //   Stream<Amplitude> get amplitudeStream {
// // //     if (!mounted || _amplitudeController.isClosed) {
// // //       return const Stream<Amplitude>.empty();
// // //     }
// // //     return _amplitudeController.stream;
// // //   }

// // //   void _initializePlayer() {
// // //     _handleAudioPlayerErrors();
// // //     _playerStateSubscription = state.audioPlayer.playerStateStream.listen((
// // //       playerState,
// // //     ) {
// // //       if (playerState.processingState == ProcessingState.completed) {
// // //         _autoPlayNextSong();
// // //       }

// // //       if (playerState.playing &&
// // //           playerState.processingState == ProcessingState.ready) {
// // //         _startAmplitudeUpdates();
// // //         // Update current music provider playing state
// // //         ref.read(currentMusicProvider.notifier).setPlaying(true);
// // //       } else {
// // //         _stopAmplitudeUpdates();
// // //         ref.read(currentMusicProvider.notifier).setPlaying(false);
// // //       }
// // //     });
// // //   }

// // //   void _autoPlayNextSong() {
// // //     if (state.currentIndex < songList.length - 1) {
// // //       final newIndex = state.currentIndex + 1;
// // //       state = state.copyWith(currentIndex: newIndex);
// // //       _loadSong(newIndex, isAutoPlay: true);
// // //     }
// // //   }

// // //   void _startAmplitudeUpdates() {
// // //     _amplitudeTimer?.cancel();
// // //     final random = Random();

// // //     _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
// // //       final value = random.nextDouble();
// // //       if (!_amplitudeController.isClosed) {
// // //         _amplitudeController.add(
// // //           Amplitude(max: value, min: value / 2, current: value),
// // //         );
// // //       }
// // //     });
// // //   }

// // //   void _stopAmplitudeUpdates() {
// // //     _amplitudeTimer?.cancel();
// // //     _amplitudeTimer = null;
// // //   }

// // //   void _listenRewardPoints() {
// // //     final user = ref.read(authStateProvider).asData?.value;
// // //     if (user == null) return;

// // //     _firestoreSubscription = FirebaseFirestore.instance
// // //         .collection('users')
// // //         .doc(user.uid)
// // //         .snapshots()
// // //         .listen((snap) {
// // //           final points = (snap.data()?['rewardPoints'] ?? 0) as int;
// // //           state = state.copyWith(currentRewardPoints: points);

// // //           if (!_initialCheckDone) {
// // //             _initialCheckDone = true;
// // //             if (points > 0) {
// // //               // Only start reward timer after first successful load
// // //               _startRewardTimer();
// // //             } else {
// // //               _stopMusicAndShowDialog();
// // //             }
// // //           } else {
// // //             if (points <= 0 &&
// // //                 state.audioPlayer.playing &&
// // //                 !state.dialogShown) {
// // //               _stopMusicAndShowDialog();
// // //             } else if (points > 0 && state.dialogShown) {
// // //               state = state.copyWith(dialogShown: false);
// // //             }
// // //           }
// // //         });
// // //   }

// // //   void _startRewardTimer() {
// // //     _rewardTimer?.cancel();
// // //     state = state.copyWith(lastDeductedMinute: 0);

// // //     _rewardTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
// // //       if (!state.audioPlayer.playing || state.dialogShown || state.isSkipping) {
// // //         return;
// // //       }

// // //       try {
// // //         final position = state.audioPlayer.position;
// // //         final playedMinutes = position.inMinutes;

// // //         if (playedMinutes > state.lastDeductedMinute) {
// // //           state = state.copyWith(lastDeductedMinute: playedMinutes);

// // //           if (state.currentRewardPoints > 0) {
// // //             await _deductRewardPoint();
// // //           }

// // //           if (state.currentRewardPoints <= 0) {
// // //             await _stopMusicAndShowDialog();
// // //           }
// // //         }
// // //       } catch (e) {
// // //         debugPrint('Error in reward timer: $e');
// // //       }
// // //     });
// // //   }

// // //   Future<void> _deductRewardPoint() async {
// // //     final user = ref.read(authStateProvider).asData?.value;
// // //     if (user == null) return;
// // //     final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
// // //     try {
// // //       await FirebaseFirestore.instance.runTransaction((transaction) async {
// // //         final snapshot = await transaction.get(doc);
// // //         final current = (snapshot.data()?['rewardPoints'] ?? 0) as int;
// // //         if (current > 0) {
// // //           transaction.update(doc, {'rewardPoints': current - 1});
// // //         }
// // //       });
// // //     } catch (e) {
// // //       debugPrint('Error deducting reward point: $e');
// // //     }
// // //   }

// // //   Future<void> _stopMusicAndShowDialog() async {
// // //     if (state.dialogShown) return;

// // //     state = state.copyWith(dialogShown: true);
// // //     try {
// // //       if (state.audioPlayer.playing) {
// // //         await state.audioPlayer.pause();
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error stopping music: $e');
// // //     }

// // //     _rewardTimer?.cancel();
// // //     _rewardTimer = null;

// // //     // Trigger dialog
// // //     ref.read(dialogShownProvider.notifier).state = true;
// // //   }

// // //   // FIXED: Main song loading method
// // //   Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
// // //     if (!_mounted) {
// // //       debugPrint('MusicPlayerNotifier is disposed, skipping _loadSong');
// // //       return;
// // //     }

// // //     if (index < 0 || index >= songList.length) {
// // //       debugPrint('Invalid song index: $index');
// // //       return;
// // //     }

// // //     try {
// // //       // Stop current playback
// // //       try {
// // //         await state.audioPlayer.stop();
// // //       } catch (e) {
// // //         debugPrint('Error stopping audio: $e');
// // //       }

// // //       if (state.isSkipping) {
// // //         state = state.copyWith(isSkipping: false);
// // //       }

// // //       // Check reward points for non-auto play
// // //       if (!isAutoPlay && state.currentRewardPoints <= 0) {
// // //         _stopMusicAndShowDialog();
// // //         return;
// // //       }

// // //       final song = songList[index];
// // //       final url = song.audio;

// // //       if (url == null || url.isEmpty) {
// // //         debugPrint('Error: Audio URL is null or empty for song: ${song.name}');
// // //         return;
// // //       }

// // //       debugPrint("Loading song: ${song.name} from URL: $url");

// // //       // Update current music state BEFORE setting audio source
// // //       ref.read(currentMusicProvider.notifier).setMusic(song, songList, index);

// // //       // Set audio source
// // //       await state.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));

// // //       // Auto-play if conditions are met
// // //       if (isAutoPlay || state.currentRewardPoints > 0) {
// // //         await state.audioPlayer.play();
// // //         debugPrint('Successfully started playing song: ${song.name}');
// // //       }

// // //       // Update state
// // //       state = state.copyWith(currentIndex: index, lastDeductedMinute: 0);
// // //     } catch (e) {
// // //       debugPrint('Error loading song: $e');
// // //       // Try to recover by reinitializing the audio player
// // //       try {
// // //         await state.audioPlayer.dispose();
// // //         state = state.copyWith(audioPlayer: AudioPlayer());
// // //         _initializePlayer();
// // //       } catch (disposeError) {
// // //         debugPrint('Error reinitializing player: $disposeError');
// // //       }
// // //     }
// // //   }

// // //   void _handleAudioPlayerErrors() {
// // //     state.audioPlayer.playbackEventStream.listen(
// // //       (event) {
// // //         // Handle playback events
// // //       },
// // //       onError: (e) {
// // //         debugPrint('Audio player error: $e');
// // //         // Try to recover
// // //         Future.delayed(const Duration(milliseconds: 500), () {
// // //           if (mounted) {
// // //             _reinitializePlayer();
// // //           }
// // //         });
// // //       },
// // //     );
// // //   }

// // //   Future<void> _reinitializePlayer() async {
// // //     try {
// // //       await state.audioPlayer.dispose();
// // //       state = state.copyWith(audioPlayer: AudioPlayer());
// // //       _initializePlayer();
// // //     } catch (e) {
// // //       debugPrint('Error reinitializing player: $e');
// // //     }
// // //   }

// // //   T? safeAccess<T>(T Function() action) {
// // //     if (_disposed) return null;
// // //     try {
// // //       return action();
// // //     } catch (e) {
// // //       return null;
// // //     }
// // //   }

// // //   // FIXED: Play/Pause method
// // //   Future<void> playPause() async {
// // //     if (!isNotifierMounted) return;

// // //     if (state.currentRewardPoints <= 0) {
// // //       _stopMusicAndShowDialog();
// // //       return;
// // //     }

// // //     try {
// // //       if (state.audioPlayer.playing) {
// // //         await state.audioPlayer.pause();
// // //         ref.read(currentMusicProvider.notifier).setPlaying(false);
// // //       } else {
// // //         await state.audioPlayer.play();
// // //         ref.read(currentMusicProvider.notifier).setPlaying(true);
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error in play/pause: $e');
// // //     }
// // //   }

// // //   void nextSong() {
// // //     if (!isNotifierMounted) return;

// // //     if (state.currentIndex < songList.length - 1) {
// // //       final newIndex = state.currentIndex + 1;
// // //       state = state.copyWith(currentIndex: newIndex, isSkipping: true);
// // //       _loadSong(newIndex);
// // //     }
// // //   }

// // //   void previousSong() {
// // //     if (!isNotifierMounted) return;

// // //     if (state.currentIndex > 0) {
// // //       final newIndex = state.currentIndex - 1;
// // //       state = state.copyWith(currentIndex: newIndex, isSkipping: true);
// // //       _loadSong(newIndex);
// // //     }
// // //   }

// // //   void seek(double value) {
// // //     try {
// // //       state.audioPlayer.seek(Duration(seconds: value.toInt()));
// // //     } catch (e) {
// // //       debugPrint('Error seeking: $e');
// // //     }
// // //   }

// // //   String formatDuration(Duration duration) {
// // //     final minutes = duration.inMinutes.toString().padLeft(2, '0');
// // //     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
// // //     return '$minutes:$seconds';
// // //   }

// // //   // FIXED: Public methods for external access
// // //   Future<void> playSong(int index) async {
// // //     await _loadSong(index);
// // //   }

// // //   Future<void> playSongDirectly(
// // //     Results song,
// // //     List<Results> playlist,
// // //     int index,
// // //   ) async {
// // //     try {
// // //       // Update current music state
// // //       ref.read(currentMusicProvider.notifier).setMusic(song, playlist, index);
// // //       // Load and play the song
// // //       await _loadSong(index);
// // //     } catch (e) {
// // //       debugPrint('Error playing song directly: $e');
// // //     }
// // //   }

// // //   Future<void> play() async {
// // //     if (!isNotifierMounted) return;

// // //     if (state.currentRewardPoints <= 0) {
// // //       _stopMusicAndShowDialog();
// // //       return;
// // //     }

// // //     try {
// // //       await state.audioPlayer.play();
// // //       ref.read(currentMusicProvider.notifier).setPlaying(true);
// // //     } catch (e) {
// // //       debugPrint('Error playing music: $e');
// // //     }
// // //   }

// // //   Future<void> pause() async {
// // //     if (!isNotifierMounted) return;

// // //     try {
// // //       await state.audioPlayer.pause();
// // //       ref.read(currentMusicProvider.notifier).setPlaying(false);
// // //     } catch (e) {
// // //       debugPrint('Error pausing music: $e');
// // //     }
// // //   }

// // //   Future<void> stop() async {
// // //     try {
// // //       await state.audioPlayer.stop();
// // //       ref.read(currentMusicProvider.notifier).stop();
// // //     } catch (e) {
// // //       debugPrint('Error stopping music: $e');
// // //     }
// // //   }

// // //   AudioPlayer getAudioPlayer() {
// // //     return state.audioPlayer;
// // //   }

// // //   // Download methods remain the same
// // //   Future<bool> _checkStoragePermission() async {
// // //     if (Platform.isAndroid) {
// // //       final androidInfo = await DeviceInfoPlugin().androidInfo;
// // //       final sdkInt = androidInfo.version.sdkInt;

// // //       if (sdkInt >= 33) {
// // //         final audioStatus = await Permission.audio.request();
// // //         return audioStatus.isGranted;
// // //       } else if (sdkInt >= 30) {
// // //         final manageStatus = await Permission.manageExternalStorage.request();
// // //         return manageStatus.isGranted;
// // //       } else {
// // //         final storageStatus = await Permission.storage.request();
// // //         return storageStatus.isGranted;
// // //       }
// // //     }
// // //     return true;
// // //   }

// // //   Future<void> startDownloadWithLoading(
// // //     String musicUrl,
// // //     String musicName,
// // //   ) async {
// // //     if (state.isDownloading) return;

// // //     state = state.copyWith(isDownloading: true);
// // //     await _startDownload(musicUrl, musicName);
// // //   }

// // //   Future<void> _startDownload(String musicUrl, String musicName) async {
// // //     final hasPermission = await _checkStoragePermission();

// // //     if (!hasPermission) {
// // //       state = state.copyWith(isDownloading: false);
// // //       return;
// // //     }

// // //     final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
// // //       ExternalPath.DIRECTORY_DOWNLOAD,
// // //     );

// // //     final sanitizedFileName = musicName.replaceAll(
// // //       RegExp(r'[\\/:*?"<>|]'),
// // //       "_",
// // //     );

// // //     try {
// // //       final taskId = await FlutterDownloader.enqueue(
// // //         url: musicUrl,
// // //         savedDir: downloadPath,
// // //         fileName: '$sanitizedFileName.mp3',
// // //         showNotification: true,
// // //         saveInPublicStorage: true,
// // //         openFileFromNotification: true,
// // //       );

// // //       if (taskId == null) throw Exception("Download failed");

// // //       state = state.copyWith(
// // //         currentDownloadTaskId: taskId,
// // //         downloadingFileName: musicName,
// // //       );
// // //     } catch (e) {
// // //       debugPrint("Download error: $e");
// // //       state = state.copyWith(isDownloading: false);
// // //     }
// // //   }

// // //   void resetDownloadComplete() {
// // //     state = state.copyWith(showDownloadComplete: false);
// // //   }

// // //   @override
// // //   void dispose() {
// // //     if (_disposed) return;
// // //     _disposed = true;
// // //     _mounted = false;

// // //     _rewardTimer?.cancel();
// // //     _amplitudeTimer?.cancel();
// // //     _playerStateSubscription?.cancel();
// // //     _firestoreSubscription?.cancel();

// // //     try {
// // //       if (!_amplitudeController.isClosed) {
// // //         _amplitudeController.close();
// // //       }
// // //       // Stop the music before disposing
// // //       ref.read(currentMusicProvider.notifier).stop();
// // //       state.audioPlayer.dispose();
// // //     } catch (e) {
// // //       debugPrint('Error disposing resources: $e');
// // //     }

// // //     super.dispose();
// // //   }
// // // }

// // // // FIXED: Provider definition
// // // final musicPlayerProvider = StateNotifierProvider.autoDispose.family<
// // //   MusicPlayerNotifier,
// // //   MusicPlayerState,
// // //   ({List<Results> songList, int initialIndex})
// // // >((ref, args) {
// // //   final notifier = MusicPlayerNotifier(
// // //     songList: args.songList,
// // //     initialIndex: args.initialIndex,
// // //     ref: ref,
// // //   );

// // //   // Listen to state changes for dialog
// // //   notifier.addListener((state) {
// // //     if (state.dialogShown && !ref.read(dialogShownProvider)) {
// // //       ref.read(dialogShownProvider.notifier).state = true;
// // //     }
// // //   });

// // //   return notifier;
// // // });

// // // final dialogShownProvider = StateProvider<bool>((ref) => false);

// // // class Amplitude {
// // //   final double min;
// // //   final double max;
// // //   final double? current;

// // //   Amplitude({required this.min, required this.max, this.current});
// // // }

// // // // FIXED: FavoriteProvider
// // // class FavoriteProvider with ChangeNotifier {
// // //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // //   final FirebaseAuth _auth = FirebaseAuth.instance;

// // //   List<Map<String, dynamic>> _favorites = [];
// // //   Set<String> _loadingSongIds = {};

// // //   List<Map<String, dynamic>> get favorites => _favorites;
// // //   bool isLoading(String songId) => _loadingSongIds.contains(songId);

// // //   Future<void> fetchFavorites() async {
// // //     try {
// // //       final user = _auth.currentUser;
// // //       if (user == null) return;

// // //       final snapshot =
// // //           await _firestore
// // //               .collection('users')
// // //               .doc(user.uid)
// // //               .collection('favorites')
// // //               .get();

// // //       _favorites = snapshot.docs.map((doc) => doc.data()).toList();
// // //       notifyListeners();
// // //     } catch (e) {
// // //       debugPrint('Error fetching favorites: $e');
// // //     }
// // //   }

// // //   Future<void> toggleFavorite(Map<String, dynamic> song) async {
// // //     try {
// // //       final user = _auth.currentUser;
// // //       if (user == null) return;

// // //       _loadingSongIds.add(song['id']);
// // //       notifyListeners();

// // //       final favoritesRef = _firestore
// // //           .collection('users')
// // //           .doc(user.uid)
// // //           .collection('favorites')
// // //           .doc(song['id'].toString());

// // //       final doc = await favoritesRef.get();

// // //       if (doc.exists) {
// // //         await favoritesRef.delete();
// // //         _favorites.removeWhere((s) => s['id'] == song['id']);
// // //       } else {
// // //         await favoritesRef.set(song);
// // //         _favorites.add(song);
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error toggling favorite: $e');
// // //     } finally {
// // //       _loadingSongIds.remove(song['id']);
// // //       notifyListeners();
// // //     }
// // //   }

// // //   bool isFavorite(String id) {
// // //     return _favorites.any((s) => s['id'] == id);
// // //   }
// // // }

// // // final activeMusicPlayerProvider = StateProvider<MusicPlayerNotifier?>(
// // //   (ref) => null,
// // // );

// // // // FIXED: Helper function
// // // MusicPlayerNotifier? getCurrentMusicPlayer(WidgetRef ref) {
// // //   try {
// // //     final currentMusicState = ref.read(currentMusicProvider);

// // //     if (currentMusicState.playlist.isEmpty ||
// // //         currentMusicState.currentSong == null) {
// // //       return null;
// // //     }

// // //     final providerFamily = musicPlayerProvider((
// // //       songList: currentMusicState.playlist,
// // //       initialIndex: currentMusicState.currentIndex,
// // //     ));

// // //     if (!ref.exists(providerFamily)) {
// // //       return null;
// // //     }

// // //     final notifier = ref.read(providerFamily.notifier);
// // //     if (!notifier.mounted) return null;

// // //     ref.read(activeMusicPlayerProvider.notifier).state = notifier;
// // //     return notifier;
// // //   } catch (e) {
// // //     debugPrint("Error getting music player: $e");
// // //     return null;
// // //   }
// // // }

// // import 'dart:async';
// // import 'dart:io';
// // import 'dart:math';
// // import 'package:device_info_plus/device_info_plus.dart';
// // import 'package:external_path/external_path.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_downloader/flutter_downloader.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:lyrica/main.dart';
// // import 'package:lyrica/model/music_model.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:lyrica/core/providers/provider.dart';

// // @pragma('vm:entry-point')
// // void downloadCallback(String? id, DownloadTaskStatus status, int progress) {
// //   if (id == null) return;
// //   final container = ProviderContainer();
// //   container.read(downloadProgressProvider(id).notifier).state = progress;
// // }

// // final downloadProgressProvider = StateProvider.family<int, String>(
// //   (ref, taskId) => 0,
// // );

// // class MusicPlayerState {
// //   final AudioPlayer audioPlayer;
// //   final int currentIndex;
// //   final bool isDownloading;
// //   final bool isSkipping;
// //   final bool dialogShown;
// //   final bool showDownloadComplete;
// //   final int lastDeductedMinute;
// //   final int currentRewardPoints;
// //   final String? currentDownloadTaskId;
// //   final String? downloadingFileName;
// //   final bool isInitialized;

// //   MusicPlayerState({
// //     required this.audioPlayer,
// //     required this.currentIndex,
// //     this.isDownloading = false,
// //     this.isSkipping = false,
// //     this.dialogShown = false,
// //     this.showDownloadComplete = false,
// //     this.lastDeductedMinute = 0,
// //     this.currentRewardPoints = 0,
// //     this.currentDownloadTaskId,
// //     this.downloadingFileName,
// //     this.isInitialized = false,
// //   });

// //   MusicPlayerState copyWith({
// //     AudioPlayer? audioPlayer,
// //     int? currentIndex,
// //     bool? isDownloading,
// //     bool? isSkipping,
// //     bool? dialogShown,
// //     bool? showDownloadComplete,
// //     int? lastDeductedMinute,
// //     int? currentRewardPoints,
// //     String? currentDownloadTaskId,
// //     String? downloadingFileName,
// //     bool? isInitialized,
// //   }) {
// //     return MusicPlayerState(
// //       audioPlayer: audioPlayer ?? this.audioPlayer,
// //       currentIndex: currentIndex ?? this.currentIndex,
// //       isDownloading: isDownloading ?? this.isDownloading,
// //       isSkipping: isSkipping ?? this.isSkipping,
// //       dialogShown: dialogShown ?? this.dialogShown,
// //       showDownloadComplete: showDownloadComplete ?? this.showDownloadComplete,
// //       lastDeductedMinute: lastDeductedMinute ?? this.lastDeductedMinute,
// //       currentRewardPoints: currentRewardPoints ?? this.currentRewardPoints,
// //       currentDownloadTaskId:
// //           currentDownloadTaskId ?? this.currentDownloadTaskId,
// //       downloadingFileName: downloadingFileName ?? this.downloadingFileName,
// //       isInitialized: isInitialized ?? this.isInitialized,
// //     );
// //   }
// // }

// // class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
// //   final List<Results> songList;
// //   final int initialIndex;
// //   final Ref ref;
// //   bool _mounted = true;
// //   bool _disposed = false;

// //   bool get isDisposed => _disposed;
// //   bool get mounted => _mounted;

// //   bool get isNotifierMounted {
// //     try {
// //       final currentState = state;
// //       return _mounted && currentState != null;
// //     } catch (e) {
// //       return false;
// //     }
// //   }

// //   late Stream<PlayerState> playerStateStream;
// //   final StreamController<Amplitude> _amplitudeController =
// //       StreamController<Amplitude>();

// //   Timer? _amplitudeTimer;
// //   Timer? _rewardTimer;
// //   bool _initialCheckDone = false;

// //   StreamSubscription? _playerStateSubscription;
// //   StreamSubscription? _firestoreSubscription;

// //   MusicPlayerNotifier({
// //     required this.songList,
// //     required this.initialIndex,
// //     required this.ref,
// //   }) : super(
// //          MusicPlayerState(
// //            audioPlayer: AudioPlayer(),
// //            currentIndex: initialIndex,
// //          ),
// //        ) {
// //     try {
// //       playerStateStream = state.audioPlayer.playerStateStream;
// //       _initializePlayer();
// //       _listenRewardPoints();
// //     } catch (e) {
// //       debugPrint('Error initializing MusicPlayerNotifier: $e');
// //       state = state.copyWith(audioPlayer: AudioPlayer());
// //       playerStateStream = state.audioPlayer.playerStateStream;
// //     }
// //   }

// //   // Initialize music - FIXED
// //   void initializeMusic() {
// //     if (songList.isNotEmpty &&
// //         initialIndex >= 0 &&
// //         initialIndex < songList.length) {
// //       // Update current music state immediately
// //       ref
// //           .read(currentMusicProvider.notifier)
// //           .setMusic(songList[initialIndex], songList, initialIndex);

// //       // Mark as initialized and load the song
// //       state = state.copyWith(isInitialized: true);

// //       // Load the initial song after a brief delay to ensure everything is set up
// //       Future.delayed(const Duration(milliseconds: 100), () {
// //         if (mounted) {
// //           _loadSong(initialIndex);
// //         }
// //       });
// //     }
// //   }

// //   Stream<Duration> get positionStream {
// //     return safeAccess(() => state.audioPlayer.positionStream) ??
// //         const Stream<Duration>.empty();
// //   }

// //   Stream<Duration?> get durationStream {
// //     if (!mounted) return const Stream<Duration?>.empty();
// //     return state.audioPlayer.durationStream;
// //   }

// //   Stream<Amplitude> get amplitudeStream {
// //     if (!mounted || _amplitudeController.isClosed) {
// //       return const Stream<Amplitude>.empty();
// //     }
// //     return _amplitudeController.stream;
// //   }

// //   void _initializePlayer() {
// //     _handleAudioPlayerErrors();
// //     _playerStateSubscription = state.audioPlayer.playerStateStream.listen((
// //       playerState,
// //     ) {
// //       if (playerState.processingState == ProcessingState.completed) {
// //         _autoPlayNextSong();
// //       }

// //       if (playerState.playing &&
// //           playerState.processingState == ProcessingState.ready) {
// //         _startAmplitudeUpdates();
// //         // Update current music provider playing state
// //         ref.read(currentMusicProvider.notifier).setPlaying(true);
// //       } else {
// //         _stopAmplitudeUpdates();
// //         ref.read(currentMusicProvider.notifier).setPlaying(false);
// //       }
// //     });
// //   }

// //   void _autoPlayNextSong() {
// //     if (state.currentIndex < songList.length - 1) {
// //       final newIndex = state.currentIndex + 1;
// //       state = state.copyWith(currentIndex: newIndex);
// //       _loadSong(newIndex, isAutoPlay: true);

// //       // Update the current music provider with the new song
// //       ref.read(currentMusicProvider.notifier).updateIndex(newIndex);
// //     }
// //   }

// //   void _startAmplitudeUpdates() {
// //     _amplitudeTimer?.cancel();
// //     final random = Random();

// //     _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
// //       final value = random.nextDouble();
// //       if (!_amplitudeController.isClosed) {
// //         _amplitudeController.add(
// //           Amplitude(max: value, min: value / 2, current: value),
// //         );
// //       }
// //     });
// //   }

// //   void _stopAmplitudeUpdates() {
// //     _amplitudeTimer?.cancel();
// //     _amplitudeTimer = null;
// //   }

// //   void _listenRewardPoints() {
// //     final user = ref.read(authStateProvider).asData?.value;
// //     if (user == null) return;

// //     _firestoreSubscription = FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .snapshots()
// //         .listen((snap) {
// //           final points = (snap.data()?['rewardPoints'] ?? 0) as int;
// //           state = state.copyWith(currentRewardPoints: points);

// //           if (!_initialCheckDone) {
// //             _initialCheckDone = true;
// //             if (points > 0) {
// //               // Only start reward timer after first successful load
// //               _startRewardTimer();
// //             } else {
// //               _stopMusicAndShowDialog();
// //             }
// //           } else {
// //             if (points <= 0 &&
// //                 state.audioPlayer.playing &&
// //                 !state.dialogShown) {
// //               _stopMusicAndShowDialog();
// //             } else if (points > 0 && state.dialogShown) {
// //               state = state.copyWith(dialogShown: false);
// //             }
// //           }
// //         });
// //   }

// //   void _startRewardTimer() {
// //     _rewardTimer?.cancel();
// //     state = state.copyWith(lastDeductedMinute: 0);

// //     _rewardTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
// //       if (!state.audioPlayer.playing || state.dialogShown || state.isSkipping) {
// //         return;
// //       }

// //       try {
// //         final position = state.audioPlayer.position;
// //         final playedMinutes = position.inMinutes;

// //         if (playedMinutes > state.lastDeductedMinute) {
// //           state = state.copyWith(lastDeductedMinute: playedMinutes);

// //           if (state.currentRewardPoints > 0) {
// //             await _deductRewardPoint();
// //           }

// //           if (state.currentRewardPoints <= 0) {
// //             await _stopMusicAndShowDialog();
// //           }
// //         }
// //       } catch (e) {
// //         debugPrint('Error in reward timer: $e');
// //       }
// //     });
// //   }

// //   Future<void> _deductRewardPoint() async {
// //     final user = ref.read(authStateProvider).asData?.value;
// //     if (user == null) return;
// //     final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
// //     try {
// //       await FirebaseFirestore.instance.runTransaction((transaction) async {
// //         final snapshot = await transaction.get(doc);
// //         final current = (snapshot.data()?['rewardPoints'] ?? 0) as int;
// //         if (current > 0) {
// //           transaction.update(doc, {'rewardPoints': current - 1});
// //         }
// //       });
// //     } catch (e) {
// //       debugPrint('Error deducting reward point: $e');
// //     }
// //   }

// //   Future<void> _stopMusicAndShowDialog() async {
// //     if (state.dialogShown) return;

// //     state = state.copyWith(dialogShown: true);
// //     try {
// //       if (state.audioPlayer.playing) {
// //         await state.audioPlayer.pause();
// //         ref.read(currentMusicProvider.notifier).setPlaying(false);
// //       }
// //     } catch (e) {
// //       debugPrint('Error stopping music: $e');
// //     }

// //     _rewardTimer?.cancel();
// //     _rewardTimer = null;

// //     // Trigger dialog
// //     ref.read(dialogShownProvider.notifier).state = true;
// //   }

// //   // FIXED: Main song loading method
// //   Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
// //     if (!_mounted) {
// //       debugPrint('MusicPlayerNotifier is disposed, skipping _loadSong');
// //       return;
// //     }

// //     if (index < 0 || index >= songList.length) {
// //       debugPrint('Invalid song index: $index');
// //       return;
// //     }

// //     try {
// //       // Stop current playback
// //       try {
// //         await state.audioPlayer.stop();
// //       } catch (e) {
// //         debugPrint('Error stopping audio: $e');
// //       }

// //       if (state.isSkipping) {
// //         state = state.copyWith(isSkipping: false);
// //       }

// //       // Check reward points for non-auto play
// //       if (!isAutoPlay && state.currentRewardPoints <= 0) {
// //         _stopMusicAndShowDialog();
// //         return;
// //       }

// //       final song = songList[index];
// //       final url = song.audio;

// //       if (url == null || url.isEmpty) {
// //         debugPrint('Error: Audio URL is null or empty for song: ${song.name}');
// //         return;
// //       }

// //       debugPrint("Loading song: ${song.name} from URL: $url");

// //       // FIXED: Update both current music state AND audio handler
// //       ref.read(currentMusicProvider.notifier).setMusic(song, songList, index);

// //       // FIXED: Also update the global audio handler
// //       await audioHandler.setCurrentSong(song);

// //       // Set audio source for local player too
// //       await state.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));

// //       // Auto-play if conditions are met
// //       if (isAutoPlay || state.currentRewardPoints > 0) {
// //         await state.audioPlayer.play();
// //         await audioHandler.play(); // FIXED: Also play through audio handler
// //         debugPrint('Successfully started playing song: ${song.name}');
// //       }

// //       // Update state
// //       state = state.copyWith(currentIndex: index, lastDeductedMinute: 0);
// //     } catch (e) {
// //       debugPrint('Error loading song: $e');
// //       // Try to recover by reinitializing the audio player
// //       try {
// //         await state.audioPlayer.dispose();
// //         state = state.copyWith(audioPlayer: AudioPlayer());
// //         _initializePlayer();
// //       } catch (disposeError) {
// //         debugPrint('Error reinitializing player: $disposeError');
// //       }
// //     }
// //   }

// //   void _handleAudioPlayerErrors() {
// //     state.audioPlayer.playbackEventStream.listen(
// //       (event) {
// //         // Handle playback events
// //       },
// //       onError: (e) {
// //         debugPrint('Audio player error: $e');
// //         // Try to recover
// //         Future.delayed(const Duration(milliseconds: 500), () {
// //           if (mounted) {
// //             _reinitializePlayer();
// //           }
// //         });
// //       },
// //     );
// //   }

// //   Future<void> _reinitializePlayer() async {
// //     try {
// //       await state.audioPlayer.dispose();
// //       state = state.copyWith(audioPlayer: AudioPlayer());
// //       _initializePlayer();
// //     } catch (e) {
// //       debugPrint('Error reinitializing player: $e');
// //     }
// //   }

// //   T? safeAccess<T>(T Function() action) {
// //     if (_disposed) return null;
// //     try {
// //       return action();
// //     } catch (e) {
// //       return null;
// //     }
// //   }

// //   // FIXED: Play/Pause method
// //   Future<void> playPause() async {
// //     if (!isNotifierMounted) return;

// //     if (state.currentRewardPoints <= 0) {
// //       _stopMusicAndShowDialog();
// //       return;
// //     }

// //     try {
// //       if (state.audioPlayer.playing) {
// //         await state.audioPlayer.pause();
// //         ref.read(currentMusicProvider.notifier).setPlaying(false);
// //       } else {
// //         await state.audioPlayer.play();
// //         ref.read(currentMusicProvider.notifier).setPlaying(true);
// //       }
// //     } catch (e) {
// //       debugPrint('Error in play/pause: $e');
// //     }
// //   }

// //   void nextSong() {
// //     if (!isNotifierMounted) return;

// //     if (state.currentIndex < songList.length - 1) {
// //       final newIndex = state.currentIndex + 1;
// //       state = state.copyWith(currentIndex: newIndex, isSkipping: true);
// //       _loadSong(newIndex);
// //     }
// //   }

// //   void previousSong() {
// //     if (!isNotifierMounted) return;

// //     if (state.currentIndex > 0) {
// //       final newIndex = state.currentIndex - 1;
// //       state = state.copyWith(currentIndex: newIndex, isSkipping: true);
// //       _loadSong(newIndex);
// //     }
// //   }

// //   void seek(double value) {
// //     try {
// //       state.audioPlayer.seek(Duration(seconds: value.toInt()));
// //     } catch (e) {
// //       debugPrint('Error seeking: $e');
// //     }
// //   }

// //   String formatDuration(Duration duration) {
// //     final minutes = duration.inMinutes.toString().padLeft(2, '0');
// //     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
// //     return '$minutes:$seconds';
// //   }

// //   Future<void> initializeMusicSafe() async {
// //     // Add a small delay to ensure the provider is fully initialized
// //     await Future.delayed(const Duration(milliseconds: 100));

// //     if (songList.isNotEmpty &&
// //         initialIndex >= 0 &&
// //         initialIndex < songList.length &&
// //         mounted) {
// //       // Update current music state
// //       ref
// //           .read(currentMusicProvider.notifier)
// //           .setMusic(songList[initialIndex], songList, initialIndex);

// //       // Mark as initialized
// //       state = state.copyWith(isInitialized: true);

// //       // Load the initial song
// //       await _loadSong(initialIndex);
// //     }
// //   }

// //   // FIXED: Public methods for external access
// //   Future<void> playSong(int index) async {
// //     await _loadSong(index);
// //   }

// //   Future<void> playSongDirectly(
// //     Results song,
// //     List<Results> playlist,
// //     int index,
// //   ) async {
// //     try {
// //       // Update current music state
// //       ref.read(currentMusicProvider.notifier).setMusic(song, playlist, index);
// //       // Load and play the song
// //       await _loadSong(index);
// //     } catch (e) {
// //       debugPrint('Error playing song directly: $e');
// //     }
// //   }

// //   Future<void> play() async {
// //     if (!isNotifierMounted) return;

// //     if (state.currentRewardPoints <= 0) {
// //       _stopMusicAndShowDialog();
// //       return;
// //     }

// //     try {
// //       await state.audioPlayer.play();
// //       ref.read(currentMusicProvider.notifier).setPlaying(true);
// //     } catch (e) {
// //       debugPrint('Error playing music: $e');
// //     }
// //   }

// //   Future<void> pause() async {
// //     if (!isNotifierMounted) return;

// //     try {
// //       await state.audioPlayer.pause();
// //       ref.read(currentMusicProvider.notifier).setPlaying(false);
// //     } catch (e) {
// //       debugPrint('Error pausing music: $e');
// //     }
// //   }

// //   Future<void> stop() async {
// //     try {
// //       await state.audioPlayer.stop();
// //       ref.read(currentMusicProvider.notifier).stop();
// //     } catch (e) {
// //       debugPrint('Error stopping music: $e');
// //     }
// //   }

// //   AudioPlayer getAudioPlayer() {
// //     return state.audioPlayer;
// //   }

// //   // Download methods remain the same
// //   Future<bool> _checkStoragePermission() async {
// //     if (Platform.isAndroid) {
// //       final androidInfo = await DeviceInfoPlugin().androidInfo;
// //       final sdkInt = androidInfo.version.sdkInt;

// //       if (sdkInt >= 33) {
// //         final audioStatus = await Permission.audio.request();
// //         return audioStatus.isGranted;
// //       } else if (sdkInt >= 30) {
// //         final manageStatus = await Permission.manageExternalStorage.request();
// //         return manageStatus.isGranted;
// //       } else {
// //         final storageStatus = await Permission.storage.request();
// //         return storageStatus.isGranted;
// //       }
// //     }
// //     return true;
// //   }

// //   Future<void> startDownloadWithLoading(
// //     String musicUrl,
// //     String musicName,
// //   ) async {
// //     if (state.isDownloading) return;

// //     state = state.copyWith(isDownloading: true);
// //     await _startDownload(musicUrl, musicName);
// //   }

// //   Future<void> _startDownload(String musicUrl, String musicName) async {
// //     final hasPermission = await _checkStoragePermission();

// //     if (!hasPermission) {
// //       state = state.copyWith(isDownloading: false);
// //       return;
// //     }

// //     final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
// //       ExternalPath.DIRECTORY_DOWNLOAD,
// //     );

// //     final sanitizedFileName = musicName.replaceAll(
// //       RegExp(r'[\\/:*?"<>|]'),
// //       "_",
// //     );

// //     try {
// //       final taskId = await FlutterDownloader.enqueue(
// //         url: musicUrl,
// //         savedDir: downloadPath,
// //         fileName: '$sanitizedFileName.mp3',
// //         showNotification: true,
// //         saveInPublicStorage: true,
// //         openFileFromNotification: true,
// //       );

// //       if (taskId == null) throw Exception("Download failed");

// //       state = state.copyWith(
// //         currentDownloadTaskId: taskId,
// //         downloadingFileName: musicName,
// //       );
// //     } catch (e) {
// //       debugPrint("Download error: $e");
// //       state = state.copyWith(isDownloading: false);
// //     }
// //   }

// //   void resetDownloadComplete() {
// //     state = state.copyWith(showDownloadComplete: false);
// //   }

// //   @override
// //   void dispose() {
// //     if (_disposed) return;
// //     _disposed = true;
// //     _mounted = false;

// //     _rewardTimer?.cancel();
// //     _amplitudeTimer?.cancel();
// //     _playerStateSubscription?.cancel();
// //     _firestoreSubscription?.cancel();

// //     try {
// //       if (!_amplitudeController.isClosed) {
// //         _amplitudeController.close();
// //       }
// //       // Stop the music before disposing
// //       ref.read(currentMusicProvider.notifier).stop();
// //       state.audioPlayer.dispose();
// //     } catch (e) {
// //       debugPrint('Error disposing resources: $e');
// //     }

// //     super.dispose();
// //   }
// // }

// // // FIXED: Provider definition
// // final musicPlayerProvider = StateNotifierProvider.autoDispose.family<
// //   MusicPlayerNotifier,
// //   MusicPlayerState,
// //   ({List<Results> songList, int initialIndex})
// // >((ref, args) {
// //   final notifier = MusicPlayerNotifier(
// //     songList: args.songList,
// //     initialIndex: args.initialIndex,
// //     ref: ref,
// //   );

// //   // Initialize the music player
// //   // notifier.initializeMusic();

// //   // Listen to state changes for dialog
// //   notifier.addListener((state) {
// //     if (state.dialogShown && !ref.read(dialogShownProvider)) {
// //       ref.read(dialogShownProvider.notifier).state = true;
// //     }
// //   });

// //   // Auto-dispose when no longer needed
// //   // ref.onDispose(() {
// //   //   notifier.dispose();
// //   // });

// //   return notifier;
// // });

// // final dialogShownProvider = StateProvider<bool>((ref) => false);

// // class Amplitude {
// //   final double min;
// //   final double max;
// //   final double? current;

// //   Amplitude({required this.min, required this.max, this.current});
// // }

// // // FIXED: FavoriteProvider
// // class FavoriteProvider with ChangeNotifier {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final FirebaseAuth _auth = FirebaseAuth.instance;

// //   List<Map<String, dynamic>> _favorites = [];
// //   Set<String> _loadingSongIds = {};

// //   List<Map<String, dynamic>> get favorites => _favorites;
// //   bool isLoading(String songId) => _loadingSongIds.contains(songId);

// //   Future<void> fetchFavorites() async {
// //     try {
// //       final user = _auth.currentUser;
// //       if (user == null) return;

// //       final snapshot =
// //           await _firestore
// //               .collection('users')
// //               .doc(user.uid)
// //               .collection('favorites')
// //               .get();

// //       _favorites = snapshot.docs.map((doc) => doc.data()).toList();
// //       notifyListeners();
// //     } catch (e) {
// //       debugPrint('Error fetching favorites: $e');
// //     }
// //   }

// //   Future<void> toggleFavorite(Map<String, dynamic> song) async {
// //     try {
// //       final user = _auth.currentUser;
// //       if (user == null) return;

// //       _loadingSongIds.add(song['id']);
// //       notifyListeners();

// //       final favoritesRef = _firestore
// //           .collection('users')
// //           .doc(user.uid)
// //           .collection('favorites')
// //           .doc(song['id'].toString());

// //       final doc = await favoritesRef.get();

// //       if (doc.exists) {
// //         await favoritesRef.delete();
// //         _favorites.removeWhere((s) => s['id'] == song['id']);
// //       } else {
// //         await favoritesRef.set(song);
// //         _favorites.add(song);
// //       }
// //     } catch (e) {
// //       debugPrint('Error toggling favorite: $e');
// //     } finally {
// //       _loadingSongIds.remove(song['id']);
// //       notifyListeners();
// //     }
// //   }

// //   bool isFavorite(String id) {
// //     return _favorites.any((s) => s['id'] == id);
// //   }
// // }

// // final activeMusicPlayerProvider = StateProvider<MusicPlayerNotifier?>(
// //   (ref) => null,
// // );

// // // FIXED: Helper function
// // MusicPlayerNotifier? getCurrentMusicPlayer(WidgetRef ref) {
// //   try {
// //     final currentMusicState = ref.read(currentMusicProvider);

// //     if (currentMusicState.playlist.isEmpty ||
// //         currentMusicState.currentSong == null) {
// //       return null;
// //     }

// //     final providerFamily = musicPlayerProvider((
// //       songList: currentMusicState.playlist,
// //       initialIndex: currentMusicState.currentIndex,
// //     ));

// //     if (!ref.exists(providerFamily)) {
// //       return null;
// //     }

// //     final notifier = ref.read(providerFamily.notifier);
// //     if (!notifier.mounted) return null;

// //     ref.read(activeMusicPlayerProvider.notifier).state = notifier;
// //     return notifier;
// //   } catch (e) {
// //     debugPrint("Error getting music player: $e");
// //     return null;
// //   }
// // }

// // // current_playing_music_provider.dart
// // final currentMusicProvider =
// //     StateNotifierProvider<CurrentMusicNotifier, CurrentMusicState>((ref) {
// //       return CurrentMusicNotifier();
// //     });

// // class CurrentMusicState {
// //   final bool isPlaying;
// //   final Results? currentSong;
// //   final List<Results> playlist;
// //   final int currentIndex;

// //   CurrentMusicState({
// //     this.isPlaying = false,
// //     this.currentSong,
// //     this.playlist = const [],
// //     this.currentIndex = -1, // Changed from 0 to -1 to indicate no song selected
// //   });

// //   CurrentMusicState copyWith({
// //     bool? isPlaying,
// //     Results? currentSong,
// //     List<Results>? playlist,
// //     int? currentIndex,
// //   }) {
// //     return CurrentMusicState(
// //       isPlaying: isPlaying ?? this.isPlaying,
// //       currentSong: currentSong ?? this.currentSong,
// //       playlist: playlist ?? this.playlist,
// //       currentIndex: currentIndex ?? this.currentIndex,
// //     );
// //   }
// // }

// // class CurrentMusicNotifier extends StateNotifier<CurrentMusicState> {
// //   CurrentMusicNotifier() : super(CurrentMusicState());

// //   void setMusic(Results song, List<Results> playlist, int index) {
// //     state = state.copyWith(
// //       currentSong: song,
// //       playlist: playlist,
// //       currentIndex: index,
// //       isPlaying: true,
// //     );
// //   }

// //   // Changed from playPause(bool) to setPlaying(bool) for better semantics
// //   void setPlaying(bool playing) {
// //     state = state.copyWith(isPlaying: playing);
// //   }

// //   // Added method to update just the index (for navigation)
// //   void updateIndex(int index) {
// //     if (index >= 0 && index < state.playlist.length) {
// //       state = state.copyWith(
// //         currentIndex: index,
// //         currentSong: state.playlist[index],
// //         isPlaying: true,
// //       );
// //     }
// //   }

// //   void stop() {
// //     state = state.copyWith(
// //       isPlaying: false,
// //       currentSong: null,
// //       currentIndex: -1,
// //       playlist: [],
// //     );
// //   }
// // }
// // music_player_provider.dart - FIXED VERSION

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lyrica/main.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyrica/core/providers/provider.dart';

@pragma('vm:entry-point')
void downloadCallback(String? id, DownloadTaskStatus status, int progress) {
  if (id == null) return;
  final container = ProviderContainer();
  container.read(downloadProgressProvider(id).notifier).state = progress;
}

final downloadProgressProvider = StateProvider.family<int, String>(
  (ref, taskId) => 0,
);

class MusicPlayerState {
  final AudioPlayer audioPlayer;
  final int currentIndex;
  final bool isDownloading;
  final bool isSkipping;
  final bool dialogShown;
  final bool showDownloadComplete;
  final int lastDeductedMinute;
  final int currentRewardPoints;
  final String? currentDownloadTaskId;
  final String? downloadingFileName;
  final bool isInitialized;

  MusicPlayerState({
    required this.audioPlayer,
    required this.currentIndex,
    this.isDownloading = false,
    this.isSkipping = false,
    this.dialogShown = false,
    this.showDownloadComplete = false,
    this.lastDeductedMinute = 0,
    this.currentRewardPoints = 0,
    this.currentDownloadTaskId,
    this.downloadingFileName,
    this.isInitialized = false,
  });

  MusicPlayerState copyWith({
    AudioPlayer? audioPlayer,
    int? currentIndex,
    bool? isDownloading,
    bool? isSkipping,
    bool? dialogShown,
    bool? showDownloadComplete,
    int? lastDeductedMinute,
    int? currentRewardPoints,
    String? currentDownloadTaskId,
    String? downloadingFileName,
    bool? isInitialized,
  }) {
    return MusicPlayerState(
      audioPlayer: audioPlayer ?? this.audioPlayer,
      currentIndex: currentIndex ?? this.currentIndex,
      isDownloading: isDownloading ?? this.isDownloading,
      isSkipping: isSkipping ?? this.isSkipping,
      dialogShown: dialogShown ?? this.dialogShown,
      showDownloadComplete: showDownloadComplete ?? this.showDownloadComplete,
      lastDeductedMinute: lastDeductedMinute ?? this.lastDeductedMinute,
      currentRewardPoints: currentRewardPoints ?? this.currentRewardPoints,
      currentDownloadTaskId:
          currentDownloadTaskId ?? this.currentDownloadTaskId,
      downloadingFileName: downloadingFileName ?? this.downloadingFileName,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
  final List<Results> songList;
  final int initialIndex;
  final Ref ref;
  bool _mounted = true;
  bool _disposed = false;

  bool get isDisposed => _disposed;
  @override
  bool get mounted => _mounted;

  bool get isNotifierMounted {
    try {
      return _mounted;
    } catch (e) {
      return false;
    }
  }

  late Stream<PlayerState> playerStateStream;
  final StreamController<Amplitude> _amplitudeController =
      StreamController<Amplitude>();

  Timer? _amplitudeTimer;
  Timer? _rewardTimer;
  bool _initialCheckDone = false;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _firestoreSubscription;

  MusicPlayerNotifier({
    required this.songList,
    required this.initialIndex,
    required this.ref,
  }) : super(
         MusicPlayerState(
           audioPlayer: AudioPlayer(),
           currentIndex: initialIndex,
         ),
       ) {
    try {
      playerStateStream = state.audioPlayer.playerStateStream;
      _initializePlayer();
      _listenRewardPoints();
    } catch (e) {
      debugPrint('Error initializing MusicPlayerNotifier: $e');
      state = state.copyWith(audioPlayer: AudioPlayer());
      playerStateStream = state.audioPlayer.playerStateStream;
    }
  }

  // FIXED: Initialize music with proper synchronization
  void initializeMusic() {
    if (songList.isNotEmpty &&
        initialIndex >= 0 &&
        initialIndex < songList.length) {
      // FIXED: Mark as initialized first
      state = state.copyWith(isInitialized: true);

      // Update current music state immediately
      ref
          .read(currentMusicProvider.notifier)
          .setMusic(songList[initialIndex], songList, initialIndex);

      // Load the initial song with delay to ensure proper initialization
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _loadSong(initialIndex);
        }
      });
    }
  }

  Stream<Duration> get positionStream {
    return safeAccess(() => state.audioPlayer.positionStream) ??
        const Stream<Duration>.empty();
  }

  Stream<Duration?> get durationStream {
    if (!mounted) return const Stream<Duration?>.empty();
    return state.audioPlayer.durationStream;
  }

  Stream<Amplitude> get amplitudeStream {
    if (!mounted || _amplitudeController.isClosed) {
      return const Stream<Amplitude>.empty();
    }
    return _amplitudeController.stream;
  }

  void _initializePlayer() {
    _handleAudioPlayerErrors();
    _playerStateSubscription = state.audioPlayer.playerStateStream.listen((
      playerState,
    ) {
      if (playerState.processingState == ProcessingState.completed) {
        _autoPlayNextSong();
      }

      // FIXED: Sync playing state with both current music provider and audio handler
      if (playerState.playing &&
          playerState.processingState == ProcessingState.ready) {
        _startAmplitudeUpdates();
        ref.read(currentMusicProvider.notifier).setPlaying(true);
      } else {
        _stopAmplitudeUpdates();
        ref.read(currentMusicProvider.notifier).setPlaying(false);
      }
    });
  }

  void _autoPlayNextSong() {
    if (state.currentIndex < songList.length - 1) {
      final newIndex = state.currentIndex + 1;
      state = state.copyWith(currentIndex: newIndex);
      _loadSong(newIndex, isAutoPlay: true);

      // Update the current music provider with the new song
      ref.read(currentMusicProvider.notifier).updateIndex(newIndex);
    }
  }

  void _startAmplitudeUpdates() {
    _amplitudeTimer?.cancel();
    final random = Random();

    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
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
          final points = (snap.data()?['rewardPoints'] ?? 0) as int;
          state = state.copyWith(currentRewardPoints: points);

          if (!_initialCheckDone) {
            _initialCheckDone = true;
            if (points > 0) {
              _startRewardTimer();
            } else {
              _stopMusicAndShowDialog();
            }
          } else {
            if (points <= 0 &&
                state.audioPlayer.playing &&
                !state.dialogShown) {
              _stopMusicAndShowDialog();
            } else if (points > 0 && state.dialogShown) {
              state = state.copyWith(dialogShown: false);
            }
          }
        });
  }

  void _startRewardTimer() {
    _rewardTimer?.cancel();
    state = state.copyWith(lastDeductedMinute: 0);

    _rewardTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!state.audioPlayer.playing || state.dialogShown || state.isSkipping) {
        return;
      }

      try {
        final position = state.audioPlayer.position;
        final playedMinutes = position.inMinutes;

        if (playedMinutes > state.lastDeductedMinute) {
          state = state.copyWith(lastDeductedMinute: playedMinutes);

          if (state.currentRewardPoints > 0) {
            await _deductRewardPoint();
          }

          if (state.currentRewardPoints <= 0) {
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
    if (state.dialogShown) return;

    state = state.copyWith(dialogShown: true);
    try {
      if (state.audioPlayer.playing) {
        await state.audioPlayer.pause();
        await audioHandler.pause(); // FIXED: Also pause audio handler
        ref.read(currentMusicProvider.notifier).setPlaying(false);
      }
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }

    _rewardTimer?.cancel();
    _rewardTimer = null;

    ref.read(dialogShownProvider.notifier).state = true;
  }

  // FIXED: Main song loading method with proper synchronization
  Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
    if (!_mounted) {
      debugPrint('MusicPlayerNotifier is disposed, skipping _loadSong');
      return;
    }

    if (index < 0 || index >= songList.length) {
      debugPrint('Invalid song index: $index');
      return;
    }

    try {
      // FIXED: Update current music state first
      final song = songList[index];
      ref.read(currentMusicProvider.notifier).setMusic(song, songList, index);

      // FIXED: Set audio handler with the song
      await audioHandler.setCurrentSong(song);

      // FIXED: Set audio source for local player
      final url = song.audio;
      if (url == null || url.isEmpty) {
        debugPrint('Error: Audio URL is null or empty for song: ${song.name}');
        return;
      }

      await state.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));

      // Auto-play if conditions are met
      if (isAutoPlay || state.currentRewardPoints > 0) {
        await state.audioPlayer.play();
        debugPrint('Successfully started playing song: ${song.name}');
      }

      // Update state
      state = state.copyWith(currentIndex: index, lastDeductedMinute: 0);
    } catch (e) {
      debugPrint('Error loading song: $e');
      // Try to recover by reinitializing the audio player
      try {
        await state.audioPlayer.dispose();
        state = state.copyWith(audioPlayer: AudioPlayer());
        _initializePlayer();
      } catch (disposeError) {
        debugPrint('Error reinitializing player: $disposeError');
      }
    }
  }

  void _handleAudioPlayerErrors() {
    state.audioPlayer.playbackEventStream.listen(
      (event) {
        // Handle playback events
      },
      onError: (e) {
        debugPrint('Audio player error: $e');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _reinitializePlayer();
          }
        });
      },
    );
  }

  Future<void> _reinitializePlayer() async {
    try {
      await state.audioPlayer.dispose();
      state = state.copyWith(audioPlayer: AudioPlayer());
      _initializePlayer();
    } catch (e) {
      debugPrint('Error reinitializing player: $e');
    }
  }

  T? safeAccess<T>(T Function() action) {
    if (_disposed) return null;
    try {
      return action();
    } catch (e) {
      return null;
    }
  }

  // FIXED: Play/Pause method with proper synchronization
  Future<void> playPause() async {
    if (!isNotifierMounted) return;

    if (state.currentRewardPoints <= 0) {
      _stopMusicAndShowDialog();
      return;
    }

    try {
      if (state.audioPlayer.playing) {
        await state.audioPlayer.pause();
        await audioHandler.pause(); // FIXED: Sync with audio handler
        ref.read(currentMusicProvider.notifier).setPlaying(false);
      } else {
        await state.audioPlayer.play();
        await audioHandler.play(); // FIXED: Sync with audio handler
        ref.read(currentMusicProvider.notifier).setPlaying(true);
      }
    } catch (e) {
      debugPrint('Error in play/pause: $e');
    }
  }

  void nextSong() {
    if (!isNotifierMounted) return;

    if (state.currentIndex < songList.length - 1) {
      final newIndex = state.currentIndex + 1;
      state = state.copyWith(currentIndex: newIndex, isSkipping: true);
      _loadSong(newIndex);
    }
  }

  void previousSong() {
    if (!isNotifierMounted) return;

    if (state.currentIndex > 0) {
      final newIndex = state.currentIndex - 1;
      state = state.copyWith(currentIndex: newIndex, isSkipping: true);
      _loadSong(newIndex);
    }
  }

  // FIXED: Seek method with proper synchronization
  void seek(double value) {
    try {
      final position = Duration(seconds: value.toInt());
      state.audioPlayer.seek(position);
      audioHandler.seek(position); // FIXED: Also seek audio handler
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> initializeMusicSafe() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (songList.isNotEmpty &&
        initialIndex >= 0 &&
        initialIndex < songList.length &&
        mounted) {
      ref
          .read(currentMusicProvider.notifier)
          .setMusic(songList[initialIndex], songList, initialIndex);

      state = state.copyWith(isInitialized: true);
      await _loadSong(initialIndex);
    }
  }

  Future<void> playSong(int index) async {
    await _loadSong(index);
  }

  Future<void> playSongDirectly(
    Results song,
    List<Results> playlist,
    int index,
  ) async {
    try {
      ref.read(currentMusicProvider.notifier).setMusic(song, playlist, index);
      await _loadSong(index);
    } catch (e) {
      debugPrint('Error playing song directly: $e');
    }
  }

  // FIXED: Play method with proper synchronization
  Future<void> play() async {
    if (!isNotifierMounted) return;

    if (state.currentRewardPoints <= 0) {
      _stopMusicAndShowDialog();
      return;
    }

    try {
      await state.audioPlayer.play();
      await audioHandler.play(); // FIXED: Sync with audio handler
      ref.read(currentMusicProvider.notifier).setPlaying(true);
    } catch (e) {
      debugPrint('Error playing music: $e');
    }
  }

  // FIXED: Pause method with proper synchronization
  Future<void> pause() async {
    if (!isNotifierMounted) return;

    try {
      await state.audioPlayer.pause();
      await audioHandler.pause(); // FIXED: Sync with audio handler
      ref.read(currentMusicProvider.notifier).setPlaying(false);
    } catch (e) {
      debugPrint('Error pausing music: $e');
    }
  }

  Future<void> stop() async {
    try {
      await state.audioPlayer.stop();
      await audioHandler.stop(); // FIXED: Also stop audio handler
      ref.read(currentMusicProvider.notifier).stop();
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }
  }

  AudioPlayer getAudioPlayer() {
    return state.audioPlayer;
  }

  // Download methods remain the same
  Future<bool> _checkStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        final audioStatus = await Permission.audio.request();
        return audioStatus.isGranted;
      } else if (sdkInt >= 30) {
        final manageStatus = await Permission.manageExternalStorage.request();
        return manageStatus.isGranted;
      } else {
        final storageStatus = await Permission.storage.request();
        return storageStatus.isGranted;
      }
    }
    return true;
  }

  Future<void> startDownloadWithLoading(
    String musicUrl,
    String musicName,
  ) async {
    if (state.isDownloading) return;

    state = state.copyWith(isDownloading: true);
    await _startDownload(musicUrl, musicName);
  }

  Future<void> _startDownload(String musicUrl, String musicName) async {
    final hasPermission = await _checkStoragePermission();

    if (!hasPermission) {
      state = state.copyWith(isDownloading: false);
      return;
    }

    final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOAD,
    );

    final sanitizedFileName = musicName.replaceAll(
      RegExp(r'[\\/:*?"<>|]'),
      "_",
    );

    try {
      final taskId = await FlutterDownloader.enqueue(
        url: musicUrl,
        savedDir: downloadPath,
        fileName: '$sanitizedFileName.mp3',
        showNotification: true,
        saveInPublicStorage: true,
        openFileFromNotification: true,
      );

      if (taskId == null) throw Exception("Download failed");

      state = state.copyWith(
        currentDownloadTaskId: taskId,
        downloadingFileName: musicName,
      );
    } catch (e) {
      debugPrint("Download error: $e");
      state = state.copyWith(isDownloading: false);
    }
  }

  void resetDownloadComplete() {
    state = state.copyWith(showDownloadComplete: false);
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _mounted = false;

    _rewardTimer?.cancel();
    _amplitudeTimer?.cancel();
    _playerStateSubscription?.cancel();
    _firestoreSubscription?.cancel();

    try {
      if (!_amplitudeController.isClosed) {
        _amplitudeController.close();
      }
      ref.read(currentMusicProvider.notifier).stop();
      state.audioPlayer.dispose();
    } catch (e) {
      debugPrint('Error disposing resources: $e');
    }

    super.dispose();
  }
}

// FIXED: Provider definition
final musicPlayerProvider = StateNotifierProvider.autoDispose.family<
  MusicPlayerNotifier,
  MusicPlayerState,
  ({List<Results> songList, int initialIndex})
>((ref, args) {
  final notifier = MusicPlayerNotifier(
    songList: args.songList,
    initialIndex: args.initialIndex,
    ref: ref,
  );

  // Listen to state changes for dialog
  notifier.addListener((state) {
    if (state.dialogShown && !ref.read(dialogShownProvider)) {
      ref.read(dialogShownProvider.notifier).state = true;
    }
  });

  return notifier;
});

final dialogShownProvider = StateProvider<bool>((ref) => false);

class Amplitude {
  final double min;
  final double max;
  final double? current;

  Amplitude({required this.min, required this.max, this.current});
}

// FIXED: FavoriteProvider
class FavoriteProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _favorites = [];
  final Set<String> _loadingSongIds = {};

  List<Map<String, dynamic>> get favorites => _favorites;
  bool isLoading(String songId) => _loadingSongIds.contains(songId);

  Future<void> fetchFavorites() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final snapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('favorites')
              .get();

      _favorites = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> song) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      _loadingSongIds.add(song['id']);
      notifyListeners();

      final favoritesRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(song['id'].toString());

      final doc = await favoritesRef.get();

      if (doc.exists) {
        await favoritesRef.delete();
        _favorites.removeWhere((s) => s['id'] == song['id']);
      } else {
        await favoritesRef.set(song);
        _favorites.add(song);
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    } finally {
      _loadingSongIds.remove(song['id']);
      notifyListeners();
    }
  }

  bool isFavorite(String id) {
    return _favorites.any((s) => s['id'] == id);
  }
}

final activeMusicPlayerProvider = StateProvider<MusicPlayerNotifier?>(
  (ref) => null,
);

// FIXED: Helper function for getting current music player
MusicPlayerNotifier? getCurrentMusicPlayer(WidgetRef ref) {
  try {
    final currentMusicState = ref.read(currentMusicProvider);

    if (currentMusicState.playlist.isEmpty ||
        currentMusicState.currentSong == null) {
      return null;
    }

    final providerFamily = musicPlayerProvider((
      songList: currentMusicState.playlist,
      initialIndex: currentMusicState.currentIndex,
    ));

    if (!ref.exists(providerFamily)) {
      return null;
    }

    final notifier = ref.read(providerFamily.notifier);
    if (!notifier.mounted) return null;

    ref.read(activeMusicPlayerProvider.notifier).state = notifier;
    return notifier;
  } catch (e) {
    debugPrint("Error getting music player: $e");
    return null;
  }
}
// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:external_path/external_path.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:lyrica/main.dart';
// import 'package:lyrica/model/music_model.dart';
// import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:lyrica/core/providers/provider.dart';

// @pragma('vm:entry-point')
// void downloadCallback(String? id, DownloadTaskStatus status, int progress) {
//   if (id == null) return;
//   final container = ProviderContainer();
//   container.read(downloadProgressProvider(id).notifier).state = progress;
// }

// final downloadProgressProvider = StateProvider.family<int, String>(
//   (ref, taskId) => 0,
// );

// class MusicPlayerState {
//   final AudioPlayer audioPlayer;
//   final int currentIndex;
//   final bool isDownloading;
//   final bool isSkipping;
//   final bool dialogShown;
//   final bool showDownloadComplete;
//   final int lastDeductedMinute;
//   final int currentRewardPoints;
//   final String? currentDownloadTaskId;
//   final String? downloadingFileName;
//   final bool isInitialized;

//   MusicPlayerState({
//     required this.audioPlayer,
//     required this.currentIndex,
//     this.isDownloading = false,
//     this.isSkipping = false,
//     this.dialogShown = false,
//     this.showDownloadComplete = false,
//     this.lastDeductedMinute = 0,
//     this.currentRewardPoints = 0,
//     this.currentDownloadTaskId,
//     this.downloadingFileName,
//     this.isInitialized = false,
//   });

//   MusicPlayerState copyWith({
//     AudioPlayer? audioPlayer,
//     int? currentIndex,
//     bool? isDownloading,
//     bool? isSkipping,
//     bool? dialogShown,
//     bool? showDownloadComplete,
//     int? lastDeductedMinute,
//     int? currentRewardPoints,
//     String? currentDownloadTaskId,
//     String? downloadingFileName,
//     bool? isInitialized,
//   }) {
//     return MusicPlayerState(
//       audioPlayer: audioPlayer ?? this.audioPlayer,
//       currentIndex: currentIndex ?? this.currentIndex,
//       isDownloading: isDownloading ?? this.isDownloading,
//       isSkipping: isSkipping ?? this.isSkipping,
//       dialogShown: dialogShown ?? this.dialogShown,
//       showDownloadComplete: showDownloadComplete ?? this.showDownloadComplete,
//       lastDeductedMinute: lastDeductedMinute ?? this.lastDeductedMinute,
//       currentRewardPoints: currentRewardPoints ?? this.currentRewardPoints,
//       currentDownloadTaskId:
//           currentDownloadTaskId ?? this.currentDownloadTaskId,
//       downloadingFileName: downloadingFileName ?? this.downloadingFileName,
//       isInitialized: isInitialized ?? this.isInitialized,
//     );
//   }
// }

// class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
//   final List<Results> songList;
//   final int initialIndex;
//   final Ref ref;
//   bool _mounted = true;
//   bool _disposed = false;

//   bool get isDisposed => _disposed;
//   @override
//   bool get mounted => _mounted;

//   bool get isNotifierMounted {
//     try {
//       return _mounted;
//     } catch (e) {
//       return false;
//     }
//   }

//   late Stream<PlayerState> playerStateStream;
//   final StreamController<Amplitude> _amplitudeController =
//       StreamController<Amplitude>();

//   Timer? _amplitudeTimer;
//   Timer? _rewardTimer;
//   bool _initialCheckDone = false;

//   StreamSubscription? _playerStateSubscription;
//   StreamSubscription? _firestoreSubscription;

//   MusicPlayerNotifier({
//     required this.songList,
//     required this.initialIndex,
//     required this.ref,
//   }) : super(
//          MusicPlayerState(
//            audioPlayer: AudioPlayer(),
//            currentIndex: initialIndex,
//          ),
//        ) {
//     try {
//       playerStateStream = state.audioPlayer.playerStateStream;
//       _initializePlayer();
//       _listenRewardPoints();
//     } catch (e) {
//       debugPrint('Error initializing MusicPlayerNotifier: $e');
//       state = state.copyWith(audioPlayer: AudioPlayer());
//       playerStateStream = state.audioPlayer.playerStateStream;
//     }
//   }

//   // FIXED: Initialize music with proper synchronization
//   void initializeMusic() {
//     if (songList.isNotEmpty &&
//         initialIndex >= 0 &&
//         initialIndex < songList.length) {
//       // FIXED: Mark as initialized first
//       state = state.copyWith(isInitialized: true);

//       // Update current music state immediately
//       ref
//           .read(currentMusicProvider.notifier)
//           .setMusic(songList[initialIndex], songList, initialIndex);

//       // Load the initial song with delay to ensure proper initialization
//       Future.delayed(const Duration(milliseconds: 200), () {
//         if (mounted) {
//           _loadSong(initialIndex);
//         }
//       });
//     }
//   }

//   Stream<Duration> get positionStream {
//     return safeAccess(() => state.audioPlayer.positionStream) ??
//         const Stream<Duration>.empty();
//   }

//   Stream<Duration?> get durationStream {
//     if (!mounted) return const Stream<Duration?>.empty();
//     return state.audioPlayer.durationStream;
//   }

//   Stream<Amplitude> get amplitudeStream {
//     if (!mounted || _amplitudeController.isClosed) {
//       return const Stream<Amplitude>.empty();
//     }
//     return _amplitudeController.stream;
//   }

//   void _initializePlayer() {
//     _handleAudioPlayerErrors();
//     _playerStateSubscription = state.audioPlayer.playerStateStream.listen((
//       playerState,
//     ) {
//       if (playerState.processingState == ProcessingState.completed) {
//         _autoPlayNextSong();
//       }

//       // FIXED: Sync playing state with both current music provider and audio handler
//       if (playerState.playing &&
//           playerState.processingState == ProcessingState.ready) {
//         _startAmplitudeUpdates();
//         ref.read(currentMusicProvider.notifier).setPlaying(true);
//       } else {
//         _stopAmplitudeUpdates();
//         ref.read(currentMusicProvider.notifier).setPlaying(false);
//       }
//     });
//   }

//   void _autoPlayNextSong() {
//     if (state.currentIndex < songList.length - 1) {
//       final newIndex = state.currentIndex + 1;
//       state = state.copyWith(currentIndex: newIndex);
//       _loadSong(newIndex, isAutoPlay: true);

//       // Update the current music provider with the new song
//       ref.read(currentMusicProvider.notifier).updateIndex(newIndex);
//     }
//   }

//   void _startAmplitudeUpdates() {
//     _amplitudeTimer?.cancel();
//     final random = Random();

//     _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
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
//           final points = (snap.data()?['rewardPoints'] ?? 0) as int;
//           state = state.copyWith(currentRewardPoints: points);

//           if (!_initialCheckDone) {
//             _initialCheckDone = true;
//             if (points > 0) {
//               _startRewardTimer();
//             } else {
//               _stopMusicAndShowDialog();
//             }
//           } else {
//             if (points <= 0 &&
//                 state.audioPlayer.playing &&
//                 !state.dialogShown) {
//               _stopMusicAndShowDialog();
//             } else if (points > 0 && state.dialogShown) {
//               state = state.copyWith(dialogShown: false);
//             }
//           }
//         });
//   }

//   void _startRewardTimer() {
//     _rewardTimer?.cancel();
//     state = state.copyWith(lastDeductedMinute: 0);

//     _rewardTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (!state.audioPlayer.playing || state.dialogShown || state.isSkipping) {
//         return;
//       }

//       try {
//         final position = state.audioPlayer.position;
//         final playedMinutes = position.inMinutes;

//         if (playedMinutes > state.lastDeductedMinute) {
//           state = state.copyWith(lastDeductedMinute: playedMinutes);

//           if (state.currentRewardPoints > 0) {
//             await _deductRewardPoint();
//           }

//           if (state.currentRewardPoints <= 0) {
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
//     if (state.dialogShown) return;

//     state = state.copyWith(dialogShown: true);
//     try {
//       if (state.audioPlayer.playing) {
//         await state.audioPlayer.pause();
//         await audioHandler.pause(); // FIXED: Also pause audio handler
//         ref.read(currentMusicProvider.notifier).setPlaying(false);
//       }
//     } catch (e) {
//       debugPrint('Error stopping music: $e');
//     }

//     _rewardTimer?.cancel();
//     _rewardTimer = null;

//     ref.read(dialogShownProvider.notifier).state = true;
//   }

//   // FIXED: Main song loading method with proper synchronization
//   Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
//     if (!_mounted) {
//       debugPrint('MusicPlayerNotifier is disposed, skipping _loadSong');
//       return;
//     }

//     if (index < 0 || index >= songList.length) {
//       debugPrint('Invalid song index: $index');
//       return;
//     }

//     try {
//       // FIXED: Update current music state first
//       final song = songList[index];
//       ref.read(currentMusicProvider.notifier).setMusic(song, songList, index);

//       // FIXED: Set audio handler with the song
//       await audioHandler.setCurrentSong(song);

//       // FIXED: Set audio source for local player
//       final url = song.audio;
//       if (url == null || url.isEmpty) {
//         debugPrint('Error: Audio URL is null or empty for song: ${song.name}');
//         return;
//       }

//       await state.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));

//       // Auto-play if conditions are met
//       if (isAutoPlay || state.currentRewardPoints > 0) {
//         await state.audioPlayer.play();
//         debugPrint('Successfully started playing song: ${song.name}');
//       }

//       // Update state
//       state = state.copyWith(currentIndex: index, lastDeductedMinute: 0);
//     } catch (e) {
//       debugPrint('Error loading song: $e');
//       // Try to recover by reinitializing the audio player
//       try {
//         await state.audioPlayer.dispose();
//         state = state.copyWith(audioPlayer: AudioPlayer());
//         _initializePlayer();
//       } catch (disposeError) {
//         debugPrint('Error reinitializing player: $disposeError');
//       }
//     }
//   }

//   void _handleAudioPlayerErrors() {
//     state.audioPlayer.playbackEventStream.listen(
//       (event) {
//         // Handle playback events
//       },
//       onError: (e) {
//         debugPrint('Audio player error: $e');
//         Future.delayed(const Duration(milliseconds: 500), () {
//           if (mounted) {
//             _reinitializePlayer();
//           }
//         });
//       },
//     );
//   }

//   Future<void> _reinitializePlayer() async {
//     try {
//       await state.audioPlayer.dispose();
//       state = state.copyWith(audioPlayer: AudioPlayer());
//       _initializePlayer();
//     } catch (e) {
//       debugPrint('Error reinitializing player: $e');
//     }
//   }

//   T? safeAccess<T>(T Function() action) {
//     if (_disposed) return null;
//     try {
//       return action();
//     } catch (e) {
//       return null;
//     }
//   }

//   // FIXED: Play/Pause method with proper synchronization
//   Future<void> playPause() async {
//     if (!isNotifierMounted) return;

//     if (state.currentRewardPoints <= 0) {
//       _stopMusicAndShowDialog();
//       return;
//     }

//     try {
//       if (state.audioPlayer.playing) {
//         await state.audioPlayer.pause();
//         await audioHandler.pause(); // FIXED: Sync with audio handler
//         ref.read(currentMusicProvider.notifier).setPlaying(false);
//       } else {
//         await state.audioPlayer.play();
//         await audioHandler.play(); // FIXED: Sync with audio handler
//         ref.read(currentMusicProvider.notifier).setPlaying(true);
//       }
//     } catch (e) {
//       debugPrint('Error in play/pause: $e');
//     }
//   }

//   void nextSong() {
//     if (!isNotifierMounted) return;

//     if (state.currentIndex < songList.length - 1) {
//       final newIndex = state.currentIndex + 1;
//       state = state.copyWith(currentIndex: newIndex, isSkipping: true);
//       _loadSong(newIndex);
//     }
//   }

//   void previousSong() {
//     if (!isNotifierMounted) return;

//     if (state.currentIndex > 0) {
//       final newIndex = state.currentIndex - 1;
//       state = state.copyWith(currentIndex: newIndex, isSkipping: true);
//       _loadSong(newIndex);
//     }
//   }

//   // FIXED: Seek method with proper synchronization
//   void seek(double value) {
//     try {
//       final position = Duration(seconds: value.toInt());
//       state.audioPlayer.seek(position);
//       audioHandler.seek(position); // FIXED: Also seek audio handler
//     } catch (e) {
//       debugPrint('Error seeking: $e');
//     }
//   }

//   String formatDuration(Duration duration) {
//     final minutes = duration.inMinutes.toString().padLeft(2, '0');
//     final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }

//   Future<void> initializeMusicSafe() async {
//     await Future.delayed(const Duration(milliseconds: 100));

//     if (songList.isNotEmpty &&
//         initialIndex >= 0 &&
//         initialIndex < songList.length &&
//         mounted) {
//       ref
//           .read(currentMusicProvider.notifier)
//           .setMusic(songList[initialIndex], songList, initialIndex);

//       state = state.copyWith(isInitialized: true);
//       await _loadSong(initialIndex);
//     }
//   }

//   Future<void> playSong(int index) async {
//     await _loadSong(index);
//   }

//   Future<void> playSongDirectly(
//     Results song,
//     List<Results> playlist,
//     int index,
//   ) async {
//     try {
//       ref.read(currentMusicProvider.notifier).setMusic(song, playlist, index);
//       await _loadSong(index);
//     } catch (e) {
//       debugPrint('Error playing song directly: $e');
//     }
//   }

//   // FIXED: Play method with proper synchronization
//   Future<void> play() async {
//     if (!isNotifierMounted) return;

//     if (state.currentRewardPoints <= 0) {
//       _stopMusicAndShowDialog();
//       return;
//     }

//     try {
//       await state.audioPlayer.play();
//       await audioHandler.play(); // FIXED: Sync with audio handler
//       ref.read(currentMusicProvider.notifier).setPlaying(true);
//     } catch (e) {
//       debugPrint('Error playing music: $e');
//     }
//   }

//   // FIXED: Pause method with proper synchronization
//   Future<void> pause() async {
//     if (!isNotifierMounted) return;

//     try {
//       await state.audioPlayer.pause();
//       await audioHandler.pause(); // FIXED: Sync with audio handler
//       ref.read(currentMusicProvider.notifier).setPlaying(false);
//     } catch (e) {
//       debugPrint('Error pausing music: $e');
//     }
//   }

//   Future<void> stop() async {
//     try {
//       await state.audioPlayer.stop();
//       await audioHandler.stop(); // FIXED: Also stop audio handler
//       ref.read(currentMusicProvider.notifier).stop();
//     } catch (e) {
//       debugPrint('Error stopping music: $e');
//     }
//   }

//   AudioPlayer getAudioPlayer() {
//     return state.audioPlayer;
//   }

//   // Download methods remain the same
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

//   Future<void> startDownloadWithLoading(
//     String musicUrl,
//     String musicName,
//   ) async {
//     if (state.isDownloading) return;

//     state = state.copyWith(isDownloading: true);
//     await _startDownload(musicUrl, musicName);
//   }

//   Future<void> _startDownload(String musicUrl, String musicName) async {
//     final hasPermission = await _checkStoragePermission();

//     if (!hasPermission) {
//       state = state.copyWith(isDownloading: false);
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

//       state = state.copyWith(
//         currentDownloadTaskId: taskId,
//         downloadingFileName: musicName,
//       );
//     } catch (e) {
//       debugPrint("Download error: $e");
//       state = state.copyWith(isDownloading: false);
//     }
//   }

//   void resetDownloadComplete() {
//     state = state.copyWith(showDownloadComplete: false);
//   }

//   @override
//   void dispose() {
//     if (_disposed) return;
//     _disposed = true;
//     _mounted = false;

//     _rewardTimer?.cancel();
//     _amplitudeTimer?.cancel();
//     _playerStateSubscription?.cancel();
//     _firestoreSubscription?.cancel();

//     try {
//       if (!_amplitudeController.isClosed) {
//         _amplitudeController.close();
//       }
//       ref.read(currentMusicProvider.notifier).stop();
//       state.audioPlayer.dispose();
//     } catch (e) {
//       debugPrint('Error disposing resources: $e');
//     }

//     super.dispose();
//   }
// }

// // FIXED: Provider definition - REMOVE AUTO DISPOSE
// final musicPlayerProvider = StateNotifierProvider.family<
//   MusicPlayerNotifier,
//   MusicPlayerState,
//   ({List<Results> songList, int initialIndex})
// >((ref, args) {
//   final notifier = MusicPlayerNotifier(
//     songList: args.songList,
//     initialIndex: args.initialIndex,
//     ref: ref,
//   );

//   // Add manual disposal
//   ref.onDispose(() {
//     if (notifier.mounted) {
//       notifier.dispose();
//     }
//   });

//   // Listen to state changes for dialog
//   notifier.addListener((state) {
//     if (state.dialogShown && !ref.read(dialogShownProvider)) {
//       ref.read(dialogShownProvider.notifier).state = true;
//     }
//   });

//   return notifier;
// });

// final dialogShownProvider = StateProvider<bool>((ref) => false);

// class Amplitude {
//   final double min;
//   final double max;
//   final double? current;

//   Amplitude({required this.min, required this.max, this.current});
// }

// // FIXED: FavoriteProvider
// class FavoriteProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   List<Map<String, dynamic>> _favorites = [];
//   final Set<String> _loadingSongIds = {};

//   List<Map<String, dynamic>> get favorites => _favorites;
//   bool isLoading(String songId) => _loadingSongIds.contains(songId);

//   Future<void> fetchFavorites() async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) return;

//       final snapshot =
//           await _firestore
//               .collection('users')
//               .doc(user.uid)
//               .collection('favorites')
//               .get();

//       _favorites = snapshot.docs.map((doc) => doc.data()).toList();
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error fetching favorites: $e');
//     }
//   }

//   Future<void> toggleFavorite(Map<String, dynamic> song) async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) return;

//       _loadingSongIds.add(song['id']);
//       notifyListeners();

//       final favoritesRef = _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('favorites')
//           .doc(song['id'].toString());

//       final doc = await favoritesRef.get();

//       if (doc.exists) {
//         await favoritesRef.delete();
//         _favorites.removeWhere((s) => s['id'] == song['id']);
//       } else {
//         await favoritesRef.set(song);
//         _favorites.add(song);
//       }
//     } catch (e) {
//       debugPrint('Error toggling favorite: $e');
//     } finally {
//       _loadingSongIds.remove(song['id']);
//       notifyListeners();
//     }
//   }

//   bool isFavorite(String id) {
//     return _favorites.any((s) => s['id'] == id);
//   }
// }

// final activeMusicPlayerProvider = StateProvider<MusicPlayerNotifier?>(
//   (ref) => null,
// );

// // FIXED: Helper function for getting current music player
// MusicPlayerNotifier? getCurrentMusicPlayer(WidgetRef ref) {
//   try {
//     final currentMusicState = ref.read(currentMusicProvider);

//     if (currentMusicState.playlist.isEmpty ||
//         currentMusicState.currentSong == null) {
//       return null;
//     }

//     final providerFamily = musicPlayerProvider((
//       songList: currentMusicState.playlist,
//       initialIndex: currentMusicState.currentIndex,
//     ));

//     if (!ref.exists(providerFamily)) {
//       return null;
//     }

//     final notifier = ref.read(providerFamily.notifier);
//     if (!notifier.mounted) return null;

//     ref.read(activeMusicPlayerProvider.notifier).state = notifier;
//     return notifier;
//   } catch (e) {
//     debugPrint("Error getting music player: $e");
//     return null;
//   }
// }
