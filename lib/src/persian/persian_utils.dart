// Category 2: Persian-calendar (PersianDate) specific functions — 30
// functions (#15 through #44).
//
// Weekday convention: following core/generic.dart, the canonical weekday
// index is 0=Monday, 1=Tuesday, 2=Wednesday, 3=Thursday, 4=Friday,
// 5=Saturday, 6=Sunday (i.e. `jdn % 7`). The Iranian week starts on
// Saturday, so persianGetMonthGrid/persianGetWeekGrid use the remapping
// `(canonical + 2) % 7` to map onto Saturday=0 ... Friday=6 columns.
//
// Note: the native-script functions (persianMonthName, persianWeekdayName,
// persianWeekdayNameShort, persianSeason, persianZodiacSign, and the holiday
// names implicit in persianGetHolidays) intentionally return Persian-script
// strings, since producing correct Persian calendar terminology is the
// whole point of this calendar. English-language variants are provided
// separately where the original spec asked for them (e.g.
// persianMonthNameEn, persianWeekdayNameEn). All comments/documentation in
// this file are in English as requested.

import 'package:persian_calendar/persian_calendar.dart';

import '../core/generic.dart';

const List<String> _persianMonthNamesFa = [
  'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور', //
  'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند',
];

const List<String> _persianMonthNamesEn = [
  'Farvardin', 'Ordibehesht', 'Khordad', 'Tir', 'Mordad', 'Shahrivar', //
  'Mehr', 'Aban', 'Azar', 'Dey', 'Bahman', 'Esfand',
];

// Canonical order (Monday=0 ... Sunday=6)
const List<String> _weekdayNamesFa = [
  'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه', 'شنبه', 'یکشنبه', //
];
const List<String> _weekdayNamesEn = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', //
  'Sunday',
];
const List<String> _weekdayNamesShortFa = [
  'د', 'س', 'چ', 'پ', 'ج', 'ش', 'ی', //
];

const List<String> _zodiacSigns = [
  'حمل', 'ثور', 'جوزا', 'سرطان', 'اسد', 'سنبله', //
  'میزان', 'عقرب', 'قوس', 'جدی', 'دلو', 'حوت',
];

const Map<String, String> _persianDigitsMap = {
  '0': '۰', '1': '۱', '2': '۲', '3': '۳', '4': '۴', //
  '5': '۵', '6': '۶', '7': '۷', '8': '۸', '9': '۹',
};

/// Converts a string of Latin digits to Persian digits; used to render the
/// output of functions like [persianToPersianString] and
/// [persianToFullString].
String _toPersianDigits(String input) =>
    input.split('').map((c) => _persianDigitsMap[c] ?? c).join();

/// Today's date in the Persian calendar, based on the system clock.
PersianDate _todayPersian() {
  final now = DateTime.now();
  return PersianDate.fromDate(CivilDate(now.year, now.month, now.day));
}

/// (15) Numeric display of a Persian date using Persian digits, as
/// YYYY/MM/DD.
///
/// Example: `persianToPersianString(PersianDate(1404, 1, 1))` → `'۱۴۰۴/۰۱/۰۱'`
String persianToPersianString(PersianDate date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.dayOfMonth.toString().padLeft(2, '0');
  return _toPersianDigits('$y/$m/$d');
}

/// (16) Full display of a Persian date including weekday name and month
/// name.
///
/// Example: `persianToFullString(PersianDate(1404, 1, 1))` →
/// `'جمعه ۱ فروردین ۱۴۰۴'`
String persianToFullString(PersianDate date) {
  final weekday = persianWeekdayName(date);
  final month = persianMonthName(date.month);
  final day = _toPersianDigits(date.dayOfMonth.toString());
  final year = _toPersianDigits(date.year.toString());
  return '$weekday $day $month $year';
}

