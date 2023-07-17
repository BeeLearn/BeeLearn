// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'type', 'question'],
  );
  return Question(
    id: json['id'] as int,
    type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
    question: json['question'],
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'question': instance.question,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.multipleChoice: 'MULTIPLE_CHOICE',
  QuestionType.singleChoice: 'SINGLE_CHOICE',
};
