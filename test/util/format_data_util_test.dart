import 'package:chat_bot/util/format_data_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('handles_midnight_correctly', handlesMidnightCorrectly);
  test('returns_correct_12_hour_format_with_am_pm',
      returnsCorrect12hourFormatWithAmPm);
}

void handlesMidnightCorrectly() {
  final formatDataUtil = FormatDataUtil();
  final now = DateTime(2023, 10, 5, 0, 0);
  final result = formatDataUtil.getCurrentHour(now: now);
  expect(result, "12:00 AM");
}

void returnsCorrect12hourFormatWithAmPm() {
  final formatDataUtil = FormatDataUtil();
  final now = DateTime(2023, 10, 5, 15, 30);
  final result = formatDataUtil.getCurrentHour(now: now);
  expect(result, "3:30 PM");
}
