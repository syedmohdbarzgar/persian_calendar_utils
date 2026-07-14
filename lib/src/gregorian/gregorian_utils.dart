// Category 3: Gregorian-calendar (CivilDate) specific functions — 23
// functions (#45 through #67).
//
// Weekday convention: the Gregorian week in this file starts on Monday
// (the ISO 8601 standard and the most common global convention), which is
// exactly the canonical order defined in core/generic.dart (0=Monday ...
// 6=Sunday), so gregorianGetMonthGrid needs no extra remapping.

import 'package:persian_calendar/persian_calendar.dart';

import '../core/generic.dart';

const List<String> _gregorianMonthNames = [
  'January', 'February', 'March', 'April', 'May', 'June', //
  'July', 'August', 'September', 'October', 'November', 'December',
];
const List<String> _gregorianMonthNamesShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
// Canonical order (Monday=0 ... Sunday=6)
const List<String> _weekdayNames = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', //
  'Sunday',
];
const List<String> _weekdayNamesShort = [
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', //
];

CivilDate _todayGregorian() {
  final now = DateTime.now();
  return CivilDate(now.year, now.month, now.day);
}

/// (45) Numeric display of a Gregorian date as YYYY-MM-DD.
///
/// Example: `gregorianToString(CivilDate(2025, 3, 21))` → `'2025-03-21'`
String gregorianToString(CivilDate date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.dayOfMonth.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// (46) Full display of a Gregorian date including weekday name and month
/// name.
///
/// Example: `gregorianToFullString(CivilDate(2025, 3, 21))` →
/// `'Friday, March 21, 2025'`
String gregorianToFullString(CivilDate date) {
  final weekday = gregorianWeekdayName(date);
  final month = gregorianMonthName(date.month);
  return '$weekday, $month ${date.dayOfMonth}, ${date.year}';
}

/// (47) Formats a Gregorian date using a custom pattern.
///
/// Tokens: `YYYY`, `YY`, `MMMM` (month name), `MMM` (short month name),
/// `MM`, `M`, `DDDD` (weekday name), `DDD` (short weekday name), `DD`, `D`.
///
/// Example: `gregorianFormat(CivilDate(2025, 3, 21), 'DD MMM YYYY')` →
/// `'21 Mar 2025'`
String gregorianFormat(CivilDate date, String pattern) {
  final tokens = <String, String Function()>{
    'YYYY': () => date.year.toString().padLeft(4, '0'),
    'YY': () => (date.year % 100).toString().padLeft(2, '0'),
    'MMMM': () => gregorianMonthName(date.month),
    'MMM': () => gregorianMonthNameShort(date.month),
    'MM': () => date.month.toString().padLeft(2, '0'),
    'M': () => date.month.toString(),
    'DDDD': () => gregorianWeekdayName(date),
    'DDD': () => gregorianWeekdayNameShort(date),
    'DD': () => date.dayOfMonth.toString().padLeft(2, '0'),
    'D': () => date.dayOfMonth.toString(),
  };
  final orderedKeys = tokens.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  final regex = RegExp(orderedKeys.map(RegExp.escape).join('|'));
  return pattern.replaceAllMapped(regex, (m) => tokens[m[0]]!());
}

/// (48) Formats a Gregorian date using strftime-style (C language)
/// patterns.
///
/// Tokens: `%Y`, `%y`, `%m`, `%d`, `%A`, `%a`, `%B`, `%b`, `%j`, `%%`.
///
/// Example: `gregorianFormatStrftime(CivilDate(2025, 3, 21), '%d/%m/%Y')` →
/// `'21/03/2025'`
String gregorianFormatStrftime(CivilDate date, String format) {
  final tokens = <String, String>{
    '%Y': date.year.toString().padLeft(4, '0'),
    '%y': (date.year % 100).toString().padLeft(2, '0'),
    '%m': date.month.toString().padLeft(2, '0'),
    '%d': date.dayOfMonth.toString().padLeft(2, '0'),
    '%A': gregorianWeekdayName(date),
    '%a': gregorianWeekdayNameShort(date),
    '%B': gregorianMonthName(date.month),
    '%b': gregorianMonthNameShort(date.month),
    '%j': gregorianDayOfYear(date).toString().padLeft(3, '0'),
    '%%': '%',
  };
  final orderedKeys = tokens.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  final regex = RegExp(orderedKeys.map(RegExp.escape).join('|'));
  return format.replaceAllMapped(regex, (m) => tokens[m[0]]!);
}

/// (49) Converts a Gregorian date to a Persian date.
PersianDate gregorianToPersian(CivilDate date) => PersianDate.fromDate(date);

/// (50) Converts a Gregorian date to an Islamic date.
IslamicDate gregorianToIslamic(CivilDate date) => IslamicDate.fromDate(date);

/// (51) Converts a Gregorian date to a Nepali date.
NepaliDate gregorianToNepali(CivilDate date) => NepaliDate.fromDate(date);

/// (52) Is the Gregorian year a leap year? (Divisible by 4, unless it is
/// divisible by 100 and not by 400.)
///
/// Example: `isGregorianLeapYear(2024)` → `true`, `isGregorianLeapYear(2025)` → `false`
bool isGregorianLeapYear(int year) {
  if (year % 4 != 0) return false;
  if (year % 100 != 0) return true;
  return year % 400 == 0;
}

/// (53) The full English name of the weekday.
String gregorianWeekdayName(CivilDate date) => _weekdayNames[date.toJdn() % 7];

/// (54) The short English name of the weekday.
String gregorianWeekdayNameShort(CivilDate date) =>
    _weekdayNamesShort[date.toJdn() % 7];

/// (55) The full English name of a month (1 to 12).
String gregorianMonthName(int month) => _gregorianMonthNames[month - 1];

/// (56) The short English name of a month.
String gregorianMonthNameShort(int month) =>
    _gregorianMonthNamesShort[month - 1];

/// (57) Adds (or subtracts) a number of days to a Gregorian date.
CivilDate gregorianAddDays(CivilDate date, int days) =>
    CivilDate.fromJdn(date.toJdn() + days);

/// (58) Adds (or subtracts) a number of months; the day is clamped to the
/// last day of the target month if needed (e.g. January 31 + 1 month =
/// February 28/29, not an overflow into March).
CivilDate gregorianAddMonths(CivilDate date, int months) {
  final totalMonths = date.year * 12 + (date.month - 1) + months;
  final newYear = (totalMonths - totalMonths % 12) ~/ 12;
  final newMonth = totalMonths % 12 + 1;
  final maxDay = getMonthDays(newYear, newMonth, CivilDate.new);
  final newDay = date.dayOfMonth > maxDay ? maxDay : date.dayOfMonth;
  return CivilDate(newYear, newMonth, newDay);
}

/// (59) Adds (or subtracts) a number of years; the day is clamped if needed
/// (for February 29 in non-leap years).
CivilDate gregorianAddYears(CivilDate date, int years) {
  final newYear = date.year + years;
  final maxDay = getMonthDays(newYear, date.month, CivilDate.new);
  final newDay = date.dayOfMonth > maxDay ? maxDay : date.dayOfMonth;
  return CivilDate(newYear, date.month, newDay);
}

/// (60) Computes exact age in Gregorian-calendar years, months, and days.
///
/// Parameters:
/// - [birthDate]: the date of birth.
/// - [today]: the reference date; if omitted, the current system date is
///   used.
///
/// Returns: a map with the keys `years`, `months`, `days`.
Map<String, int> gregorianAge(CivilDate birthDate, [CivilDate? today]) {
  final now = today ?? _todayGregorian();
  var years = now.year - birthDate.year;
  var months = now.month - birthDate.month;
  var days = now.dayOfMonth - birthDate.dayOfMonth;
  if (days < 0) {
    final prevMonth = now.month == 1 ? 12 : now.month - 1;
    final prevYear = now.month == 1 ? now.year - 1 : now.year;
    days += getMonthDays(prevYear, prevMonth, CivilDate.new);
    months -= 1;
  }
  if (months < 0) {
    months += 12;
    years -= 1;
  }
  return {'years': years, 'months': months, 'days': days};
}

/// (61) The total number of days in a Gregorian year (365 or 366).
int gregorianDaysInYear(int year) => isGregorianLeapYear(year) ? 366 : 365;

/// (62) The day-of-year number for a Gregorian date (1 to 365 or 366).
int gregorianDayOfYear(CivilDate date) =>
    date.toJdn() - CivilDate(date.year, 1, 1).toJdn() + 1;

/// (63) The ISO 8601 week-of-year number (week 1 is the week containing the
/// year's first Thursday).
int gregorianWeekOfYear(CivilDate date) {
  final jdn = date.toJdn();
  final canonicalWeekday = jdn % 7; // 0=Monday ... 6=Sunday
  final thursdayJdn = jdn + 3 - canonicalWeekday;
  final isoYear = CivilDate.fromJdn(thursdayJdn).year;
  final isoYearJan1Jdn = CivilDate(isoYear, 1, 1).toJdn();
  return ((thursdayJdn - isoYearJan1Jdn) ~/ 7) + 1;
}

/// (64) Is this date equal to today (based on the system clock)?
bool gregorianIsToday(CivilDate date) => isSameDay(date, _todayGregorian());

/// (65) Is this date a weekend day (Saturday or Sunday)?
bool gregorianIsWeekend(CivilDate date) {
  final canonical = date.toJdn() % 7; // 0=Monday ... 6=Sunday
  return canonical == 5 || canonical == 6; // Saturday or Sunday
}

/// (66) Is this date a working day (Monday through Friday)?
bool gregorianIsWeekday(CivilDate date) => !gregorianIsWeekend(date);

/// (67) A 6x7 grid of the days of a Gregorian month, for rendering a
/// calendar widget.
///
/// Each row is a week starting on Monday (ISO standard). Cells outside the
/// range of the month are filled with `null`.
List<List<int?>> gregorianGetMonthGrid(int year, int month) {
  final firstDayCanonical = getFirstDayOfMonth(year, month, CivilDate.new);
  final daysInMonth = getMonthDays(year, month, CivilDate.new);

  final grid = List.generate(6, (_) => List<int?>.filled(7, null));
  var day = 1;
  for (var week = 0; week < 6 && day <= daysInMonth; week++) {
    for (var col = 0; col < 7; col++) {
      if (week == 0 && col < firstDayCanonical) continue;
      if (day > daysInMonth) continue;
      grid[week][col] = day;
      day++;
    }
  }
  return grid;
}
