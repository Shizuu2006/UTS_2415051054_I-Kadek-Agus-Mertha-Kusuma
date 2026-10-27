import 'package:flutter/material.dart';

import '../constants.dart';
import '../theme.dart';
import 'course_list_page.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? _filter;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final options = <String?>[null, ...statuses];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text(
            'Daftar Tugas',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Cari tugas atau kode MK',
              prefixIcon: Icon(Icons.search, color: AppColors.blue),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Wrap(
            spacing: 8,
            children: options
                .map(
                  (s) => ChoiceChip(
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
                )
                .toList(),
          ),
        ),
        Expanded(
          child: CourseListPage(filterStatus: _filter, query: _query),
        ),
      ],
    );
  }
}
