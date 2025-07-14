// // ignore_for_file: deprecated_member_use

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lyrica/core/constant/app_colors.dart';

// class CustomBottomBar extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   const CustomBottomBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       backgroundColor: const Color.fromARGB(255, 1, 29, 29),
//       type: BottomNavigationBarType.fixed,
//       elevation: 1,
//       selectedItemColor: Colors.white,
//       unselectedItemColor: Colors.white60,
//       showSelectedLabels: false,
//       unselectedLabelStyle: GoogleFonts.poppins(
//         color: Color(AppColors.lightText),
//       ),
//       selectedLabelStyle: GoogleFonts.poppins(
//         color: Color(AppColors.lightText),
//       ),
//       showUnselectedLabels: false,
//       currentIndex: currentIndex,
//       onTap: onTap,
//       items: [
//         BottomNavigationBarItem(
//           icon: _buildIcon(CupertinoIcons.home, 0),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: _buildIcon(CupertinoIcons.search, 1),
//           label: 'Explore',
//         ),
//         BottomNavigationBarItem(
//           icon: _buildIcon(CupertinoIcons.book, 2),
//           label: 'Library',
//         ),
//       ],
//     );
//   }

//   Widget _buildIcon(IconData icon, int index) {
//     bool isSelected = currentIndex == index;

// ignore_for_file: deprecated_member_use

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         shape: BoxShape.circle,
//         gradient:
//             isSelected
//                 ? RadialGradient(
//                   colors: [Colors.white.withOpacity(0.9), Colors.transparent],
//                 )
//                 : null,
//         boxShadow:
//             isSelected
//                 ? [
//                   BoxShadow(
//                     color: Color(AppColors.secondaryColor).withOpacity(0.7),
//                     blurRadius: 25,
//                     spreadRadius: 7,
//                     offset: Offset(0, 5),
//                   ),
//                 ]
//                 : [],
//       ),
//       padding: EdgeInsets.all(10),
//       child: Icon(
//         icon,
//         size: isSelected ? 30 : 25,
//         color: isSelected ? Colors.white70 : Colors.white54,
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lyrica/common/widget/app_text.dart';
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
                ? RadialGradient(colors: [Colors.white, Colors.transparent])
                : null,
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: Color(AppColors.secondaryColor).withOpacity(0.5),
                    blurRadius: 25,
                    spreadRadius: 8,
                    offset: const Offset(0, 0),
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
          SizedBox(height: 4),
          AppText(
            textName:
                index == 0
                    ? 'Home'
                    : index == 1
                    ? 'Explore'
                    : 'Library',
            textColor: isSelected ? Colors.white70 : Colors.white54,
            fontSize: isSelected ? 16 : 12,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
