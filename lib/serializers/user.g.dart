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
      'avatar',
      'first_name',
      'last_name',
      'is_premium'
    ],
  );
  return User(
    token: json['token'] == null
        ? null
        : Token.fromJson(json['token'] as Map<String, dynamic>),
    profile: json['profile'] == null
        ? null
        : Profile.fromJson(json['profile'] as Map<String, dynamic>),
    settings: json['settings'] == null
        ? null
        : Settings.fromJson(json['settings'] as Map<String, dynamic>),
    id: json['id'] as int,
    userType: $enumDecode(_$UserTypeEnumMap, json['user_type']),
    username: json['username'] as String,
    email: json['email'] as String,
    avatar: json['avatar'] as String,
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
      'token': instance.token,
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
