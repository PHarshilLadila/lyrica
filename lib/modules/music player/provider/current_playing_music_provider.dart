// // // current_playing_music_provider.dart
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:lyrica/model/music_model.dart';

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
// // current_playing_music_provider.dart - FIXED VERSION

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lyrica/model/music_model.dart';

// final currentMusicProvider =
//     StateNotifierProvider<CurrentMusicNotifier, CurrentMusicState>((ref) {
//       return CurrentMusicNotifier();
//     });

// class CurrentMusicState {
//   final bool isPlaying;
//   final Results? currentSong;
//   final List<Results> playlist;
//   final int currentIndex;

//   CurrentMusicState({
//     this.isPlaying = false,
//     this.currentSong,
//     this.playlist = const [],
//     this.currentIndex = 0, // -1 indicates no song selected
//   });

//   CurrentMusicState copyWith({
//     bool? isPlaying,
//     Results? currentSong,
//     List<Results>? playlist,
//     int? currentIndex,
//   }) {
//     return CurrentMusicState(
//       isPlaying: isPlaying ?? this.isPlaying,
//       currentSong: currentSong ?? this.currentSong,
//       playlist: playlist ?? this.playlist,
//       currentIndex: currentIndex ?? this.currentIndex,
//     );
//   }
// }

// class CurrentMusicNotifier extends StateNotifier<CurrentMusicState> {
//   CurrentMusicNotifier() : super(CurrentMusicState());

//   // FIXED: Set music with proper validation and immediate state update
//   void setMusic(Results song, List<Results> playlist, int index) {
//     // Validate inputs
//     if (playlist.isEmpty || index < 0 || index >= playlist.length) {
//       debugPrint(
//         'Invalid parameters in setMusic: playlist length=${playlist.length}, index=$index',
//       );
//       return;
//     }

//     // FIXED: Ensure the song matches the index
//     final actualSong = playlist[index];

//     state = state.copyWith(
//       currentSong: actualSong,
//       playlist: playlist,
//       currentIndex: index,
//       isPlaying: true,
//     );

//     debugPrint('Current music updated: ${actualSong.name} at index $index');
//   }

//   // FIXED: Set playing state with validation
//   void setPlaying(bool playing) {
//     if (state.currentSong == null) {
//       debugPrint('Warning: Trying to set playing state without a current song');
//       return;
//     }

//     state = state.copyWith(isPlaying: playing);
//     debugPrint(
//       'Playing state updated: $playing for ${state.currentSong?.name}',
//     );
//   }

//   // FIXED: Update index with proper validation and song sync
//   void updateIndex(int index) {
//     if (state.playlist.isEmpty) {
//       debugPrint('Warning: Trying to update index with empty playlist');
//       return;
//     }

//     if (index >= 0 && index < state.playlist.length) {
//       final newSong = state.playlist[index];
//       state = state.copyWith(
//         currentIndex: index,
//         currentSong: newSong,
//         isPlaying: true,
//       );
//       debugPrint('Index updated: $index, new song: ${newSong.name}');
//     } else {
//       debugPrint(
//         'Invalid index in updateIndex: $index (playlist length: ${state.playlist.length})',
//       );
//     }
//   }

//   // FIXED: Stop with complete state reset
//   void stop() {
//     debugPrint('Stopping current music player');
//     state = CurrentMusicState(
//       isPlaying: false,
//       currentSong: null,
//       currentIndex: -1,
//       playlist: [],
//     );
//   }

//   // FIXED: Additional helper methods for better state management
//   void pause() {
//     if (state.currentSong != null) {
//       state = state.copyWith(isPlaying: false);
//       debugPrint('Music paused: ${state.currentSong?.name}');
//     }
//   }

//   void resume() {
//     if (state.currentSong != null) {
//       state = state.copyWith(isPlaying: true);
//       debugPrint('Music resumed: ${state.currentSong?.name}');
//     }
//   }

//   // FIXED: Method to update just the song without changing playing state
//   void updateCurrentSong(Results song) {
//     if (state.playlist.isNotEmpty) {
//       // Find the song in the playlist
//       final index = state.playlist.indexWhere((s) => s.id == song.id);
//       if (index != -1) {
//         state = state.copyWith(currentSong: song, currentIndex: index);
//         debugPrint('Current song updated: ${song.name}');
//       }
//     }
//   }

//   // FIXED: Getter methods for external access
//   bool get hasCurrentSong => state.currentSong != null;
//   bool get hasPlaylist => state.playlist.isNotEmpty;
//   bool get canGoNext => state.currentIndex < state.playlist.length - 1;
//   bool get canGoPrevious => state.currentIndex > 0;

