import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/course.dart';
import 'course_data_source.dart';

class CourseApiService implements CourseDataSource {
  final http.Client _client = http.Client();
  static const _headers = {'Content-Type': 'application/json'};
  static const _timeout = Duration(seconds: 10);

  Uri _uri([int? id]) =>
      Uri.parse(id == null ? courseApiBaseUrl : '$courseApiBaseUrl/$id');

  void _check(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request gagal (kode ${res.statusCode})');
    }
  }

  @override
  Future<List<Course>> getCourses() async {
    final res = await _client.get(_uri()).timeout(_timeout);
    _check(res);
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final res = await _client
        .post(_uri(), headers: _headers, body: jsonEncode(course.toJson()))
        .timeout(_timeout);
    _check(res);
    return Course.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    final res = await _client
        .put(_uri(id), headers: _headers, body: jsonEncode(course.toJson()))
        .timeout(_timeout);
    _check(res);
  }

  @override
  Future<void> deleteCourse(int id) async {
    final res = await _client.delete(_uri(id)).timeout(_timeout);
    _check(res);
  }
}
