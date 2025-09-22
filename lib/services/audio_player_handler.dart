// // // // // audio_player_handler.dart
// // // // import 'dart:async';

// // // // import 'package:audio_service/audio_service.dart';
// // // // import 'package:just_audio/just_audio.dart';
// // // // import 'package:lyrica/model/music_model.dart';

// // // // class AudioPlayerHandler extends BaseAudioHandler {
// // // //   final AudioPlayer _player = AudioPlayer();
// // // //   final List<MediaItem> _mediaItems = [];
// // // //   int _currentIndex = 0;

// // // //   AudioPlayerHandler() {
// // // //     _player.playbackEventStream.listen((event) {
// // // //       playbackState.add(_transformEvent(event));
// // // //     });
// // // //     _player.positionStream.listen((position) {
// // // //       playbackState.add(
// // // //         playbackState.value.copyWith(
// // // //           updatePosition: position,
// // // //           bufferedPosition: _player.bufferedPosition,
// // // //         ),
// // // //       );
// // // //     });
// // // //     _player.processingStateStream.listen((state) {
// // // //       playbackState.add(
// // // //         playbackState.value.copyWith(
// // // //           processingState: _transformProcessingState(state),
// // // //         ),
// // // //       );
// // // //     });
// // // //     Timer.periodic(const Duration(milliseconds: 200), (timer) {
// // // //       if (_player.position != Duration.zero) {
// // // //         playbackState.add(
// // // //           playbackState.value.copyWith(
// // // //             updatePosition: _player.position,
// // // //             bufferedPosition: _player.bufferedPosition,
// // // //           ),
// // // //         );
// // // //       }
// // // //     });

// // // //     _player.playbackEventStream.listen((event) {
// // // //       playbackState.add(_transformEvent(event));
// // // //     });

// // // //     _player.processingStateStream.listen((state) {
// // // //       playbackState.add(
// // // //         playbackState.value.copyWith(
// // // //           processingState: _transformProcessingState(state),
// // // //         ),
// // // //       );
// // // //     });
// // // //   }

// // // //   @override
// // // //   Future<void> play() => _player.play();

// // // //   @override
// // // //   Future<void> pause() => _player.pause();

// // // //   @override
// // // //   Future<void> stop() => _player.stop();

// // // //   @override
// // // //   Future<void> seek(Duration position) => _player.seek(position);

// // // //   @override
// // // //   Future<void> skipToNext() => skip(_currentIndex + 1);

// // // //   @override
// // // //   Future<void> skipToPrevious() => skip(_currentIndex - 1);

// // // //   Future<void> skip(int index) async {
// // // //     if (index < 0 || index >= _mediaItems.length) return;
// // // //     _currentIndex = index;

// // // //     final item = _mediaItems[index];
// // // //     mediaItem.add(item);

// // // //     await _player.setAudioSource(
// // // //       AudioSource.uri(Uri.parse(_getAudioUrl(index)), tag: item),
// // // //     );

// // // //     await play();
// // // //   }

// // // //   String _getAudioUrl(int index) {
// // // //     return _mediaItems[index].id;
// // // //   }

// // // //   Future<void> setMediaItems(List<Results> songs, int initialIndex) async {
// // // //     _mediaItems.clear();
// // // //     _mediaItems.addAll(
// // // //       songs
// // // //           .map(
// // // //             (song) => MediaItem(
// // // //               id: song.id?.toString() ?? song.audio ?? "",
// // // //               title: song.name ?? "Unknown Title",
// // // //               artist: song.artistName ?? "Unknown Artist",
// // // //               artUri:
// // // //                   song.image != null && song.image!.isNotEmpty
// // // //                       ? Uri.parse(song.image!)
// // // //                       : null,
// // // //             ),
// // // //           )
// // // //           .toList(),
// // // //     );

// // // //     _currentIndex = initialIndex;
// // // //     mediaItem.add(_mediaItems[_currentIndex]);

// // // //     queue.add(_mediaItems);

// // // //     await _player.setAudioSource(
// // // //       AudioSource.uri(
// // // //         Uri.parse(_getAudioUrl(initialIndex)),
// // // //         tag: _mediaItems[initialIndex],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Future<void> setCurrentSong(Results song) async {
// // // //     final mediaItem = MediaItem(
// // // //       id: song.id?.toString() ?? song.audio ?? "",
// // // //       title: song.name ?? "Unknown Title",
// // // //       artist: song.artistName ?? "Unknown Artist",
// // // //       artUri:
// // // //           song.image != null && song.image!.isNotEmpty
// // // //               ? Uri.parse(song.image!)
// // // //               : null,
// // // //       duration:
// // // //           song.duration != null ? Duration(seconds: song.duration!) : null,
// // // //     );

// // // //     this.mediaItem.add(mediaItem);

// // // //     // Set the audio source
// // // //     await _player.setAudioSource(
// // // //       AudioSource.uri(Uri.parse(song.audio ?? ""), tag: mediaItem),
// // // //     );
// // // //   }

// // // //   AudioProcessingState _transformProcessingState(ProcessingState state) {
// // // //     switch (state) {
// // // //       case ProcessingState.idle:
// // // //         return AudioProcessingState.idle;
// // // //       case ProcessingState.loading:
// // // //         return AudioProcessingState.loading;
// // // //       case ProcessingState.buffering:
// // // //         return AudioProcessingState.buffering;
// // // //       case ProcessingState.ready:
// // // //         return AudioProcessingState.ready;
// // // //       case ProcessingState.completed:
// // // //         return AudioProcessingState.completed;
// // // //       default:
// // // //         return AudioProcessingState.idle;
// // // //     }
// // // //   }

// // // //   PlaybackState _transformEvent(PlaybackEvent event) {
// // // //     return PlaybackState(
// // // //       controls: [
// // // //         MediaControl.skipToPrevious,
// // // //         if (_player.playing) MediaControl.pause else MediaControl.play,
// // // //         MediaControl.stop,
// // // //         MediaControl.skipToNext,
// // // //       ],

