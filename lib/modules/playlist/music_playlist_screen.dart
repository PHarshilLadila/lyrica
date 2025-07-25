import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/core/constant/app_string.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/playlist/provider/playlist_provider.dart';
import 'package:lyrica/modules/playlist/view%20playlist/view_playlist_screen.dart';
import 'package:lyrica/modules/playlist/widget/recommended_song_list.dart';
import 'package:lyrica/modules/search%20items/view/search_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MusicPlaylistScreen extends ConsumerStatefulWidget {
  final String playListName;
  const MusicPlaylistScreen({super.key, required this.playListName});

  @override
  ConsumerState<MusicPlaylistScreen> createState() =>
      _MusicPlaylistScreenState();
}

class _MusicPlaylistScreenState extends ConsumerState<MusicPlaylistScreen> {
  void _showPlaylistDetails(BuildContext context, List<Results> playlist) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.sp),

          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF001B1F), Color(0xFF003543)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              AppText(
                text: '${widget.playListName} (${playlist.length})',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                textColor: Color(AppColors.whiteBackground),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child:
                    playlist.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.music_off,
                                size: 50.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16.h),
                              AppText(
                                text: 'No songs in playlist',
                                fontSize: 16.sp,
                                textColor: Colors.grey,
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: playlist.length,
                          itemBuilder: (context, index) {
                            final track = playlist[index];
                            return Dismissible(
                              key: Key(track.id.toString()),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.w),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                ref
                                    .read(playlistProvider.notifier)
                                    .removeSong(track);
                                showAppSnackBar(
                                  context,
                                  "${track.name} ${AppLocalizations.of(context)!.removeFromPlaylist}",
                                  Color(AppColors.errorColor),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 4.h),
                                color: Colors.white.withOpacity(0.1),
                                child: ListTile(
                                  leading:
                                      track.albumImage != null
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                            child: Image.network(
                                              track.albumImage!,
                                              width: 50.w,
                                              height: 50.h,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) => Icon(
                                                    Icons.music_note,
                                                    size: 30,
                                                  ),
                                            ),
                                          )
                                          : Icon(Icons.music_note, size: 30),
                                  title: AppText(
                                    text: track.name ?? 'Unknown',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    textColor: Color(AppColors.whiteBackground),
                                  ),
                                  subtitle: AppText(
                                    text: track.artistName ?? 'Unknown artist',
                                    fontSize: 12.sp,
                                    textColor: Color(
                                      AppColors.whiteBackground,
                                    ).withOpacity(0.5),
                                  ),
                                  trailing: IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.red,
                                      size: 18.sp,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(playlistProvider.notifier)
                                          .removeSong(track);
                                      showAppSnackBar(
                                        context,
                                        "${track.name} ${AppLocalizations.of(context)!.removeFromPlaylist}",
                                        Color(AppColors.errorColor),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
              SizedBox(height: 16.h),
              if (playlist.isNotEmpty)
                AppMainButton(
                  height: 45.h,
                  onPressed: () async {
                    try {
                      await ref
                          .read(playlistProvider.notifier)
                          .savePlaylist(widget.playListName);

                      ref.read(playlistProvider.notifier).clearPlaylist();

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPlaylistScreen(),
                          ),
                        );
                        showAppSnackBar(
                          context,
                          AppLocalizations.of(context)!.playlistSavedSuccess,
                          Color(AppColors.successColor),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        showAppSnackBar(
                          context,
                          "${AppLocalizations.of(context)!.playlistSavedFailed} ${e.toString()}",
                          Color(AppColors.errorColor),
                        );
                      }
                    }
                  },
                  gradient: LinearGradient(
                    colors: [
                      Color(AppColors.whiteBackground),
                      Color(AppColors.whiteBackground),
                    ],
                  ),
                  child: AppText(
                    fontSize: 18.sp,
                    text: AppLocalizations.of(context)!.savetoPlaylist,
                    textColor: Color(
                      AppColors.blackBackground,
                    ).withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(height: 10.h),
              AppMainButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.transparent],
                ),

                child: AppText(
                  fontSize: 16.sp,
                  text:
                      playlist.isEmpty
                          ? 'Close'
                          : AppLocalizations.of(context)!.cancel,
                  textColor: Color(AppColors.whiteBackground),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final musicAsyncValue = ref.watch(musicDataProvider);
    final userModelAsync = ref.watch(userModelProvider);
    final playlist = ref.watch(playlistProvider);

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),
      child: Scaffold(
        backgroundColor: Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          leading: AppBackButton(),
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          actions: [
            if (playlist.isNotEmpty)
              IconButton(
                onPressed: () => _showPlaylistDetails(context, playlist),
                icon: FaIcon(
                  FontAwesomeIcons.list,
                  color: Color(AppColors.whiteBackground),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (playlist.isEmpty) {
                        showAppSnackBar(
                          context,
                          AppLocalizations.of(context)!.playlistIsEmptyAddSongs,
                          Color(AppColors.errorColor),
                        );
                      } else {
                        _showPlaylistDetails(context, playlist);
                      }
                    },
                    child: Container(
                      height: 130.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child:
                          playlist.isEmpty
                              ? Center(
                                child: Image.asset(
                                  "assets/image/musicLogo.png",
                                  height: 80.h,
                                  width: 80.w,
                                ),
                              )
                              : Stack(
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Image.network(
                                        playlist.first.albumImage ??
                                            AppString.defaultImageLogo,
                                        fit: BoxFit.cover,
                                        height: 130.h,
                                        width: 150.w,
                                        errorBuilder:
                                            (_, __, ___) => Center(
                                              child: Image.asset(
                                                "assets/image/musicLogo.png",
                                                height: 80.h,
                                                width: 80.w,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                  if (playlist.length > 1)
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '+${playlist.length - 1}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: widget.playListName,
                          textColor: Color(AppColors.whiteBackground),
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        userModelAsync.when(
                          data: (userModel) {
                            final displayName = userModel?.username;
                            final displayText =
                                (displayName != null && displayName.isNotEmpty)
                                    ? displayName
                                    : "N/A";

                            final profileImage = userModel?.image ?? "";

                            final bool hasNetworkImage =
                                profileImage.startsWith("http") ||
                                profileImage.startsWith("https");
                            final bool hasValidAsset =
                                profileImage.isNotEmpty && !hasNetworkImage;

                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child:
                                      hasNetworkImage
                                          ? Image.network(
                                            profileImage,
                                            fit: BoxFit.cover,
                                            height: 28.h,
                                            width: 28.w,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return _buildInitialAvatar(
                                                displayText,
                                              );
                                            },
                                          )
                                          : hasValidAsset
                                          ? Image.asset(
                                            profileImage,
                                            fit: BoxFit.cover,
                                            height: 28.h,
                                            width: 28.w,
                                          )
                                          : _buildInitialAvatar(displayText),
                                ),
                                SizedBox(width: 6.w),
                                AppText(
                                  text: displayText,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  textColor: Color(
                                    AppColors.lightText,
                                  ).withOpacity(0.8),
                                ),
                              ],
                            );
                          },
                          loading: () => appLoader(),
                          error:
                              (e, _) => AppText(
                                text: "Error loading user",
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                textColor: Colors.redAccent,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100.w),
                  child: AppMainButton(
                    borderRadius: BorderRadius.circular(50.r),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(true),
                        ),
                      );
                    },
                    gradient: LinearGradient(
                      colors: [
                        Color(AppColors.blueLight),
                        Color(AppColors.primaryColor),
                      ],
                    ),
                    child: Center(
                      child: AppText(
                        fontSize: 14.sp,
                        maxLines: 1,
                        text: AppLocalizations.of(context)!.exploreMusic,
                        fontWeight: FontWeight.bold,
                        textColor: Color(AppColors.whiteBackground),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: AppMainButton(
                    borderRadius: BorderRadius.circular(50.r),

                    onPressed: () {
                      if (playlist.isEmpty) {
                        showAppSnackBar(
                          context,
                          AppLocalizations.of(context)!.playlistIsEmptyAddSongs,
                          Color(AppColors.errorColor),
                        );
                      } else {
                        _showPlaylistDetails(context, playlist);
                      }
                    },

                    gradient: LinearGradient(
                      colors: [
                        Color(AppColors.whiteBackground),
                        Color(AppColors.whiteBackground),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.plus,
                          size: 16.sp,
                          color: Color(
                            AppColors.blackBackground,
                          ).withOpacity(0.8),
                        ),
                        SizedBox(width: 6.w),
                        AppText(
                          maxLines: 1,
                          text: AppLocalizations.of(context)!.addToPlayList,
                          fontWeight: FontWeight.bold,
                          textColor: Color(AppColors.blackBackground),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),
              RecommendedSongs(musicAsyncValue: musicAsyncValue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialAvatar(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";
    return CircleAvatar(
      radius: 14.r,
      backgroundColor: Colors.grey.shade700,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
