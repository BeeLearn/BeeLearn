import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  @JsonKey(required: true)
  final String key;

  const Token({required this.key});

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
}
