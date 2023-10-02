import '../mixins/api_model_mixin.dart';
import '../serializers/serializers.dart';

class _PurchaseController with ApiModelMixin {
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
    required String id,
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

  Future<void> deletePurchase({
    required dynamic id,
    Map<String, dynamic>? query,
  }) async {
    return super.remove(path: id, query: query);
  }

  /// Create payment link to redirect user
  Future<PaymentLink<T>> createPaymentLink<T>(Map<String, dynamic> body) {
    return super.create(
      url: getDetailedPath("create-payment-link"),
      body: body,
      fromJson: PaymentLink.fromJson,
    );
  }

  /// Verify in-app purchase, throws NotFound, NotAcceptable exception
  /// [Response] NotFound: If purchase data can't be gotten
  /// [Response] NotAcceptable: If purchase source is not implemented
  Future<Purchase> verifyPurchase(Map<String, dynamic> body) {
    return create(
      body: body,
      url: getDetailedPath("verify"),
      fromJson: Purchase.fromJson,
    );
  }
}

final purchaseController = _PurchaseController();
