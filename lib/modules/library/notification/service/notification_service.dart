import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MusicNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String _currentTimeZone = 'UTC';
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    await _detectTimezone();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Notification tapped: ${response.payload}');
      },
    );

    _initialized = true;
  }

  Future<void> _detectTimezone() async {
    try {
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      _currentTimeZone = _offsetToTimezone(offset);
      tz.setLocalLocation(tz.getLocation(_currentTimeZone));
    } catch (e) {
      debugPrint('Timezone error: $e');
      _currentTimeZone = 'UTC';
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  String _offsetToTimezone(Duration offset) {
    final hours = offset.inHours;
    final minutes = offset.inMinutes % 60;
    if (hours == 5 && minutes == 30) return 'Asia/Kolkata';
    return 'UTC';
  }

  Future<void> scheduleDailyNotification(
    TimeOfDay time,
    String period,
    int id,
  ) async {
    if (!_initialized) await init();

    final location = tz.getLocation(_currentTimeZone);
    final now = tz.TZDateTime.now(location);

    var scheduled = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      "Ready to Vibe? 🎵",
      "Hey! Your $period playlist misses you 💜",
      scheduled,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    if (!_initialized) await init();
    await _notificationsPlugin.cancelAll();
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'music_notification_channel',
        'Music Notifications',
        channelDescription: 'Channel for daily music reminders',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }
}
