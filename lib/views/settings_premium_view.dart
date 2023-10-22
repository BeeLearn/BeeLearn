import 'package:beelearn/middlewares/api_middleware.dart';
import 'package:beelearn/models/models.dart';
import 'package:beelearn/services/purchase_service.dart';
import 'package:beelearn/widget_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import 'fragments/dialog_fragment.dart';

class SettingsPremiumView extends StatefulWidget {
  const SettingsPremiumView({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPremiumView();
}

class _SettingsPremiumView extends State<SettingsPremiumView> {
  Widget _getBody(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const CloseButton(key: premiumSettingsViewBackButtonKey),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Manage Subscription"),
                onTap: () {
                  if (kIsWeb) {
                    /// Todo show subscription manage ui
                  } else {
                    /// Todo Intent to deepLink appStore
                  }
                },
              ),
              PopupMenuItem(
                child: const Text("Restore Subscriptions"),
                onTap: () async {
                  if (await PurchaseService.instance.isInAppPurchaseSupported) {
                    InAppPurchase.instance.restorePurchases();
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: Consumer<UserModel>(
        builder: (context, model, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Text(
                    model.value.isPremium ? "You are premium" : "You're not Premium",
                    style: GoogleFonts.nunitoSans(
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      color: Theme.of(context).brightness == Brightness.dark ? null : Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "What's included?",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Flexible(
                          flex: 2,
                          child: ListView.builder(
                            itemCount: subscriptionBenefits.length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final benefit = subscriptionBenefits[index];

                              return ListTile(
                                leading: const Icon(Icons.check_circle),
                                title: Text(benefit),
                              );
                            },
                          ),
                        ),
                        Flexible(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: FutureBuilder(
                                future: PurchaseService.instance.getSubscriptionProduct(context: context),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.done:
                                      return Wrap(
                                        runSpacing: 8.0,
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: FilledButton(
                                                  onPressed: model.value.isPremium
                                                      ? null
                                                      : () async {
                                                          if (!context.loaderOverlay.visible) {
                                                            context.loaderOverlay.show();
                                                            try {
                                                              await PurchaseService.instance.subscription(
                                                                context,
                                                                snapshot.requireData,
                                                              );

                                                              if (kIsWeb) {
                                                                showSnackBar(
                                                                  leading: const Icon(
                                                                    Icons.pending,
                                                                    color: Colors.amber,
                                                                  ),
                                                                  title: "Payment is being processed, please wait few minutes and refresh.",
                                                                );
                                                              }
                                                            } finally {
                                                              if(context.mounted) context.loaderOverlay.hide();
                                                            }
                                                          }
                                                        },
                                                  style: FilledButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                  ),
                                                  child: const Center(
                                                    child: Text("Subscribe"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(text: "Auto-renews for "),
                                                TextSpan(text: "${snapshot.requireData.price}/months "),
                                                const TextSpan(text: "until canceled"),
                                              ],
                                            ),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.notoSans(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      );
                                    default:
                                      return const SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                        ),
                                      );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Terms & Privacy policy",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white60 : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: Colors.black45,
      child: DialogFragment(
        alignment: Alignment.center,
        builder: _getBody,
      ),
    );
  }
}
