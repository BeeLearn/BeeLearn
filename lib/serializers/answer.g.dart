// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'text', 'is_correct'],
  );
  return Answer(
    id: json['id'] as int,
    text: json['text'] as String,
    isCorrect: json['is_correct'] as bool,
  );
}

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'is_correct': instance.isCorrect,
    };
