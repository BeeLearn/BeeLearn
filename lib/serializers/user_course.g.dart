// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCourse _$UserCourseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'course', 'last_lesson', 'is_complete'],
  );
  return UserCourse(
    id: json['id'] as int,
    course: Course.fromJson(json['course'] as Map<String, dynamic>),
    lastLesson: json['last_lesson'] == null
        ? null
        : Lesson.fromJson(json['last_lesson'] as Map<String, dynamic>),
    isComplete: json['is_complete'] as bool,
  );
}

Map<String, dynamic> _$UserCourseToJson(UserCourse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course': instance.course,
      'last_lesson': instance.lastLesson,
      'is_complete': instance.isComplete,
    };
