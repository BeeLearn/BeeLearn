// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'user_type',
      'username',
      'email',
      'profile',
      'settings',
      'avatar',
      'first_name',
      'last_name',
      'is_premium'
    ],
  );
  return User(
    id: json['id'] as int,
    userType: $enumDecode(_$UserTypeEnumMap, json['user_type']),
    username: json['username'] as String,
    email: json['email'] as String,
    avatar: json['avatar'] as String?,
    profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    settings: Settings.fromJson(json['settings'] as Map<String, dynamic>),
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    isPremium: json['is_premium'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'user_type': _$UserTypeEnumMap[instance.userType]!,
      'username': instance.username,
      'email': instance.email,
      'profile': instance.profile,
      'settings': instance.settings,
      'avatar': instance.avatar,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'is_premium': instance.isPremium,
    };

const _$UserTypeEnumMap = {
  UserType.student: 'STUDENT',
  UserType.curator: 'CURATOR',
  UserType.specialist: 'SPECIALIST',
};
