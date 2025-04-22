import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, NavigationState>(
      (ref) => NavigationNotifier(),
    );

class NavigationState {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationState({required this.navigatorKey});
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier()
    : super(NavigationState(navigatorKey: GlobalKey<NavigatorState>()));

  void navigateTo(Widget page) {
    state.navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void goBack() {
    state.navigatorKey.currentState?.pop();
  }
}
