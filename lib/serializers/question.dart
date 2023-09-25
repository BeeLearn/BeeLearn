import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

enum QuestionType {
  @JsonValue("TEXT_OPTION")
  textOption,
  @JsonValue("DRAG_DROP")
  dragDrop,
  @JsonValue("REORDER_CHOICE")
  reorderChoice,
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
  final String title;

  @JsonKey(required: true)
  final QuestionType type;

  const Question({
    required this.id,
    required this.title,
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final type = json["type"];

    switch (type) {
      case "SINGLE_CHOICE":
        return SingleChoiceQuestion.fromJson(json);
      case "MULTIPLE_CHOICE":
        return MultiChoiceQuestion.fromJson(json);
      case "TEXT_OPTION":
        return TextOptionQuestion.fromJson(json);
      case "DRAG_DROP":
        return DragDropQuestion.fromJson(json);
      case "REORDER_CHOICE":
        return ReorderChoiceQuestion.fromJson(json);
      default:
        throw UnimplementedError("question of $type is not implemented.");
    }
  }
}

@JsonSerializable()
class Choice {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true, name: "is_answer")
  final bool isAnswer;

  const Choice({
    required this.id,
    required this.name,
    required this.isAnswer,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
}

class ChoiceQuestion extends Question {
  @JsonKey(required: true)
  final List<Choice> choices;

  const ChoiceQuestion({
    required super.id,
    required super.title,
    required super.type,
    required this.choices,
  });
}

@JsonSerializable()
class MultiChoiceQuestion extends ChoiceQuestion {
  const MultiChoiceQuestion({
    required super.id,
    required super.title,
    required super.type,
    required super.choices,
  });

  factory MultiChoiceQuestion.fromJson(Map<String, dynamic> json) => _$MultiChoiceQuestionFromJson(json);
}

@JsonSerializable()
class SingleChoiceQuestion extends ChoiceQuestion {
  const SingleChoiceQuestion({
    required super.id,
    required super.title,
    required super.type,
    required super.choices,
  });

  factory SingleChoiceQuestion.fromJson(Map<String, dynamic> json) => _$SingleChoiceQuestionFromJson(json);
}

@JsonSerializable()
class ReorderChoice {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final int position;

  const ReorderChoice({
    required this.id,
    required this.name,
    required this.position,
  });

  @override
  int get hashCode => Object.hashAll([id, name, position]);

  @override
  bool operator ==(Object other) => other is ReorderChoice && id == other.id && name == other.name && position == other.position;

  factory ReorderChoice.fromJson(Map<String, dynamic> json) => _$ReorderChoiceFromJson(json);
}

@JsonSerializable()
class ReorderChoiceQuestion extends Question {
  @JsonKey(required: true)
  final List<ReorderChoice> choices;

  const ReorderChoiceQuestion({
    required super.id,
    required super.title,
    required super.type,
    required this.choices,
  });

  factory ReorderChoiceQuestion.fromJson(Map<String, dynamic> json) => _$ReorderChoiceQuestionFromJson(json);
}

@JsonSerializable()
class DragDropQuestion extends Question {
  @JsonKey(required: true, name: "choices")
  final String choicesValue;

  @JsonKey(required: true, name: "question")
  final String question;

  List<String> get choices => choicesValue.split(",");

  const DragDropQuestion({
    required super.id,
    required super.title,
    required super.type,
    required this.question,
    required this.choicesValue,
  });

  factory DragDropQuestion.fromJson(Map<String, dynamic> json) => _$DragDropQuestionFromJson(json);
}

@JsonSerializable()
class TextOptionQuestion extends Question {
  final String question;

  const TextOptionQuestion({
    required super.id,
    required super.title,
    required super.type,
    required this.question,
  });

  factory TextOptionQuestion.fromJson(Map<String, dynamic> json) => _$TextOptionQuestionFromJson(json);
}
