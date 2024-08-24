class FormatDataUtil {
  String getCurrentHour() {
    final now = DateTime.now();
    final int currentHour = now.hour;
    final int currentMinute = now.minute;
    int hour12 = currentHour > 12 ? currentHour - 12 : currentHour;
    String period = currentHour >= 12 ? 'PM' : 'AM';
    return "$hour12:$currentMinute $period";
  }
}
