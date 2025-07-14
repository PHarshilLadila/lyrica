import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';

class BiometricsAuthenticationScreen extends StatefulWidget {
  const BiometricsAuthenticationScreen({super.key});

  @override
  State<BiometricsAuthenticationScreen> createState() =>
      _BiometricsAuthenticationScreenState();
}

class _BiometricsAuthenticationScreenState
    extends State<BiometricsAuthenticationScreen> {
  bool canAuthenticate = false;
  bool didAuthenticate = false;

  @override
  void initState() {
    authenticate();
    super.initState();
  }

  authenticate() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;

      canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        return;
      }
      setState(() {
        canAuthenticate = canAuthenticate;
      });
      didAuthenticate = await auth.authenticate(
        localizedReason: 'please to Goto next screen',
        options: AuthenticationOptions(biometricOnly: true),
      );
      setState(() {});
      if (didAuthenticate) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const GoogleLoginScreen()),
          (route) => false,
        );
      }
    } on PlatformException catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            !canAuthenticate
                ? "Biomatrics not available"
                : didAuthenticate
                ? "Authenticated "
                : "Please authenticate with biometrics",
          ),
        ],
      ),
    );
  }
}