// // // //       systemActions: const {
// // // //         MediaAction.seek,
// // // //         MediaAction.seekForward,
// // // //         MediaAction.seekBackward,
// // // //         MediaAction.skipToNext,
// // // //         MediaAction.skipToPrevious,
// // // //       },
// // // //       androidCompactActionIndices: const [0, 1, 2],
// // // //       processingState: _transformProcessingState(event.processingState),
// // // //       playing: _player.playing,
// // // //       updatePosition: _player.position,
// // // //       bufferedPosition: _player.bufferedPosition,
// // // //       speed: _player.speed,
// // // //       queueIndex: event.currentIndex,
// // // //     );
// // // //   }
// // // // }
// // // // audio_player_handler.dart - FIXED VERSION

// // // import 'dart:async';

// // // import 'package:audio_service/audio_service.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:just_audio/just_audio.dart';
// // // import 'package:lyrica/model/music_model.dart';

// // // class AudioPlayerHandler extends BaseAudioHandler {
// // //   final AudioPlayer _player = AudioPlayer();
// // //   final List<MediaItem> _mediaItems = [];
// // //   int _currentIndex = 0;

// // //   AudioPlayerHandler() {
// // //     // FIXED: Initialize playback state properly
// // //     playbackState.add(
// // //       PlaybackState(
// // //         controls: [
// // //           MediaControl.skipToPrevious,
// // //           MediaControl.play,
// // //           MediaControl.stop,
// // //           MediaControl.skipToNext,
// // //         ],
// // //         systemActions: const {
// // //           MediaAction.seek,
// // //           MediaAction.seekForward,
// // //           MediaAction.seekBackward,
// // //         },
// // //         androidCompactActionIndices: const [0, 1, 3],
// // //         processingState: AudioProcessingState.idle,
// // //         playing: false,
// // //         updatePosition: Duration.zero,
// // //         bufferedPosition: Duration.zero,
// // //         speed: 1.0,
// // //         queueIndex: 0,
// // //       ),
// // //     );

// // //     // FIXED: Listen to player state changes and update playback state
// // //     _player.playbackEventStream.listen((event) {
// // //       final state = _transformEvent(event);
// // //       playbackState.add(state);
// // //     });

// // //     // FIXED: Listen to position changes with proper timing
// // //     _player.positionStream.listen((position) {
// // //       if (playbackState.hasValue) {
// // //         playbackState.add(
// // //           playbackState.value.copyWith(
// // //             updatePosition: position,
// // //             bufferedPosition: _player.bufferedPosition,
// // //           ),
// // //         );
// // //       }
// // //     });

// // //     // FIXED: Listen to processing state changes
// // //     _player.processingStateStream.listen((state) {
// // //       if (playbackState.hasValue) {
// // //         playbackState.add(
// // //           playbackState.value.copyWith(
// // //             processingState: _transformProcessingState(state),
// // //           ),
// // //         );
// // //       }
// // //     });

// // //     // FIXED: Listen to player state for playing status
// // //     _player.playerStateStream.listen((playerState) {
// // //       if (playbackState.hasValue) {
// // //         playbackState.add(
// // //           playbackState.value.copyWith(
// // //             playing: playerState.playing,
// // //             processingState: _transformProcessingState(
// // //               playerState.processingState,
// // //             ),
// // //           ),
// // //         );
// // //       }
// // //     });

// // //     // FIXED: Periodic position updates for better synchronization
// // //     Timer.periodic(const Duration(milliseconds: 200), (timer) {
// // //       if (_player.position != Duration.zero && playbackState.hasValue) {
// // //         playbackState.add(
// // //           playbackState.value.copyWith(
// // //             updatePosition: _player.position,
// // //             bufferedPosition: _player.bufferedPosition,
// // //           ),
// // //         );
// // //       }
// // //     });
// // //   }

// // //   @override
// // //   Future<void> play() async {
// // //     try {
// // //       await _player.play();
// // //       // FIXED: Update playback state immediately
// // //       if (playbackState.hasValue) {
// // //         playbackState.add(
// // //           playbackState.value.copyWith(
// // //             playing: true,
// // //             controls: [
// // //               MediaControl.skipToPrevious,
// // //               MediaControl.pause,
// // //               MediaControl.stop,
// // //               MediaControl.skipToNext,
// // //             ],
// // //           ),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error playing audio: $e');
// // //     }
// // //   }

// // //   @override
// // //   Future<void> pause() async {
// // //     try {
// // //       await _player.pause();
// // //       // FIXED: Update playback state immediately
// // //       if (playbackState.hasValue) {
// // //         playbackState.add(
// // //           playbackState.value.copyWith(
// // //             playing: false,
// // //             controls: [
// // //               MediaControl.skipToPrevious,
// // //               MediaControl.play,
// // //               MediaControl.stop,
// // //               MediaControl.skipToNext,
// // //             ],
// // //           ),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error pausing audio: $e');
// // //     }
// // //   }

// // //   @override
// // //   Future<void> stop() async {
// // //     try {
// // //       await _player.stop();
// // //       // FIXED: Update playback state immediately
// // //       if (playbackState.hasValue) {
// // //         playbackState.add(
// // //           playbackState.value.copyWith(
// // //             playing: false,
// // //             processingState: AudioProcessingState.idle,
// // //             updatePosition: Duration.zero,
// // //             bufferedPosition: Duration.zero,
// // //             controls: [
// // //               MediaControl.skipToPrevious,
// // //               MediaControl.play,
// // //               MediaControl.stop,
// // //               MediaControl.skipToNext,
// // //             ],
// // //           ),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error stopping audio: $e');
// // //     }
// // //   }

// // //   @override
// // //   Future<void> seek(Duration position) async {
// // //     try {
// // //       await _player.seek(position);
// // //       // FIXED: Update playback state immediately after seeking
// // //       if (playbackState.hasValue) {
// // //         playbackState.add(
// // //           playbackState.value.copyWith(updatePosition: position),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error seeking audio: $e');
// // //     }
// // //   }

// // //   @override
// // //   Future<void> skipToNext() => skip(_currentIndex + 1);

// // //   @override
// // //   Future<void> skipToPrevious() => skip(_currentIndex - 1);

// // //   Future<void> skip(int index) async {
// // //     if (index < 0 || index >= _mediaItems.length) return;
// // //     _currentIndex = index;

// // //     final item = _mediaItems[index];
// // //     mediaItem.add(item);

