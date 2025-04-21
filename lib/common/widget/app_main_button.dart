import 'package:flutter/material.dart';
 import 'package:lyrica/core/constant/app_colors.dart';

class AppMainButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const AppMainButton({
    super.key,
    required this.onPressed,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    required this.gradient,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(gradient: gradient, borderRadius: borderRadius),
      child: ElevatedButton(
        onPressed: onPressed,
        style:
            style ??
            ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(
                Colors.transparent,
              ),
              shadowColor: WidgetStatePropertyAll<Color>(Colors.transparent),
              shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: borderRadius,
                  side: BorderSide(
                    width: 0.5,
                    color: Color(AppColors.whiteBackground),
                  ),
                ),
              ),
            ),
        child: child,
      ),
    );
  }
}
