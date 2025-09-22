// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/modules/playlist/provider/playlist_provider.dart';
import 'package:lyrica/modules/playlist/view%20playlist/play_list_songs_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewPlaylistScreen extends ConsumerStatefulWidget {
  const ViewPlaylistScreen({super.key});

  @override
  ConsumerState<ViewPlaylistScreen> createState() => _ViewPlaylistScreenState();
}

class _ViewPlaylistScreenState extends ConsumerState<ViewPlaylistScreen> {
  late String _currentSortOption;
  late List<String> _sortOptions;
  late Map<String, String> _sortKeys;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = AppLocalizations.of(context)!;

    _sortKeys = {
      'newest': locale.newestSong,
      'oldest': locale.oldestSong,
      'aToZ': locale.aToZ,
      'zToA': locale.zToA,
      'mostSongs': locale.mostSongs,
      'fewestSongs': locale.fewestSongs,
    };

    _currentSortOption = 'newest';
    _sortOptions = _sortKeys.keys.toList();
  }

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    String playlistName,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: isDark ? Colors.red[300] : Colors.red[600],
                        size: 28.sp,
                      ),
                      SizedBox(width: 12.w),
                      Flexible(
                        child: AppText(
                          text:
                              "Delete Playlist", //AppLocalizations.of(context)!.deletePlaylist,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          textColor: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  SizedBox(height: 16.h),
                  AppText(
                    maxLines: 4,
                    text:
                        "Confirm deletion of '$playlistName'? All songs in this playlist will be permanently removed.",

                    // "${AppLocalizations.of(context)!.confirmDeletePlaylist} '$playlistName'? ${AppLocalizations.of(context)!.allSongsRemoved}",
                    fontSize: 16.sp,
                    textColor: isDark ? Colors.white70 : Colors.black54,
                    align: TextAlign.start,
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: AppText(
                          text: AppLocalizations.of(context)!.cancel,
                          fontSize: 16.sp,
                          textColor: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              isDark
                                  ? Colors.red[700]?.withOpacity(0.2)
                                  : Colors.red[100],
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: AppText(
                          text:
                              "Delete", //AppLocalizations.of(context)!.delete,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          textColor: isDark ? Colors.red[300] : Colors.red[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _deletePlaylist(String playlistId) {
    ref
        .read(playlistProvider.notifier)
        .deletePlaylist(playlistId)
        .then((_) {
          showAppSnackBar(
            context,
            AppLocalizations.of(context)!.playlistDeleteSuccess,
            const Color(AppColors.successColor),
          );
        })
        .catchError((error) {
          showAppSnackBar(
            context,
            "${AppLocalizations.of(context)!.playlistDeleteFailed} ${error.toString()}",
            const Color(AppColors.errorColor),
          );
        });
  }

  Widget _buildDefaultCover() {
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Icon(
          Icons.music_note,
          color: Colors.white.withOpacity(0.8),
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    // final locale = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      color: Colors.black45,
      icon: Icon(Icons.sort, color: Colors.white, size: 28.sp),
      onSelected: (String value) {
        setState(() {
          _currentSortOption = value;
        });
      },
      itemBuilder: (BuildContext context) {
        return _sortOptions.map((String key) {
          final isSelected = _currentSortOption == key;
          return PopupMenuItem<String>(
            value: key,
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check : Icons.sort_outlined,
                  color:
                      isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                ),
                SizedBox(width: 8.w),
                AppText(
                  text: _sortKeys[key]!,
                  textColor: Color(AppColors.whiteBackground),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  List<Playlist> _sortPlaylists(List<Playlist> playlists) {
    switch (_currentSortOption) {
      case 'newest':
        playlists.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        playlists.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'aToZ':
        playlists.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'zToA':
        playlists.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'mostSongs':
        playlists.sort((a, b) => b.songCount.compareTo(a.songCount));
        break;
      case 'fewestSongs':
        playlists.sort((a, b) => a.songCount.compareTo(b.songCount));
        break;
    }
    return playlists;
  }

  @override
  Widget build(BuildContext context) {
    final playlistsAsync = ref.watch(userPlaylistsProvider);

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          leading: const AppBackButton(),
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          title: AppText(
            text: AppLocalizations.of(context)!.yourPlaylists,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          actions: [_buildSortDropdown(), SizedBox(width: 12.w)],
        ),
        body: playlistsAsync.when(
          loading: () => Center(child: appLoader()),
          error:
              (error, stack) =>
                  Center(child: AppText(text: "Error loading playlists")),
          data: (playlists) {
            final sortedPlaylists = _sortPlaylists(playlists);

            return sortedPlaylists.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.music,
                        size: 50,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      AppText(
                        text:
                            "No playlists yet", // AppLocalizations.of(context)!.noPlaylists,
                        fontSize: 18,
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                )
                : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppText(
                            text:
                                '${AppLocalizations.of(context)!.shortedBy} ${_sortKeys[_currentSortOption]}',
                            fontSize: 12.sp,
                            textColor: Colors.white.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: sortedPlaylists.length,
                        itemBuilder: (context, index) {
                          final playlist = sortedPlaylists[index];
                          return Dismissible(
                            key: Key(playlist.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20.w),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30.sp,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              return await _showDeleteConfirmation(
                                context,
                                playlist.name,
                              );
                            },
                            onDismissed: (direction) {
                              _deletePlaylist(playlist.id);
                            },
                            child: Card(
                              margin: EdgeInsets.only(bottom: 12.h),
                              color: Colors.white.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => PlaylistSongsScreen(
                                            playlistId: playlist.id,
                                            playlistName: playlist.name,
                                          ),
                                    ),
                                  );
                                },
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                      playlist.coverImageUrl != null
                                          ? Image.network(
                                            playlist.coverImageUrl!,
                                            width: 50.w,
                                            height: 50.h,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (_, __, ___) =>
                                                    _buildDefaultCover(),
                                          )
                                          : _buildDefaultCover(),
                                ),
                                title: AppText(
                                  text: playlist.name,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  textColor: Colors.white,
                                ),
                                subtitle: AppText(
                                  text: "${playlist.songCount} songs",
                                  // "${playlist.songCount} ${AppLocalizations.of(context)!.songs}",
                                  textColor: Colors.white.withOpacity(0.7),
                                  fontSize: 14.sp,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      onPressed: () async {
                                        final shouldDelete =
                                            await _showDeleteConfirmation(
                                              context,
                                              playlist.name,
                                            );
                                        if (shouldDelete == true) {
                                          _deletePlaylist(playlist.id);
                                        }
                                      },
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
          },
        ),
      ),
    );
  }
}
