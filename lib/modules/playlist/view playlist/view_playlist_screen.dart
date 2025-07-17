// // view_playlist_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:lyrica/common/utils/utils.dart';
// import 'package:lyrica/common/widget/app_back_button.dart';
// import 'package:lyrica/common/widget/app_text.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/modules/playlist/provider/playlist_provider.dart';
// import 'package:lyrica/modules/playlist/view%20playlist/play_list_songs_screen.dart';

// class ViewPlaylistScreen extends ConsumerWidget {
//   const ViewPlaylistScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final playlistsAsync = ref.watch(userPlaylistsProvider);

//     return Container(
//       decoration: BoxDecoration(gradient: backgroundGradient()),
//       child: Scaffold(
//         backgroundColor: Color.fromARGB(197, 0, 43, 53),
//         appBar: AppBar(
//           leading: AppBackButton(),
//           elevation: 0,
//           toolbarHeight: 90,
//           backgroundColor: Colors.transparent,
//           title: AppText(
//             textName: "Your Playlists",
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         body: playlistsAsync.when(
//           loading: () => Center(child: CircularProgressIndicator()),
//           error:
//               (error, stack) =>
//                   Center(child: AppText(textName: "Error loading playlists")),
//           data:
//               (playlists) =>
//                   playlists.isEmpty
//                       ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             FaIcon(
//                               FontAwesomeIcons.music,
//                               size: 50,
//                               color: Colors.grey.withOpacity(0.5),
//                             ),
//                             SizedBox(height: 16),
//                             AppText(
//                               textName: "No playlists yet",
//                               fontSize: 18,
//                               textColor: Colors.grey,
//                             ),
//                           ],
//                         ),
//                       )
//                       : ListView.builder(
//                         padding: EdgeInsets.all(16),
//                         itemCount: playlists.length,
//                         itemBuilder: (context, index) {
//                           final playlist = playlists[index];
//                           return Card(
//                             margin: EdgeInsets.only(bottom: 12.h),
//                             color: Colors.white.withOpacity(0.2),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                             child: ListTile(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) => PlaylistSongsScreen(
//                                           playlistId: playlist.id,
//                                           playlistName: playlist.name,
//                                         ),
//                                   ),
//                                 );
//                               },
//                               leading: ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child:
//                                     playlist.coverImageUrl != null
//                                         ? Image.network(
//                                           playlist.coverImageUrl!,
//                                           width: 50,
//                                           height: 50,
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (_, __, ___) =>
//                                                   _buildDefaultCover(),
//                                         )
//                                         : _buildDefaultCover(),
//                               ),
//                               title: AppText(
//                                 textName: playlist.name,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 textColor: Colors.white,
//                               ),
//                               subtitle: AppText(
//                                 textName: "${playlist.songCount} songs",
//                                 textColor: Colors.white.withOpacity(0.7),
//                                 fontSize: 14,
//                               ),
//                               trailing: Icon(
//                                 Icons.chevron_right,
//                                 color: Colors.white.withOpacity(0.5),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDefaultCover() {
//     return Container(
//       width: 50,
//       height: 50,
//       color: Colors.black.withOpacity(0.3),
//       child: Center(
//         child: Icon(Icons.music_note, color: Colors.white.withOpacity(0.8)),
//       ),
//     );
//   }
// }

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

class ViewPlaylistScreen extends ConsumerStatefulWidget {
  const ViewPlaylistScreen({super.key});

  @override
  ConsumerState<ViewPlaylistScreen> createState() => _ViewPlaylistScreenState();
}

class _ViewPlaylistScreenState extends ConsumerState<ViewPlaylistScreen> {
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
                          textName: "Delete Playlist",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          textColor: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 16.h),

                  AppText(
                    maxLines: 4,
                    textName:
                        "Confirm deletion of '$playlistName'? All songs in this playlist will be permanently removed.",
                    fontSize: 16.sp,
                    textColor: isDark ? Colors.white70 : Colors.black54,
                    align: TextAlign.start,
                  ),

                  SizedBox(height: 18.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: AppText(
                          textName: "Cancel",
                          fontSize: 16.sp,
                          textColor: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),

                      SizedBox(width: 12.w),

                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          backgroundColor:
                              isDark
                                  ? Colors.red[700]?.withOpacity(0.2)
                                  : Colors.red[100],
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: AppText(
                          textName: "Delete",
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
          showSnackBar(
            context,
            "Playlist deleted successfully",
            const Color(AppColors.successColor),
          );
        })
        .catchError((error) {
          showSnackBar(
            context,
            "Failed to delete playlist: ${error.toString()}",
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
            textName: "Your Playlists",
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        body: playlistsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stack) =>
                  Center(child: AppText(textName: "Error loading playlists")),
          data:
              (playlists) =>
                  playlists.isEmpty
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
                              textName: "No playlists yet",
                              fontSize: 18,
                              textColor: Colors.grey,
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          final playlist = playlists[index];
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
                                  textName: playlist.name,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  textColor: Colors.white,
                                ),
                                subtitle: AppText(
                                  textName: "${playlist.songCount} songs",
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
      ),
    );
  }
}
