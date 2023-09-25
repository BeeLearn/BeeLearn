import '../mixins/api_model_mixin.dart';
import '../serializers/paginate.dart';
import '../serializers/purchase.dart';

class PurchaseController with ApiModelMixin {
  @override
  String get basePath => "api/payment/purchases";

  Future<Paginate<Purchase>> listPurchases({
    String? url,
    Map<String, dynamic>? query,
  }) {
    return super.list(
      url: url,
      query: query,
      fromJson: (Map<String, dynamic> json) => Paginate.fromJson(json, Purchase.fromJson),
    );
  }

  Future<Purchase> createPurchase({
    Map<String, dynamic>? query,
    required Map<String, dynamic> body,
  }) {
    return super.create(
      query: query,
      body: body,
      fromJson: Purchase.fromJson,
    );
  }

  Future<Purchase> updatePurchase({
    required int id,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? body,
  }) {
    return super.update(
      path: id,
      query: query,
      body: body,
      fromJson: Purchase.fromJson,
    );
  }
}
