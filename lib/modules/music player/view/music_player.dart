// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_main_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/library/view/library_screen.dart';
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  final List<Results> songList;
  final int initialIndex;

  const MusicPlayer({
    super.key,
    required this.songList,
    required this.initialIndex,
  });

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayer> {
  String musicShareURL = '';

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FlutterDownloader.initialize();
    // });
    Future.delayed(Duration.zero, () {
      context.read<FavoriteProvider>().fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayer = ref.watch(
      musicPlayerProvider((
        songList: widget.songList,
        initialIndex: widget.initialIndex,
      )).notifier,
    );
    final musicPlayerState = ref.watch(
      musicPlayerProvider((
        songList: widget.songList,
        initialIndex: widget.initialIndex,
      )),
    );
    final rewardPointsAsync = ref.watch(rewardPointsProvider);
    final currentSong = widget.songList[musicPlayerState.currentIndex];
    // final isFavorite = ref.watch(
    //   favoriteProvider.select(
    //     (favorites) => favorites.contains(
    //       widget.songList[musicPlayerState.currentIndex].id,
    //     ),
    //   ),
    // );

    ref.listen<bool>(
      musicPlayerProvider((
        songList: widget.songList,
        initialIndex: widget.initialIndex,
      )).select((state) => state.showDownloadComplete),
      (previous, next) {
        if (next) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: true,
            builder:
                (_) => _buildDownloadSuccessDialog(
                  context,
                  musicPlayerState.downloadingFileName ?? "Unknown",
                ),
          ).then((_) {
            musicPlayer.resetDownloadComplete();
          });
        }
      },
    );

    ref.listen<bool>(dialogShownProvider, (previous, next) {
      if (next) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: "RewardDialog",
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => _buildNoPointsDialog(context, ref),
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
              child: child,
            );
          },
        );
      }
    });

    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient()),

      child: Scaffold(
        backgroundColor: const Color.fromARGB(197, 0, 43, 53),
        appBar: AppBar(
          leading: AppBackButton(),
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: "Now Playing",
                fontSize: 20.sp,
                textColor: Color(AppColors.lightText),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 16.w, left: 16.w),
              margin: EdgeInsets.only(top: 20.h, bottom: 20.h, right: 12.w),
              decoration: BoxDecoration(
                color: Color(AppColors.primaryColor),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color(AppColors.primaryColor).withOpacity(0.18),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.stars, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  rewardPointsAsync.when(
                    data:
                        (points) => AppText(
                          text: "$points",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          textColor: Colors.white,
                        ),
                    loading:
                        () => SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                    error:
                        (error, stack) => AppText(
                          text: "0",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          textColor: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.95, end: 1.0),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  AppColors.primaryColor,
                                ).withOpacity(0.25),
                                blurRadius: 40,
                                spreadRadius: 8,
                                offset: Offset(0, 16),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              width: 300.w,
                              height: 300.w,
                              currentSong.image ?? "",
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      Icon(Icons.music_note, size: 100.sp),
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 32.h),

                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        Color(AppColors.blueLight),
                        Color(AppColors.primaryColor),
                        Color(AppColors.secondaryColor),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    currentSong.name ?? "",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: "By - ${currentSong.artistName ?? ""}",
                      textColor: Colors.white54,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      maxLines: 2,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(CupertinoIcons.share),
                          iconSize: 22.sp,
                          color: Color(AppColors.primaryColor),
                          onPressed: () async {
                            final String songTitle =
                                currentSong.name ?? "Unknown Song";

                            SharePlus.instance.share(
                              ShareParams(
                                title: songTitle,
                                previewThumbnail: XFile(
                                  currentSong.image ??
                                      "https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg",
                                ),
                                uri: Uri.parse(
                                  currentSong.shareurl ??
                                      "https://licensing.jamendo.com/en/in-store?jmm=instore",
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: FaIcon(
                            context.watch<FavoriteProvider>().isFavorite(
                                  currentSong.id ?? "",
                                )
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                          ),
                          iconSize: 20.sp,
                          color:
                              context.watch<FavoriteProvider>().isFavorite(
                                    currentSong.id ?? "",
                                  )
                                  ? Color(AppColors.blueLight)
                                  : Color(AppColors.primaryColor),

                          onPressed: () async {
                            final SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            final String? userId = preferences.getString(
                              "userUID",
                            );
                            final songData = {
                              "userId": userId,

                              "id": currentSong.id,
                              "name": currentSong.name,
                              "artistName": currentSong.artistName,
                              "image": currentSong.image,
                              "audio": currentSong.audio,
                              "audioDuration": currentSong.duration,
                              "albumImage": currentSong.albumImage,
                              "albumName": currentSong.albumName,
                              "position": currentSong.position,
                            };
                            context.read<FavoriteProvider>().toggleFavorite(
                              songData,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                StreamBuilder<Duration>(
                  stream: musicPlayer.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration =
                        musicPlayerState.audioPlayer.duration ?? Duration.zero;

                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Slider(
                            year2023: true,
                            mouseCursor: MouseCursor.defer,
                            thumbColor: Color(AppColors.blueLight),
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value:
                                position.inSeconds
                                    .clamp(0, duration.inSeconds)
                                    .toDouble(),
                            onChanged: musicPlayer.seek,
                            padding: EdgeInsets.only(
                              top: 12.h,
                              right: 4.w,
                              left: 4.w,
                              bottom: 4.h,
                            ),
                            activeColor: Color(AppColors.primaryColor),
                            inactiveColor: Color(AppColors.blueExtraLight),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 6.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: musicPlayer.formatDuration(position),
                                textColor: Colors.white70,
                              ),
                              AppText(
                                text: musicPlayer.formatDuration(duration),
                                textColor: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.shuffle),
                      iconSize: 25.sp,
                      color: Color(AppColors.primaryColor),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.backward),
                      iconSize: 35.sp,
                      color: Color(AppColors.primaryColor),
                      onPressed: musicPlayer.previousSong,
                    ),
                    _AnimatedGlow(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(AppColors.primaryColor),
                              Color(AppColors.blueLight),
                            ],
                          ),
                        ),
                        child: StreamBuilder<PlayerState>(
                          stream: musicPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            final playerState = snapshot.data;
                            final isPlaying = playerState?.playing ?? false;
                            return IconButton(
                              icon: Icon(
                                isPlaying
                                    ? CupertinoIcons.pause_circle
                                    : CupertinoIcons.play_circle,
                              ),
                              iconSize: 60,
                              color: Colors.white,
                              onPressed: musicPlayer.playPause,
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.forward),
                      iconSize: 35.sp,
                      color: Color(AppColors.primaryColor),
                      onPressed: musicPlayer.nextSong,
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.arrowDown),
                      iconSize: 25.sp,
                      color: Color(AppColors.primaryColor),
                      onPressed: () {
                        final audioUrl = currentSong.audio ?? "";
                        final name = currentSong.name ?? "Unknown";

                        if (audioUrl.isNotEmpty) {
                          musicPlayer.startDownloadWithLoading(audioUrl, name);
                          _buildDownloadSuccessDialog(context, audioUrl);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoPointsDialog(BuildContext context, WidgetRef ref) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(AppColors.whiteBackground),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Color(AppColors.primaryColor).withOpacity(0.18),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/image/rewardIcon.png", height: 80),
              const SizedBox(height: 16),
              AppText(
                text: "No Reward Points!",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                textColor: Color(AppColors.primaryColor),
              ),
              const SizedBox(height: 12),
              AppText(
                text:
                    "You need more reward points to play music.\nGo to Library and earn more points by watching ads.",
                align: TextAlign.center,
                fontSize: 16,
                textColor: Color(AppColors.darkBlue),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LibraryScreen()),
                  );
                  ref.read(dialogShownProvider.notifier).state = false;
                },
                icon: const Icon(Icons.card_giftcard, color: Colors.white),
                label: AppText(
                  text: "Go to Library",
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadSuccessDialog(BuildContext context, String fileName) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.checkCircle,
              size: 60,
              color: Color(AppColors.primaryColor),
            ),
            const SizedBox(height: 16),
            AppText(
              text: "Download Complete",
              fontSize: 20,
              textColor: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 9.h),
            AppText(
              text:
                  '"${fileName.length > 20 ? '${fileName.substring(0, 20)}...' : fileName}.mp3"',
              align: TextAlign.center,
              fontSize: 16,
              textColor: Colors.black54,
            ),
            SizedBox(height: 2.h),
            AppText(
              text: "has been saved to your Downloads folder",
              align: TextAlign.center,
              fontSize: 14,
              textColor: Colors.black54,
            ),
            const SizedBox(height: 24),
            AppMainButton(
              onPressed: () => Navigator.of(context).pop(),
              gradient: LinearGradient(
                colors: [
                  Color(AppColors.blueLight),
                  Color(AppColors.primaryColor),
                ],
              ),
              child: AppText(
                text: "OK",
                fontWeight: FontWeight.bold,
                fontSize: 16,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedGlow extends StatefulWidget {
  final Widget child;
  const _AnimatedGlow({required this.child});

  @override
  State<_AnimatedGlow> createState() => _AnimatedGlowState();
}

class _AnimatedGlowState extends State<_AnimatedGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glow = 18.0 + 12.0 * _controller.value;
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(AppColors.primaryColor).withOpacity(0.5),
                blurRadius: glow,
                spreadRadius: 1,
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: widget.child,
        );
      },
    );
  }
}