// // //     try {
// // //       await _player.setAudioSource(
// // //         AudioSource.uri(Uri.parse(_getAudioUrl(index)), tag: item),
// // //       );
// // //       await play();
// // //     } catch (e) {
// // //       debugPrint('Error skipping to track: $e');
// // //     }
// // //   }

// // //   String _getAudioUrl(int index) {
// // //     // FIXED: Use the actual audio URL from the media item's extras or id
// // //     final item = _mediaItems[index];
// // //     return item.extras?['audioUrl'] ?? item.id;
// // //   }

// // //   Future<void> setMediaItems(List<Results> songs, int initialIndex) async {
// // //     _mediaItems.clear();
// // //     _mediaItems.addAll(
// // //       songs
// // //           .map(
// // //             (song) => MediaItem(
// // //               id: song.id?.toString() ?? song.audio ?? "",
// // //               title: song.name ?? "Unknown Title",
// // //               artist: song.artistName ?? "Unknown Artist",
// // //               artUri:
// // //                   song.image != null && song.image!.isNotEmpty
// // //                       ? Uri.parse(song.image!)
// // //                       : null,
// // //               duration:
// // //                   song.duration != null
// // //                       ? Duration(seconds: song.duration!)
// // //                       : null,
// // //               // FIXED: Store actual audio URL in extras
// // //               extras: {'audioUrl': song.audio ?? ''},
// // //             ),
// // //           )
// // //           .toList(),
// // //     );

// // //     _currentIndex = initialIndex.clamp(0, _mediaItems.length - 1);
// // //     if (_mediaItems.isNotEmpty) {
// // //       mediaItem.add(_mediaItems[_currentIndex]);
// // //       queue.add(_mediaItems);

// // //       try {
// // //         await _player.setAudioSource(
// // //           AudioSource.uri(
// // //             Uri.parse(_getAudioUrl(_currentIndex)),
// // //             tag: _mediaItems[_currentIndex],
// // //           ),
// // //         );
// // //       } catch (e) {
// // //         debugPrint('Error setting media items: $e');
// // //       }
// // //     }
// // //   }

// // //   // FIXED: Set current song with proper error handling and state management
// // //   Future<void> setCurrentSong(Results song) async {
// // //     try {
// // //       final audioUrl = song.audio;
// // //       if (audioUrl == null || audioUrl.isEmpty) {
// // //         debugPrint('Error: Audio URL is null or empty');
// // //         return;
// // //       }

// // //       // FIXED: Stop current playback first
// // //       await _player.stop();

// // //       final mediaItemData = MediaItem(
// // //         id: song.id?.toString() ?? audioUrl,
// // //         title: song.name ?? "Unknown Title",
// // //         artist: song.artistName ?? "Unknown Artist",
// // //         artUri:
// // //             song.image != null && song.image!.isNotEmpty
// // //                 ? Uri.parse(song.image!)
// // //                 : null,
// // //         duration:
// // //             song.duration != null ? Duration(seconds: song.duration!) : null,
// // //         extras: {'audioUrl': audioUrl},
// // //       );

// // //       // FIXED: Update media item immediately
// // //       mediaItem.add(mediaItemData);

// // //       // FIXED: Set the audio source with proper error handling
// // //       await _player.setAudioSource(
// // //         AudioSource.uri(Uri.parse(audioUrl), tag: mediaItemData),
// // //       );

// // //       // FIXED: Update playback state to ready but DON'T auto-play
// // //       playbackState.add(
// // //         PlaybackState(
// // //           controls: [
// // //             MediaControl.skipToPrevious,
// // //             MediaControl.play, // Keep it as play button, not pause
// // //             MediaControl.stop,
// // //             MediaControl.skipToNext,
// // //           ],
// // //           processingState: AudioProcessingState.ready,
// // //           playing: false, // Don't set playing to true automatically
// // //           updatePosition: Duration.zero,
// // //           bufferedPosition: Duration.zero,
// // //           speed: 1.0,
// // //           queueIndex: 0,
// // //         ),
// // //       );

// // //       debugPrint('Successfully set current song: ${song.name}');
// // //     } catch (e) {
// // //       debugPrint('Error setting current song: $e');

// // //       // FIXED: Update playback state to reflect error
// // //       playbackState.add(
// // //         PlaybackState(
// // //           processingState: AudioProcessingState.error,
// // //           playing: false,
// // //           updatePosition: Duration.zero,
// // //           bufferedPosition: Duration.zero,
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   // FIXED: Proper processing state transformation
// // //   AudioProcessingState _transformProcessingState(ProcessingState state) {
// // //     switch (state) {
// // //       case ProcessingState.idle:
// // //         return AudioProcessingState.idle;
// // //       case ProcessingState.loading:
// // //         return AudioProcessingState.loading;
// // //       case ProcessingState.buffering:
// // //         return AudioProcessingState.buffering;
// // //       case ProcessingState.ready:
// // //         return AudioProcessingState.ready;
// // //       case ProcessingState.completed:
// // //         return AudioProcessingState.completed;
// // //     }
// // //   }

// // //   // FIXED: Enhanced playback event transformation
// // //   PlaybackState _transformEvent(PlaybackEvent event) {
// // //     return PlaybackState(
// // //       controls: [
// // //         MediaControl.skipToPrevious,
// // //         if (_player.playing) MediaControl.pause else MediaControl.play,
// // //         MediaControl.stop,
// // //         MediaControl.skipToNext,
// // //       ],
// // //       systemActions: const {
// // //         MediaAction.seek,
// // //         MediaAction.seekForward,
// // //         MediaAction.seekBackward,
// // //         MediaAction.skipToNext,
// // //         MediaAction.skipToPrevious,
// // //       },
// // //       androidCompactActionIndices: const [0, 1, 2],
// // //       processingState: _transformProcessingState(event.processingState),
// // //       playing: _player.playing,
// // //       updatePosition: _player.position,
// // //       bufferedPosition: _player.bufferedPosition,
// // //       speed: _player.speed,
// // //       queueIndex: event.currentIndex,
// // //     );
// // //   }

// // //   @override
// // //   Future<void> onTaskRemoved() async {
// // //     // FIXED: Properly handle task removal
// // //     await stop();
// // //     await super.onTaskRemoved();
// // //   }

