import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getUserid();
  runApp(ProviderScope(child: const MyApp()));
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

// https://api.jamendo.com/v3.0/tracks/?client_id=540fd4db&format=json&limit=200

// firebase firestore permission rules
//       allow read, write: if request.time < timestamp.date(2025, 5, 18);
