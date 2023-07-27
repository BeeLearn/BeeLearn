import 'package:beelearn/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SetGoalFragment extends StatefulWidget {
  const SetGoalFragment({super.key});

  @override
  State createState() => _SetGoalFragmentState();
}

class _SetGoalFragmentState extends State<SetGoalFragment> {
  bool isLoading = false;
  late int dailyStreakMinutesGoal;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserModel>(context, listen: false).user;
    setState(() {
      dailyStreakMinutesGoal = user.profile.dailyStreakMinutes;
    });
  }

  @override
  Widget build(context) {
    return Column(
      children: [
        AppBar(
          elevation: 0,
          leading: const CloseButton(),
          backgroundColor: Colors.transparent,
          title: const Text("Daily goal"),
          actions: [
            FilledButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                UserModel userModel = Provider.of<UserModel>(context, listen: false);
                final user = userModel.user;

                return user.setDailyStreakMinutes(dailyStreakMinutesGoal).then(
                  (user) {
                    userModel.setUser(user);
                    Navigator.of(context).pop();
                  },
                ).whenComplete(() {
                  setState(() {
                    isLoading = false;
                  });
                });
              },
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
            initialValue: dailyStreakMinutesGoal.toDouble(),
            appearance: CircularSliderAppearance(
              size: 256,
              animationEnabled: false,
              customColors: CustomSliderColors(
                progressBarColor: Colors.green,
                trackColor: Colors.green[100],
                hideShadow: true,
              ),
              infoProperties: InfoProperties(
                modifier: (percentage) {
                  return "${percentage.round()} min";
                },
              ),
            ),
            onChangeEnd: (double value) async {
              setState(() {
                dailyStreakMinutesGoal = value.toInt();
              });
            },
          ),
        ),
      ],
    );
  }
}
