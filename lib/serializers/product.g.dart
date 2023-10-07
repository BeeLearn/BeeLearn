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
      'name',
      'description',
      'price',
      'amount',
      'currency',
      'consumable',
      'flutterwave_plan_id',
      'paystack_plan_code',
      'created_at',
      'updated_at'
    ],
  );
  return Product(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    price: json['price'] as String,
    amount: json['amount'] as String,
    currency: json['currency'] as String,
    consumable: json['consumable'] as bool,
    flutterwavePlanId: json['flutterwave_plan_id'] as String?,
    paystackPlanCode: json['paystack_plan_code'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'amount': instance.amount,
      'currency': instance.currency,
      'consumable': instance.consumable,
      'flutterwave_plan_id': instance.flutterwavePlanId,
      'paystack_plan_code': instance.paystackPlanCode,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
