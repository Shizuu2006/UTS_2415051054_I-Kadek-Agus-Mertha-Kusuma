import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  SupabaseClient get _db => Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await _db.from('courses').select().order('id');
    return data.map((e) => Course.fromJson(e)).toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final row = await _db
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();
    return Course.fromJson(row);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    await _db.from('courses').update(course.toJson()).eq('id', id);
  }

  @override
  Future<void> deleteCourse(int id) async {
    await _db.from('courses').delete().eq('id', id);
  }
}
