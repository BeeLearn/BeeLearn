import 'dart:developer';

import '../models/base_model.dart';
import '../serializers/streak.dart';
import '../services/date_service.dart';

class StreakModel extends BaseModel<Streak> {
  Streak get todayStreak => items.singleWhere((element) => element.isToday);

  List<Streak> get weekStreaks {
    final (weekStart, weekEnd) = DateService.getWeekStartAndEnd();

    return items.where((streak) {
      final date = streak.date;
      return date.isAtSameMomentAs(weekStart) || date.isAtSameMomentAs(weekEnd) || (date.isAfter(weekStart) && date.isBefore(weekEnd));
    }).toList();
  }

  int get totalCompletedWeekStreaks => weekStreaks.where((streak) => streak.isComplete).length;

  List<DateTime> get completedStreakDates => items.where((streak) => streak.isComplete).map((streak) => streak.date).toList();

  @override
  int getEntityId(Streak item) => item.id;

  @override
  int orderBy(Streak first, Streak second) => first.date.compareTo(second.date);
}
