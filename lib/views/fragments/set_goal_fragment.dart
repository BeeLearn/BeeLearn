import 'package:beelearn/widget_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../middlewares/api_middleware.dart';
import '../../models/streak_model.dart';
import '../../models/user_model.dart';

class SetGoalFragment extends StatefulWidget {
  const SetGoalFragment({super.key});

  @override
  State createState() => _SetGoalFragmentState();
}

class _SetGoalFragmentState extends State<SetGoalFragment> {
  bool isLoading = false;

  late int _dailyStreakMinutesGoal;
  late final UserModel _userModel;
  late final StreakModel _streakModel;

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );
    _streakModel = Provider.of<StreakModel>(
      context,
      listen: false,
    );

    _dailyStreakMinutesGoal = _userModel.value.profile!.dailyStreakMinutes;
  }

  Future<void> _updateDailyGoal() async {
    setState(() => isLoading = true);
    final user = _userModel.value;

    await user.setDailyStreakMinutes(_dailyStreakMinutesGoal).then(
      (user) {
        _userModel.value = user;
        _streakModel.todayStreak.currentStreakSeconds = 0;
        Navigator.of(context).pop();

        showSnackBar(
          leading: Icon(
            Icons.check_circle_rounded,
            color: Colors.greenAccent[700],
          ),
          title: "Daily goal updated",
        );
      },
    );

    setState(() => isLoading = false);
  }

  @override
  Widget build(context) {
    return Column(
      children: [
        AppBar(
          elevation: 0,
          leading: const CloseButton(key: profileStreakCardDismissAdjustGoalModalKey),
          backgroundColor: Colors.transparent,
          title: const Text("Daily goal"),
          actions: [
            FilledButton(
              onPressed: _dailyStreakMinutesGoal == _userModel.value.profile!.dailyStreakMinutes ? null : _updateDailyGoal,
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).indicatorColor,
                      ),
                    )
                  : const Text("Done"),
            ),
            const SizedBox(width: 8.0)
          ],
        ),
        Expanded(
          child: SleekCircularSlider(
            min: 1,
            max: 240,
            initialValue: _dailyStreakMinutesGoal.toDouble(),
            appearance: CircularSliderAppearance(
              size: 256,
              animationEnabled: false,
              customColors: CustomSliderColors(
                progressBarColor: Colors.green,
                trackColor: Colors.green[100],
                hideShadow: true,
              ),
              infoProperties: InfoProperties(
                mainLabelStyle: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 256 / 5.0,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
                modifier: (percentage) {
                  return "${percentage.round()} min";
                },
              ),
            ),
            onChangeEnd: (double value) async {
              setState(
                () => _dailyStreakMinutesGoal = value.toInt(),
              );
            },
          ),
        ),
      ],
    );
  }
}
