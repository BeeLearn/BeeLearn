import "package:flutter/material.dart";

class StreakCalender extends StatelessWidget {
  final List<String> days = ["M", "T", "W", "T", "F", "S", "S"];

  StreakCalender({super.key});

  @override
  Widget build(context) {
    return Container(
      height: 48.0,
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ListView.builder(
        itemCount: days.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final day = days[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day,
                style: const TextStyle(color: Colors.green),
              ),
            ),
          );
        },
      ),
    );
  }
}
