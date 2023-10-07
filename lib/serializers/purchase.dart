import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'purchase.g.dart';

enum PurchaseStatus {
  @JsonValue("FAILED")
  failed,
  @JsonValue("PENDING")
  pending,
  @JsonValue("UNKNOWN")
  unknown,
  @JsonValue("CANCELED")
  canceled,
  @JsonValue("SUCCESSFUL")
  successful,
}

@JsonSerializable()
class Purchase {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true, name: "order_id")
  final String orderId;

  @JsonKey(required: true)
  final Product product;

  @JsonKey(required: true)
  final PurchaseStatus status;

  @JsonKey(required: true, includeIfNull: false)
  final Map<String, dynamic>? metadata;

  @JsonKey(required: true, name: "created_at")
  final DateTime createdAt;

  @JsonKey(required: true, name: "updated_at")
  final DateTime updatedAt;

  const Purchase({
    required this.id,
    required this.orderId,
    required this.product,
    required this.status,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => _$PurchaseFromJson(json);
}
