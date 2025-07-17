// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:lyrica/modules/auth/view/google_login_screen.dart';
// import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// String? userUid;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await dotenv.load(fileName: ".env");
//   await MobileAds.instance.initialize();
//   debugDisableShadows = true;
//   debugDisableClipLayers = true;

//   try {
//     await Firebase.initializeApp();
//   } catch (e, s) {
//     debugPrint("Firebase init error: $e\n$s");
//   }

//   userUid = await _getUserIdFromPrefs();

//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

//   runApp(const ProviderScope(child: MyApp()));
// }

// Future<String?> _getUserIdFromPrefs() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString("userUID");
// }

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Flutter Demo',
//           theme: ThemeData(
//             textTheme: GoogleFonts.poppinsTextTheme(
//               Theme.of(context).textTheme,
//             ),
//           ),
//           home:
//               userUid != null
//                   ? BottomSheetScreen(key: bottomNavKey)
//                   : const GoogleLoginScreen(),
//         );
//       },
//     );
//   }
// }

// // // https://api.jamendo.com/v3.0/albums?client_id=540fd4db&format=json&limit=200
// // https://api.jamendo.com/v3.0/albums?client_id=540fd4db&format=json&limit=200

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lyrica/common/utils/utils.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: MyApp()));
}

Future<String?> _getUserIdFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("userUID");
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
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
