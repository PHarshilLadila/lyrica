import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:lyrica/model/music_model.dart';
import 'package:lyrica/modules/albums/album%20tracks/album_tracks_provider.dart';
import 'package:lyrica/modules/albums/albums_provider.dart';
import 'package:lyrica/modules/library/music_equalizer/equalizer_provider.dart';
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
import 'package:lyrica/modules/music%20player/view/music_player.dart';
import 'package:lyrica/services/audio_player_handler.dart';
import 'package:provider/provider.dart' as provider;
import 'package:lyrica/l10n/locale_provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
import 'package:lyrica/modules/home/view/home_screen.dart';
import 'package:lyrica/modules/search%20items/view/search_screen.dart';
import 'package:lyrica/modules/library/view/library_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart'
    as current_music;
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart'
    as music_player;
import 'package:miniplayer/miniplayer.dart';

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

String? userUid;
late final AudioPlayerHandler audioHandler;

// Create a provider to track if we're using AudioService
final isUsingAudioServiceProvider = StateProvider<bool>((ref) => true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize AudioService with the custom handler
    audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.lyrica.channel.audio',
        androidNotificationChannelName: 'Lyrica Music',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        androidNotificationIcon: 'mipmap/ic_launcher',
        preloadArtwork: true,
      ),
    );
  } catch (e) {
    debugPrint("AudioService initialization error: $e");
  }

  await dotenv.load(fileName: ".env");
  await MobileAds.instance.initialize();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await requestNotificationPermission();

  try {
    await Firebase.initializeApp();
  } catch (e, s) {
    debugPrint("Firebase init error: $e\n$s");
  }

  userUid = await _getUserIdFromPrefs();
  // await MongoDatabaseService.connect();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await _createNotificationChannel();

  runApp(
    ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider<LocaleProvider>(
            create: (_) => LocaleProvider(),
          ),
          provider.ChangeNotifierProvider<AlbumProvider>(
            create: (_) => AlbumProvider(),
          ),
          provider.ChangeNotifierProvider<AlbumsTracksProvider>(
            create: (_) => AlbumsTracksProvider(),
          ),
          provider.ChangeNotifierProvider<FavoriteProvider>(
            create: (_) => FavoriteProvider()..fetchFavorites(),
          ),
          provider.ChangeNotifierProvider<EqualizerProvider>(
            create: (_) => EqualizerProvider(),
          ),
          provider.Provider<AudioPlayerHandler>(
            create: (_) => audioHandler,
            dispose: (_, handler) => handler.dispose(),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

Future<void> _createNotificationChannel() async {
  if (Platform.isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'lyrica_music_channel', // Same as in manifest
      'Music Playback',
      description: 'Music playback controls',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }
}

Future<String?> _getUserIdFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("userUID");
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeProvider = provider.Provider.of<LocaleProvider>(context);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          scrollBehavior: NoGlowScrollBehavior(),
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('gu'),
            Locale('es'),
            Locale('de'),
            Locale('pt'),
            Locale('fr'),
            Locale('ru'),
            Locale('zh'),
            Locale('ko'),
            Locale('ar', 'EG'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: 'Lyrica',
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            useMaterial3: false,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          ),
          home:
              userUid != null
                  ? MainWithMiniPlayer(key: MainWithMiniPlayer.globalKey)
                  : const GoogleLoginScreen(),

          // userUid != null
          //     ? const MainWithMiniPlayer()
          //     : const GoogleLoginScreen(),
        );
      },
    );
  }
}

class MainWithMiniPlayer extends ConsumerStatefulWidget {
  const MainWithMiniPlayer({super.key});
  static final GlobalKey<_MainWithMiniPlayerState> globalKey =
      GlobalKey<_MainWithMiniPlayerState>();

  @override
  ConsumerState<MainWithMiniPlayer> createState() => _MainWithMiniPlayerState();
}

