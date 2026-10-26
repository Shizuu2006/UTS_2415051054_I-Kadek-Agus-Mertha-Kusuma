import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/course.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const reminderDays = [3, 2, 1];

  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> init() async {
    if (!_supported) return;
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings);
    _ready = true;
  }

  Future<bool> requestPermission() async {
    if (!_ready) return false;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
  }

  Future<void> schedule(Course c) async {
    if (!_ready || c.id == null) return;
    await cancel(c.id!);
    if (c.deadline == null || c.status == 'done') return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'deadline_channel',
        'Pengingat Deadline',
        channelDescription: 'Pengingat tugas yang deadline-nya dekat',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    for (final d in reminderDays) {
      final when = c.deadline!.subtract(Duration(days: d));
      if (when.isBefore(DateTime.now())) continue;
      await _plugin.zonedSchedule(
        c.id! * 10 + d,
        'Deadline tinggal $d hari lagi',
        '${c.code} - ${c.title}',
        tz.TZDateTime.from(when, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancel(int courseId) async {
    if (!_ready) return;
    for (final d in reminderDays) {
      await _plugin.cancel(courseId * 10 + d);
    }
  }
}