//   Results? get currentSong => state.currentSong;
//   List<Results> get playlist => state.playlist;
//   int get currentIndex => state.currentIndex;
//   bool get isPlaying => state.isPlaying;
// }
// // current_playing_music_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lyrica/model/music_model.dart';

// final currentMusicProvider =
//     StateNotifierProvider<CurrentMusicNotifier, CurrentMusicState>((ref) {
//       return CurrentMusicNotifier();
//     });

// class CurrentMusicState {
//   final bool isPlaying;
//   final Results? currentSong;
//   final List<Results> playlist;
//   final int currentIndex;

//   CurrentMusicState({
//     this.isPlaying = false,
//     this.currentSong,
//     this.playlist = const [],
//     this.currentIndex = -1, // Changed from 0 to -1 to indicate no song selected
//   });

//   CurrentMusicState copyWith({
//     bool? isPlaying,
//     Results? currentSong,
//     List<Results>? playlist,
//     int? currentIndex,
//   }) {
//     return CurrentMusicState(
//       isPlaying: isPlaying ?? this.isPlaying,
//       currentSong: currentSong ?? this.currentSong,
//       playlist: playlist ?? this.playlist,
//       currentIndex: currentIndex ?? this.currentIndex,
//     );
//   }
// }

// class CurrentMusicNotifier extends StateNotifier<CurrentMusicState> {
//   CurrentMusicNotifier() : super(CurrentMusicState());

//   void setMusic(Results song, List<Results> playlist, int index) {
//     state = state.copyWith(
//       currentSong: song,
//       playlist: playlist,
//       currentIndex: index,
//       isPlaying: true,
//     );
//   }

//   // Changed from playPause(bool) to setPlaying(bool) for better semantics
//   void setPlaying(bool playing) {
//     state = state.copyWith(isPlaying: playing);
//   }

//   // Added method to update just the index (for navigation)
//   void updateIndex(int index) {
//     if (index >= 0 && index < state.playlist.length) {
//       state = state.copyWith(
//         currentIndex: index,
//         currentSong: state.playlist[index],
//         isPlaying: true,
//       );
//     }
//   }

//   void stop() {
//     state = state.copyWith(
//       isPlaying: false,
//       currentSong: null,
//       currentIndex: -1,
//       playlist: [],
//     );
//   }
// }
// current_playing_music_provider.dart - FIXED VERSION

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyrica/model/music_model.dart';

final currentMusicProvider =
    StateNotifierProvider<CurrentMusicNotifier, CurrentMusicState>((ref) {
      return CurrentMusicNotifier();
    });

class CurrentMusicState {
  final bool isPlaying;
  final Results? currentSong;
  final List<Results> playlist;
  final int currentIndex;
  final int position; // NEW: current position in seconds

  CurrentMusicState({
    this.isPlaying = false,
    this.currentSong,
    this.playlist = const [],
    this.currentIndex = 0,
    this.position = 0, // default 0
  });

  CurrentMusicState copyWith({
    bool? isPlaying,
    Results? currentSong,
    List<Results>? playlist,
    int? currentIndex,
    int? position, // NEW
  }) {
    return CurrentMusicState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentSong: currentSong ?? this.currentSong,
      playlist: playlist ?? this.playlist,
      currentIndex: currentIndex ?? this.currentIndex,
      position: position ?? this.position, // NEW
    );
  }
}

class CurrentMusicNotifier extends StateNotifier<CurrentMusicState> {
  CurrentMusicNotifier() : super(CurrentMusicState());

  // FIXED: Set music with proper validation and immediate state update
  void setMusic(Results song, List<Results> playlist, int index) {
    // Validate inputs
    if (playlist.isEmpty || index < 0 || index >= playlist.length) {
      debugPrint(
        'Invalid parameters in setMusic: playlist length=${playlist.length}, index=$index',
      );
      return;
    }

    // FIXED: Ensure the song matches the index
    final actualSong = playlist[index];

    state = state.copyWith(
      currentSong: actualSong,
      playlist: playlist,
      currentIndex: index,
      isPlaying: true,
    );

    debugPrint('Current music updated: ${actualSong.name} at index $index');
  }

  void setSong(Results song, List<Results> playlist, int index) {
    setMusic(song, playlist, index);
  }