/// (17) Formats a Persian date using a custom pattern.
///
/// Supported tokens: `YYYY`, `YY`, `MMMM` (month name), `MM`, `M`, `DDDD`
/// (weekday name), `DD`, `D`. Numbers in this function use Latin digits
/// (unlike [persianToPersianString]).
///
/// Example: `persianFormat(PersianDate(1404, 1, 1), 'DD MMMM YYYY')` →
/// `'01 فروردین 1404'`
String persianFormat(PersianDate date, String pattern) {
  final tokens = <String, String Function()>{
    'YYYY': () => date.year.toString().padLeft(4, '0'),
    'YY': () => (date.year % 100).toString().padLeft(2, '0'),
    'MMMM': () => persianMonthName(date.month),
    'MM': () => date.month.toString().padLeft(2, '0'),
    'M': () => date.month.toString(),
    'DDDD': () => persianWeekdayName(date),
    'DD': () => date.dayOfMonth.toString().padLeft(2, '0'),
    'D': () => date.dayOfMonth.toString(),
  };
  final orderedKeys = tokens.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  final regex = RegExp(orderedKeys.map(RegExp.escape).join('|'));
  return pattern.replaceAllMapped(regex, (m) => tokens[m[0]]!());
}

/// (18) Formats a Persian date using strftime-style (C language) patterns.
///
/// Supported tokens: `%Y`, `%y`, `%m`, `%d`, `%A` (full weekday name), `%a`
/// (short weekday name), `%B` (month name), `%b` (month name), `%j` (day of
/// year), `%%`.
///
/// Example: `persianFormatStrftime(PersianDate(1404, 1, 1), '%Y/%m/%d')` →
/// `'1404/01/01'`
String persianFormatStrftime(PersianDate date, String format) {
  final tokens = <String, String>{
    '%Y': date.year.toString().padLeft(4, '0'),
    '%y': (date.year % 100).toString().padLeft(2, '0'),
    '%m': date.month.toString().padLeft(2, '0'),
    '%d': date.dayOfMonth.toString().padLeft(2, '0'),
    '%A': persianWeekdayName(date),
    '%a': persianWeekdayNameShort(date),
    '%B': persianMonthName(date.month),
    '%b': persianMonthName(date.month),
    '%j': persianDayOfYear(date).toString().padLeft(3, '0'),
    '%%': '%',
  };
  final orderedKeys = tokens.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  final regex = RegExp(orderedKeys.map(RegExp.escape).join('|'));
  return format.replaceAllMapped(regex, (m) => tokens[m[0]]!);
}

/// (19) Converts a Persian date to a Gregorian date.
///
/// Example: `persianToGregorian(PersianDate(1404, 1, 1))` → `CivilDate(2025, 3, 21)`
CivilDate persianToGregorian(PersianDate date) => CivilDate.fromDate(date);

/// (20) Converts a Persian date to an Islamic date (based on whichever
/// calculation method is active in [IslamicDate.useUmmAlQura]).
IslamicDate persianToIslamic(PersianDate date) => IslamicDate.fromDate(date);

/// (21) Converts a Persian date to a Nepali date.
NepaliDate persianToNepali(PersianDate date) => NepaliDate.fromDate(date);

/// (22) Is the given Persian year a leap year (i.e. does Esfand have 30
/// days)?
///
/// Instead of the approximate 33-year-cycle formula, this function uses the
/// library's own astronomical calculation directly (via
/// [persianDaysInYear]), so it always stays consistent with the actual
/// output of [PersianDate].
///
/// Example: `isPersianLeapYear(1403)` → `true`, `isPersianLeapYear(1404)` → `false`
bool isPersianLeapYear(int year) => persianDaysInYear(year) == 366;

/// (23) The Persian name of the weekday of a Persian date.
String persianWeekdayName(PersianDate date) =>
    _weekdayNamesFa[date.toJdn() % 7];

/// (24) The English name of the weekday of a Persian date.
String persianWeekdayNameEn(PersianDate date) =>
    _weekdayNamesEn[date.toJdn() % 7];

/// (25) The short (single-letter) Persian weekday name.
String persianWeekdayNameShort(PersianDate date) =>
    _weekdayNamesShortFa[date.toJdn() % 7];

/// (26) The Persian name of a Persian month (1 to 12).
String persianMonthName(int month) => _persianMonthNamesFa[month - 1];

/// (27) The English (transliterated) name of a Persian month.
String persianMonthNameEn(int month) => _persianMonthNamesEn[month - 1];

/// (28) The season of the year based on the Persian month number.
///
/// Example: `persianSeason(1)` → `'بهار'` (spring), `persianSeason(10)` →
/// `'زمستان'` (winter)
String persianSeason(int month) {
  if (month >= 1 && month <= 3) return 'بهار';
  if (month >= 4 && month <= 6) return 'تابستان';
  if (month >= 7 && month <= 9) return 'پاییز';
  return 'زمستان';
}

