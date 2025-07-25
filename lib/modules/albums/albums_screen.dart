import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';
import 'package:provider/provider.dart';
import 'albums_model.dart';
import 'albums_provider.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlbumProvider>(
        context,
        listen: false,
      ).fetchAlbum('5KF4xCxDD8ip003hoatFT9');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album Details'), centerTitle: true),
      body: Consumer<AlbumProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(child: Text(provider.error));
          }

          if (provider.album == null) {
            return const Center(child: Text('No album data available'));
          }

          final album = provider.album!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAlbumHeader(album),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildArtistsSection(album),

                      _buildAlbumInfo(album),

                      _buildPopularityWidget(album.popularity),

                      if (album.copyrights.isNotEmpty)
                        _buildCopyrightsSection(album),

                      const SizedBox(height: 24),
                      Text(
                        'Tracks (${album.totalTracks})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTracksList(album.tracks),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAlbumHeader(AlbumsModel album) {
    final coverImage = album.images.isNotEmpty ? album.images[0].url : '';
    final smallestImage = album.images.isNotEmpty ? album.images.last.url : '';

    return Stack(
      children: [
        // Album cover image
        SizedBox(
          height: 300,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: coverImage,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
            errorWidget:
                (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note, size: 50),
                ),
          ),
        ),

        // Gradient overlay
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                album.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${album.albumType.toUpperCase()} • ${album.releaseDate.year}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: const Icon(Icons.open_in_new, color: Colors.white),
            onPressed: () {
              if (album.externalUrls.spotify.isNotEmpty) {
                // You would typically use url_launcher here
                // launchUrl(Uri.parse(album.externalUrls.spotify));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArtistsSection(AlbumsModel album) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Artists',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              album.artists
                  .map(
                    (artist) => InkWell(
                      onTap: () {
                        // Navigate to artist page
                      },
                      child: Chip(
                        label: Text(artist.name),
                        avatar: const CircleAvatar(
                          child: Icon(Icons.person, size: 16),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildAlbumInfo(AlbumsModel album) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Release Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(album.releaseDate),
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Label',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                album.label,
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularityWidget(int popularity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popularity',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: popularity / 100,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 4),
          Text('$popularity%', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCopyrightsSection(AlbumsModel album) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Copyright',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...album.copyrights.map(
          (copyright) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${copyright.type}: ${copyright.text}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTracksList(Tracks tracks) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tracks.items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final track = tracks.items[index];
        final artists = track.artists.map((artist) => artist.name).join(', ');

        return ListTile(
          leading: SizedBox(
            width: 30,
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
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
            artists,
            style: TextStyle(color: Colors.grey[600]),
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
            _navigateToMusicPlayer(
              context: context,
              track: track,
              trackList: tracks.items,
              initialIndex: index,
            );
          },
        );
      },
    );
  }

  void _navigateToMusicPlayer({
    required BuildContext context,
    required Item track,
    required List<Item> trackList,
    required int initialIndex,
  }) {
    final songs =
        trackList
            .map(
              (item) => Results(
                name: item.name,
                id: item.id,
                artistName: item.artists.map((a) => a.name).join(', '),
                duration: item.durationMs,
                albumId: '',
                audio: item.previewUrl?.toString() ?? '',
              ),
            )
            .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                MusicPlayer(initialIndex: initialIndex, songList: songs),
      ),
    );
  }

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class Song {
  final String id;
  final String title;
  final String artist;
  final int duration;
  final String albumArt;
  final String audioUrl;
  final bool isExplicit;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.albumArt,
    required this.audioUrl,
    required this.isExplicit,
  });
}
