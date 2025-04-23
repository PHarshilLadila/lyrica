// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';

// class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
//   AudioPlayer audioPlayer = AudioPlayer();

//   UriAudioSource createAudioSource(MediaItem item) {
//     return ProgressiveAudioSource(Uri.parse(item.id));
//   }

//   // listen for changes tn the current song index and update the meadia items
//   void listenForCurrentSongIndexChanges() {
//     audioPlayer.currentIndexStream.listen((index) {
//       final playList = queue.value;
//       if (index == null || playList.isEmpty) return;
//       mediaItem.add(playList[index]);
//     });
//   }

//   void broadcastState(PlaybackEvent event) {
//     playbackState.add(
//       playbackState.value.copyWith(
//         controls: [
//           MediaControl.skipToPrevious,
//           if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
//           MediaControl.skipToNext,
//         ],
//         systemActions: {
//           MediaAction.seek,
//           MediaAction.seekForward,
//           MediaAction.seekBackward,
//         },
//         processingState:
//             {
//               ProcessingState.idle: AudioProcessingState.idle,
//               ProcessingState.loading: AudioProcessingState.loading,
//               ProcessingState.buffering: AudioProcessingState.buffering,
//               ProcessingState.ready: AudioProcessingState.ready,
//               ProcessingState.completed: AudioProcessingState.completed,
//             }[audioPlayer.processingState]!,
//         playing: audioPlayer.playing,
//         updatePosition: audioPlayer.position,
//         bufferedPosition: audioPlayer.bufferedPosition,
//         speed: audioPlayer.speed,
//         queueIndex: event.currentIndex,
//       ),
//     );
//   }

//   /// function for initialize the songs and set up  the adio player
//   Future<void> initSongs({required List<MediaItem> songs}) async {
//     // listen for playback  events and broadcast the state
//     audioPlayer.playbackEventStream.listen(broadcastState);
//     // create list of audio source from the provided songs
//     final audioSource = songs.map(createAudioSource);

//     // set the audio source of the audio player to the concatenation  of the audio source
//     await audioPlayer.setAudioSource(
//       // ignore: deprecated_member_use
//       ConcatenatingAudioSource(children: audioSource.toList()),
//     );

//     // add the song to the queue
//     final newQueue = queue.value..addAll(songs);
//     queue.add(newQueue);

//     // listen for the changes in the current song index
//     listenForCurrentSongIndexChanges();

//     // listen for proccessing state changes, and skip  to the next song  when complated
//     audioPlayer.processingStateStream.listen((state) {
//       if (state == ProcessingState.completed) skipToNext();
//     });
//   }

//   // play function to start playback
//   @override
//   Future<void> play() async => audioPlayer.play();

//   // play function to pause playback
//   @override
//   Future<void> pause() async => audioPlayer.pause();

//   // seek function to change the palyback position
//   @override
//   Future<void> seek(Duration position) async => audioPlayer.seek(position);

//   // skip to a specefic  item in  the queue and start playback
//   @override
//   Future<void> skipToQueueItem(int index) async {
//     await audioPlayer.seek(Duration.zero, index: index);
//     play();
//   }

//   // skip to the next item i the queue
//   @override
//   Future<void> skipToNext() async => audioPlayer.seekToNext();

//   // skip to the previous item i the queue
//   @override
//   Future<void> skipToPrevious() async => audioPlayer.seekToPrevious();
// }
