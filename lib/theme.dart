import 'package:flutter/material.dart';

import 'constants.dart';

class AppColors {
  static const navy = Color(0xFF03045E);
  static const blue = Color(0xFF0077B6);
  static const cyan = Color(0xFF00B4D8);
  static const sky = Color(0xFF90E0EF);
  static const ice = Color(0xFFCAF0F8);
  static const bg = Color(0xFFF3FBFD);
}

Color statusColor(String status) {
  switch (normalizeStatus(status)) {
    case statusActive:
      return AppColors.cyan;
    case statusDone:
      return AppColors.navy;
    default:
      return AppColors.blue;
  }
}

String statusLabel(String status) {
  switch (normalizeStatus(status)) {
    case statusActive:
      return 'Proses';
    case statusDone:
      return 'Selesai';
    default:
      return 'Belum Selesai';
  }
}

IconData statusIcon(String status) {
  switch (normalizeStatus(status)) {
    case statusActive:
      return Icons.pending_actions;
    case statusDone:
      return Icons.check_circle_outline;
    default:
      return Icons.description_outlined;
  }
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.blue,
    primary: AppColors.blue,
    secondary: AppColors.cyan,
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.navy,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.ice,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.blue,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.ice,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.ice,
    ),
  );
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];
const _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

String formatDeadline(DateTime d) {
  final hh = d.hour.toString().padLeft(2, '0');
  final mm = d.minute.toString().padLeft(2, '0');
  return '${_days[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year} • $hh:$mm';
}

String remainingText(DateTime d) {
  final diff = d.difference(DateTime.now());
  if (diff.isNegative) return 'Terlambat';
  if (diff.inDays >= 1) return '${diff.inDays} hari lagi';
  if (diff.inHours >= 1) return '${diff.inHours} jam lagi';
  return '${diff.inMinutes} menit lagi';
}

Color urgencyColor(DateTime d) {
  final diff = d.difference(DateTime.now());
  if (diff.isNegative || diff.inDays < 1) return Colors.red;
  if (diff.inDays <= 3) return Colors.orange;
  return AppColors.blue;
}
