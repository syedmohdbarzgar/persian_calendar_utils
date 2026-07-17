// Kurdish-calendar (KurdishDate) specific functions, mirroring the style
// and conventions of src/persian/persian_utils.dart.
//
// Weekday convention: same as the rest of the package (0=Monday ...
// 6=Sunday, i.e. `jdn % 7`); kurdishWeekdayName/kurdishGetMonthGrid remap
// this onto the Saturday-first week used across the region, exactly like
// persianGetMonthGrid does.
//
// A note on sourcing: unlike the Persian month names (which are
// standardized), Kurdish month names have some regional/dialectal
// variation (Kurmanji vs. Sorani, and older vs. newer usage -- e.g. month 2
// is called both "Gulan" and "Banemerr", and month 8 both "Gelarêzan" and
// "Xezelwer" in different sources). The lists below use the romanization
// most common in international/diaspora usage (matching, e.g., Kurdish
// calendar converters and media) for the Latin names, and the spelling
// used by present-day Sorani calendars for the native-script names.
import 'package:persian_calendar/persian_calendar.dart';

import '../core/generic.dart';
import 'kurdish_date.dart';

const List<String> _kurdishMonthNamesSorani = [
  'خاکەلێوە', 'بانەمەڕ', 'جۆزەردان', 'پووشپەڕ', 'گەلاوێژ', 'خەرمانان', //
  'ڕەزبەر', 'خەزەڵوەر', 'سەرماوەز', 'بەفرانبار', 'ڕێبەندان', 'ڕەشەمە',
];

const List<String> _kurdishMonthNamesLatin = [
  'Xakelêwe', 'Banemerr', 'Cozerdan', 'Pûşper', 'Gelawêj', 'Xermanan', //
  'Rezber', 'Gelarêzan', 'Sermawez', 'Befranbar', 'Rêbendan', 'Reşeme',
];

// Canonical order (Monday=0 ... Sunday=6), Sorani script.
const List<String> _kurdishWeekdayNamesSorani = [
  'دووشەممە', 'سێشەممە', 'چوارشەممە', 'پێنجشەممە', 'ھەینی', 'شەممە', //
  'یەکشەممە',
];

const List<String> _kurdishWeekdayNamesLatin = [
  'Dûşemme', 'Sêşemme', 'Çwarşemme', 'Pêncşemme', 'Heyni', 'Şemme', //
  'Yekşemme',
];

/// Today's date in the Kurdish calendar, based on the system clock.
KurdishDate _todayKurdish() {
  final now = DateTime.now();
  return KurdishDate.fromDate(CivilDate(now.year, now.month, now.day));
}

/// The Sorani name of a Kurdish month (1 to 12).
String kurdishMonthName(int month) => _kurdishMonthNamesSorani[month - 1];

/// The Latin-script (romanized) name of a Kurdish month.
String kurdishMonthNameLatin(int month) => _kurdishMonthNamesLatin[month - 1];

/// The Sorani name of the weekday of a Kurdish date.
String kurdishWeekdayName(KurdishDate date) =>
    _kurdishWeekdayNamesSorani[date.toJdn() % 7];

/// The Latin-script (romanized) name of the weekday of a Kurdish date.
String kurdishWeekdayNameLatin(KurdishDate date) =>
    _kurdishWeekdayNamesLatin[date.toJdn() % 7];

/// Numeric display of a Kurdish date as YYYY/MM/DD.
///
/// Example: `kurdishToNumericString(KurdishDate(2725, 1, 1))` → `'2725/01/01'`
String kurdishToNumericString(KurdishDate date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.dayOfMonth.toString().padLeft(2, '0');
  return '$y/$m/$d';
}

/// Full display of a Kurdish date including weekday and month name
/// (Sorani script).
///
/// Example: `kurdishToFullString(KurdishDate(2725, 1, 1))` →
/// `'ھەینی 1 خاکەلێوە 2725'`
String kurdishToFullString(KurdishDate date) {
  final weekday = kurdishWeekdayName(date);
  final month = kurdishMonthName(date.month);
  return '$weekday ${date.dayOfMonth} $month ${date.year}';
}