  void setLastPlayedSongFromLastPlayedSong(dynamic last) {
    // 'last' is expected to be the LastPlayedSong-like object from main.dart
    // Map fields carefully - adapt if types differ
    final song = Results(
      id: last.id,
      name: last.name,
      artistName: last.artistName,
      image: last.image,
      duration: last.duration,
    );
    state = state.copyWith(
      currentSong: song,
      currentIndex: last.playlistIndex ?? 0,
    );
  }

  // void setLastPlayedSongFromLastPlayedSong(dynamic last) {
  //   // 'last' is expected to be the LastPlayedSong-like object from main.dart
  //   // Map fields carefully - adapt if types differ
  //   final song = Results(
  //     id: last.id,
  //     name: last.name,
  //     artistName: last.artistName,
  //     image: last.image,
  //     duration: last.duration,
  //   );
  //   state = state.copyWith(
  //     currentSong: song,
  //     currentIndex: last.playlistIndex ?? 0,
  //   );
  // }

  void setCurrentSongFromMediaItem(MediaItem mediaItem) {
    // Create a Results object from MediaItem
    final song = Results(
      id: mediaItem.id,
      name: mediaItem.title,
      artistName: mediaItem.artist,
      image: mediaItem.artUri?.toString(),
      duration: mediaItem.duration?.inSeconds ?? 0,
    );

    // Check if the song exists in the playlist
    final index = state.playlist.indexWhere((s) => s.id == song.id);

    if (index != -1) {
      // Song exists in playlist
      state = state.copyWith(currentSong: song, currentIndex: index);
    } else {
      // Song not in playlist, optionally add it
      final newPlaylist = [...state.playlist, song];
      state = state.copyWith(
        currentSong: song,
        playlist: newPlaylist,
        currentIndex: newPlaylist.length - 1,
      );
    }

    debugPrint('Current song set from MediaItem: ${song.name}');
  }

  void setPosition(int seconds) {
    if (state.currentSong == null) return;

    state = state.copyWith(position: seconds);
    // debugPrint('Position updated: $seconds s');
  }

  // FIXED: Set playing state with validation
  void setPlaying(bool playing) {
    if (state.currentSong == null) {
      debugPrint('Warning: Trying to set playing state without a current song');
      return;
    }

    state = state.copyWith(isPlaying: playing);
    debugPrint(
      'Playing state updated: $playing for ${state.currentSong?.name}',
    );
  }

  // FIXED: Update index with proper validation and song sync
  void updateIndex(int index) {
    if (state.playlist.isEmpty) {
      debugPrint('Warning: Trying to update index with empty playlist');
      return;
    }

    if (index >= 0 && index < state.playlist.length) {
      final newSong = state.playlist[index];
      state = state.copyWith(
        currentIndex: index,
        currentSong: newSong,
        isPlaying: true,
      );
      debugPrint('Index updated: $index, new song: ${newSong.name}');
    } else {
      debugPrint(
        'Invalid index in updateIndex: $index (playlist length: ${state.playlist.length})',
      );
    }
  }

  // FIXED: Stop with complete state reset
  void stop() {
    debugPrint('Stopping current music player');
    state = CurrentMusicState(
      isPlaying: false,
      currentSong: null,
      currentIndex: -1,
      playlist: [],
    );
  }

  // FIXED: Additional helper methods for better state management
  void pause() {
    if (state.currentSong != null) {
      state = state.copyWith(isPlaying: false);
      debugPrint('Music paused: ${state.currentSong?.name}');
    }
  }

  void resume() {
    if (state.currentSong != null) {
      state = state.copyWith(isPlaying: true);
      debugPrint('Music resumed: ${state.currentSong?.name}');
    }
  }

  // FIXED: Method to update just the song without changing playing state
  void updateCurrentSong(Results song) {
    if (state.playlist.isNotEmpty) {
      // Find the song in the playlist
      final index = state.playlist.indexWhere((s) => s.id == song.id);
      if (index != -1) {
        state = state.copyWith(currentSong: song, currentIndex: index);
        debugPrint('Current song updated: ${song.name}');
      }
    }
  }

  // FIXED: Getter methods for external access
  bool get hasCurrentSong => state.currentSong != null;
  bool get hasPlaylist => state.playlist.isNotEmpty;
  bool get canGoNext => state.currentIndex < state.playlist.length - 1;
  bool get canGoPrevious => state.currentIndex > 0;

  Results? get currentSong => state.currentSong;
  List<Results> get playlist => state.playlist;
  int get currentIndex => state.currentIndex;
  bool get isPlaying => state.isPlaying;
}
