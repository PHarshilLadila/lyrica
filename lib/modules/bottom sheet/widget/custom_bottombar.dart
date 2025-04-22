// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyrica/core/constant/app_colors.dart';

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
      backgroundColor: Colors.transparent,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      showSelectedLabels: false,
      unselectedLabelStyle: GoogleFonts.poppins(
        color: Color(AppColors.lightText),
      ),
      selectedLabelStyle: GoogleFonts.poppins(
        color: Color(AppColors.lightText),
      ),
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: _buildIcon(CupertinoIcons.home, 0),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(CupertinoIcons.search, 1),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(CupertinoIcons.book, 2),
          label: 'Library',
        ),
      ],
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    bool isSelected = currentIndex == index;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        gradient:
            isSelected
                ? RadialGradient(
                  colors: [Colors.white.withOpacity(0.9), Colors.transparent],
                )
                : null,
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: Color(AppColors.secondaryColor).withOpacity(0.7),
                    blurRadius: 25,
                    spreadRadius: 7,
                    offset: Offset(0, 5),
                  ),
                ]
                : [],
      ),
      padding: EdgeInsets.all(10),
      child: Icon(
        icon,
        size: isSelected ? 30 : 25,
        color: isSelected ? Colors.white70 : Colors.white54,
      ),
    );
  }
}