/// (29) The zodiac sign matching the birth month (the Persian calendar's
/// months align exactly with the astronomical zodiac signs).
String persianZodiacSign(PersianDate date) => _zodiacSigns[date.month - 1];

/// (30) Adds (or subtracts, with a negative number) a number of days to a
/// Persian date.
PersianDate persianAddDays(PersianDate date, int days) =>
    PersianDate.fromJdn(date.toJdn() + days);

/// (31) Adds (or subtracts) a number of months to a Persian date; if the day
/// exceeds the length of the target month, it is clamped to the last day of
/// that month (e.g. 31 Farvardin + 11 months = 29 or 30 Esfand, not an
/// overflow into the next month).
PersianDate persianAddMonths(PersianDate date, int months) {
  final totalMonths = date.year * 12 + (date.month - 1) + months;
  final newYear = (totalMonths - totalMonths % 12) ~/ 12;
  final newMonth = totalMonths % 12 + 1;
  final maxDay = getMonthDays(newYear, newMonth, PersianDate.new);
  final newDay = date.dayOfMonth > maxDay ? maxDay : date.dayOfMonth;
  return PersianDate(newYear, newMonth, newDay);
}

/// (32) Adds (or subtracts) a number of years to a Persian date; the day is
/// clamped to the last day of the same month in the target year if needed
/// (for the 29th/30th of Esfand).
PersianDate persianAddYears(PersianDate date, int years) {
  final newYear = date.year + years;
  final maxDay = getMonthDays(newYear, date.month, PersianDate.new);
  final newDay = date.dayOfMonth > maxDay ? maxDay : date.dayOfMonth;
  return PersianDate(newYear, date.month, newDay);
}

/// (33) Computes exact age in Persian-calendar years, months, and days.
///
/// Parameters:
/// - [birthDate]: the date of birth.
/// - [today]: the reference date for the calculation; if omitted, the
///   current system date is used.
///
/// Returns: a map with the keys `years`, `months`, `days`.
///
/// Example:
/// ```dart
/// persianAge(PersianDate(1370, 5, 10), PersianDate(1404, 1, 1));
/// // {'years': 33, 'months': 7, 'days': 21}
/// ```
Map<String, int> persianAge(PersianDate birthDate, [PersianDate? today]) {
  final now = today ?? _todayPersian();
  var years = now.year - birthDate.year;
  var months = now.month - birthDate.month;
  var days = now.dayOfMonth - birthDate.dayOfMonth;
  if (days < 0) {
    final prevMonth = now.month == 1 ? 12 : now.month - 1;
    final prevYear = now.month == 1 ? now.year - 1 : now.year;
    days += getMonthDays(prevYear, prevMonth, PersianDate.new);
    months -= 1;
  }
  if (months < 0) {
    months += 12;
    years -= 1;
  }
  return {'years': years, 'months': months, 'days': days};
}

/// (34) The total number of days in a Persian year (365 or 366).
int persianDaysInYear(int year) {
  final thisYearStart = PersianDate(year, 1, 1).toJdn();
  final nextYearStart = PersianDate(year + 1, 1, 1).toJdn();
  return nextYearStart - thisYearStart;
}

/// (35) The day-of-year number for a Persian date (1 to 365 or 366).
int persianDayOfYear(PersianDate date) =>
    date.toJdn() - PersianDate(date.year, 1, 1).toJdn() + 1;

/// (36) The week-of-year number; every 7 days from the start of Farvardin
/// counts as one week (this is a simple sequential week number, not the ISO
/// standard, which was designed specifically for the Gregorian calendar).
int persianWeekOfYear(PersianDate date) =>
    ((persianDayOfYear(date) - 1) ~/ 7) + 1;

/// (37) Is this date equal to today (based on the system clock)?
bool persianIsToday(PersianDate date) => isSameDay(date, _todayPersian());

/// (38) Is this date a Friday?
bool persianIsFriday(PersianDate date) => date.toJdn() % 7 == 4;

/// (39) Is this date a weekend day (Friday, Iran's official weekly
/// holiday)?
bool persianIsWeekend(PersianDate date) => persianIsFriday(date);

/// (40) Is this date a working day (Saturday through Thursday)?
bool persianIsWeekday(PersianDate date) => !persianIsWeekend(date);

