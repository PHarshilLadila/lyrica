// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 0, 33, 43),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: _buildIcon(context, CupertinoIcons.home, 0),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(context, CupertinoIcons.search, 1),
          label: AppLocalizations.of(context)!.explore,
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(context, CupertinoIcons.book, 2),
          label: AppLocalizations.of(context)!.library,
        ),
      ],
    );
  }

  Widget _buildIcon(BuildContext context, IconData icon, int index) {
    bool isSelected = currentIndex == index;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        gradient:
            isSelected
                ? RadialGradient(colors: [Colors.white, Colors.transparent])
                : null,
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: Color(AppColors.secondaryColor).withOpacity(0.5),
                    blurRadius: 28,
                    spreadRadius: 1,
                    offset: Offset(0, 5.h),
                  ),
                ]
                : [],
      ),
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isSelected ? 30 : 25,
            color: isSelected ? Colors.white70 : Colors.white54,
          ),
          SizedBox(height: 3.h),
          AppText(
            text:
                index == 0
                    ? AppLocalizations.of(context)!.home
                    : index == 1
                    ? AppLocalizations.of(context)!.explore
                    : AppLocalizations.of(context)!.library,
            textColor: isSelected ? Colors.white70 : Colors.white54,
            fontSize: isSelected ? 16 : 12,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
