import 'package:flutter/material.dart';
import 'package:mytugas/theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

import 'constants.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/responsive_shell.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';
import 'services/notification_service.dart';
import 'services/calendar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

  final notif = NotificationService();
  await notif.init();
  final cal = CalendarService();

  final CourseDataSource dataSource = CourseSupabaseService();

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(CourseRepository(dataSource), notif, cal),
      child: const MYTUGASApp(),
    ),
  );
}

class MYTUGASApp extends StatelessWidget {
  const MYTUGASApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MY TUGAS',
    debugShowCheckedModeBanner: false,
    theme: buildTheme(),
    home: const ResponsiveShell(),
  );
}
