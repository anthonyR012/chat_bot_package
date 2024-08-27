class FormatDataUtil {
  String getCurrentHour({DateTime? now}) {
    now = now ?? DateTime.now();
    final int currentHour = now.hour;
    final int currentMinute = now.minute;
    int hour12 = currentHour % 12 == 0 ? 12 : currentHour % 12;
    String minuteStr = currentMinute.toString().padLeft(2, '0');
    String period = currentHour >= 12 ? 'PM' : 'AM';
    return "$hour12:$minuteStr $period";
  }
}