class _MainWithMiniPlayerState extends ConsumerState<MainWithMiniPlayer>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final MiniplayerController _miniplayerController = MiniplayerController();
  double currentHeight = 70;
  PanelState _currentPanelState = PanelState.MIN;
  late AnimationController _waveController;

  final List<Widget> _screens = [
    HomeScreen("", ""),
    SearchScreen(false),
    LibraryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Load last played music from storage
    _loadLastPlayedMusic();

    // Listen to AudioService events
    audioHandler.playbackState.listen((state) {
      final isPlaying = state.playing;
      final processingState = state.processingState;

      // Update the current music provider state based on AudioService
      ref
          .read(current_music.currentMusicProvider.notifier)
          .setPlaying(isPlaying);

      // Update position if needed
      if (state.updatePosition != Duration.zero) {
        ref.read(current_music.currentMusicProvider.notifier);
      }
    });
  }

  void expandMiniPlayer() {
    _miniplayerController.animateToHeight(state: PanelState.MAX);
    setState(() {
      _currentPanelState = PanelState.MAX;
    });
  }

  void minimizeMiniPlayer() {
    _miniplayerController.animateToHeight(state: PanelState.MIN);
    setState(() {
      _currentPanelState = PanelState.MIN;
      currentHeight = 70;
    });
  }

  // Load last played music from shared preferences
  Future<void> _loadLastPlayedMusic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasLastPlayed = prefs.getBool('hasLastPlayed') ?? false;

      if (hasLastPlayed) {
        final songId = prefs.getString('lastSongId');
        final songName = prefs.getString('lastSongName');
        final artistName = prefs.getString('lastArtistName');
        final imageUrl = prefs.getString('lastImageUrl');
        final duration = prefs.getInt('lastDuration');
        final isPlaying = prefs.getBool('lastIsPlaying') ?? false;

        if (songId != null && songName != null) {
          // Create a mock song object with the saved data
          final lastSong = Results(
            id: songId,
            name: songName,
            artistName: artistName ?? 'Unknown Artist',
            image: imageUrl,
            duration: duration,
          );

          // Update the provider with the last played song
          ref
              .read(current_music.currentMusicProvider.notifier)
              .setSong(
                lastSong,
                [], // Empty playlist as we don't store the full playlist
                0, // Default index
              );

          // Set playing state if it was playing
          if (isPlaying) {
            ref
                .read(current_music.currentMusicProvider.notifier)
                .setPlaying(true);
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading last played music: $e");
    }
  }

  // Save current playing music to shared preferences
  Future<void> _saveCurrentMusic() async {
    try {
      final currentState = ref.read(current_music.currentMusicProvider);
      final prefs = await SharedPreferences.getInstance();

      if (currentState.currentSong != null) {
        await prefs.setBool('hasLastPlayed', true);
        await prefs.setString('lastSongId', currentState.currentSong!.id ?? '');
        await prefs.setString(
          'lastSongName',
          currentState.currentSong!.name ?? '',
        );
        await prefs.setString(
          'lastArtistName',
          currentState.currentSong!.artistName ?? '',
        );
        await prefs.setString(
          'lastImageUrl',
          currentState.currentSong!.image ?? '',
        );
        await prefs.setInt(
          'lastDuration',
          currentState.currentSong!.duration ?? 0,
        );
        await prefs.setBool('lastIsPlaying', currentState.isPlaying);
      } else {
        await prefs.setBool('hasLastPlayed', false);
      }
    } catch (e) {
      debugPrint("Error saving current music: $e");
    }
  }

  @override
  void dispose() {
    // Save current music state when disposing
    _saveCurrentMusic();
    _miniplayerController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _expandMiniPlayer() {
    _miniplayerController.animateToHeight(state: PanelState.MAX);
    setState(() {
      _currentPanelState = PanelState.MAX;
    });
  }

  void _minimizeMiniPlayer() {
    _miniplayerController.animateToHeight(state: PanelState.MIN);
    setState(() {
      _currentPanelState = PanelState.MIN;
      currentHeight = 70;
    });
  }

  void _closeMiniPlayer() {
    // Only minimize, don't close completely
    _minimizeMiniPlayer();

    // Save the current music state when minimizing
    _saveCurrentMusic();
  }

  @override
  Widget build(BuildContext context) {
    final currentMusicState = ref.watch(current_music.currentMusicProvider);
    final isUsingAudioService = ref.watch(isUsingAudioServiceProvider);

    return WillPopScope(
      onWillPop: () async {
        if (_currentPanelState == PanelState.MAX) {
          _minimizeMiniPlayer();
          return false;
        } else if (_currentPanelState == PanelState.MIN &&
            currentMusicState.currentSong != null) {
          // Don't allow back navigation if there's a song playing
          // Just minimize further if needed
          return false;
        }

        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(index: _currentIndex, children: _screens),
            // Always show miniplayer if there's a current song
            if (currentMusicState.currentSong != null)
              Positioned(
                bottom: 1,
                left: 0,
                right: 0,
                child: _buildMiniPlayer(currentMusicState),
              ),
          ],
        ),
        bottomNavigationBar: CustomBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildMiniPlayer(current_music.CurrentMusicState musicState) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Color(AppColors.primaryColor).withOpacity(0.8),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Miniplayer(
            backgroundColor: Colors.transparent,
            controller: _miniplayerController,
            minHeight: 80,
            maxHeight: MediaQuery.of(context).size.height,
            onDismissed: () {
              _closeMiniPlayer();
            },
            builder: (height, percentage) {
              currentHeight = height;

              if (height <= 80) {
                _currentPanelState = PanelState.MIN;
                return _buildCollapsedMiniPlayer(musicState);
              } else {
                _currentPanelState = PanelState.MAX;
                return MusicPlayer(
                  songList: musicState.playlist,
                  initialIndex: musicState.currentIndex,
                  onMinimize: _minimizeMiniPlayer,
                  // Pass the audioHandler to the MusicPlayer
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedMiniPlayer(current_music.CurrentMusicState musicState) {
    return GestureDetector(
      onTap: _expandMiniPlayer,
      onVerticalDragEnd: (details) {
        // Only allow swiping down to minimize, not to close completely
        if (details.primaryVelocity! > 100) {
          _closeMiniPlayer();
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Wave background progress - using AudioHandler stream
            StreamBuilder<PlaybackState>(
              stream: audioHandler.playbackState,
              builder: (context, snapshot) {
                final playbackState = snapshot.data;
                final position = playbackState?.updatePosition ?? Duration.zero;
                final duration =
                    musicState.currentSong?.duration != null
                        ? Duration(seconds: musicState.currentSong!.duration!)
                        : Duration.zero;

                double progress = 0.0;
                if (duration.inSeconds > 0) {
                  progress = position.inSeconds / duration.inSeconds;
                }

                return AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(double.infinity, 80),
                      painter: WaveBackgroundPainter(
                        waveValue: _waveController.value,
                        progress: progress.clamp(0.0, 1.0),
                        waveColor: const Color.fromARGB(
                          255,
                          1,
                          40,
                          56,
                        ).withOpacity(0.7),
                        backgroundColor: Colors.black38,
                      ),
                    );
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  // Song thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      musicState.currentSong!.image ?? "",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 40,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Song info + progress bar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          musicState.currentSong!.name ?? "Unknown",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          musicState.currentSong!.artistName ??
                              "Unknown Artist",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 6),
                        // Progress slider with audio handler integration
                        StreamBuilder<PlaybackState>(
                          stream: audioHandler.playbackState,
                          builder: (context, snapshot) {
                            final playbackState = snapshot.data;
                            final position =
                                playbackState?.updatePosition ?? Duration.zero;
                            final duration =
                                musicState.currentSong?.duration != null
                                    ? Duration(
                                      seconds:
                                          musicState.currentSong!.duration!,
                                    )
                                    : Duration.zero;

                            return SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 2,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: SliderComponentShape.noOverlay,
                              ),
                              child: Slider(
                                value:
                                    duration.inSeconds > 0
                                        ? position.inSeconds.toDouble().clamp(
                                          0.0,
                                          duration.inSeconds.toDouble(),
                                        )
                                        : 0.0,
                                max:
                                    duration.inSeconds > 0
                                        ? duration.inSeconds.toDouble()
                                        : 1.0,
                                activeColor: Colors.white,
                                inactiveColor: Colors.white24,
                                onChanged: (value) {
                                  // Use AudioService for seeking
                                  final newPosition = Duration(
                                    seconds: value.toInt(),
                                  );
                                  audioHandler.seek(newPosition);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Play / Pause button with audio handler integration
                  StreamBuilder<PlaybackState>(
                    stream: audioHandler.playbackState,
                    builder: (context, snapshot) {
                      final playbackState = snapshot.data;
                      final isPlaying = playbackState?.playing ?? false;
                      final processingState =
                          playbackState?.processingState ??
                          AudioProcessingState.idle;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              // Show loading indicator when buffering
                              processingState ==
                                          AudioProcessingState.buffering ||
                                      processingState ==
                                          AudioProcessingState.loading
                                  ? Icons.hourglass_empty
                                  : (isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled),
                              size: 36,
                              color: Colors.white,
                            ),
                            onPressed:
                                processingState ==
                                            AudioProcessingState.buffering ||
                                        processingState ==
                                            AudioProcessingState.loading
                                    ? null // Disable button when loading
                                    : () async {
                                      try {
                                        // Use AudioService for control
                                        if (isPlaying) {
                                          await audioHandler.pause();
                                        } else {
                                          await audioHandler.play();
                                        }
                                      } catch (e) {
                                        debugPrint(
                                          'Error in mini player play/pause: $e',
                                        );
                                      }
                                    },
                          ),
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.arrowRight,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              try {
                                // Use AudioService for control
                                debugPrint("it is taped");
                                await audioHandler.skipToNext();
                              } catch (e) {
                                debugPrint(
                                  'Error in mini player skipToNext: $e',
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveBackgroundPainter extends CustomPainter {
  final double waveValue;
  final double progress;
  final Color waveColor;
  final Color backgroundColor;

  WaveBackgroundPainter({
    required this.waveValue,
    required this.progress,
    required this.waveColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Background
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

    final wavePaint =
        Paint()
          ..color = waveColor
          ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 6.0;

    // Vertical progress (bottom → top)
    final progressHeight = height * progress;
    final baseLine = height - progressHeight; // starting Y from bottom

    // Start from bottom-left
    path.moveTo(0, height);

    // Draw sine wave across the width at the "fill level"
    for (double x = 0; x <= width; x++) {
      final y = baseLine - sin((x / 45) + waveValue * 2 * pi) * waveHeight;
      path.lineTo(x, y);
    }

    // Close shape down to bottom-right and bottom-left
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant WaveBackgroundPainter oldDelegate) {
    return oldDelegate.waveValue != waveValue ||
        oldDelegate.progress != progress ||
        oldDelegate.waveColor != waveColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

Future<void> disposeAllMusicPlayers(WidgetRef ref) async {
  try {
    // Always use AudioService for control
    await audioHandler.stop();
    ref.read(current_music.currentMusicProvider.notifier).stop();
  } catch (e) {
    debugPrint("Error disposing all music players: $e");
  }
}

// import 'dart:io';
// import 'dart:math';
// import 'dart:ui';

// import 'package:audio_service/audio_service.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:lyrica/common/utils/utils.dart';
// import 'package:lyrica/core/constant/app_colors.dart';
// import 'package:lyrica/model/music_model.dart';
// import 'package:lyrica/modules/albums/album%20tracks/album_tracks_provider.dart';
// import 'package:lyrica/modules/albums/albums_provider.dart';
// import 'package:lyrica/modules/library/music_equalizer/equalizer_provider.dart';
// import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
// import 'package:lyrica/modules/music%20player/view/music_player.dart';
// import 'package:lyrica/services/audio_player_handler.dart';
// import 'package:provider/provider.dart' as provider;
// import 'package:lyrica/l10n/locale_provider.dart';
// import 'package:lyrica/modules/auth/view/google_login_screen.dart';
// import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
// import 'package:lyrica/modules/home/view/home_screen.dart';
// import 'package:lyrica/modules/search%20items/view/search_screen.dart';
// import 'package:lyrica/modules/library/view/library_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:lyrica/modules/music%20player/provider/current_playing_music_provider.dart'
//     as current_music;
// import 'package:miniplayer/miniplayer.dart';

// class NoGlowScrollBehavior extends ScrollBehavior {
//   @override
//   Widget buildOverscrollIndicator(
//     BuildContext context,
//     Widget child,
//     ScrollableDetails details,
//   ) {
//     return child;
//   }
// }

// String? userUid;
// late final AudioPlayerHandler audioHandler;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     // Initialize AudioService with the custom handler
//     audioHandler = await AudioService.init(
//       builder: () => AudioPlayerHandler(),
//       config: const AudioServiceConfig(
//         androidNotificationChannelId: 'com.lyrica.channel.audio',
//         androidNotificationChannelName: 'Lyrica Music',
//         androidNotificationOngoing: true,
//         androidStopForegroundOnPause: true,
//         androidNotificationIcon: 'mipmap/ic_launcher',
//         preloadArtwork: true,
//       ),
//     );
//   } catch (e) {
//     debugPrint("AudioService initialization error: $e");
//   }

//   await dotenv.load(fileName: ".env");
//   await MobileAds.instance.initialize();
//   await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
//   await requestNotificationPermission();

//   try {
//     await Firebase.initializeApp();
//   } catch (e, s) {
//     debugPrint("Firebase init error: $e\n$s");
//   }

//   userUid = await _getUserIdFromPrefs();

//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   await _createNotificationChannel();

//   runApp(
//     ProviderScope(
//       child: provider.MultiProvider(
//         providers: [
//           provider.ChangeNotifierProvider<LocaleProvider>(
//             create: (_) => LocaleProvider(),
//           ),
//           provider.ChangeNotifierProvider<AlbumProvider>(
//             create: (_) => AlbumProvider(),
//           ),
//           provider.ChangeNotifierProvider<AlbumsTracksProvider>(
//             create: (_) => AlbumsTracksProvider(),
//           ),
//           provider.ChangeNotifierProvider<FavoriteProvider>(
//             create: (_) => FavoriteProvider()..fetchFavorites(),
//           ),
//           provider.ChangeNotifierProvider<EqualizerProvider>(
//             create: (_) => EqualizerProvider(),
//           ),
//           provider.Provider<AudioPlayerHandler>(
//             create: (_) => audioHandler,
//             dispose: (_, handler) => handler.dispose(),
//           ),
//         ],
//         child: MyApp(),
//       ),
//     ),
//   );
// }

// Future<void> _createNotificationChannel() async {
//   if (Platform.isAndroid) {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'lyrica_music_channel',
//       'Music Playback',
//       description: 'Music playback controls',
//       importance: Importance.low,
//     );

//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//   }
// }

// Future<String?> _getUserIdFromPrefs() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString("userUID");
// }

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final localeProvider = provider.Provider.of<LocaleProvider>(context);
//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           scrollBehavior: NoGlowScrollBehavior(),
//           locale: localeProvider.locale,
//           supportedLocales: const [
//             Locale('en'),
//             Locale('hi'),
//             Locale('gu'),
//             Locale('es'),
//             Locale('de'),
//             Locale('pt'),
//             Locale('fr'),
//             Locale('ru'),
//             Locale('zh'),
//             Locale('ko'),
//             Locale('ar', 'EG'),
//           ],
//           localizationsDelegates: [
//             AppLocalizations.delegate,
//             GlobalMaterialLocalizations.delegate,
//             GlobalWidgetsLocalizations.delegate,
//             GlobalCupertinoLocalizations.delegate,
//           ],
//           debugShowCheckedModeBanner: false,
//           title: 'Lyrica',
//           theme: ThemeData(
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             useMaterial3: false,
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
//           ),
//           home:
//               userUid != null
//                   ? MainWithMiniPlayer(key: MainWithMiniPlayer.globalKey)
//                   : const GoogleLoginScreen(),
//         );
//       },
//     );
//   }
// }

// class MainWithMiniPlayer extends ConsumerStatefulWidget {
//   const MainWithMiniPlayer({super.key});
//   static final GlobalKey<_MainWithMiniPlayerState> globalKey =
//       GlobalKey<_MainWithMiniPlayerState>();

//   @override
//   ConsumerState<MainWithMiniPlayer> createState() => _MainWithMiniPlayerState();
// }

// class _MainWithMiniPlayerState extends ConsumerState<MainWithMiniPlayer>
//     with SingleTickerProviderStateMixin {
//   int _currentIndex = 0;
//   final MiniplayerController _miniplayerController = MiniplayerController();
//   double currentHeight = 70;
//   PanelState _currentPanelState = PanelState.MIN;
//   late AnimationController _waveController;

//   final List<Widget> _screens = [
//     HomeScreen("", ""),
//     SearchScreen(false),
//     LibraryScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _waveController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();

//     // Load last played music from storage
//     _loadLastPlayedMusic();

//     // Listen to AudioService events and sync with provider
//     _setupAudioServiceListeners();
//   }

//   void _setupAudioServiceListeners() {
//     // Listen to playback state changes
//     audioHandler.playbackState.listen((playbackState) {
//       if (!mounted) return;

//       final isPlaying = playbackState.playing;
//       // final processingState = playbackState.processingState;

//       // Update the current music provider state based on AudioService
//       final currentMusic = ref.read(current_music.currentMusicProvider);
//       if (currentMusic.isPlaying != isPlaying) {
//         ref
//             .read(current_music.currentMusicProvider.notifier)
//             .setPlaying(isPlaying);
//       }

//       // Update position
//       final position = playbackState.updatePosition;
//       if (position.inSeconds != currentMusic.position) {
//         ref
//             .read(current_music.currentMusicProvider.notifier)
//             .setPosition(position.inSeconds);
//       }
//     });

//     // Listen to media item changes
//     audioHandler.mediaItem.listen((mediaItem) {
//       if (!mounted || mediaItem == null) return;

//       // Update current music provider when media item changes
//       ref
//           .read(current_music.currentMusicProvider.notifier)
//           .setCurrentSongFromMediaItem(mediaItem);
//     });

//     // Listen to queue changes
//     audioHandler.queue.listen((queue) {
//       if (!mounted || queue.isEmpty) return;

//       // Convert MediaItems back to Results for the provider
//       final results =
//           queue
//               .map(
//                 (mediaItem) => Results(
//                   id: mediaItem.id,
//                   name: mediaItem.title,
//                   artistName: mediaItem.artist,
//                   image: mediaItem.artUri?.toString(),
//                   duration: mediaItem.duration?.inSeconds,
//                   audio: mediaItem.extras?['url'] as String?,
//                 ),
//               )
//               .toList();

//       // Update playlist in current music provider if different
//       final currentState = ref.read(current_music.currentMusicProvider);
//       if (currentState.playlist.length != results.length ||
//           !_playlistsEqual(currentState.playlist, results)) {
//         // Find current song in new playlist
//         final currentIndex = results.indexWhere(
//           (song) => song.id == currentState.currentSong?.id,
//         );
//         if (currentIndex != -1) {
//           ref
//               .read(current_music.currentMusicProvider.notifier)
//               .setMusic(results[currentIndex], results, currentIndex);
//         }
//       }
//     });
//   }

//   bool _playlistsEqual(List<Results> list1, List<Results> list2) {
//     if (list1.length != list2.length) return false;
//     for (int i = 0; i < list1.length; i++) {
//       if (list1[i].id != list2[i].id) return false;
//     }
//     return true;
//   }

//   void expandMiniPlayer() {
//     _miniplayerController.animateToHeight(state: PanelState.MAX);
//     setState(() {
//       _currentPanelState = PanelState.MAX;
//     });
//   }

//   void minimizeMiniPlayer() {
//     _miniplayerController.animateToHeight(state: PanelState.MIN);
//     setState(() {
//       _currentPanelState = PanelState.MIN;
//       currentHeight = 70;
//     });
//   }

//   // Load last played music from shared preferences
//   Future<void> _loadLastPlayedMusic() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final hasLastPlayed = prefs.getBool('hasLastPlayed') ?? false;

//       if (hasLastPlayed) {
//         final songId = prefs.getString('lastSongId');
//         final songName = prefs.getString('lastSongName');
//         final artistName = prefs.getString('lastArtistName');
//         final imageUrl = prefs.getString('lastImageUrl');
//         final audioUrl = prefs.getString('lastAudioUrl');
//         final duration = prefs.getInt('lastDuration');
//         final position = prefs.getInt('lastPosition') ?? 0;

//         if (songId != null && songName != null && audioUrl != null) {
//           // Create a mock song object with the saved data
//           final lastSong = Results(
//             id: songId,
//             name: songName,
//             artistName: artistName ?? 'Unknown Artist',
//             image: imageUrl,
//             audio: audioUrl,
//             duration: duration,
//           );

//           // Update the provider with the last played song
//           ref.read(current_music.currentMusicProvider.notifier).setSong(
//             lastSong,
//             [lastSong], // Single song playlist
//             0,
//           );

//           // Set the song in AudioHandler
//           await audioHandler.setCurrentSong(lastSong);
//           if (audioUrl.isNotEmpty) {
//             await audioHandler.setAudioSource(audioUrl);
//           }

//           // Restore position
//           if (position > 0) {
//             await audioHandler.seek(Duration(seconds: position));
//             ref
//                 .read(current_music.currentMusicProvider.notifier)
//                 .setPosition(position);
//           }

//           debugPrint(
//             'Restored last played song: $songName at position ${position}s',
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint("Error loading last played music: $e");
//     }
//   }

//   // Save current playing music to shared preferences
//   Future<void> _saveCurrentMusic() async {
//     try {
//       final currentState = ref.read(current_music.currentMusicProvider);
//       final prefs = await SharedPreferences.getInstance();
//       final position = audioHandler.currentPosition.inSeconds;

//       if (currentState.currentSong != null) {
//         await prefs.setBool('hasLastPlayed', true);
//         await prefs.setString('lastSongId', currentState.currentSong!.id ?? '');
//         await prefs.setString(
//           'lastSongName',
//           currentState.currentSong!.name ?? '',
//         );
//         await prefs.setString(
//           'lastArtistName',
//           currentState.currentSong!.artistName ?? '',
//         );
//         await prefs.setString(
//           'lastImageUrl',
//           currentState.currentSong!.image ?? '',
//         );
//         await prefs.setString(
//           'lastAudioUrl',
//           currentState.currentSong!.audio ?? '',
//         );
//         await prefs.setInt(
//           'lastDuration',
//           currentState.currentSong!.duration ?? 0,
//         );
//         await prefs.setInt('lastPosition', position);
//         await prefs.setBool('lastIsPlaying', currentState.isPlaying);

//         debugPrint(
//           'Saved current music: ${currentState.currentSong!.name} at position ${position}s',
//         );
//       } else {
//         await prefs.setBool('hasLastPlayed', false);
//       }
//     } catch (e) {
//       debugPrint("Error saving current music: $e");
//     }
//   }

//   @override
//   void dispose() {
//     // Save current music state when disposing
//     _saveCurrentMusic();
//     _miniplayerController.dispose();
//     _waveController.dispose();
//     super.dispose();
//   }

//   void _expandMiniPlayer() {
//     _miniplayerController.animateToHeight(state: PanelState.MAX);
//     setState(() {
//       _currentPanelState = PanelState.MAX;
//     });
//   }

//   void _minimizeMiniPlayer() {
//     _miniplayerController.animateToHeight(state: PanelState.MIN);
//     setState(() {
//       _currentPanelState = PanelState.MIN;
//       currentHeight = 70;
//     });
//   }

//   void _closeMiniPlayer() {
//     _minimizeMiniPlayer();
//     _saveCurrentMusic();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentMusicState = ref.watch(current_music.currentMusicProvider);

//     return WillPopScope(
//       onWillPop: () async {
//         if (_currentPanelState == PanelState.MAX) {
//           _minimizeMiniPlayer();
//           return false;
//         } else if (_currentPanelState == PanelState.MIN &&
//             currentMusicState.currentSong != null) {
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             IndexedStack(index: _currentIndex, children: _screens),
//             // Always show miniplayer if there's a current song
//             if (currentMusicState.currentSong != null)
//               Positioned(
//                 bottom: 1,
//                 left: 0,
//                 right: 0,
//                 child: _buildMiniPlayer(currentMusicState),
//               ),
//           ],
//         ),
//         bottomNavigationBar: CustomBottomBar(
//           currentIndex: _currentIndex,
//           onTap: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildMiniPlayer(current_music.CurrentMusicState musicState) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(16.r),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Color(AppColors.primaryColor).withOpacity(0.8),
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           child: Miniplayer(
//             backgroundColor: Colors.transparent,
//             controller: _miniplayerController,
//             minHeight: 80,
//             maxHeight: MediaQuery.of(context).size.height,
//             onDismissed: _closeMiniPlayer,
//             builder: (height, percentage) {
//               currentHeight = height;

//               if (height <= 80) {
//                 _currentPanelState = PanelState.MIN;
//                 return _buildCollapsedMiniPlayer(musicState);
//               } else {
//                 _currentPanelState = PanelState.MAX;
//                 return MusicPlayer(
//                   songList: musicState.playlist,
//                   initialIndex: musicState.currentIndex,
//                   onMinimize: _minimizeMiniPlayer,
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCollapsedMiniPlayer(current_music.CurrentMusicState musicState) {
//     return GestureDetector(
//       onTap: _expandMiniPlayer,
//       onVerticalDragEnd: (details) {
//         if (details.primaryVelocity! > 100) {
//           _closeMiniPlayer();
//         }
//       },
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16.r),
//         child: Stack(
//           children: [
//             // Wave background progress
//             StreamBuilder<PlaybackState>(
//               stream: audioHandler.playbackState,
//               builder: (context, snapshot) {
//                 final playbackState = snapshot.data;
//                 final position = playbackState?.updatePosition ?? Duration.zero;
//                 final mediaItem = audioHandler.mediaItem.value;
//                 final duration = mediaItem?.duration ?? Duration.zero;

//                 double progress = 0.0;
//                 if (duration.inSeconds > 0) {
//                   progress = position.inSeconds / duration.inSeconds;
//                 }

//                 return AnimatedBuilder(
//                   animation: _waveController,
//                   builder: (context, child) {
//                     return CustomPaint(
//                       size: const Size(double.infinity, 80),
//                       painter: WaveBackgroundPainter(
//                         waveValue: _waveController.value,
//                         progress: progress.clamp(0.0, 1.0),
//                         waveColor: const Color.fromARGB(
//                           255,
//                           1,
//                           40,
//                           56,
//                         ).withOpacity(0.7),
//                         backgroundColor: Colors.black38,
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               child: Row(
//                 children: [
//                   // Song thumbnail
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       musicState.currentSong!.image ?? "",
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                       errorBuilder:
//                           (_, __, ___) => const Icon(
//                             Icons.music_note,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // Song info + progress bar
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           musicState.currentSong!.name ?? "Unknown",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                         Text(
//                           musicState.currentSong!.artistName ??
//                               "Unknown Artist",
//                           style: const TextStyle(
//                             color: Colors.white70,
//                             fontSize: 12,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                         const SizedBox(height: 6),
//                         // Progress slider
//                         StreamBuilder<PlaybackState>(
//                           stream: audioHandler.playbackState,
//                           builder: (context, snapshot) {
//                             final playbackState = snapshot.data;
//                             final position =
//                                 playbackState?.updatePosition ?? Duration.zero;
//                             final mediaItem = audioHandler.mediaItem.value;
//                             final duration =
//                                 mediaItem?.duration ?? Duration.zero;

//                             return SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 trackHeight: 2,
//                                 thumbShape: const RoundSliderThumbShape(
//                                   enabledThumbRadius: 6,
//                                 ),
//                                 overlayShape: SliderComponentShape.noOverlay,
//                               ),
//                               child: Slider(
//                                 value:
//                                     duration.inSeconds > 0
//                                         ? position.inSeconds.toDouble().clamp(
//                                           0.0,
//                                           duration.inSeconds.toDouble(),
//                                         )
//                                         : 0.0,
//                                 max:
//                                     duration.inSeconds > 0
//                                         ? duration.inSeconds.toDouble()
//                                         : 1.0,
//                                 activeColor: Colors.white,
//                                 inactiveColor: Colors.white24,
//                                 onChanged: (value) {
//                                   final newPosition = Duration(
//                                     seconds: value.toInt(),
//                                   );
//                                   audioHandler.seek(newPosition);
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Control buttons
//                   StreamBuilder<PlaybackState>(
//                     stream: audioHandler.playbackState,
//                     builder: (context, snapshot) {
//                       final playbackState = snapshot.data;
//                       final isPlaying = playbackState?.playing ?? false;
//                       final processingState =
//                           playbackState?.processingState ??
//                           AudioProcessingState.idle;

//                       return Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(
//                               processingState ==
//                                           AudioProcessingState.buffering ||
//                                       processingState ==
//                                           AudioProcessingState.loading
//                                   ? Icons.hourglass_empty
//                                   : (isPlaying
//                                       ? Icons.pause_circle_filled
//                                       : Icons.play_circle_filled),
//                               size: 36,
//                               color: Colors.white,
//                             ),
//                             onPressed:
//                                 processingState ==
//                                             AudioProcessingState.buffering ||
//                                         processingState ==
//                                             AudioProcessingState.loading
//                                     ? null
//                                     : () async {
//                                       if (isPlaying) {
//                                         await audioHandler.pause();
//                                       } else {
//                                         await audioHandler.play();
//                                       }
//                                     },
//                           ),
//                           IconButton(
//                             icon: const FaIcon(
//                               FontAwesomeIcons.arrowRight,
//                               size: 24,
//                               color: Colors.white,
//                             ),
//                             onPressed: () async {
//                               await audioHandler.skipToNext();
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class WaveBackgroundPainter extends CustomPainter {
//   final double waveValue;
//   final double progress;
//   final Color waveColor;
//   final Color backgroundColor;

//   WaveBackgroundPainter({
//     required this.waveValue,
//     required this.progress,
//     required this.waveColor,
//     required this.backgroundColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final width = size.width;
//     final height = size.height;

//     // Background
//     final bgPaint = Paint()..color = backgroundColor;
//     canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

//     final wavePaint =
//         Paint()
//           ..color = waveColor
//           ..style = PaintingStyle.fill;

//     final path = Path();
//     final waveHeight = 6.0;

//     // Vertical progress (bottom → top)
//     final progressHeight = height * progress;
//     final baseLine = height - progressHeight;

//     // Start from bottom-left
//     path.moveTo(0, height);

//     // Draw sine wave across the width at the "fill level"
//     for (double x = 0; x <= width; x++) {
//       final y = baseLine - sin((x / 45) + waveValue * 2 * pi) * waveHeight;
//       path.lineTo(x, y);
//     }

//     // Close shape down to bottom-right and bottom-left
//     path.lineTo(width, height);
//     path.lineTo(0, height);
//     path.close();

//     canvas.drawPath(path, wavePaint);
//   }

//   @override
//   bool shouldRepaint(covariant WaveBackgroundPainter oldDelegate) {
//     return oldDelegate.waveValue != waveValue ||
//         oldDelegate.progress != progress ||
//         oldDelegate.waveColor != waveColor ||
//         oldDelegate.backgroundColor != backgroundColor;
//   }
// }

// Future<void> disposeAllMusicPlayers(WidgetRef ref) async {
//   try {
//     await audioHandler.stop();
//     ref.read(current_music.currentMusicProvider.notifier).stop();
//   } catch (e) {
//     debugPrint("Error disposing all music players: $e");
//   }
// }
