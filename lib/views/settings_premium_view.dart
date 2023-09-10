import 'package:beelearn/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/buttons.dart';
import 'components/premium_subscription.dart';

class SettingsPremiumView extends StatelessWidget {
  const SettingsPremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text("Manage Subscription"),
              ),
              const PopupMenuItem(
                child: Text("Restore Subscriptions"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
            "You're not Premium",
            style: GoogleFonts.nunitoSans(
              textStyle: Theme.of(context).textTheme.headlineLarge,
              color: Theme.of(context).brightness == Brightness.dark ? null : Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 32.0),
          Text(
            "What's included",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32.0),
          Expanded(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: subscriptionBenefits.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final benefit = subscriptionBenefits[index];

                    return ListTile(
                      leading: const Icon(Icons.check_circle),
                      title: Text(benefit),
                    );
                  },
                ),
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomOutlinedButton(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (innerContext) => Container(
                                height: MediaQuery.of(context).size.height * 0.7,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0),
                                  ),
                                ),
                                child: const PremiumSubscription(),
                              ),
                            );
                          },
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).highlightColor : Theme.of(context).colorScheme.inversePrimary,
                          child: const Center(
                            child: Text("Subscribe"),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: kToolbarHeight),
            child: Text("Terms & Privacy policy"),
          ),
        ],
      ),
    );
  }
}
