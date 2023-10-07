import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String description;

  @JsonKey(required: true)
  final String price;

  @JsonKey(required: true)
  final String amount;

  @JsonKey(required: true)
  final String currency;

  @JsonKey(required: true)
  final bool consumable;

  @JsonKey(required: true, includeIfNull: true, name: "flutterwave_plan_id")
  final String? flutterwavePlanId;

  @JsonKey(required: true, includeIfNull: true, name: "paystack_plan_code")
  final String? paystackPlanCode;

  @JsonKey(required: true, name: "created_at")
  final DateTime createdAt;

  @JsonKey(required: true, name: "updated_at")
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.amount,
    required this.currency,
    required this.consumable,
    required this.flutterwavePlanId,
    required this.paystackPlanCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
