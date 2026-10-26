import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';
import '../services/calendar_service.dart';
import '../services/notification_service.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository _repo;
  final NotificationService? _notif;
  final CalendarService? _cal;
  CourseProvider(this._repo, [this._notif, this._cal]);

  List<Course> courses = [];
  bool isLoading = false;
  bool isSaving = false;
  String? error;
  String? notice; // pesan tambahan setelah simpan (mis. izin ditolak)

  bool get isEmpty => !isLoading && error == null && courses.isEmpty;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      courses = await _repo.getCourses();
      for (final c in courses) {
        try {
          await _notif?.schedule(c);
        } catch (e) {
          debugPrint('Gagal jadwalkan notifikasi: $e');
        }
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> _afterSave(Course c, bool addToCalendar) async {
    if (c.deadline == null) return;
    try {
      final notifOk = await _notif?.requestPermission() ?? false;
      await _notif?.schedule(c);
      final msgs = <String>[];
      if (!notifOk) msgs.add('izin notifikasi belum diberikan');

      if (addToCalendar && _cal != null) {
        final calOk = await _cal.sync(c);
        if (!calOk) {
          msgs.add('tugas belum masuk kalender (izin ditolak/tidak tersedia)');
        }
      }
      if (msgs.isNotEmpty) notice = 'Tersimpan, tetapi ${msgs.join(' dan ')}.';
    } catch (e) {
      debugPrint('Reminder error: $e');
    }
  }

  Future<bool> createCourse(Course c, {bool addToCalendar = false}) async {
    if (isSaving) return false;
    isSaving = true;
    notice = null;
    notifyListeners();
    try {
      final created = await _repo.createCourse(c);
      await _afterSave(c.copyWith(id: created.id), addToCalendar);
      await loadCourses();
      return true;
    } catch (e) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateCourse(
    int id,
    Course c, {
    bool addToCalendar = false,
  }) async {
    if (isSaving) return false;
    isSaving = true;
    notice = null;
    notifyListeners();
    try {
      await _repo.updateCourse(id, c);
      await _afterSave(c.copyWith(id: id), addToCalendar);
      await loadCourses();
      return true;
    } catch (e) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCourse(int id) async {
    if (isSaving) return false;
    isSaving = true;
    notice = null;
    notifyListeners();
    try {
      await _repo.deleteCourse(id);
      await _notif?.cancel(id);
      await _cal?.remove(id);
      await loadCourses();
      return true;
    } catch (e) {
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
