class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  final DateTime? deadline;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
    this.deadline,
  });

  Course copyWith({int? id}) => Course(
    id: id ?? this.id,
    code: code,
    title: title,
    credits: credits,
    status: status,
    deadline: deadline,
  );

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'] == null ? null : int.tryParse(json['id'].toString()),
    code: (json['code'] ?? '').toString(),
    title: (json['title'] ?? '').toString(),
    credits: (json['credits'] as num?)?.toInt() ?? 1,
    status: (json['status'] ?? 'planned').toString(),
    deadline: DateTime.tryParse((json['deadline'] ?? '').toString())?.toLocal(),
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
    'deadline': deadline?.toUtc().toIso8601String(),
  };
}
