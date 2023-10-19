import 'package:beelearn/widget_keys.dart';
import 'package:clean_calendar/clean_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

/// Streak analytic and calender calender
class StreakView extends StatelessWidget {
  const StreakView({super.key});

  @override
  Widget build(context) {
    final currentDate = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: kDebugMode
          ? AppBar(
              backgroundColor: Colors.transparent,
              leading: const CloseButton(key: streakModalDismissButtonKey),
            )
          : null,
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
            top: kReleaseMode ? 16.0 : 0,
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
                        Text(
                          "Your monthly streak overview for ${DateFormat("MMMM").format(currentDate)}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Consumer<StreakModel>(
                builder: (context, model, child) {
                  final monthStart = DateTime(currentDate.year, currentDate.month);
                  final monthEnd = DateTime(currentDate.year, currentDate.month + 1, 0);

                  return CleanCalendar(
                    startDateOfCalendar: monthStart,
                    endDateOfCalendar: monthEnd,
                    headerProperties: const HeaderProperties(
                      hide: true,
                    ),
                    datesForStreaks: model.completedStreakDates,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
