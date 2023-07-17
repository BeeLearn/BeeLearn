import 'package:beelearn/serializers/question.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true, name: "is_liked")
  final bool isLiked;

  @JsonKey(required: true)
  final String title;

  @JsonKey(required: true)
  final String content;

  @JsonKey(required: true)
  final Question question;

  const Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.isLiked,
    required this.question,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
