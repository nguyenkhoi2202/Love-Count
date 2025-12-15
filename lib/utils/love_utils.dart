class LoveUtils {
  static final DateTime startLoveDate = DateTime(2025, 7, 12);

  static int daysInLove() {
    return DateTime.now().difference(startLoveDate).inDays + 1;
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

  static int daysToNextMilestone() {
    final milestones = [100, 200, 300, 365, 500, 1000, 2000];
    final current = daysInLove();

    for (final m in milestones) {
      if (m > current) return m - current;
    }
    return 0;
  }
}
