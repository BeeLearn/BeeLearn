import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

enum ProductPeriod {
  @JsonValue("LIFETIME")
  lifeTime,
  @JsonValue("DAILY")
  daily,
  @JsonValue("WEEKLY")
  weekly,
  @JsonValue("MONTHLY")
  monthly,
  @JsonValue("QUARTERLY")
  quarterly,
  @JsonValue("YEARLY")
  yearly,
}

@JsonSerializable()
class Product {
  @JsonKey(required: true)
  final int id;

  @JsonKey(
    required: true,
    includeIfNull: true,
  )
  final String? skid;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String description;

  @JsonKey(required: true)
  final int price;

  @JsonKey(required: true)
  final ProductPeriod period;

  @JsonKey(required: true, name: "is_premium")
  final String isPremium;

  @JsonKey(required: true, name: "created_at")
  final DateTime createdAt;

  @JsonKey(required: true, name: "updated_at")
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.skid,
    required this.name,
    required this.description,
    required this.price,
    required this.period,
    required this.isPremium,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
