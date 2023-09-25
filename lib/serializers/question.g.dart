// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'title', 'type'],
  );
  return Question(
    id: json['id'] as int,
    title: json['title'] as String,
    type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$QuestionTypeEnumMap[instance.type]!,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.textOption: 'TEXT_OPTION',
  QuestionType.dragDrop: 'DRAG_DROP',
  QuestionType.reorderChoice: 'REORDER_CHOICE',
  QuestionType.multipleChoice: 'MULTIPLE_CHOICE',
  QuestionType.singleChoice: 'SINGLE_CHOICE',
};

Choice _$ChoiceFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'name', 'is_answer'],
  );
  return Choice(
    id: json['id'] as int,
    name: json['name'] as String,
    isAnswer: json['is_answer'] as bool,
  );
}

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_answer': instance.isAnswer,
    };

MultiChoiceQuestion _$MultiChoiceQuestionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'title', 'type', 'choices'],
  );
  return MultiChoiceQuestion(
    id: json['id'] as int,
    title: json['title'] as String,
    type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
    choices: (json['choices'] as List<dynamic>)
        .map((e) => Choice.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MultiChoiceQuestionToJson(
        MultiChoiceQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'choices': instance.choices,
    };

SingleChoiceQuestion _$SingleChoiceQuestionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'title', 'type', 'choices'],
  );
  return SingleChoiceQuestion(
    id: json['id'] as int,
    title: json['title'] as String,
    type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
    choices: (json['choices'] as List<dynamic>)
        .map((e) => Choice.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SingleChoiceQuestionToJson(
        SingleChoiceQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'choices': instance.choices,
    };

ReorderChoice _$ReorderChoiceFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'name', 'position'],
  );
  return ReorderChoice(
    id: json['id'] as int,
    name: json['name'] as String,
    position: json['position'] as int,
  );
}

Map<String, dynamic> _$ReorderChoiceToJson(ReorderChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
    };

ReorderChoiceQuestion _$ReorderChoiceQuestionFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'title', 'type', 'choices'],
  );
  return ReorderChoiceQuestion(
    id: json['id'] as int,
    title: json['title'] as String,
    type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
    choices: (json['choices'] as List<dynamic>)
        .map((e) => ReorderChoice.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ReorderChoiceQuestionToJson(
        ReorderChoiceQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'choices': instance.choices,
    };

DragDropQuestion _$DragDropQuestionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'title', 'type', 'choices', 'question'],
  );
  return DragDropQuestion(
    id: json['id'] as int,
    title: json['title'] as String,
    type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
    question: json['question'] as String,
    choicesValue: json['choices'] as String,
  );
}

Map<String, dynamic> _$DragDropQuestionToJson(DragDropQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'choices': instance.choicesValue,
      'question': instance.question,
    };

TextOptionQuestion _$TextOptionQuestionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'title', 'type'],
  );
  return TextOptionQuestion(
    id: json['id'] as int,
    title: json['title'] as String,
    type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
    question: json['question'] as String,
  );
}

Map<String, dynamic> _$TextOptionQuestionToJson(TextOptionQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'question': instance.question,
    };
