import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:simple_circular_progress_bar/simple_circular_progress_bar.dart";

import "../components/streak_calender.dart";

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 390,
            width: double.infinity,
            child: Column(
              children: [
                const Column(
                  children: [
                    Text(
                      "Daily goals",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Read and listen every day to achieve your goals",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                SimpleCircularProgressBar(
                  size: 156,
                  progressStrokeWidth: 8,
                  progressColors: const [Colors.green],
                  mergeMode: true,
                  onGetText: (s_) {
                    return const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "0 \n",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(text: "Of 60 min goal"),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                Wrap(
                  spacing: 8.0,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Adjust goal"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Share"),
                    ),
                  ],
                ),
                StreakCalender(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.gift_fill,
                        color: Colors.green,
                      ),
                    ),
                    const Expanded(
                      child: Text("My streak is 1 day"),
                    ), /*
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "All time record",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
