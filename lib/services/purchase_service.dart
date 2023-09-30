import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../main_application.dart';
import '../controllers/controllers.dart';
import '../models/models.dart';
import '../serializers/serializers.dart';

class PurchaseService {
  late bool isInAppPurchaseAvailable;
  static PurchaseService? _instance;

  /// Does platform support inAppPurchase
  bool get isInAppPurchaseEnabled => !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  /// Is InApp Purchase supported for this application
  bool get isInAppPurchaseSupported => isInAppPurchaseEnabled && isInAppPurchaseAvailable;

  /// Purchase service singleton instance
  static PurchaseService get instance => _instance ??= PurchaseService._();

  PurchaseService._() {
    _initialize();
  }

  Future<void> _initialize() async {
    isInAppPurchaseAvailable = isInAppPurchaseEnabled ? await InAppPurchase.instance.isAvailable() : false;
  }

  /// Todo add support for other interval
  // Only monthly subscription is available on beelearn
  Future<dynamic> getSubscriptionProduct({required BuildContext context}) async {
    final productModel = Provider.of<ProductModel>(
      context,
      listen: false,
    );

    final products = productModel.items;

    if (isInAppPurchaseSupported) {
      /// Pipe predicate - filter out kIds is null
      final Set<String> kIds = products.map((product) => product.id).toSet();
      final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(kIds);

      return response.productDetails.firstWhere(
        (productDetail) => productDetail.id.contains("monthly"),
      );
    }

    return products.firstWhere(
      (product) => product.id.contains("monthly"),
    );
  }

  Future<void> subscription(BuildContext context, dynamic product) {
    if (isInAppPurchaseSupported) return _subscribeInApp(product);

    return _subscribeExternal(context, product);
  }

  /// Handle in-app subscription
  Future<void> _subscribeInApp(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Handle external subscription
  Future<void> _subscribeExternal(BuildContext context, Product product) async {
    final userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );
    final txRef = const Uuid().v4();
    final paymentLinkResponse = purchaseController.createPaymentLink(
      {
        "tx_ref": txRef,
        "amount": product.amount,
        "currency": product.currency,
        "redirect_url": "${MainApplication.baseURL}/payment/verify/",
        "customer": {"email": userModel.value.email},
        "customization": {
          "title": "BeeLearn",
          "logo": MainApplication.appNetworkLogo,
          "description": "Subscribe to BeeLearn Premium Membership Plan",
        }
      },
    );

    final chargeResponse = await Flutterwave.fromPaymentLink(
      context: context,
      txRef: txRef,
      link: (await paymentLinkResponse).link,
    );

    await purchaseController.createPurchase(
      body: {
        "product": product.id,
        "reference": chargeResponse.txRef,
        "status": chargeResponse.status ?? "PENDING",
      },
    );
  }
}
