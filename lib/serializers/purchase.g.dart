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
      'order_id',
      'product',
      'status',
      'metadata',
      'created_at',
      'updated_at'
    ],
  );
  return Purchase(
    id: json['id'] as int,
    orderId: json['order_id'] as String,
    product: Product.fromJson(json['product'] as Map<String, dynamic>),
    status: $enumDecode(_$PurchaseStatusEnumMap, json['status']),
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$PurchaseToJson(Purchase instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'order_id': instance.orderId,
    'product': instance.product,
    'status': _$PurchaseStatusEnumMap[instance.status]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('metadata', instance.metadata);
  val['created_at'] = instance.createdAt.toIso8601String();
  val['updated_at'] = instance.updatedAt.toIso8601String();
  return val;
}

const _$PurchaseStatusEnumMap = {
  PurchaseStatus.failed: 'FAILED',
  PurchaseStatus.pending: 'PENDING',
  PurchaseStatus.unknown: 'UNKNOWN',
  PurchaseStatus.canceled: 'CANCELED',
  PurchaseStatus.successful: 'SUCCESSFUL',
};
