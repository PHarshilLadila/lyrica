// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lyrica/core/providers/auth_provider.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:lyrica/modules/auth/view/login_screen.dart';
import 'package:lyrica/modules/bottom%20sheet/view/bottom_sheet_screen.dart';
 import 'package:lyrica/modules/splash/view/splash_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return BottomSheetScreen();
        } else {
          return const GoogleLoginScreen();
        }
      },
      error: (e, trace) => LoginScreen(),
      loading: () => SplashScreen(),
    );
  }
}
