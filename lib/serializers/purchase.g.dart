// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'product',
      'status',
      'metadata',
      'created_at',
      'updated_at'
    ],
  );
  return Purchase(
    id: json['id'] as int,
    product: Product.fromJson(json['product'] as Map<String, dynamic>),
    status: $enumDecode(_$PurchaseStatusEnumMap, json['status']),
    metadata: json['metadata'] as Map<String, dynamic>,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$PurchaseToJson(Purchase instance) => <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'status': _$PurchaseStatusEnumMap[instance.status]!,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$PurchaseStatusEnumMap = {
  PurchaseStatus.failed: 'failed',
  PurchaseStatus.pending: 'pending',
  PurchaseStatus.successful: 'successful',
};
