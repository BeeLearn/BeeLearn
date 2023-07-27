import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true, name: "is_new")
  final bool isNew;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String image;

  @JsonKey(required: true, name: "is_enrolled")
  final bool isEnrolled;

  @JsonKey(required: true, name: "is_completed")
  final bool isCompleted;

  const Course({
    required this.id,
    required this.name,
    required this.image,
    required this.isNew,
    required this.isEnrolled,
    required this.isCompleted,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
