import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

enum QuestionType {
  @JsonValue("MULTIPLE_CHOICE")
  multipleChoice,
  @JsonValue("SINGLE_CHOICE")
  singleChoice,
}

@JsonSerializable()
class Question {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final QuestionType type;

  @JsonKey(required: true)
  final dynamic question;

  const Question({
    required this.id,
    required this.type,
    required this.question,
  });

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
}
