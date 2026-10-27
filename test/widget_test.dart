import 'package:flutter_test/flutter_test.dart';
import 'package:mytugas/models/course.dart';
import 'package:mytugas/models/quote.dart';

void main() {
  group('Course', () {
    test('fromJson dan toJson', () {
      final c = Course.fromJson({
        'id': 1,
        'code': 'MOB01',
        'title': 'Laporan Praktikum',
        'credits': 4,
        'status': 'active',
        'deadline': '2026-11-01T10:00:00Z',
      });

      expect(c.id, 1);
      expect(c.code, 'MOB01');
      expect(c.credits, 4);
      expect(c.deadline, isNotNull);
      expect(c.toJson()['status'], 'active');
    });

    test('nilai kosong memakai default', () {
      final c = Course.fromJson({'code': 'X', 'title': 'Y'});
      expect(c.credits, 1);
      expect(c.status, 'planned');
      expect(c.deadline, isNull);
    });
  });

  group('Quote', () {
    test('fromJson', () {
      final q = Quote.fromJson({'id': 7, 'quote': 'Halo', 'author': 'Aku'});
      expect(q.id, 7);
      expect(q.text, 'Halo');
      expect(q.author, 'Aku');
    });
  });
}
