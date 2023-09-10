import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumSubscription extends StatelessWidget {
  const PremiumSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          leading: const CloseButton(),
          title: const Text("Subscription Plans"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 32,
                  ),
                  const Text("GO PREMIUM"),
                  const SizedBox(height: 16.0),
                  Text(
                    "Explore more with BeeLearn",
                    style: GoogleFonts.nunitoSansTextTheme(
                      Theme.of(context).textTheme,
                    ).titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    "Pay only when you use the app. You can cancel this subscription any time",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark ? CupertinoColors.systemGrey3 : CupertinoColors.systemGrey,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
              SizedBox(
                height: 224.0,
                child: PageView.builder(
                  padEnds: false,
                  controller: PageController(viewportFraction: 0.45),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Most Popular",
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).colorScheme.primaryContainer,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                const Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "6 \n",
                                        style: TextStyle(
                                          fontSize: 32.0,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "months",
                                        style: TextStyle(
                                          fontSize: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const Text("\$14.66/mon"),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text("Save 50%"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text("Continue"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
