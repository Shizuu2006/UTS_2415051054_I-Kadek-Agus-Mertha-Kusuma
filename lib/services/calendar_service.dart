import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/foundation.dart';

import '../models/course.dart';

class CalendarService {
  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Membuka layar tambah event bawaan kalender device.
  Future<bool> sync(Course c) async {
    if (!_supported || c.deadline == null) return false;

    final event = Event(
      title: '[TugasKu] ${c.code} - ${c.title}',
      description: 'Prioritas ${c.credits}/5 • Status: ${c.status}',
      startDate: c.deadline!.subtract(const Duration(hours: 1)),
      endDate: c.deadline!,
      iosParams: const IOSParams(reminder: Duration(days: 1)),
      androidParams: const AndroidParams(),
    );
    return Add2Calendar.addEvent2Cal(event);
  }

  /// Event kalender tidak bisa dihapus otomatis dengan pendekatan ini.
  Future<void> remove(int courseId) async {}
}
