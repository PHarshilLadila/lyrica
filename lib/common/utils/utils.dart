// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/core/constant/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

Widget appLoader() {
  return Container(
    color: Colors.transparent,
    // color: color ??Colors.transparent?? Colors.black.withOpacity(0.6),
    child: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        size: 50,
        color: Color(AppColors.primaryColor),
      ),
    ),
  );
}

LinearGradient backgroundGradient() {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 9, 226, 255), // Light blue
      Color.fromARGB(255, 9, 193, 218), // Slightly darker blue

      Color.fromARGB(255, 14, 128, 145), // Darker teal
      Color.fromARGB(255, 16, 102, 115), // Dark teal
      Color(0xff0E0E0E), // Very dark
    ],
    stops: [0.0, 0.1, 0.2, 0.3, 0.5],
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar(
  BuildContext context,
  String message,
  Color bgColor,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 30,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(10),
      backgroundColor: bgColor,
      content: AppText(text: message, fontWeight: FontWeight.bold, maxLines: 3),
    ),
  );
}

void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(child: appLoader()),
  );
}

void hideLoader(BuildContext context) {
  Navigator.of(context).pop();
}

void showAppSnackBar(BuildContext context, String msg, Color bgColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 30,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(10.sp),
      content: AppText(text: msg, maxLines: 3),
      backgroundColor: bgColor,
    ),
  );
}

void myPushNavigator(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

class ScrollAwareScaffold extends StatefulWidget {
  final String title;
  final Widget body;

  const ScrollAwareScaffold({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  State<ScrollAwareScaffold> createState() => _ScrollAwareScaffoldState();
}

class _ScrollAwareScaffoldState extends State<ScrollAwareScaffold> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 10 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 10 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: widget.title, maxLines: 2),
        backgroundColor: _isScrolled ? Colors.black : Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: widget.body,
      ),
    );
  }
}

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await Permission.notification.status;

    if (androidInfo.isDenied || androidInfo.isPermanentlyDenied) {
      final result = await Permission.notification.request();

      if (result.isGranted) {
        debugPrint('Notification permission granted on Android');
      } else if (result.isPermanentlyDenied) {
        debugPrint('Notification permission permanently denied on Android');
        await openAppSettings();
      } else {
        debugPrint('Notification permission denied on Android');
      }
    }
  } else if (Platform.isIOS) {
    final result = await Permission.notification.request();

    if (result.isGranted) {
      debugPrint('Notification permission granted on iOS');
    } else if (result.isPermanentlyDenied) {
      debugPrint('Notification permission permanently denied on iOS');
      await openAppSettings();
    } else {
      debugPrint('Notification permission denied on iOS');
    }
  }
}
