import 'package:json_annotation/json_annotation.dart';

part 'module.g.dart';

@JsonSerializable()
class Module {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true, name: "is_complete")
  final bool isComplete;

  @JsonKey(required:  true, name: "is_locked")
  final bool isLocked;

  const Module({
    required this.id,
    required this.name,
    required this.isLocked,
    required this.isComplete,
  });

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);
}
