import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../theme.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import '../widgets/highlight_card.dart';
import 'course_detail_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSeeAll;
  const HomePage({super.key, required this.onSeeAll});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _filter;

  void _open(Course c) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CourseDetailPage(course: c)),
  );

  Widget _title(String text, {Widget? trailing}) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
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
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
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
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              Text(
                'NIM $studentNim • $studentClass',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.navy.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 26,
          backgroundColor: AppColors.ice,
          child: Icon(Icons.person, color: AppColors.blue),
        ),
      ],
    ),
  );

  Widget _searchRow() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: true,
            onTap: widget.onSeeAll,
            decoration: const InputDecoration(
              hintText: 'Cari tugas atau Nama Mata Kuliah',
              suffixIcon: Icon(Icons.search, color: AppColors.blue),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onSeeAll,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.ice,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.tune, color: AppColors.blue),
          ),
        ),
      ],
    ),
  );

  Widget _chips() {
    final options = <String?>[null, 'active', 'done'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: options
            .map(
              (s) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(s == null ? 'Semua' : statusLabel(s)),
                  selected: _filter == s,
                  selectedColor: AppColors.blue,
                  backgroundColor: AppColors.ice,
                  side: BorderSide.none,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: _filter == s ? Colors.white : AppColors.navy,
                  ),
                  onSelected: (_) => setState(() => _filter = s),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CourseProvider>();

    final children = <Widget>[_header(), _searchRow(), _chips()];

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
      final base = p.courses
          .where(
            (c) => _filter == null ? c.status != 'done' : c.status == _filter,
          )
          .toList();

      final highlights = [...base]
        ..sort((a, b) => b.credits.compareTo(a.credits));

      final upcoming = base.where((c) => c.deadline != null).toList()
        ..sort((a, b) => a.deadline!.compareTo(b.deadline!));

      children.add(_title('Prioritas Utama'));
      if (highlights.isEmpty) {
        children.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Tidak ada tugas pada filter ini.'),
          ),
        );
      } else {
        children.add(
          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: highlights.length > 5 ? 5 : highlights.length,
              itemBuilder: (_, i) => HighlightCard(
                course: highlights[i],
                alt: i.isOdd,
                onTap: () => _open(highlights[i]),
              ),
            ),
          ),
        );
      }

      children.add(
        _title(
          'Deadline Terdekat',
          trailing: TextButton(
            onPressed: widget.onSeeAll,
            child: const Text('Lihat semua'),
          ),
        ),
      );
      if (upcoming.isEmpty) {
        children.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Belum ada tugas dengan deadline.'),
          ),
        );
      } else {
        children.addAll(
          upcoming
              .take(3)
              .map((c) => CourseCard(course: c, onTap: () => _open(c))),
        );
      }
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
