import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyrica/modules/bottom%20sheet/widget/custom_bottombar.dart';
import 'package:lyrica/modules/home/view/home_screen.dart';
import 'package:lyrica/modules/library/view/library_screen.dart';
import 'package:lyrica/modules/search%20items/view/search_screen.dart';

class BottomSheetScreen extends ConsumerStatefulWidget {
  const BottomSheetScreen({super.key});

  @override
  ConsumerState<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends ConsumerState<BottomSheetScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