// // //   // FIXED: Proper disposal
// // //   void dispose() {
// // //     _player.dispose();
// // //   }
// // // }
// // import 'dart:async';

// // import 'package:audio_service/audio_service.dart';
// // import 'package:flutter/material.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:lyrica/model/music_model.dart';

// // class AudioPlayerHandler extends BaseAudioHandler {
// //   final AudioPlayer _player = AudioPlayer();
// //   final List<MediaItem> _mediaItems = [];
// //   int _currentIndex = 0;
// //   bool _isDisposed = false;
// //   bool _hasCurrentSong = false;

// //   AudioPlayerHandler() {
// //     _initializePlayer();
// //   }

// //   void _initializePlayer() {
// //     if (_isDisposed) return;

// //     // Initialize playback state
// //     playbackState.add(
// //       PlaybackState(
// //         controls: [
// //           MediaControl.skipToPrevious,
// //           MediaControl.play,
// //           MediaControl.stop,
// //           MediaControl.skipToNext,
// //         ],
// //         systemActions: const {
// //           MediaAction.seek,
// //           MediaAction.seekForward,
// //           MediaAction.seekBackward,
// //         },
// //         androidCompactActionIndices: const [0, 1, 3],
// //         processingState: AudioProcessingState.idle,
// //         playing: false,
// //         updatePosition: Duration.zero,
// //         bufferedPosition: Duration.zero,
// //         speed: 1.0,
// //         queueIndex: 0,
// //       ),
// //     );

// //     // Listen to player state changes
// //     _player.playbackEventStream.listen((event) {
// //       if (_isDisposed) return;
// //       final state = _transformEvent(event);
// //       playbackState.add(state);
// //     });

// //     // Listen to position changes
// //     _player.positionStream.listen((position) {
// //       if (_isDisposed || !playbackState.hasValue) return;
// //       playbackState.add(
// //         playbackState.value.copyWith(
// //           updatePosition: position,
// //           bufferedPosition: _player.bufferedPosition,
// //         ),
// //       );
// //     });

// //     // Listen to processing state changes
// //     _player.processingStateStream.listen((state) {
// //       if (_isDisposed || !playbackState.hasValue) return;
// //       playbackState.add(
// //         playbackState.value.copyWith(
// //           processingState: _transformProcessingState(state),
// //         ),
// //       );
// //     });

// //     // Listen to player state for playing status
// //     _player.playerStateStream.listen((playerState) {
// //       if (_isDisposed || !playbackState.hasValue) return;
// //       playbackState.add(
// //         playbackState.value.copyWith(
// //           playing: playerState.playing,
// //           processingState: _transformProcessingState(
// //             playerState.processingState,
// //           ),
// //         ),
// //       );
// //     });

// //     // Handle playback completion
// //     _player.playerStateStream
// //         .where((state) => state.processingState == ProcessingState.completed)
// //         .listen((_) {
// //           if (_isDisposed) return;
// //           skipToNext();
// //         });
// //   }

// //   @override
// //   Future<void> play() async {
// //     if (_isDisposed || !_hasCurrentSong) {
// //       debugPrint('Warning: Cannot play - no current song or handler disposed');
// //       return;
// //     }

// //     try {
// //       await _player.play();
// //       _updatePlaybackState();
// //     } catch (e) {
// //       debugPrint('Error playing audio: $e');
// //     }
// //   }

// //   @override
// //   Future<void> pause() async {
// //     if (_isDisposed || !_hasCurrentSong) {
// //       debugPrint('Warning: Cannot pause - no current song or handler disposed');
// //       return;
// //     }

// //     try {
// //       await _player.pause();
// //       _updatePlaybackState();
// //     } catch (e) {
// //       debugPrint('Error pausing audio: $e');
// //     }
// //   }

// //   @override
// //   Future<void> stop() async {
// //     if (_isDisposed) return;

// //     try {
// //       await _player.stop();
// //       _hasCurrentSong = false;
// //       _updatePlaybackState();
// //     } catch (e) {
// //       debugPrint('Error stopping audio: $e');
// //     }
// //   }

// //   @override
// //   Future<void> seek(Duration position) async {
// //     if (_isDisposed || !_hasCurrentSong) return;

// //     try {
// //       await _player.seek(position);
// //       if (playbackState.hasValue) {
// //         playbackState.add(
// //           playbackState.value.copyWith(updatePosition: position),
// //         );
// //       }
// //     } catch (e) {
// //       debugPrint('Error seeking audio: $e');
// //     }
// //   }

// //   @override
// //   Future<void> skipToNext() => _skip(_currentIndex + 1);

// //   @override
// //   Future<void> skipToPrevious() => _skip(_currentIndex - 1);

// //   Future<void> _skip(int index) async {
// //     if (_isDisposed || _mediaItems.isEmpty) return;

// //     index = index.clamp(0, _mediaItems.length - 1);
// //     _currentIndex = index;

// //     final item = _mediaItems[index];
// //     mediaItem.add(item);

// //     try {
// //       await _player.setAudioSource(
// //         AudioSource.uri(Uri.parse(_getAudioUrl(index)), tag: item),
// //       );
// //       _hasCurrentSong = true;
// //       await play();
// //     } catch (e) {
// //       debugPrint('Error skipping to track: $e');
// //       _hasCurrentSong = false;
// //     }
// //   }

// //   String _getAudioUrl(int index) {
// //     final item = _mediaItems[index];
// //     return item.extras?['audioUrl'] ?? item.id;
// //   }

// //   Future<void> setMediaItems(List<Results> songs, int initialIndex) async {
// //     if (_isDisposed) return;

// //     _mediaItems.clear();
// //     _mediaItems.addAll(
// //       songs
// //           .map(
// //             (song) => MediaItem(
// //               id: song.id?.toString() ?? song.audio ?? "",
// //               title: song.name ?? "Unknown Title",
// //               artist: song.artistName ?? "Unknown Artist",
// //               artUri:
// //                   song.image != null && song.image!.isNotEmpty
// //                       ? Uri.parse(song.image!)
// //                       : null,
// //               duration:
// //                   song.duration != null
// //                       ? Duration(seconds: song.duration!)
// //                       : null,
// //               extras: {'audioUrl': song.audio ?? ''},
// //             ),
// //           )
// //           .toList(),
// //     );

