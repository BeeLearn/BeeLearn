import "package:beelearn/views/fragments/set_goal_fragment.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:step_progress_indicator/step_progress_indicator.dart';

import "../../models/streak_model.dart";
import "../../models/user_model.dart";
import "streak_calender.dart";

class StreakCard extends StatefulWidget {
  const StreakCard({super.key});

  @override
  State createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard> {
  late final StreakModel _streakModel;

  @override
  void initState() {
    super.initState();

    _streakModel = Provider.of<StreakModel>(
      context,
      listen: false,
    );

    StreakModel.getStreak(
      query: {"start_date": DateTime.now().toIso8601String()},
    ).then((response) => _streakModel.setAll(response.results));
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 416,
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
                Consumer2<UserModel, StreakModel>(
                  builder: (context, userModel, streakModel, child) {
                    final user = userModel.value;
                    final isStreakComplete = streakModel.streaks.isEmpty ? false : streakModel.todayStreak.isComplete;
                    final dailyStreakSeconds = streakModel.streaks.isEmpty ? 0 : streakModel.todayStreak.currentStreakSeconds;
                    final dailyStreakMinutes = streakModel.streaks.isEmpty ? 0 : streakModel.todayStreak.currentStreakMinutes;

                    return CircularStepProgressIndicator(
                      width: 156,
                      height: 156,
                      padding: 0,
                      totalSteps: user.profile!.dailyStreakSeconds,
                      currentStep: dailyStreakSeconds,
                      selectedColor: Colors.green,
                      child: Center(
                        child: isStreakComplete
                            ? const Icon(
                                Icons.check,
                                size: 72,
                                color: Colors.green,
                              )
                            : Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "$dailyStreakMinutes\n",
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextSpan(text: "Of ${user.profile!.dailyStreakMinutes} min goal"),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const SetGoalFragment();
                          },
                        );
                      },
                      child: const Text("Adjust goal"),
                    ),
                    FilledButton.tonal(
                      onPressed: () {},
                      child: const Text("Share"),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Consumer<StreakModel>(
                  builder: (context, model, child) {
                    return StreakCalender(streaks: model.streaks);
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.gift_fill,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Expanded(
                      child: Text("My streak is 1 day"),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "All time record",
                      ),
                    ),
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
