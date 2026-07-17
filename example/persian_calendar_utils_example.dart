import 'package:persian_calendar_utils/persian_calendar_utils.dart';
import 'package:persian_calendar_utils/src/kurdish/kurdish_date.dart';
import 'package:persian_calendar_utils/src/kurdish/kurdish_utils.dart';

/// A simple demonstration of the library's main capabilities.
void main() {
  print('=== Example usage of persian_calendar_utils ===\n');

  // 1. Today's date in several calendars
  final now = DateTime.now();
  final civilNow = CivilDate(now.year, now.month, now.day);
  final persianNow = PersianDate.fromDate(civilNow);
  final islamicNow = IslamicDate.fromDate(civilNow);
  final nepaliNow = NepaliDate.fromDate(civilNow);
  final kurdishNow = KurdishDate.fromDate(civilNow);

  print('Today (Gregorian): ${gregorianToString(civilNow)}');
  print('Today (Persian):   ${persianToPersianString(persianNow)}');
  print('Today (Islamic):   ${islamicToString(islamicNow)}');
  print('Today (Nepali):    ${nepaliToString(nepaliNow)}');
  print('Today (Kurdish):   ${kurdishToNumericString(kurdishNow)}\n');

  // 2. Date conversion
  final persianDate = PersianDate(1404, 1, 1);
  final gregorianDate = convertToGregorian(persianDate);
  print('1 Farvardin 1404 is equivalent to: ${gregorianToFullString(gregorianDate)}');

  // 3. Difference in days
  final anotherPersian = PersianDate(1404, 12, 29);
  final diff = daysBetween(persianDate, anotherPersian);
  print('Days between 1 Farvardin and 29 Esfand 1404: $diff days\n');

  // 4. Adding days/months/years
  final plusDays = persianAddDays(persianDate, 10);
  final plusMonths = persianAddMonths(persianDate, 1);
  final plusYears = persianAddYears(persianDate, 5);
  print('10 days later:   ${persianToPersianString(plusDays)}');
  print('1 month later:   ${persianToPersianString(plusMonths)}');
  print('5 years later:   ${persianToPersianString(plusYears)}\n');

  // 5. Official holidays for a Persian year (approximate)
  final holidays = persianGetHolidays(1404);
  print('Number of official holidays in 1404 (approximate): ${holidays.length}');
  print('First holiday: ${persianToFullString(holidays.first)}\n');

  // 6. Month grid (for a calendar widget)
  final grid = persianGetMonthGrid(1404, 1);
  print('Grid for Farvardin 1404 (columns: Saturday to Friday):');
  for (var row in grid) {
    print(row.map((d) => d == null ? '  ' : d.toString().padLeft(2)).join(' '));
  }

  // 7. Age calculation
  final birth = PersianDate(1370, 5, 10);
  final age = persianAge(birth, persianNow);
  print('\nAge in Persian calendar: ${age['years']} years, ${age['months']} months, ${age['days']} days');

  // 8. Kurdish calendar example
  final kurdish = KurdishDate(2725, 1, 1);
  print('\nKurdish Newroz: ${kurdishToFullString(kurdish)}');
  print('Gregorian equivalent: ${gregorianToFullString(kurdishToGregorian(kurdish))}');
}