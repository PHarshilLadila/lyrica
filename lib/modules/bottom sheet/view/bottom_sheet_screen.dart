// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
// import 'package:lyrica/modules/home/view/home_screen.dart';
// import 'package:lyrica/modules/library/view/library_screen.dart';
// import 'package:lyrica/modules/search%20items/view/search_screen.dart';

// class BottomSheetScreen extends ConsumerStatefulWidget {
//   const BottomSheetScreen({super.key});

//   @override
//   ConsumerState<BottomSheetScreen> createState() => _BottomSheetScreenState();
// }

// // class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen> {
// //   int _currentIndex = 0;

// //   final List<Widget> _screens = [
// //     HomeScreen(),
// //     const SearchScreen(),
// //     LibraryScreen(),
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: _screens[_currentIndex],
// //       bottomNavigationBar: CustomBottomBar(
// //         currentIndex: _currentIndex,
// //         onTap: (index) {
// //           setState(() {
// //             _currentIndex = index;
// //           });
// //         },
// //       ),
// //     );
// //   }
// // }
// class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     HomeScreen(),
//     const SearchScreen(),
//     LibraryScreen(),
//   ];

// ignore_for_file: library_private_types_in_public_api

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(index: _currentIndex, children: _screens),
//       bottomNavigationBar: CustomBottomBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
import 'package:lyrica/modules/home/view/home_screen.dart';
import 'package:lyrica/modules/search%20items/view/search_screen.dart';
import 'package:lyrica/modules/library/view/library_screen.dart';

final GlobalKey<_BottomSheetScreenState> bottomNavKey = GlobalKey();

class BottomSheetScreen extends ConsumerStatefulWidget {
  const BottomSheetScreen({super.key});

  @override
  ConsumerState<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen> {
  int _currentIndex = 0;

  void setTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = const [
    HomeScreen("", ""),
    SearchScreen(false),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
