import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../theme.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import '../widgets/highlight_card.dart';
import 'course_detail_page.dart';

class CourseListPage extends StatelessWidget {
  final String? filterStatus;
  final String query;
  const CourseListPage({super.key, this.filterStatus, this.query = ''});

  void _open(BuildContext context, course) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
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

    final q = query.trim().toLowerCase();
    final items = p.courses.where((c) {
      final okStatus = filterStatus == null || c.status == filterStatus;
      final okQuery =
          q.isEmpty ||
          c.title.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q);
      return okStatus && okQuery;
    }).toList();

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.assignment_turned_in_outlined,
              size: 64,
              color: AppColors.sky,
            ),
            const SizedBox(height: 12),
            const Text(
              'Belum ada tugas.',
              style: TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text('Tekan tombol + untuk menambah.'),
          ],
        ),
      );
    }

    final highlights = p.courses.where((c) => c.status != 'done').toList()
      ..sort((a, b) => b.credits.compareTo(a.credits));
    final showHighlights =
        filterStatus == null && q.isEmpty && highlights.isNotEmpty;

    return RefreshIndicator(
      onRefresh: p.loadCourses,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          if (showHighlights) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 10),
              child: Text(
                'Prioritas Utama',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: highlights
                    .take(5)
                    .map(
                      (c) => HighlightCard(
                        course: c,
                        onTap: () => _open(context, c),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              filterStatus == null
                  ? 'Semua Tugas (${items.length})'
                  : '${statusLabel(filterStatus!)} (${items.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
          ),
          ...items.map(
            (c) => CourseCard(course: c, onTap: () => _open(context, c)),
          ),
        ],
      ),
    );
  }
}
