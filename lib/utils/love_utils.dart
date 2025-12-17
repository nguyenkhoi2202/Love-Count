class LoveUtils {
  static final DateTime startLoveDate = DateTime(2025, 7, 12);

  static int daysInLove() {
    return DateTime.now().difference(startLoveDate).inDays + 1;
  }

  static List<int> milestones = [100, 200, 300, 365, 500, 1000, 2000];

  static DateTime? nextMilestoneDate() {
    final today = DateTime.now();

    for (final m in milestones) {
      final date = startLoveDate.add(Duration(days: m - 1));
      if (date.isAfter(today) || _isSameDay(date, today)) {
        return date;
      }
    }
    return null;
  }

  static int daysToNextMilestone() {
    final date = nextMilestoneDate();
    if (date == null) return 0;
    return date.difference(DateTime.now()).inDays;
  }

  static bool isTodayMilestone() {
    final date = nextMilestoneDate();
    if (date == null) return false;
    return _isSameDay(date, DateTime.now());
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int monthsInLove() {
    final now = DateTime.now();
    int months =
        (now.year - startLoveDate.year) * 12 +
        (now.month - startLoveDate.month);

    if (now.day < startLoveDate.day) {
      months -= 1;
    }

    return months < 0 ? 0 : months;
  }

  // static int daysToNextMilestone() {
  //   final milestones = [100, 200, 300, 365, 500, 1000, 2000];
  //   final current = daysInLove();

  //   for (final m in milestones) {
  //     if (m > current) return m - current;
  //   }
  //   return 0;
  // }
}
