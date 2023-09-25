import 'package:intl/intl.dart' show DateFormat;

class DateService {
  static final defaultFormatter = DateFormat('yyyy-MM-dd');

  static (DateTime, DateTime) getWeekStartAndEnd() {
    final today = DateTime.now();
    final weekEnd = today.subtract(Duration(days: today.weekday - 7));
    final weekStart = weekEnd.subtract(const Duration(days: 7));

    return (weekStart, weekEnd);
  }

  static (DateTime, DateTime) getMonthStartAndEnd() {
    final today = DateTime.now();
    final currentMonth = DateTime(today.year, today.month);
    final nextMonth = DateTime(today.year, today.month + 1);

    return (
      currentMonth,
      nextMonth,
    );
  }
}
