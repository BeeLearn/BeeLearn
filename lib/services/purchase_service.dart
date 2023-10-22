import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_paystack_payment/flutter_paystack_payment.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../controllers/controllers.dart';
import '../main_application.dart';
import '../models/models.dart';
import '../serializers/serializers.dart';

class PurchaseService {
  static PurchaseService? _instance;
  static final PaystackPayment _paystackPayment = PaystackPayment();

  /// Does platform support inAppPurchase
  bool get isInAppPurchaseEnabled => !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  Future <bool>  get isInAppPurchaseAvailable async => isInAppPurchaseEnabled ? await InAppPurchase.instance.isAvailable() : false;

  /// Is InApp Purchase supported for this application
  Future <bool> get isInAppPurchaseSupported async  => isInAppPurchaseEnabled && await isInAppPurchaseAvailable;


  /// Purchase service singleton instance
  static PurchaseService get instance => _instance ??= PurchaseService._();

  PurchaseService._() {
    _initialize();
    _paystackPayment.initialize(
      publicKey: FirebaseRemoteConfig.instance.getString("PAYSTACK_PUBLIC_KEY"),
    );
  }

  Future<void> _initialize() async {
  }

  /// Todo add support for other interval
  // Only monthly subscription is available on beelearn
  Future<dynamic> getSubscriptionProduct({required BuildContext context}) async {
    final productModel = Provider.of<ProductModel>(
      context,
      listen: false,
    );

    final products = productModel.items;

    if (await isInAppPurchaseSupported) {
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

  Future<void> subscription(BuildContext context, dynamic product) async {

    return isInAppPurchaseSupported.then((value) {
      if (value) return _subscribeInApp(product);
      
      return _subscribeExternal(context, product);
    });

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

    final paymentLinkResponse = purchaseController.createPaymentLink<PaystackPaymentLink>(
      {
        "reference": txRef,
        "source": "paystack",
        "amount": product.amount,
        "plan": product.paystackPlanCode,
        "email": userModel.value.email,
        "metadata": {
          "reference": txRef,
        },
      },
    );

    _paystackPayment.initialize(publicKey: FirebaseRemoteConfig.instance.getString("PAYSTACK_PUBLIC_KEY"));

    final chargeResponse = await _paystackPayment.checkout(
      context,
      scanCard: !kIsWeb && (Platform.isIOS || Platform.isAndroid),
      logo: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: CachedNetworkImage(
          imageUrl: MainApplication.appNetworkLogo,
          width: 32,
          height: 32,
        ),
      ),
      charge: Charge()
        ..amount = int.parse(product.amount)
        ..email = userModel.value.email
        ..accessCode = (await paymentLinkResponse).data.accessCode
        ..reference = (await paymentLinkResponse).data.reference,
    );

    if (chargeResponse.status) {
      await purchaseController.createPurchase(
        body: {
          "metadata": {
            "reference": txRef,
          },
          "product": product.id,
        },
      );
    }
  }
}