// //     if (_mediaItems.isEmpty) {
// //       _hasCurrentSong = false;
// //       return;
// //     }

// //     _currentIndex = initialIndex.clamp(0, _mediaItems.length - 1);
// //     mediaItem.add(_mediaItems[_currentIndex]);
// //     queue.add(_mediaItems);

// //     try {
// //       await _player.setAudioSource(
// //         AudioSource.uri(
// //           Uri.parse(_getAudioUrl(_currentIndex)),
// //           tag: _mediaItems[_currentIndex],
// //         ),
// //       );
// //       _hasCurrentSong = true;
// //     } catch (e) {
// //       debugPrint('Error setting media items: $e');
// //       _hasCurrentSong = false;
// //     }
// //   }

// //   // Future<void> setCurrentSong(Results song) async {
// //   //   if (_isDisposed) return;

// //   //   try {
// //   //     final audioUrl = song.audio;
// //   //     if (audioUrl == null || audioUrl.isEmpty) {
// //   //       debugPrint('Error: Audio URL is null or empty');
// //   //       _hasCurrentSong = false;
// //   //       return;
// //   //     }

// //   //     // Stop current playback
// //   //     await _player.stop();

// //   //     final mediaItemData = MediaItem(
// //   //       id: song.id?.toString() ?? audioUrl,
// //   //       title: song.name ?? "Unknown Title",
// //   //       artist: song.artistName ?? "Unknown Artist",
// //   //       artUri:
// //   //           song.image != null && song.image!.isNotEmpty
// //   //               ? Uri.parse(song.image!)
// //   //               : null,
// //   //       duration:
// //   //           song.duration != null ? Duration(seconds: song.duration!) : null,
// //   //       extras: {'audioUrl': audioUrl},
// //   //     );

// //   //     // Update media item
// //   //     mediaItem.add(mediaItemData);

// //   //     // Set audio source
// //   //     await _player.setAudioSource(
// //   //       AudioSource.uri(Uri.parse(audioUrl), tag: mediaItemData),
// //   //     );

// //   //     _hasCurrentSong = true;

// //   //     // Update playback state to ready but don't auto-play
// //   //     playbackState.add(
// //   //       PlaybackState(
// //   //         controls: [
// //   //           MediaControl.skipToPrevious,
// //   //           MediaControl.play,
// //   //           MediaControl.stop,
// //   //           MediaControl.skipToNext,
// //   //         ],
// //   //         processingState: AudioProcessingState.ready,
// //   //         playing: false,
// //   //         updatePosition: Duration.zero,
// //   //         bufferedPosition: _player.bufferedPosition,
// //   //         speed: 1.0,
// //   //         queueIndex: 0,
// //   //       ),
// //   //     );

// //   //     debugPrint('Successfully set current song: ${song.name}');
// //   //   } catch (e) {
// //   //     debugPrint('Error setting current song: $e');
// //   //     _hasCurrentSong = false;

// //   //     playbackState.add(
// //   //       PlaybackState(
// //   //         processingState: AudioProcessingState.error,
// //   //         playing: false,
// //   //         updatePosition: Duration.zero,
// //   //         bufferedPosition: Duration.zero,
// //   //       ),
// //   //     );
// //   //   }
// //   // }
// //   Future<void> setCurrentSong(Results song, {List<Results>? playlist}) async {
// //     if (_isDisposed) return;

// //     try {
// //       // If a playlist is passed, set queue
// //       if (playlist != null && playlist.isNotEmpty) {
// //         await setMediaItems(playlist, playlist.indexOf(song));
// //         return;
// //       }

// //       // Fallback: single song only
// //       final audioUrl = song.audio;
// //       if (audioUrl == null || audioUrl.isEmpty) {
// //         debugPrint('Error: Audio URL is null or empty');
// //         _hasCurrentSong = false;
// //         return;
// //       }

// //       await _player.stop();

// //       final mediaItemData = MediaItem(
// //         id: song.id?.toString() ?? audioUrl,
// //         title: song.name ?? "Unknown Title",
// //         artist: song.artistName ?? "Unknown Artist",
// //         artUri: song.image?.isNotEmpty == true ? Uri.parse(song.image!) : null,
// //         duration:
// //             song.duration != null ? Duration(seconds: song.duration!) : null,
// //         extras: {'audioUrl': audioUrl},
// //       );

// //       mediaItem.add(mediaItemData);
// //       _mediaItems
// //         ..clear()
// //         ..add(mediaItemData); // keep at least 1 item in queue
// //       _currentIndex = 0;

// //       await _player.setAudioSource(
// //         AudioSource.uri(Uri.parse(audioUrl), tag: mediaItemData),
// //       );

// //       _hasCurrentSong = true;
// //       _updatePlaybackState();
// //     } catch (e) {
// //       debugPrint('Error setting current song: $e');
// //       _hasCurrentSong = false;
// //     }
// //   }

// //   void _updatePlaybackState() {
// //     if (_isDisposed || !playbackState.hasValue) return;

// //     playbackState.add(
// //       playbackState.value.copyWith(
// //         playing: _player.playing,
// //         controls: [
// //           MediaControl.skipToPrevious,
// //           if (_player.playing) MediaControl.pause else MediaControl.play,
// //           MediaControl.stop,
// //           MediaControl.skipToNext,
// //         ],
// //       ),
// //     );
// //   }

// //   AudioProcessingState _transformProcessingState(ProcessingState state) {
// //     switch (state) {
// //       case ProcessingState.idle:
// //         return AudioProcessingState.idle;
// //       case ProcessingState.loading:
// //         return AudioProcessingState.loading;
// //       case ProcessingState.buffering:
// //         return AudioProcessingState.buffering;
// //       case ProcessingState.ready:
// //         return AudioProcessingState.ready;
// //       case ProcessingState.completed:
// //         return AudioProcessingState.completed;
// //     }
// //   }

