class DropService {
  static DateTime get todayDropTime {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 20, 0); // 8:00 PM
  }

  static Duration timeRemaining() {
    final now = DateTime.now();
    return todayDropTime.difference(now);
  }

  static bool isLate() {
    return DateTime.now().isAfter(todayDropTime);
  }
}
