// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'skid',
      'name',
      'description',
      'price',
      'period',
      'is_premium',
      'created_at',
      'updated_at'
    ],
  );
  return Product(
    id: json['id'] as int,
    skid: json['skid'] as String?,
    name: json['name'] as String,
    description: json['description'] as String,
    price: json['price'] as int,
    period: $enumDecode(_$ProductPeriodEnumMap, json['period']),
    isPremium: json['is_premium'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'skid': instance.skid,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'period': _$ProductPeriodEnumMap[instance.period]!,
      'is_premium': instance.isPremium,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ProductPeriodEnumMap = {
  ProductPeriod.lifeTime: 'LIFETIME',
  ProductPeriod.daily: 'DAILY',
  ProductPeriod.weekly: 'WEEKLY',
  ProductPeriod.monthly: 'MONTHLY',
  ProductPeriod.quarterly: 'QUARTERLY',
  ProductPeriod.yearly: 'YEARLY',
};
