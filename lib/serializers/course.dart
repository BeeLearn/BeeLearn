import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true, name: "is_new")
  final bool isNew;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String image;

  const Course({
    required this.id,
    required this.name,
    required this.image,
    required this.isNew,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
