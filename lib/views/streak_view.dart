import 'package:clean_calendar/clean_calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

/// Streak analytic and calender calender
class StreakView extends StatelessWidget {
  const StreakView({super.key});

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
        top: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Monthly streaks",
                      style: GoogleFonts.albertSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      "Your monthly streak overview for september",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Consumer<StreakModel>(
            builder: (context, model, child) {
              return CleanCalendar(
                startDateOfCalendar: DateTime(2023, 9, 1),
                endDateOfCalendar: DateTime(2023, 9, 23),
                headerProperties: const HeaderProperties(
                  hide: true,
                ),
                datesForStreaks: model.completedStreakDates,
              );
            },
          ),
        ],
      ),
    );
  }
}
