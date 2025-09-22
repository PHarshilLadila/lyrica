// services/audio_service.dart
// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _songs = [];
  int _currentIndex = 0;

  // Stream controllers for state management
  final StreamController<List<String>> _songsController =
      StreamController<List<String>>.broadcast();
  final StreamController<String> _currentSongController =
      StreamController<String>.broadcast();
  final StreamController<PlayerState> _playerStateController =
      StreamController<PlayerState>.broadcast();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration?> _durationController =
      StreamController<Duration?>.broadcast();

  AudioPlayerService() {
    _setupAudioPlayerListeners();
  }

  void _setupAudioPlayerListeners() {
    _audioPlayer.playerStateStream.listen((playerState) {
      _playerStateController.add(playerState);
    });

    _audioPlayer.positionStream.listen((position) {
      _positionController.add(position);
    });

    _audioPlayer.durationStream.listen((duration) {
      _durationController.add(duration);
    });
  }

  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> loadSongsFromDevice() async {
    try {
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        _songs =
            result.files
                .map((file) => file.path!)
                .where((path) => path != null)
                .toList();
        _songsController.add(_songs);

        if (_songs.isNotEmpty) {
          await playSong(0);
        }
      }
    } catch (e) {
      throw Exception('Failed to load songs: $e');
    }
  }

  Future<void> playSong(int index) async {
    if (index < 0 || index >= _songs.length) return;

    _currentIndex = index;
    final songPath = _songs[index];

    try {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(songPath)));
      await _audioPlayer.play();
      _currentSongController.add(songPath);
    } catch (e) {
      throw Exception('Failed to play song: $e');
    }
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> next() async {
    if (_currentIndex < _songs.length - 1) {
      await playSong(_currentIndex + 1);
    }
  }

  Future<void> previous() async {
    if (_currentIndex > 0) {
      await playSong(_currentIndex - 1);
    }
  }

  // Stream getters
  Stream<List<String>> get songsStream => _songsController.stream;
  Stream<String> get currentSongStream => _currentSongController.stream;
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration?> get durationStream => _durationController.stream;

  // Current state getters
  List<String> get songs => _songs;
  String? get currentSong =>
      _currentIndex < _songs.length ? _songs[_currentIndex] : null;
  int get currentIndex => _currentIndex;

  void dispose() {
    _audioPlayer.dispose();
    _songsController.close();
    _currentSongController.close();
    _playerStateController.close();
    _positionController.close();
    _durationController.close();
  }
}
