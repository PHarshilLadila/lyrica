import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lyrica/model/artist_model.dart';
import 'package:lyrica/model/music_model.dart';
 import 'package:lyrica/model/user_model.dart';
import 'package:lyrica/modules/auth/controller/auth_controller.dart';
import 'package:lyrica/services/api_service.dart';
 
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authControllerProvider = Provider((ref) {
  return AuthController(ref);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authControllerProvider).authStateChanges;
});

final userModelProvider = FutureProvider<UserModel?>((ref) async {
  final authController = ref.read(authControllerProvider);
  return await authController.getUser();
});



// music api provider

final musicDataProvider = FutureProvider<List<Results>>((ref) async {
  return ref.watch(apiProvider).getMusicList();
});

final genreMusicProvider = FutureProvider.family<List<Results>, String>((
  ref,
  genre,
) async {
  return ref.watch(apiProvider).getMusicByGenre(genre);
});

final artistDataProvider = FutureProvider<List<ArtistResults>>((ref) async {
  return ref.watch(apiProvider).getArtistList();
});

final artistMusicDataProvider = FutureProvider.family<List<Results>, String>((
  ref,
  id,
) async {
  return ref.watch(apiProvider).getArtistWiseSong(id);
});

final hindiSongDataProvider = FutureProvider<List<Results>>((ref) async {
  return ref.watch(apiProvider).getHindiSongsList();
});




// search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider.autoDispose<List<Results>>((
  ref,
) async {
  final query = ref.watch(searchQueryProvider);

   await Future.delayed(const Duration(milliseconds: 0));

  if (query.trim().isEmpty) return [];

  return ref.watch(apiProvider).searchTracks(query);
});

 

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final isPlayingProvider = StreamProvider.autoDispose<bool>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.playingStream;
});

final positionProvider = StreamProvider.autoDispose<Duration>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.positionStream;
});

final durationProvider = StreamProvider.autoDispose<Duration?>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.durationStream;
});
