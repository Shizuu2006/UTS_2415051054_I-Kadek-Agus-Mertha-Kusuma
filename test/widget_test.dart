import 'package:flutter_test/flutter_test.dart';
import 'package:mytugas/models/course.dart';
import 'package:mytugas/theme.dart';

void main() {
  test('Course fromJson dan toJson', () {
    final c = Course.fromJson({
      'id': 1,
      'title': 'Pemrograman Mobile',
      'title2': 'Laporan Praktikum',
      'credits': 4,
      'status': 'Belum Selesai',
    });

    expect(c.title, 'Pemrograman Mobile');
    expect(c.credits, 4);
    expect(c.toJson()['credits'], 4);
    expect(c.toJson()['status'], 'planned');
  });

  test('Course normalizes status values for display and updates', () {
    expect(Course.fromJson({'status': 'BELUM SELESAI'}).status, 'planned');
    expect(Course.fromJson({'status': ' PROSES '}).status, 'active');
    expect(Course.fromJson({'status': 'SELESAI'}).status, 'done');
    expect(statusLabel('planned'), 'Belum Selesai');
    expect(statusLabel('active'), 'Proses');
    expect(statusLabel('done'), 'Selesai');
  });
}
