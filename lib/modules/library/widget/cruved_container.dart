import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(const MaterialApp(home: CurveContainer()));

class CurveContainer extends StatelessWidget {
  const CurveContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background with curved top container
          ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              height: 200,
              color: const Color(0xFF5E1B5E), // Purple background
            ),
          ),

          // Mic Button
          Positioned(
            bottom: 0,
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFE37CC5), // Pink circle
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                FontAwesomeIcons.microphone,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomClipper for concave curve
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start top-left
    path.lineTo(0, size.height - 40);

    // Curve down and up again
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 40, // control point
      size.width,
      size.height - 40, // end point
    );

    // Complete shape
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
