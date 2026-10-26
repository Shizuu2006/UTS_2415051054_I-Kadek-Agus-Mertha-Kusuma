import 'package:flutter/material.dart';

import '../models/course.dart';
import 'course_form_page.dart';

/// Screen Edit Tugas (Update). Data tugas dikirim dari halaman Detail.
class EditCoursePage extends StatelessWidget {
  final Course course;
  const EditCoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) => CourseFormPage(course: course);
}
