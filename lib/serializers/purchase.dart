import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'purchase.g.dart';

enum PurchaseStatus {
  failed,
  pending,
  successful,
}

@JsonSerializable()
class Purchase {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final Product product;

  @JsonKey(required: true)
  final PurchaseStatus status;

  @JsonKey(required: true)
  final Map<String, dynamic> metadata;

  @JsonKey(required: true, name: "created_at")
  final DateTime createdAt;

  @JsonKey(required: true, name: "updated_at")
  final DateTime updatedAt;

  const Purchase({
    required this.id,
    required this.product,
    required this.status,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => _$PurchaseFromJson(json);
}
