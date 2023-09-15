// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thread _$ThreadFromJson(Map<String, dynamic> json) => Thread(
      reference: json['reference'] as String,
      comment: Comment.fromJson(json['comment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'reference': instance.reference,
      'comment': instance.comment,
    };
