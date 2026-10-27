import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../theme.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'course_detail_page.dart';

class CourseListPage extends StatelessWidget {
  final String? filterStatus;
  final String query;
  const CourseListPage({super.key, this.filterStatus, this.query = ''});

  void _open(BuildContext context, Course course) => Navigator.push(
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
            Text(
              p.courses.isEmpty ? 'Belum ada tugas.' : 'Tidak ada hasil.',
              style: const TextStyle(
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

    return RefreshIndicator(
      onRefresh: p.loadCourses,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final columns = w >= 1100 ? 3 : (w >= 640 ? 2 : 1);

          if (columns == 1) {
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              itemCount: items.length,
              itemBuilder: (_, i) => CourseCard(
                course: items[i],
                onTap: () => _open(context, items[i]),
              ),
            );
          }

          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: 112,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => CourseCard(
              course: items[i],
              onTap: () => _open(context, items[i]),
            ),
          );
        },
      ),
    );
  }
}
