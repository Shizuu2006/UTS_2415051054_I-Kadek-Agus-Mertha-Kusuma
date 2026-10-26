import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/course_provider.dart';
import '../theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _row(IconData icon, String label, String value) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.ice.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.blue, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.navy.withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final total = context.watch<CourseProvider>().courses.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        const Text(
          'Profil',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.navy, AppColors.blue, AppColors.cyan],
            ),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.ice,
                child: Icon(Icons.person, size: 44, color: AppColors.blue),
              ),
              const SizedBox(height: 12),
              const Text(
                studentName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '$studentNim • $studentClass',
                style: TextStyle(color: AppColors.ice),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Tentang Aplikasi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 10),
        _row(Icons.assignment_outlined, 'Aplikasi', 'TugasKu (TaskMate)'),
        _row(Icons.list_alt, 'Total tugas tersimpan', '$total'),
        _row(Icons.code, 'Teknologi', 'Flutter • Provider • Supabase'),
        _row(Icons.cloud_outlined, 'REST API', 'dummyjson.com (kutipan)'),
        _row(Icons.info_outline, 'Versi', '1.0.0'),
      ],
    );
  }
}
