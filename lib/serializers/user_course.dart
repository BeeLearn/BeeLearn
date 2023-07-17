import 'package:json_annotation/json_annotation.dart';

import 'course.dart';
import 'lesson.dart';

part 'user_course.g.dart';

@JsonSerializable()
class UserCourse {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final Course course;

  @JsonKey(required: true, name: "last_lesson")
  final Lesson? lastLesson;

  @JsonKey(required: true, name: "is_complete")
  final bool isComplete;

  const UserCourse({
    required this.id,
    required this.course,
    required this.lastLesson,
    required this.isComplete,
  });

  factory UserCourse.fromJson(Map<String, dynamic> json) => _$UserCourseFromJson(json);
}