// //   PlaybackState _transformEvent(PlaybackEvent event) {
// //     return PlaybackState(
// //       controls: [
// //         MediaControl.skipToPrevious,
// //         if (_player.playing) MediaControl.pause else MediaControl.play,
// //         MediaControl.stop,
// //         MediaControl.skipToNext,
// //       ],
// //       systemActions: const {
// //         MediaAction.seek,
// //         MediaAction.seekForward,
// //         MediaAction.seekBackward,
// //         MediaAction.skipToNext,
// //         MediaAction.skipToPrevious,
// //       },
// //       androidCompactActionIndices: const [0, 1, 2],
// //       processingState: _transformProcessingState(event.processingState),
// //       playing: _player.playing,
// //       updatePosition: _player.position,
// //       bufferedPosition: _player.bufferedPosition,
// //       speed: _player.speed,
// //       queueIndex: event.currentIndex,
// //     );
// //   }

// //   @override
// //   Future<void> onTaskRemoved() async {
// //     if (_isDisposed) return;
// //     await stop();
// //     await super.onTaskRemoved();
// //   }

// // ignore_for_file: deprecated_member_use, prefer_is_empty

// //   void dispose() {
// //     _isDisposed = true;
// //     _player.dispose();
// //   }
// // }
// // Updated AudioPlayerHandler (replace your existing class with this)

