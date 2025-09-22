import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyrica/model/music_model.dart';

final playlistProvider = StateNotifierProvider<PlaylistNotifier, List<Results>>(
  (ref) {
    return PlaylistNotifier();
  },
);

final userPlaylistsProvider = StreamProvider.autoDispose<List<Playlist>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('playlists')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => Playlist.fromFirestore(doc)).toList(),
      );
});

class PlaylistNotifier extends StateNotifier<List<Results>> {
  PlaylistNotifier() : super([]);

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void addSong(Results song) {
    if (!state.any((s) => s.id == song.id)) {
      state = [...state, song];
    }
  }

  void removeSong(Results song) {
    state = state.where((s) => s.id != song.id).toList();
  }

  void clearPlaylist() {
    state = [];
  }

  Future<void> savePlaylist(String playlistName) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final songsData = state.map((song) => song.toJson()).toList();

    await _firestore.collection('users').doc(uid).collection('playlists').add({
      'name': playlistName,
      'createdAt': FieldValue.serverTimestamp(),
      'songs': songsData,
    });
  }

  Future<List<Results>> getPlaylistSongs(String playlistId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final doc =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('playlists')
            .doc(playlistId)
            .get();

    if (!doc.exists) return [];

    final data = doc.data() as Map<String, dynamic>;
    final songs = data['songs'] as List<dynamic>? ?? [];

    return songs.map((song) => Results.fromJson(song)).toList();
  }

  Future<void> deletePlaylist(String playlistId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('playlists')
        .doc(playlistId)
        .delete();
  }
}

class Playlist {
  final String id;
  final String name;
  final DateTime createdAt;
  final int songCount;
  final String? coverImageUrl;

  Playlist({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.songCount,
    this.coverImageUrl,
  });

  factory Playlist.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final songs = data['songs'] as List<dynamic>? ?? [];

    return Playlist(
      id: doc.id,
      name: data['name'] ?? 'Unnamed Playlist',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      songCount: songs.length,
      coverImageUrl:
          songs.isNotEmpty
              ? (songs.first as Map<String, dynamic>)['albumImage']
              : null,
    );
  }
}
