import 'package:json_annotation/json_annotation.dart';

import 'course.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final List<Course> courses;

  const Category({
    required this.id,
    required this.name,
    required this.courses,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}
