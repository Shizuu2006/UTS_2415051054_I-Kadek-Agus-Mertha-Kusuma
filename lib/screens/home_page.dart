import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../theme.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import '../widgets/highlight_card.dart';
import '../widgets/quote_section.dart';
import 'course_detail_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onSeeAll;
  const HomePage({super.key, required this.onSeeAll});

  void _open(BuildContext context, Course c) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CourseDetailPage(course: c)),
  );

  Widget _title(String text, {Widget? trailing}) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
        ),
        ?trailing,
      ],
    ),
  );

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Halo,',
                style: TextStyle(fontSize: 14, color: AppColors.blue),
              ),
              const Text(
                studentName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              Text(
                'NIM $studentNim • TugasKu',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.navy.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.ice,
          child: Icon(Icons.person, color: AppColors.blue),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CourseProvider>();

    final children = <Widget>[_header(), const QuoteSection()];

    if (p.isLoading) {
      children.add(
        const Padding(
          padding: EdgeInsets.all(48),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    } else if (p.error != null) {
      children.add(
        SizedBox(
          height: 300,
          child: ErrorView(message: p.error!, onRetry: p.loadCourses),
        ),
      );
    } else if (p.courses.isEmpty) {
      children.add(
        const Padding(
          padding: EdgeInsets.all(48),
          child: Center(
            child: Text('Belum ada tugas. Tekan + untuk menambah.'),
          ),
        ),
      );
    } else {
      final total = p.courses.length;
      final active = p.courses.where((c) => c.status == 'active').length;
      final done = p.courses.where((c) => c.status == 'done').length;

      final highlights = p.courses.where((c) => c.status != 'done').toList()
        ..sort((a, b) => b.credits.compareTo(a.credits));

      final upcoming =
          p.courses
              .where((c) => c.status != 'done' && c.deadline != null)
              .toList()
            ..sort((a, b) => a.deadline!.compareTo(b.deadline!));

      children.addAll([
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Row(
            children: [
              _Stat('Total', total, Icons.list_alt),
              _Stat('Aktif', active, Icons.pending_actions),
              _Stat('Selesai', done, Icons.check_circle_outline),
            ],
          ),
        ),
        if (highlights.isNotEmpty) ...[
          _title('Prioritas Utama'),
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
        _title(
          'Deadline Terdekat',
          trailing: TextButton(
            onPressed: onSeeAll,
            child: const Text('Lihat semua'),
          ),
        ),
        if (upcoming.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Belum ada tugas dengan deadline.'),
          )
        else
          ...upcoming
              .take(3)
              .map(
                (c) => CourseCard(course: c, onTap: () => _open(context, c)),
              ),
      ]);
    }

    return RefreshIndicator(
      onRefresh: p.loadCourses,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        children: children,
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  const _Stat(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.ice.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.blue),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.navy.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    ),
  );
}
