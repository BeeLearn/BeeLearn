import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:step_progress_indicator/step_progress_indicator.dart';

import "../../models/streak_model.dart";
import "../../models/user_model.dart";
import "../../views/fragments/set_goal_fragment.dart";
import "streak_calender.dart";

class StreakCard extends StatefulWidget {
  const StreakCard({super.key});

  @override
  State createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard> {
  @override
  void initState() {
    super.initState();
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
            child: Flex(
              direction: Axis.vertical,
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
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer2<UserModel, StreakModel>(
                        builder: (context, userModel, streakModel, child) {
                          final user = userModel.value;

                          /// Todo switch to a more explicit method
                          final isStreakComplete = streakModel.items.isEmpty ? false : streakModel.todayStreak.isComplete;
                          //final dailyStreakSeconds = streakModel.items.isEmpty ? 0 : streakModel.todayStreak.currentStreakSeconds;
                          final dailyStreakMinutes = streakModel.items.isEmpty ? 0 : streakModel.todayStreak.currentStreakMinutes;

                          return CircularStepProgressIndicator(
                            width: 156,
                            height: 156,
                            padding: 0,
                            totalSteps: user.profile!.dailyStreakMinutes,
                            currentStep: dailyStreakMinutes,
                            unselectedColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[300] : Colors.grey,
                            selectedColor: Theme.of(context).brightness == Brightness.dark ? Colors.green : Colors.greenAccent[400],
                            child: Center(
                              child: isStreakComplete
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: 72,
                                      color: Theme.of(context).brightness == Brightness.dark ? Colors.green : Colors.greenAccent[400],
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
                              if(MediaQuery.of(context).orientation == Orientation.portrait){
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => const SetGoalFragment(),
                                );
                              } else {
                                showBottomSheet(
                                  context: context,
                                  builder: (context) => const SetGoalFragment(),
                                );
                              }
                            },
                            child: const Text("Adjust goal"),
                          ),
                          FilledButton.tonal(
                            onPressed: () {},
                            child: const Text("Share"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Consumer<StreakModel>(
                      builder: (context, model, child) {
                        return StreakCalender(streaks: model.weekStreaks);
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
                        Expanded(
                          child: Consumer<StreakModel>(
                            builder: (context, model, child) {
                              return Text("My streak is ${model.totalCompletedWeekStreaks} day");
                            },
                          ),
                        ),
                      ],
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
