import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/common/widget/app_back_button.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

class MusicPlayer extends ConsumerStatefulWidget {
  final List<Results> songList;
  final int initialIndex;

  const MusicPlayer({
    super.key,
    required this.songList,
    required this.initialIndex,
  });

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends ConsumerState<MusicPlayer> {
  late AudioPlayer audioPlayer;
  late int currentIndex;

  Stream<Duration> get positionStream => audioPlayer.positionStream;
  Stream<Duration?> get durationStream => audioPlayer.durationStream;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    // audioPlayer = ref.read(audioPlayerProvider);
    currentIndex = widget.initialIndex;
    _loadSong(currentIndex);
  }

  Future<void> _loadSong(int index) async {
    await audioPlayer.stop();

    final url = widget.songList[index].audio;
    if (url != null) {
      await audioPlayer.setUrl(url);
      audioPlayer.play();
    }
  }

  void _playPause() {
    if (audioPlayer.playing) {
      setState(() {
        audioPlayer.pause();
      });
    } else {
      setState(() {
        audioPlayer.play();
      });
    }
  }

  void _nextSong() {
    if (currentIndex < widget.songList.length - 1) {
      setState(() {
        currentIndex++;
        _loadSong(currentIndex);
      });
    }
  }

  void _previousSong() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _loadSong(currentIndex);
      });
    }
  }

  void _seek(double value) {
    audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songList[currentIndex];

    return MiniplayerWillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Container(
        decoration: BoxDecoration(gradient: backgroundGradient()),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(221, 39, 39, 39),
          appBar: AppBar(
            leading: AppBackButton(),
            elevation: 0,
            toolbarHeight: 90,
            backgroundColor: Colors.transparent,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  textName: "Now Playing",
                  fontSize: 20.sp,
                  textColor: Color(AppColors.lightText),
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),

                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    currentSong.image ?? "",
                    width: 280.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10.h),
                GradientText(
                  currentSong.name ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 24.sp),
                  gradientType: GradientType.radial,
                  radius: 5.5,
                  colors: [
                    Color(AppColors.blueLight),
                    Color(AppColors.blueThird),
                    Color(AppColors.blueLight),
                    Color(AppColors.secondaryColor),
                  ],
                ),
                SizedBox(height: 5.h),
                AppText(
                  textName: "By - ${currentSong.artistName ?? ""}",
                  textColor: Colors.white54,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 15.h),
                StreamBuilder<Duration>(
                  stream: positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = audioPlayer.duration ?? Duration.zero;

                    return Column(
                      children: [
                        Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value:
                              position.inSeconds
                                  .clamp(0, duration.inSeconds)
                                  .toDouble(),
                          onChanged: _seek,
                          activeColor: Color(AppColors.primaryColor),
                          inactiveColor: Colors.white24,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.backward),
                      iconSize: 50,
                      color: Color.fromARGB(255, 218, 250, 255),
                      onPressed: _previousSong,
                    ),
                    SizedBox(width: 30.w),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(AppColors.primaryColor),
                            Color(AppColors.blueLight),
                          ],
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          !audioPlayer.playing
                              ? (CupertinoIcons.pause_circle)
                              : (CupertinoIcons.play_circle),
                        ),

                        iconSize: 50,
                        color: Colors.white,
                        onPressed: _playPause,
                      ),
                    ),
                    SizedBox(width: 30.w),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.forward),
                      iconSize: 50,
                      color: Color.fromARGB(255, 218, 250, 255),
                      onPressed: _nextSong,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  // StreamBuilder<Duration>(
              //   stream: positionStream,
              //   builder: (context, snapshot) {
              //     final position = snapshot.data ?? Duration.zero;
              //     final duration = audioPlayer.duration ?? Duration.zero;

              //     return SleekCircularSlider(
              //       min: 0,
              //       max: duration.inSeconds.toDouble(),
              //       onChange: (double value) {
              //         _seek(value);
              //       },
              //       appearance: CircularSliderAppearance(
              //         size: 200.h,
              //         customWidths: CustomSliderWidths(
              //           trackWidth: 3,
              //           handlerSize: 8,
              //           progressBarWidth: 10,
              //           shadowWidth: 25,
              //         ),
              //         customColors: CustomSliderColors(
              //           shadowStep: 2,
              //           trackColor: Color.fromARGB(255, 185, 247, 255),
              //           shadowColor: Color.fromARGB(255, 0, 225, 255),
              //           progressBarColors: [
              //             Color.fromARGB(255, 3, 54, 56),
              //             Color(AppColors.secondaryColor),
              //             Color(AppColors.blueThird),
              //             Color(AppColors.primaryColor),
              //           ],
              //         ),
              //       ),
              //       initialValue: position.inSeconds.toDouble(),
              //       onChangeStart: (value) {
              //         if (audioPlayer.playing) {
              //           audioPlayer.pause();
              //         }
              //       },
              //       onChangeEnd: (value) {
              //         _seek(value);
              //         if (!audioPlayer.playing) {
              //           audioPlayer.play();
              //         }
              //       },
              //       innerWidget: (double value) {
              //         return Center(
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(100),
              //             child: Image.network(
              //               currentSong.image ?? "",
              //               height: 160.h,
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),