import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lyrica/modules/albums/album%20tracks/album_tracks_model.dart';
import 'package:lyrica/modules/albums/album%20tracks/album_tracks_provider.dart';
import 'package:provider/provider.dart';

class AlbumTracksScreen extends StatefulWidget {
  final String albumId;
  final String albumName;
  final String? albumImage;

  const AlbumTracksScreen({
    super.key,
    required this.albumId,
    required this.albumName,
    this.albumImage,
  });

  @override
  State<AlbumTracksScreen> createState() => _AlbumTracksScreenState();
}

class _AlbumTracksScreenState extends State<AlbumTracksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlbumsTracksProvider>(
        context,
        listen: false,
      ).fetchAlbumTracks(widget.albumId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.albumName)),
      body: Consumer<AlbumsTracksProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(child: Text(provider.error));
          }

          if (provider.tracks == null || provider.tracks!.items.isEmpty) {
            return const Center(child: Text('No tracks available'));
          }

          final tracks = provider.tracks!;
          return Column(
            children: [
              if (widget.albumImage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: widget.albumImage!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: tracks.items.length,
                  separatorBuilder:
                      (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final track = tracks.items[index];
                    return _buildTrackTile(track, index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTrackTile(Item track, int index) {
    return ListTile(
      leading: SizedBox(
        width: 40,
        child: Center(
          child: Text(
            '${track.trackNumber}',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
      title: Text(
        track.name,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: track.explicit ? Colors.red : null,
        ),
      ),
      subtitle: Text(
        track.artists.map((artist) => artist.name).join(', '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (track.explicit)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                'E',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            _formatDuration(track.durationMs),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
      onTap: () {
        // Handle track play
        if (track.previewUrl != null) {
          // Play preview
        }
      },
    );
  }

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
