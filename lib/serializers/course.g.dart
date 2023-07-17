// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'is_new', 'name', 'image'],
  );
  return Course(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    isNew: json['is_new'] as bool,
  );
}

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'id': instance.id,
      'is_new': instance.isNew,
      'name': instance.name,
      'image': instance.image,
    };