import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:lyrica/model/music_model.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();
  final List<MediaItem> _mediaItems = [];
  int _currentIndex = 0;
  bool _isDisposed = false;
  bool _hasCurrentSong = false;

  AudioPlayerHandler() {
    _initializePlayer();
  }

  void _initializePlayer() {
    if (_isDisposed) return;

    // Initialize playback state
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: AudioProcessingState.idle,
        playing: false,
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,
        speed: 1.0,
        queueIndex: 0,
      ),
    );

    // playback event -> update playbackState
    _player.playbackEventStream.listen((event) {
      if (_isDisposed) return;
      final state = _transformEvent(event);
      playbackState.add(state);
    });

    // position updates
    _player.positionStream.listen((position) {
      if (_isDisposed || !playbackState.hasValue) return;
      playbackState.add(
        playbackState.value.copyWith(
          updatePosition: position,
          bufferedPosition: _player.bufferedPosition,
        ),
      );
    });

    // processing state updates (keeps AudioService state in sync)
    _player.processingStateStream.listen((procState) {
      if (_isDisposed || !playbackState.hasValue) return;
      playbackState.add(
        playbackState.value.copyWith(
          processingState: _transformProcessingState(procState),
        ),
      );
    });

    // playerStateStream for playing flag and processing state
    _player.playerStateStream.listen((playerState) {
      if (_isDisposed || !playbackState.hasValue) return;
      playbackState.add(
        playbackState.value.copyWith(
          playing: playerState.playing,
          processingState: _transformProcessingState(
            playerState.processingState,
          ),
        ),
      );
    });

    // When a track completes, go to next (just_audio will update currentIndexStream)
    _player.playerStateStream
        .where((state) => state.processingState == ProcessingState.completed)
        .listen((_) {
          if (_isDisposed) return;
          skipToNext();
        });

    // IMPORTANT: Listen to currentIndexStream so we publish correct MediaItem when index changes
    _player.currentIndexStream.listen((index) {
      if (_isDisposed) return;
      if (index != null && index >= 0 && index < _mediaItems.length) {
        _currentIndex = index;
        mediaItem.add(_mediaItems[_currentIndex]);
        // Also update queueIndex in playback state
        if (playbackState.hasValue) {
          playbackState.add(
            playbackState.value.copyWith(queueIndex: _currentIndex),
          );
        }
      }
    });
  }

  @override
  Future<void> play() async {
    if (_isDisposed || !_hasCurrentSong) {
      debugPrint('Warning: Cannot play - no current song or handler disposed');
      return;
    }

    try {
      await _player.play();
      _updatePlaybackState();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  @override
  Future<void> pause() async {
    if (_isDisposed || !_hasCurrentSong) {
      debugPrint('Warning: Cannot pause - no current song or handler disposed');
      return;
    }

    try {
      await _player.pause();
      _updatePlaybackState();
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  @override
  Future<void> stop() async {
    if (_isDisposed) return;

    try {
      await _player.stop();
      _hasCurrentSong = false;
      _updatePlaybackState();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  @override
  Future<void> seek(Duration position) async {
    if (_isDisposed || !_hasCurrentSong) return;

    try {
      await _player.seek(position);
      if (playbackState.hasValue) {
        playbackState.add(
          playbackState.value.copyWith(updatePosition: position),
        );
      }
    } catch (e) {
      debugPrint('Error seeking audio: $e');
    }
  }

  @override
  Future<void> skipToNext() => _skip(_currentIndex + 1);

  @override
  Future<void> skipToPrevious() => _skip(_currentIndex - 1);

  Future<void> _skip(int index) async {
    if (_isDisposed || _mediaItems.isEmpty) return;

    index = index.clamp(0, _mediaItems.length - 1);
    // If we already have a sequence (ConcatenatingAudioSource), use seek with index
    try {
      if ((_player.sequence.length) > 0) {
        // jump to item by index (stays in same concatenating source)
        await _player.seek(Duration.zero, index: index);
        _currentIndex = index;
        mediaItem.add(_mediaItems[_currentIndex]);
        // start playing after skip (if desired)
        if (_player.playing) {
          // already playing; no-op
        } else {
          // auto-play after skipping (optional) — keep behavior consistent with previous code
          await _player.play();
        }
        _hasCurrentSong = true;
        _updatePlaybackState();
        return;
      } else {
        // Fallback to older behavior: set single audio source for that index (works but less efficient)
        _currentIndex = index;
        final item = _mediaItems[index];
        mediaItem.add(item);
        await _player.setAudioSource(
          AudioSource.uri(Uri.parse(_getAudioUrl(index)), tag: item),
        );
        _hasCurrentSong = true;
        await play();
      }
    } catch (e) {
      debugPrint('Error skipping to track: $e');
      _hasCurrentSong = false;
    }
  }

  String _getAudioUrl(int index) {
    final item = _mediaItems[index];
    return item.extras?['audioUrl'] ?? item.id;
  }

  // Set playlist with ConcatenatingAudioSource for correct skip/seek behavior
  Future<void> setMediaItems(List<Results> songs, int initialIndex) async {
    if (_isDisposed) return;

    _mediaItems.clear();
    _mediaItems.addAll(
      songs
          .map(
            (song) => MediaItem(
              id: song.id?.toString() ?? song.audio ?? "",
              title: song.name ?? "Unknown Title",
              artist: song.artistName ?? "Unknown Artist",
              artUri:
                  song.image != null && song.image!.isNotEmpty
                      ? Uri.parse(song.image!)
                      : null,
              duration:
                  song.duration != null
                      ? Duration(seconds: song.duration!)
                      : null,
              extras: {'audioUrl': song.audio ?? ''},
            ),
          )
          .toList(),
    );

    if (_mediaItems.isEmpty) {
      _hasCurrentSong = false;
      queue.add(_mediaItems);
      return;
    }

    _currentIndex = initialIndex.clamp(0, _mediaItems.length - 1);
    mediaItem.add(_mediaItems[_currentIndex]);
    queue.add(_mediaItems);

    try {
      // Build a concatenating audio source (works even with 1 item)
      final children =
          _mediaItems
              .map(
                (m) => AudioSource.uri(
                  Uri.parse(m.extras?['audioUrl'] ?? m.id),
                  tag: m,
                ),
              )
              .toList();

      final concat = ConcatenatingAudioSource(children: children);

      await _player.setAudioSource(concat, initialIndex: _currentIndex);
      _hasCurrentSong = true;
    } catch (e) {
      debugPrint('Error setting media items: $e');
      _hasCurrentSong = false;
    }
  }

  Future<void> setCurrentSong(Results song, {List<Results>? playlist}) async {
    if (_isDisposed) return;

    try {
      // If a playlist is passed, set queue using setMediaItems
      if (playlist != null && playlist.isNotEmpty) {
        await setMediaItems(playlist, playlist.indexOf(song));
        return;
      }

      // Fallback: single song only
      final audioUrl = song.audio;
      if (audioUrl == null || audioUrl.isEmpty) {
        debugPrint('Error: Audio URL is null or empty');
        _hasCurrentSong = false;
        return;
      }

      await _player.stop();

      final mediaItemData = MediaItem(
        id: song.id?.toString() ?? audioUrl,
        title: song.name ?? "Unknown Title",
        artist: song.artistName ?? "Unknown Artist",
        artUri: song.image?.isNotEmpty == true ? Uri.parse(song.image!) : null,
        duration:
            song.duration != null ? Duration(seconds: song.duration!) : null,
        extras: {'audioUrl': audioUrl},
      );

      mediaItem.add(mediaItemData);
      _mediaItems
        ..clear()
        ..add(mediaItemData);
      _currentIndex = 0;

      // Use a concatenating source with single child for consistency
      final concat = ConcatenatingAudioSource(
        children: [AudioSource.uri(Uri.parse(audioUrl), tag: mediaItemData)],
      );

      await _player.setAudioSource(concat, initialIndex: 0);

      _hasCurrentSong = true;
      _updatePlaybackState();
    } catch (e) {
      debugPrint('Error setting current song: $e');
      _hasCurrentSong = false;
    }
  }

  void _updatePlaybackState() {
    if (_isDisposed || !playbackState.hasValue) return;

    playbackState.add(
      playbackState.value.copyWith(
        playing: _player.playing,
        controls: [
          MediaControl.skipToPrevious,
          if (_player.playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        queueIndex: _currentIndex,
      ),
    );
  }

  AudioProcessingState _transformProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: _transformProcessingState(event.processingState),
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex ?? _currentIndex,
    );
  }

  @override
  Future<void> onTaskRemoved() async {
    if (_isDisposed) return;
    await stop();
    await super.onTaskRemoved();
  }

  void dispose() {
    _isDisposed = true;
    _player.dispose();
  }
}

// import 'dart:async';
// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:flutter/material.dart';
// import 'package:lyrica/model/music_model.dart';

// class AudioPlayerHandler extends BaseAudioHandler
//     with QueueHandler, SeekHandler {
//   final AudioPlayer _player = AudioPlayer();

//   // Current playlist and index
//   List<Results> _playlist = [];
//   int _currentIndex = 0;

//   // Completer for initialization
//   final Completer<void> _initCompleter = Completer<void>();
//   Future<void> get initialized => _initCompleter.future;

//   AudioPlayerHandler() {
//     _init();
//   }

//   void _init() {
//     // Listen to audio player events
//     _player.playbackEventStream.listen(_broadcastState);

//     // Listen to player state changes
//     _player.playerStateStream.listen((playerState) {
//       if (playerState.processingState == ProcessingState.completed) {
//         _handleSongCompletion();
//       }
//     });

//     // Listen to position stream for continuous updates
//     _player.positionStream.listen((position) {
//       playbackState.add(playbackState.value.copyWith(updatePosition: position));
//     });

//     _initCompleter.complete();
//   }

//   void _broadcastState(PlaybackEvent event) {
//     playbackState.add(
//       playbackState.value.copyWith(
//         controls: [
//           MediaControl.skipToPrevious,
//           _player.playing ? MediaControl.pause : MediaControl.play,
//           MediaControl.skipToNext,
//         ],
//         systemActions: const {
//           MediaAction.seek,
//           MediaAction.seekForward,
//           MediaAction.seekBackward,
//         },
//         androidCompactActionIndices: const [0, 1, 2],
//         processingState:
//             const {
//               ProcessingState.idle: AudioProcessingState.idle,
//               ProcessingState.loading: AudioProcessingState.loading,
//               ProcessingState.buffering: AudioProcessingState.buffering,
//               ProcessingState.ready: AudioProcessingState.ready,
//               ProcessingState.completed: AudioProcessingState.completed,
//             }[_player.processingState]!,
//         playing: _player.playing,
//         updatePosition: _player.position,
//         bufferedPosition: _player.bufferedPosition,
//         speed: _player.speed,
//         queueIndex: _currentIndex,
//       ),
//     );
//   }

//   void _handleSongCompletion() {
//     if (_currentIndex < _playlist.length - 1) {
//       skipToNext();
//     } else {
//        stop();
//     }
//   }

//   // Set the current song and load it
//   Future<void> setCurrentSong(Results song) async {
//     await initialized;

//     try {
//       // Create MediaItem
//       final mediaItem = MediaItem(
//         id: song.id ?? '',
//         title: song.name ?? 'Unknown',
//         artist: song.artistName ?? 'Unknown Artist',
//         artUri: song.image != null ? Uri.parse(song.image!) : null,
//         duration:
//             song.duration != null ? Duration(seconds: song.duration!) : null,
//         extras: {'url': song.audio ?? ''},
//       );

//       // Update media item
//       this.mediaItem.add(mediaItem);

//       debugPrint('AudioHandler: Setting current song: ${song.name}');
//     } catch (e) {
//       debugPrint('Error setting current song: $e');
//     }
//   }

//   // Set audio source
//   Future<void> setAudioSource(String url) async {
//     await initialized;

//     try {
//       if (url.isNotEmpty) {
//         await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
//         debugPrint('AudioHandler: Audio source set successfully: $url');
//       }
//     } catch (e) {
//       debugPrint('AudioHandler: Error setting audio source: $e');
//       rethrow;
//     }
//   }

//   // Set playlist
//   Future<void> setPlaylist(List<Results> playlist, int initialIndex) async {
//     await initialized;

//     _playlist = playlist;
//     _currentIndex = initialIndex.clamp(0, playlist.length - 1);

//     // Update queue
//     final mediaItems =
//         playlist
//             .map(
//               (song) => MediaItem(
//                 id: song.id ?? '',
//                 title: song.name ?? 'Unknown',
//                 artist: song.artistName ?? 'Unknown Artist',
//                 artUri: song.image != null ? Uri.parse(song.image!) : null,
//                 duration:
//                     song.duration != null
//                         ? Duration(seconds: song.duration!)
//                         : null,
//                 extras: {'url': song.audio ?? ''},
//               ),
//             )
//             .toList();

//     queue.add(mediaItems);

//     // Set current song
//     if (playlist.isNotEmpty && _currentIndex < playlist.length) {
//       await setCurrentSong(playlist[_currentIndex]);
//       await setAudioSource(playlist[_currentIndex].audio ?? '');
//     }
//   }

//   @override
//   Future<void> play() async {
//     await initialized;

//     try {
//       await _player.play();
//       debugPrint('AudioHandler: Play command executed');
//     } catch (e) {
//       debugPrint('AudioHandler: Error playing: $e');
//     }
//   }

//   @override
//   Future<void> pause() async {
//     await initialized;

//     try {
//       await _player.pause();
//       debugPrint('AudioHandler: Pause command executed');
//     } catch (e) {
//       debugPrint('AudioHandler: Error pausing: $e');
//     }
//   }

//   @override
//   Future<void> stop() async {
//     await initialized;

//     try {
//       await _player.stop();

//       // Clear media item
//       mediaItem.add(null);

//       // Clear playback state
//       playbackState.add(
//         playbackState.value.copyWith(
//           processingState: AudioProcessingState.idle,
//           playing: false,
//           updatePosition: Duration.zero,
//         ),
//       );

//       debugPrint('AudioHandler: Stop command executed');
//     } catch (e) {
//       debugPrint('AudioHandler: Error stopping: $e');
//     }
//   }

//   @override
//   Future<void> seek(Duration position) async {
//     await initialized;

//     try {
//       await _player.seek(position);
//       debugPrint('AudioHandler: Seek to ${position.inSeconds}s');
//     } catch (e) {
//       debugPrint('AudioHandler: Error seeking: $e');
//     }
//   }

//   @override
//   Future<void> skipToNext() async {
//     await initialized;

//     if (_playlist.isEmpty) return;

//     final nextIndex = (_currentIndex + 1).clamp(0, _playlist.length - 1);
//     if (nextIndex != _currentIndex) {
//       _currentIndex = nextIndex;
//       await _loadCurrentSong();
//       await play();
//       debugPrint(
//         'AudioHandler: Skipped to next song: ${_playlist[_currentIndex].name}',
//       );
//     }
//   }

//   @override
//   Future<void> skipToPrevious() async {
//     await initialized;

//     if (_playlist.isEmpty) return;

//     final prevIndex = (_currentIndex - 1).clamp(0, _playlist.length - 1);
//     if (prevIndex != _currentIndex) {
//       _currentIndex = prevIndex;
//       await _loadCurrentSong();
//       await play();
//       debugPrint(
//         'AudioHandler: Skipped to previous song: ${_playlist[_currentIndex].name}',
//       );
//     }
//   }

//   @override
//   Future<void> skipToQueueItem(int index) async {
//     await initialized;

//     if (_playlist.isEmpty || index < 0 || index >= _playlist.length) return;

//     _currentIndex = index;
//     await _loadCurrentSong();
//     await play();
//     debugPrint(
//       'AudioHandler: Skipped to queue item $index: ${_playlist[_currentIndex].name}',
//     );
//   }

//   Future<void> _loadCurrentSong() async {
//     if (_playlist.isEmpty ||
//         _currentIndex < 0 ||
//         _currentIndex >= _playlist.length) {
//       return;
//     }

//     final song = _playlist[_currentIndex];
//     await setCurrentSong(song);

//     if (song.audio != null && song.audio!.isNotEmpty) {
//       await setAudioSource(song.audio!);
//     }
//   }

//   // Update media item
//   @override
//   Future<void> updateMediaItem(MediaItem mediaItem) async {
//     await initialized;
//     this.mediaItem.add(mediaItem);
//   }

//   // Get current position
//   Duration get currentPosition => _player.position;

//   // Get current duration
//   Duration? get currentDuration => _player.duration;

//   // Get current playing state
//   bool get isPlaying => _player.playing;

//   // Get processing state
//   ProcessingState get processingState => _player.processingState;

//   @override
//   Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
//     switch (name) {
//       case 'setPlaylist':
//         if (extras != null) {
//           final playlist = extras['playlist'] as List<Results>?;
//           final index = extras['index'] as int?;
//           if (playlist != null && index != null) {
//             await setPlaylist(playlist, index);
//           }
//         }
//         break;
//       case 'playSongAtIndex':
//         if (extras != null) {
//           final index = extras['index'] as int?;
//           if (index != null) {
//             await skipToQueueItem(index);
//           }
//         }
//         break;
//     }
//   }

//   Future<void> dispose() async {
//     try {
//       await _player.dispose();
//     } catch (e) {
//       debugPrint('Error disposing AudioPlayerHandler: $e');
//     }
//   }
// }
