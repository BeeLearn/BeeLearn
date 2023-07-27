// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Response _$ResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['status', 'requestId', 'method', 'data'],
  );
  return Response(
    status: json['status'] as int,
    requestId: json['requestId'] as String,
    method: $enumDecode(_$MethodEnumMap, json['method']),
    data: json['data'],
  );
}

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'status': instance.status,
      'requestId': instance.requestId,
      'method': _$MethodEnumMap[instance.method]!,
      'data': instance.data,
    };

const _$MethodEnumMap = {
  Method.get: 'GET',
  Method.post: 'POST',
  Method.put: 'PUT',
  Method.patch: 'PATCH',
  Method.subscription: 'SUBSCRIPTION',
};
