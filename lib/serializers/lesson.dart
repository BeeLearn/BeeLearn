import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true, name: "module_id")
  final int moduleId;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true, name: "is_unlocked")
  final bool isUnlocked;

  @JsonKey(required: true, name: "is_completed")
  final bool isCompleted;

  const Lesson({
    required this.id,
    required this.moduleId,
    required this.name,
    required this.isUnlocked,
    required this.isCompleted,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
