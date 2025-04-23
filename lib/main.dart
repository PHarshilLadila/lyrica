import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userUid = "";
Future<void> getUserid() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final result = preferences.getString("userUID");
  userUid = result;
}

// MyAudioHandler audioHandler = MyAudioHandler();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // audioHandler = await AudioService.init(
  //   builder: () => MyAudioHandler(),
  //   config: AudioServiceConfig(
  //     androidNotificationChannelId: 'com.example.lyrica',
  //     androidNotificationChannelName: "Lyrica",
  //     androidNotificationOngoing: true,
  //   ),
  // );
  await dotenv.load(fileName: ".env");
  getUserid();
  runApp(ProviderScope(child: const MyApp()));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
        // final user = ref.watch(authStateProvider);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          ),
          // ignore: unnecessary_null_comparison
          home: userUid != null ? BottomSheetScreen() : GoogleLoginScreen(),
        );
      },
    );
  }
}
