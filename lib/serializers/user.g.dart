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
      'username',
      'email',
      'profile',
      'avatar',
      'first_name',
      'last_name'
    ],
  );
  return User(
    id: json['id'] as int,
    username: json['username'] as String,
    email: json['email'] as String,
    avatar: json['avatar'] as String?,
    profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'profile': instance.profile,
      'avatar': instance.avatar,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
    };