// Fixed Persian-calendar holidays: [month, day]
const List<List<int>> _fixedPersianHolidays = [
  [1, 1], [1, 2], [1, 3], [1, 4], // Nowruz
  [1, 12], // Islamic Republic Day
  [1, 13], // Sizdah Bedar (Nature Day)
  [3, 14], // Death of Ayatollah Khomeini
  [3, 15], // 15 Khordad uprising
  [11, 22], // Anniversary of the Islamic Revolution
  [12, 29], // Oil Nationalization Day
];

// Lunar holidays with a fixed Hijri (Islamic) date: [month, day], which
// fall on a different Persian date each year and must be computed via
// IslamicDate.
const List<List<int>> _lunarPersianHolidays = [
  [1, 9], // Tasu'a
  [1, 10], // Ashura
  [2, 20], // Arba'een
  [3, 17], // Mawlid (birth of the Prophet)
  [7, 13], // Birth of Imam Ali
  [7, 27], // Mab'ath (the Prophet's first revelation)
  [9, 21], // Martyrdom of Imam Ali
  [10, 1], // Eid al-Fitr
  [12, 9], // Day of Arafah
  [12, 10], // Eid al-Adha
  [12, 18], // Eid al-Ghadir
];

/// (41) An approximate list of official Iranian holidays in a given Persian
/// year.
///
/// This list includes fixed solar holidays and religious lunar holidays
/// (mapped to Persian dates via [IslamicDate], following whichever
/// calculation method is active in [IslamicDate.useUmmAlQura]). **This list
/// is neither exhaustive nor official** and may differ by a day from the
/// official moon-sighting announcement; for legal/administrative purposes it
/// should be cross-checked against an official government source.
List<PersianDate> persianGetHolidays(int year) {
  final holidays = <PersianDate>[
    for (final f in _fixedPersianHolidays) PersianDate(year, f[0], f[1]),
  ];

  final yearStartHijri = IslamicDate.fromDate(PersianDate(year, 1, 1)).year;
  final lastDayJdn =
      PersianDate(year, 1, 1).toJdn() + persianDaysInYear(year) - 1;
  final yearEndHijri = IslamicDate.fromJdn(lastDayJdn).year;

  final candidateHijriYears = {
    yearStartHijri,
    yearEndHijri,
    yearStartHijri + 1,
  };
  for (final hijriYear in candidateHijriYears) {
    for (final lh in _lunarPersianHolidays) {
      final equivalent = PersianDate.fromDate(
        IslamicDate(hijriYear, lh[0], lh[1]),
      );
      if (equivalent.year == year) holidays.add(equivalent);
    }
  }

  holidays.sort((a, b) => a.toJdn().compareTo(b.toJdn()));
  return holidays;
}

/// (42) Is this date an official holiday? (Either a Friday, or one of the
/// dates from [persianGetHolidays].)
bool persianIsHoliday(PersianDate date) {
  if (persianIsFriday(date)) return true;
  return persianGetHolidays(date.year).any((h) => isSameDay(h, date));
}

/// (43) A 6x7 grid of the days of a Persian month, for rendering a calendar
/// widget.
///
/// Each row is a week starting on Saturday (columns: Saturday, Sunday,
/// Monday, Tuesday, Wednesday, Thursday, Friday). Cells outside the range
/// of the month are filled with `null`.
List<List<int?>> persianGetMonthGrid(int year, int month) {
  final firstDayCanonical = getFirstDayOfMonth(year, month, PersianDate.new);
  // Map from canonical order (Monday=0) to Iranian order (Saturday=0)
  final firstDaySaturdayIndexed = (firstDayCanonical + 2) % 7;
  final daysInMonth = getMonthDays(year, month, PersianDate.new);

  final grid = List.generate(6, (_) => List<int?>.filled(7, null));
  var day = 1;
  for (var week = 0; week < 6 && day <= daysInMonth; week++) {
    for (var col = 0; col < 7; col++) {
      if (week == 0 && col < firstDaySaturdayIndexed) continue;
      if (day > daysInMonth) continue;
      grid[week][col] = day;
      day++;
    }
  }
  return grid;
}

/// (44) The days of a specific week (by row index, starting at 0) in a
/// Persian month.
///
/// If [weekIndex] is out of range for the month's grid, a list of seven
/// `null` values is returned.
List<int?> persianGetWeekGrid(int year, int month, int weekIndex) {
  final grid = persianGetMonthGrid(year, month);
  if (weekIndex < 0 || weekIndex >= grid.length) {
    return List<int?>.filled(7, null);
  }
  return grid[weekIndex];
}
