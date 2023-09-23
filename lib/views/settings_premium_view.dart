import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals.dart';

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
            "What's included?",
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Wrap(
                    runSpacing: 8.0,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                // showModalBottomSheet(
                                //   context: context,
                                //   useSafeArea: true,
                                //   isScrollControlled: true,
                                //   backgroundColor: Colors.transparent,
                                //   builder: (innerContext) => Container(
                                //     height: MediaQuery.of(context).size.height * 0.7,
                                //     decoration: BoxDecoration(
                                //       color: Theme.of(context).colorScheme.secondaryContainer,
                                //       borderRadius: const BorderRadius.only(
                                //         topLeft: Radius.circular(25.0),
                                //         topRight: Radius.circular(25.0),
                                //       ),
                                //     ),
                                //     child: const PremiumSubscription(),
                                //   ),
                                // );
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
                      Opacity(
                        opacity: 0.8,
                        child: Text.rich(
                          const TextSpan(
                            children: [
                              TextSpan(text: "Auto-renews for "),
                              TextSpan(
                                text: "₦1,578.78/months ",
                              ),
                              TextSpan(text: "until canceled"),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kToolbarHeight),
            child: Text(
              "Terms & Privacy policy",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white60 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
