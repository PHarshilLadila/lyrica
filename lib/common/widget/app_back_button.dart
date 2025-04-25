import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyrica/core/constant/app_colors.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(106, 29, 178, 183),
                Color.fromARGB(106, 29, 178, 183),
                Color.fromARGB(106, 23, 106, 109),
              ],
            ),
            border: Border.all(color: Colors.white54, width: 0.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: Color(AppColors.whiteBackground),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
