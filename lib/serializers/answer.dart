import 'package:json_annotation/json_annotation.dart';

part 'answer.g.dart';

@JsonSerializable()
class Answer {
  @JsonKey(required: true)
  final int id;
  @JsonKey(required: true)
  final String text;
  @JsonKey(required: true, name: "is_correct")
  final bool isCorrect;

  const Answer({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);
}
