import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals.dart';
import 'fragments/dialog_fragment.dart';

class SettingsPremiumView extends StatelessWidget {
  const SettingsPremiumView({super.key});

  Widget _getBody(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const CloseButton(),
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
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            Text(
              "You're not Premium",
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
                        child: Wrap(
                          runSpacing: 8.0,
                          alignment: WrapAlignment.center,
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
                            Text.rich(
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
                          ],
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
  }

  @override
  Widget build(BuildContext context) {
    return DialogFragment(
      alignment: Alignment.center,
      builder: _getBody,
    );
  }
}
