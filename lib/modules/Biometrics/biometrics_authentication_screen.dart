import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lyrica/modules/auth/view/google_login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class BiometricsAuthenticationScreen extends StatefulWidget {
  const BiometricsAuthenticationScreen({super.key});

  @override
  State<BiometricsAuthenticationScreen> createState() =>
      _BiometricsAuthenticationScreenState();
}

class _BiometricsAuthenticationScreenState
    extends State<BiometricsAuthenticationScreen>
    with SingleTickerProviderStateMixin {
  bool canAuthenticate = false;
  bool didAuthenticate = false;
  bool isAuthenticating = false;
  String statusText = "Checking biometrics...";
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);
    authenticate();
  }

  Future<void> authenticate() async {
    setState(() {
      isAuthenticating = true;
      statusText = "Checking biometrics...";
    });
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        setState(() {
          statusText = "Biometrics not available on this device.";
          isAuthenticating = false;
        });
        return;
      }

      setState(() {
        statusText = "Touch the fingerprint sensor";
      });

      didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      setState(() {
        isAuthenticating = false;
        statusText =
            didAuthenticate
                ? "Authentication successful!"
                : "Authentication failed. Try again.";
      });

      if (didAuthenticate && mounted) {
        await Future.delayed(const Duration(milliseconds: 600));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const GoogleLoginScreen()),
          (route) => false,
        );
      }
    } on PlatformException catch (e) {
      setState(() {
        statusText = "Error: ${e.message}";
        isAuthenticating = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFingerprintIcon() {
    return ScaleTransition(
      scale: _controller,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF1CB5E0), Color(0xFF000046)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.25),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: EdgeInsets.all(32),
        child: Icon(Icons.fingerprint, size: 80, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1CB5E0), Color(0xFF000046)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFingerprintIcon(),
                  const SizedBox(height: 40),
                  Text(
                    "Biometric Authentication",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    statusText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (!isAuthenticating &&
                      (!didAuthenticate || !canAuthenticate))
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1CB5E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                      onPressed: authenticate,
                      icon: const Icon(
                        CupertinoIcons.refresh,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Retry",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
