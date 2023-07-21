// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'lives', 'xp', 'bits'],
  );
  return Profile(
    id: json['id'] as int,
    lives: json['lives'] as int,
    xp: json['xp'] as int,
    bits: json['bits'] as int,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'lives': instance.lives,
      'xp': instance.xp,
      'bits': instance.bits,
    };
