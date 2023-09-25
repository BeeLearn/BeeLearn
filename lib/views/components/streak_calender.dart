import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../serializers/streak.dart";

class StreakCalender extends StatelessWidget {
  final List<Streak> streaks;

  const StreakCalender({
    super.key,
    required this.streaks,
  });

  @override
  Widget build(context) {
    return Container(
      height: 48.0,
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ListView.builder(
        itemCount: streaks.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final streak = streaks[index];
          final activeColor = streak.isComplete ? Colors.green : Colors.grey;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: activeColor),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                DateFormat("dd").format(streak.date),
                style: TextStyle(color: activeColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
