import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_course_page.dart';
import '../constants.dart';
import '../providers/course_provider.dart';
import '../theme.dart';
import 'course_list_page.dart';

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _index = 0;
  String _query = '';

  static const _filters = <String?>[null, 'active', 'done'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Halo,',
                    style: TextStyle(fontSize: 14, color: AppColors.blue),
                  ),
                  Text(
                    studentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
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
              radius: 24,
              backgroundColor: AppColors.ice,
              child: Icon(Icons.person, color: AppColors.blue),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(
            hintText: 'Cari tugas atau Nama Mata Kuliah',
            prefixIcon: Icon(Icons.search, color: AppColors.blue),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        _header(),
        Expanded(
          child: CourseListPage(filterStatus: _filters[_index], query: _query),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 700;

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.blue,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddCoursePage()),
            ),
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: wide
                ? Row(
                    children: [
                      NavigationRail(
                        selectedIndex: _index,
                        onDestinationSelected: (i) =>
                            setState(() => _index = i),
                        labelType: NavigationRailLabelType.all,
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            selectedIcon: Icon(Icons.home),
                            label: Text('Semua'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.pending_actions),
                            label: Text('Proses'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.check_circle_outline),
                            selectedIcon: Icon(Icons.check_circle),
                            label: Text('Selesai'),
                          ),
                        ],
                      ),
                      Expanded(child: content),
                    ],
                  )
                : content,
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Semua',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.pending_actions),
                      label: 'Proses',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.check_circle_outline),
                      selectedIcon: Icon(Icons.check_circle),
                      label: 'Selesai',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
