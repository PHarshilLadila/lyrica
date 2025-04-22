import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String? textName;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWidth;

  const AppText({
    super.key,
    this.textName,
    this.textColor,
    this.fontSize,
    this.fontWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textName ?? "",
      style: GoogleFonts.poppins(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWidth,
      ),
    );
  }
}