/// Formats a Kurdish date using a custom pattern.
///
/// Supported tokens: `YYYY`, `YY`, `MMMM` (Sorani month name), `MM`, `M`,
/// `DDDD` (Sorani weekday name), `DD`, `D`.
///
/// Example: `kurdishFormat(KurdishDate(2725, 1, 1), 'DD MMMM YYYY')` →
/// `'01 خاکەلێوە 2725'`
String kurdishFormat(KurdishDate date, String pattern) {
  final tokens = <String, String Function()>{
    'YYYY': () => date.year.toString().padLeft(4, '0'),
    'YY': () => (date.year % 100).toString().padLeft(2, '0'),
    'MMMM': () => kurdishMonthName(date.month),
    'MM': () => date.month.toString().padLeft(2, '0'),
    'M': () => date.month.toString(),
    'DDDD': () => kurdishWeekdayName(date),
    'DD': () => date.dayOfMonth.toString().padLeft(2, '0'),
    'D': () => date.dayOfMonth.toString(),
  };
  final orderedKeys = tokens.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  final regex = RegExp(orderedKeys.map(RegExp.escape).join('|'));
  return pattern.replaceAllMapped(regex, (m) => tokens[m[0]]!());
}

/// Is the given Kurdish year a leap year (does the 12th month have 30
/// days)?
///
/// Since the Kurdish and Persian calendars share the exact same leap-year
/// placement (see the file-level comment in kurdish_date.dart), this is
/// computed by checking the corresponding Persian year.
///
/// Example: `isKurdishLeapYear(2724)` → `true` (Persian year 1403)
bool isKurdishLeapYear(int year) => kurdishDaysInYear(year) == 366;

/// The total number of days in a Kurdish year (365 or 366).
int kurdishDaysInYear(int year) {
  final thisYearStart = KurdishDate(year, 1, 1).toJdn();
  final nextYearStart = KurdishDate(year + 1, 1, 1).toJdn();
  return nextYearStart - thisYearStart;
}

/// The day-of-year number for a Kurdish date (1 to 365 or 366).
int kurdishDayOfYear(KurdishDate date) =>
    date.toJdn() - KurdishDate(date.year, 1, 1).toJdn() + 1;

/// Adds (or subtracts) a number of days to a Kurdish date.
KurdishDate kurdishAddDays(KurdishDate date, int days) =>
    KurdishDate.fromJdn(date.toJdn() + days);

/// Adds (or subtracts) a number of months to a Kurdish date; if the day
/// exceeds the length of the target month, it is clamped to the last day
/// of that month.
KurdishDate kurdishAddMonths(KurdishDate date, int months) {
  final totalMonths = date.year * 12 + (date.month - 1) + months;
  final newYear = (totalMonths - totalMonths % 12) ~/ 12;
  final newMonth = totalMonths % 12 + 1;
  final maxDay = getMonthDays(newYear, newMonth, KurdishDate.new);
  final newDay = date.dayOfMonth > maxDay ? maxDay : date.dayOfMonth;
  return KurdishDate(newYear, newMonth, newDay);
}

/// Adds (or subtracts) a number of years to a Kurdish date; the day is
/// clamped to the last day of the same month in the target year if needed
/// (for the 29th/30th day of the 12th month).
KurdishDate kurdishAddYears(KurdishDate date, int years) {
  final newYear = date.year + years;
  final maxDay = getMonthDays(newYear, date.month, KurdishDate.new);
  final newDay = date.dayOfMonth > maxDay ? maxDay : date.dayOfMonth;
  return KurdishDate(newYear, date.month, newDay);
}

/// Is this date equal to today (based on the system clock)?
bool kurdishIsToday(KurdishDate date) => isSameDay(date, _todayKurdish());

/// Is this date a Friday?
bool kurdishIsFriday(KurdishDate date) => date.toJdn() % 7 == 4;

/// Converts a Kurdish date to a Persian date. This is a same-day identity
/// (year-shift only), since the two calendars share their day layout; see
/// [KurdishDate.asPersianDate].
PersianDate kurdishToPersian(KurdishDate date) => date.asPersianDate;

/// Converts a Persian date to a Kurdish date (the inverse of
/// [kurdishToPersian]).
KurdishDate persianToKurdish(PersianDate date) =>
    KurdishDate(date.year + kurdishYearOffset, date.month, date.dayOfMonth);

/// Converts a Kurdish date to a Gregorian date.
CivilDate kurdishToGregorian(KurdishDate date) => CivilDate.fromDate(date);

/// Converts a Kurdish date to an Islamic date (based on whichever
/// calculation method is active in [IslamicDate.useUmmAlQura]).
IslamicDate kurdishToIslamic(KurdishDate date) => IslamicDate.fromDate(date);

/// A 6x7 grid of the days of a Kurdish month, for rendering a calendar
/// widget. Each row is a week starting on Saturday, matching
/// persianGetMonthGrid's layout. Cells outside the range of the month are
/// filled with `null`.
List<List<int?>> kurdishGetMonthGrid(int year, int month) {
  final firstDayCanonical = getFirstDayOfMonth(year, month, KurdishDate.new);
  final firstDaySaturdayIndexed = (firstDayCanonical + 2) % 7;
  final daysInMonth = getMonthDays(year, month, KurdishDate.new);

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
