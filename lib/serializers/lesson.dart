import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true, name: "is_unlocked")
  final bool isUnlocked;

  @JsonKey(required: true, name: "is_complete")
  final bool isComplete;

  const Lesson({
    required this.id,
    required this.name,
    required this.isComplete,
    required this.isUnlocked,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
