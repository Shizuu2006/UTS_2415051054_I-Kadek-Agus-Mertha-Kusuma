import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  final CourseDataSource _source;
  CourseRepository(this._source);

  Future<List<Course>> getCourses() => _source.getCourses();
  Future<Course> createCourse(Course c) => _source.createCourse(c);
  Future<void> updateCourse(int id, Course c) => _source.updateCourse(id, c);
  Future<void> deleteCourse(int id) => _source.deleteCourse(id);
}
