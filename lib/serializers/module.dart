import 'package:json_annotation/json_annotation.dart';

import 'lesson.dart';

part 'module.g.dart';

@JsonSerializable()
class Module {
  @JsonKey(required: true)
  final int id;


  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true, name: "is_complete")
  final bool isComplete;

  @JsonKey(required: true, name: "is_unlocked")
  final bool isUnLocked;

  @JsonKey(required: true, name: "lessons")
  final List<Lesson> lessons;

  const Module({
    required this.id,
    required this.name,
    required this.isUnLocked,
    required this.isComplete,
    required this.lessons,
  });

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);
}
