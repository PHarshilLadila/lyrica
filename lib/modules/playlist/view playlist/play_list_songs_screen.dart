// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';
import 'package:lyrica/modules/playlist/provider/playlist_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaylistSongsScreen extends ConsumerStatefulWidget {
  final String playlistId;
  final String playlistName;

  const PlaylistSongsScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  ConsumerState<PlaylistSongsScreen> createState() =>
      _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends ConsumerState<PlaylistSongsScreen> {
  late Future<List<Results>> _songsFuture;

  @override
  void initState() {
    super.initState();
    _songsFuture = ref
        .read(playlistProvider.notifier)
        .getPlaylistSongs(widget.playlistId);
  }

  void _playSong(BuildContext context, List<Results> songs, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayer(songList: songs, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(197, 0, 43, 53),
      appBar: AppBar(
        title: AppText(text: widget.playlistName, fontWeight: FontWeight.bold),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Results>>(
        future: _songsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: appLoader());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: AppText(text: "Error loading songs"));
          }

          final songs = snapshot.data!;

          if (songs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.music_off, size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  AppText(
                    text: "No songs in this playlist",
                    fontSize: 18,
                    textColor: Colors.grey,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return GestureDetector(
                onTap: () => _playSong(context, songs, index),
                child: Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  color: Colors.white.withOpacity(0.2),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child:
                          song.albumImage != null
                              ? Image.network(
                                song.albumImage!,
                                width: 50.w,
                                height: 50.h,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => _buildDefaultSongCover(),
                              )
                              : _buildDefaultSongCover(),
                    ),
                    title: AppText(
                      text: song.name ?? 'Unknown',
                      fontWeight: FontWeight.bold,
                      textColor: Colors.white,
                    ),
                    subtitle: AppText(
                      text: song.artistName ?? 'Unknown artist',
                      textColor: Colors.white.withOpacity(0.7),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeSong(context, song),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDefaultSongCover() {
    return Container(
      width: 50.w,
      height: 50.h,
      color: Colors.grey.withOpacity(0.3),
      child: Center(
        child: Icon(Icons.music_note, color: Colors.white.withOpacity(0.5)),
      ),
    );
  }

  Future<void> _removeSong(BuildContext context, Results song) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: AppText(text: "Remove Song"),
            content: AppText(text: "Remove ${song.name} from playlist?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: AppText(text: "Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: AppText(text: "Remove", textColor: Colors.red),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) return;

        final playlistDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('playlists')
            .doc(widget.playlistId);

        final playlist = await playlistDoc.get();
        if (!playlist.exists) return;

        final songs =
            (playlist.data()!['songs'] as List<dynamic>)
                .where((s) => s['id'] != song.id)
                .toList();

        await playlistDoc.update({'songs': songs});

        setState(() {
          _songsFuture = ref
              .read(playlistProvider.notifier)
              .getPlaylistSongs(widget.playlistId);
        });

        showAppSnackBar(
          context,
          AppLocalizations.of(context)!.songRemoveFromPlaylist,
          Color(AppColors.successColor),
        );
      } catch (e) {
        showAppSnackBar(
          context,
          "${AppLocalizations.of(context)!.songRemoveFromPlaylistError} ${e.toString()}",
          Color(AppColors.errorColor),
        );
      }
    }
  }
}
