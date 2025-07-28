// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/modules/albums/album%20tracks/album_tracks_provider.dart';
import 'package:lyrica/modules/albums/albums_provider.dart';
import 'package:lyrica/modules/music%20player/provider/music_player_provider.dart';
import 'package:lyrica/services/mongodb_service.dart';
import 'package:provider/provider.dart' as provider;
import 'package:lyrica/l10n/locale_provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? userUid;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  await MongoDatabaseService.connect();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
        ],
        child: MyApp(),
      ),
    ),
  );
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
          title: 'Flutter Demo',
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            useMaterial3: false,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          ),
          home:
              // userUid != null
              //     ? BottomSheetScreen(key: bottomNavKey)
              //     : const BiometricsAuthenticationScreen(),
              userUid != null ? BottomSheetScreen() : const GoogleLoginScreen(),
        );
      },
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // No glow effect
  }
}
