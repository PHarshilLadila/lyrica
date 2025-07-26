import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/services/mongodb_service.dart';
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
    );
  }
}

class MusicPlayerNotifier extends StateNotifier<MusicPlayerState> {
  final List<Results> songList;
  final int initialIndex;
  final Ref ref;

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
    playerStateStream = state.audioPlayer.playerStateStream;
    _initializePlayer();
    _listenRewardPoints();
    // FlutterDownloader.registerCallback(
    //   (id, status, progress) =>
    //       downloadCallback(id, "" as DownloadTaskStatus, progress),
    // );
  }

  Stream<Duration> get positionStream => state.audioPlayer.positionStream;
  Stream<Duration?> get durationStream => state.audioPlayer.durationStream;
  Stream<Amplitude> get amplitudeStream => _amplitudeController.stream;

  void _initializePlayer() {
    _playerStateSubscription = state.audioPlayer.playerStateStream.listen((
      state,
    ) {
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
    if (state.currentIndex < songList.length - 1) {
      final newIndex = state.currentIndex + 1;
      state = state.copyWith(currentIndex: newIndex);
      _loadSong(newIndex, isAutoPlay: true);
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
              _loadSong(state.currentIndex);
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
      }
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }

    _rewardTimer?.cancel();
    _rewardTimer = null;
  }

  Future<void> _loadSong(int index, {bool isAutoPlay = false}) async {
    try {
      await state.audioPlayer.stop();

      if (state.isSkipping) {
        state = state.copyWith(isSkipping: false);
      }

      if (!isAutoPlay && state.currentRewardPoints <= 0) {
        _stopMusicAndShowDialog();
        return;
      }

      final url = songList[index].audio;
      if (url != null) {
        debugPrint("$url is now playing");
        await state.audioPlayer.setUrl(url);
        await state.audioPlayer.play();
        debugPrint('Playing next song automatically');
      }

      state = state.copyWith(lastDeductedMinute: 0);
    } catch (e) {
      debugPrint('Error loading song: $e');
    }
  }

  Future<void> playPause() async {
    if (state.currentRewardPoints <= 0) {
      _stopMusicAndShowDialog();
      return;
    }

    try {
      if (state.audioPlayer.playing) {
        await state.audioPlayer.pause();
      } else {
        await state.audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error in play/pause: $e');
    }
  }

  void nextSong() {
    if (state.currentIndex < songList.length - 1) {
      final newIndex = state.currentIndex + 1;
      state = state.copyWith(currentIndex: newIndex, isSkipping: true);
      _loadSong(newIndex);
    }
  }

  void previousSong() {
    if (state.currentIndex > 0) {
      final newIndex = state.currentIndex - 1;
      state = state.copyWith(currentIndex: newIndex, isSkipping: true);
      _loadSong(newIndex);
    }
  }

  void seek(double value) {
    try {
      state.audioPlayer.seek(Duration(seconds: value.toInt()));
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

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

      // Progress will be handled by the static callback and downloadProgressProvider
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
    _rewardTimer?.cancel();
    _amplitudeTimer?.cancel();
    _playerStateSubscription?.cancel();
    _firestoreSubscription?.cancel();

    try {
      if (!_amplitudeController.isClosed) {
        _amplitudeController.close();
      }
      state.audioPlayer.dispose();
    } catch (e) {
      debugPrint('Error disposing resources: $e');
    }

    super.dispose();
  }
}

final musicPlayerProvider = StateNotifierProvider.autoDispose.family<
  MusicPlayerNotifier,
  MusicPlayerState,
  ({List<Results> songList, int initialIndex})
>((ref, args) {
  return MusicPlayerNotifier(
    songList: args.songList,
    initialIndex: args.initialIndex,
    ref: ref,
  )..addListener((state) {
    if (state.dialogShown) {
      ref.read(dialogShownProvider.notifier).state = true;
    }
  });
});

final dialogShownProvider = StateProvider<bool>((ref) => false);

class Amplitude {
  final double min;
  final double max;
  final double? current;

  Amplitude({required this.min, required this.max, this.current});
}
// favorite provider

// final favoriteProvider = StateNotifierProvider<FavoriteNotifier, Set<String>>((
//   ref,
// ) {
//   return FavoriteNotifier();
// });

class FavoriteProvider with ChangeNotifier {
  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  Future<void> fetchFavorites() async {
    _favorites = await MongoDatabaseService.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(Map<String, dynamic> song) async {
    if (MongoDatabaseService.favoriteCollection == null) return;

    final exists = _favorites.any((s) => s["id"] == song["id"]);
    if (exists) {
      await MongoDatabaseService.removeFavorite(song["id"]);
      _favorites.removeWhere((s) => s["id"] == song["id"]);
      debugPrint("Remove Song in to Favorite: ${song["id"]}");
    } else {
      await MongoDatabaseService.addFavorite(song);
      _favorites.add(song);
      debugPrint("Add Song in to Favorite: $song");
    }
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((s) => s["id"] == id);
  }
}
