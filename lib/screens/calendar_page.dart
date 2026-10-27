import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../theme.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'course_detail_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const _dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static const _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    _selected = DateTime(n.year, n.month, n.day);
  }

  DateTime get _weekStart =>
      _selected.subtract(Duration(days: _selected.weekday - 1));

  bool _same(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _shiftWeek(int dir) =>
      setState(() => _selected = _selected.add(Duration(days: 7 * dir)));

  void _open(Course c) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CourseDetailPage(course: c)),
  );

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CourseProvider>();

    if (p.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (p.error != null) {
      return ErrorView(message: p.error!, onRetry: p.loadCourses);
    }

    final tasks =
        p.courses
            .where((c) => c.deadline != null && _same(c.deadline!, _selected))
            .toList()
          ..sort((a, b) => a.deadline!.compareTo(b.deadline!));

    bool hasTask(DateTime d) =>
        p.courses.any((c) => c.deadline != null && _same(c.deadline!, d));

    final days = List.generate(7, (i) => _weekStart.add(Duration(days: i)));

    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${_monthNames[_selected.month - 1]} ${_selected.year}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _shiftWeek(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                onPressed: () => _shiftWeek(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: days.map((d) {
              final selected = _same(d, _selected);
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => setState(() => _selected = d),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _dayNames[d.weekday - 1],
                          style: TextStyle(
                            fontSize: 11,
                            color: selected ? AppColors.blue : AppColors.ice,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${d.day}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: selected ? AppColors.navy : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasTask(d)
                                ? (selected ? AppColors.cyan : AppColors.sky)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            'Tugas tanggal ${_selected.day} ${_monthNames[_selected.month - 1]}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
        ),
        if (tasks.isEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text('Tidak ada deadline pada tanggal ini.'),
          )
        else
          ...tasks.map((c) => CourseCard(course: c, onTap: () => _open(c))),
      ],
    );
  }
}
