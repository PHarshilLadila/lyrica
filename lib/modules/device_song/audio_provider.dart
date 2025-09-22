// providers/audio_provider.dart
import 'package:flutter/foundation.dart';
import 'package:lyrica/services/audio_service.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayerService _audioService = AudioPlayerService();

  List<String> _songs = [];
  String? _currentSong;
  final int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration? _duration;

  AudioProvider() {
    _setupListeners();
  }

  void _setupListeners() {
    _audioService.songsStream.listen((songs) {
      _songs = songs;
      notifyListeners();
    });

    _audioService.currentSongStream.listen((song) {
      _currentSong = song;
      notifyListeners();
    });

    _audioService.playerStateStream.listen((playerState) {
      _isPlaying = playerState.playing;
      notifyListeners();
    });

    _audioService.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    _audioService.durationStream.listen((duration) {
      _duration = duration;
      notifyListeners();
    });
  }

  Future<void> loadSongs() async {
    try {
      await _audioService.loadSongsFromDevice();
    } catch (e) {
      throw Exception('Failed to load songs: $e');
    }
  }

  Future<void> playSong(int index) async {
    await _audioService.playSong(index);
  }

  Future<void> play() async {
    await _audioService.play();
  }

  Future<void> pause() async {
    await _audioService.pause();
  }

  Future<void> stop() async {
    await _audioService.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  Future<void> next() async {
    await _audioService.next();
  }

  Future<void> previous() async {
    await _audioService.previous();
  }

  // Getters
  List<String> get songs => _songs;
  String? get currentSong => _currentSong;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration? get duration => _duration;

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
