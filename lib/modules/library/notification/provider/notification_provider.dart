import 'package:flutter/material.dart';
import 'package:lyrica/modules/library/notification/service/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MusicNotificationProvider with ChangeNotifier {
  final MusicNotificationService _notificationService =
      MusicNotificationService();
  bool _notificationsEnabled = false;

  final Map<String, TimeOfDay> _reminderTimes = {
    'morning': TimeOfDay(hour: 8, minute: 0),
    'afternoon': TimeOfDay(hour: 11, minute: 0),
    'evening': TimeOfDay(hour: 18, minute: 0),
    'night': TimeOfDay(hour: 22, minute: 0),
    'midnight': TimeOfDay(hour: 3, minute: 0),
  };

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    await _notificationService.init();

    if (_notificationsEnabled) {
      for (final period in _reminderTimes.keys) {
        await _scheduleNotification(period);
      }
    }

    notifyListeners();
  }

  Future<void> _scheduleNotification(String period) async {
    final time = _reminderTimes[period]!;
    final id = _getNotificationId(period);
    await _notificationService.scheduleDailyNotification(time, period, id);
  }

  int _getNotificationId(String period) {
    switch (period) {
      case 'morning':
        return 1;
      case 'afternoon':
        return 2;
      case 'evening':
        return 3;
      case 'night':
        return 4;
      case 'midnight':
        return 5;
      default:
        return 0;
    }
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value) {
      final hasPermission = await _checkAndRequestNotificationPermission();
      if (!hasPermission) {
        _notificationsEnabled = false;
        notifyListeners();
        return;
      }

      for (final period in _reminderTimes.keys) {
        await _scheduleNotification(period);
      }
    } else {
      await _notificationService.cancelAllNotifications();
    }

    _notificationsEnabled = value;
    await prefs.setBool('notifications_enabled', value);
    notifyListeners();
  }

  Future<bool> _checkAndRequestNotificationPermission() async {
    try {
      if (await Permission.notification.isGranted) return true;
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('Permission error: $e');
      return false;
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }
}
