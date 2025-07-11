// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:lyrica/modules/auth/instagram/instagram_login.dart';
// import 'package:lyrica/modules/auth/view/google_login_screen.dart';
// import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// String? userUid = "";
// Future<void> getUserid() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   final result = preferences.getString("userUID");
//   userUid = result;
// }

// // MyAudioHandler audioHandler = MyAudioHandler();
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   MobileAds.instance.initialize();
//   try {
//     await Firebase.initializeApp();
//   } catch (e, s) {
//     debugPrint("Firebase init error: $e\n$s");
//   }

//   // MobileAds.instance.updateRequestConfiguration(
//   //   RequestConfiguration(testDeviceIds: ['B41DC894DFE5C61603E677AE10B23567']),
//   // );
//   // audioHandler = await AudioService.init(
//   //   builder: () => MyAudioHandler(),
//   //   config: AudioServiceConfig(
//   //     androidNotificationChannelId: 'com.example.lyrica',
//   //     androidNotificationChannelName: "Lyrica",
//   //     androidNotificationOngoing: true,
//   //   ),
//   // );
//   await dotenv.load(fileName: ".env");
//   getUserid();
//   runApp(ProviderScope(child: const MyApp()));
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
//         // final user = ref.watch(authStateProvider);

//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Flutter Demo',
//           theme: ThemeData(
//             useMaterial3: false,
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
//           ),
//           // ignore: unnecessary_null_comparison
//           home:
//               //InstagramView(),
//               userUid != null
//                   ? BottomSheetScreen(key: bottomNavKey)
//                   : GoogleLoginScreen(),
//         );
//       },
//     );
//   }
// }

// // https://api.jamendo.com/v3.0/albums?client_id=540fd4db&format=json&limit=200
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userUid;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await MobileAds.instance.initialize();

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
              userUid != null
                  ? BottomSheetScreen(key: bottomNavKey)
                  : const GoogleLoginScreen(),
        );
      },
    );
  }
}
