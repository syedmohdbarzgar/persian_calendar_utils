// Category 4: Islamic-calendar (IslamicDate) specific functions — 21
// functions (#68 through #88).
//
// Every function in this file is sensitive to the current setting of
// [IslamicDate.useUmmAlQura]; i.e. results change depending on whether the
// active calculation method is Umm al-Qura or the Iranian tabular method
// (exactly as persian_calendar itself was designed to behave).
//
// Weekday convention for islamicGetMonthGrid: like the Persian calendar,
// the week is Saturday-based (common in most Middle Eastern countries),
// using the same `(canonical + 2) % 7` remapping.

import 'package:persian_calendar/persian_calendar.dart';

import '../core/generic.dart';

const List<String> _islamicMonthNamesAr = [
  'محرم', 'صفر', 'ربیع الأول', 'ربیع الآخر', 'جمادى الأولى', //
  'جمادى الآخرة', 'رجب', 'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
];
const List<String> _islamicMonthNamesEn = [
  "Muharram", "Safar", "Rabi' al-awwal", "Rabi' al-thani", //
  "Jumada al-awwal", "Jumada al-thani", "Rajab", "Sha'ban", "Ramadan", //
  "Shawwal", "Dhu al-Qi'dah", "Dhu al-Hijjah",
];
// Canonical order (Monday=0 ... Sunday=6)
const List<String> _weekdayNamesAr = [
  'الاثنین', 'الثلاثاء', 'الأربعاء', 'الخمیس', 'الجمعة', 'السبت', 'الأحد', //
];
const List<String> _weekdayNamesEn = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', //
  'Sunday',
];

const Map<String, String> _arabicIndicDigitsMap = {
  '0': '٠', '1': '١', '2': '٢', '3': '٣', '4': '٤', //
  '5': '٥', '6': '٦', '7': '٧', '8': '٨', '9': '٩',
};

String _toArabicIndicDigits(String input) =>
    input.split('').map((c) => _arabicIndicDigitsMap[c] ?? c).join();

IslamicDate _todayIslamic() {
  final now = DateTime.now();
  return IslamicDate.fromDate(CivilDate(now.year, now.month, now.day));
}

/// (68) Numeric display of an Islamic date using Arabic-Indic digits, as
/// YYYY/MM/DD.
///
/// Example: `islamicToString(IslamicDate(1446, 9, 1))` → `'١٤٤٦/٠٩/٠١'`
String islamicToString(IslamicDate date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.dayOfMonth.toString().padLeft(2, '0');
  return _toArabicIndicDigits('$y/$m/$d');
}

/// (69) Full display of an Islamic date including weekday name and month
/// name, using Arabic-Indic digits.
///
/// Example: `islamicToFullString(IslamicDate(1446, 9, 1))` →
/// `'الأحد ١ رمضان ١٤٤٦'` (the weekday name depends on the actual computed
/// date)
String islamicToFullString(IslamicDate date) {
  final weekday = islamicWeekdayName(date);
  final month = islamicMonthName(date.month);
  final day = _toArabicIndicDigits(date.dayOfMonth.toString());
  final year = _toArabicIndicDigits(date.year.toString());
  return '$weekday $day $month $year';
}

/// (70) Formats an Islamic date using a custom pattern (Latin digits).
///
/// Tokens: `YYYY`, `YY`, `MMMM` (English month name), `MM`, `M`, `DDDD`
/// (English weekday name), `DD`, `D`.
///
/// Example: `islamicFormat(IslamicDate(1446, 9, 1), 'DD MMMM YYYY')` →
/// `'01 Ramadan 1446'`
String islamicFormat(IslamicDate date, String pattern) {
  final tokens = <String, String Function()>{
    'YYYY': () => date.year.toString().padLeft(4, '0'),
    'YY': () => (date.year % 100).toString().padLeft(2, '0'),
    'MMMM': () => islamicMonthNameEn(date.month),
    'MM': () => date.month.toString().padLeft(2, '0'),
    'M': () => date.month.toString(),
    'DDDD': () => islamicWeekdayNameEn(date),
    'DD': () => date.dayOfMonth.toString().padLeft(2, '0'),
    'D': () => date.dayOfMonth.toString(),
  };
  final orderedKeys = tokens.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  final regex = RegExp(orderedKeys.map(RegExp.escape).join('|'));
  return pattern.replaceAllMapped(regex, (m) => tokens[m[0]]!());
}

/// (71) Converts an Islamic date to a Persian date.
PersianDate islamicToPersian(IslamicDate date) => PersianDate.fromDate(date);

/// (72) Converts an Islamic date to a Gregorian date.
CivilDate islamicToGregorian(IslamicDate date) => CivilDate.fromDate(date);

/// (73) Converts an Islamic date to a Nepali date.
NepaliDate islamicToNepali(IslamicDate date) => NepaliDate.fromDate(date);

/// (74) Sets the calculation method for the Islamic calendar, for the
/// *entire* [IslamicDate] class application-wide (since
/// [IslamicDate.useUmmAlQura] is a global static variable).
///
/// Parameters:
/// - [useUmmAlQura]: `true` for the Umm al-Qura method, `false` for the
///   Iranian tabular method.
void islamicSetCalculationMethod(bool useUmmAlQura) {
  IslamicDate.useUmmAlQura = useUmmAlQura;
}

/// (75) Gets the currently active Islamic calendar calculation method.
bool islamicGetCalculationMethod() => IslamicDate.useUmmAlQura;

/// (76) Is the given Islamic year a leap year (355 days instead of 354)?
/// The result depends on the currently active calculation method (Umm
/// al-Qura or the Iranian tabular method).
bool islamicIsLeapYear(int year) => islamicDaysInYear(year) == 355;

/// (77) The Arabic name of the weekday of an Islamic date.
String islamicWeekdayName(IslamicDate date) =>
    _weekdayNamesAr[date.toJdn() % 7];

/// (78) The English name of the weekday of an Islamic date.
String islamicWeekdayNameEn(IslamicDate date) =>
    _weekdayNamesEn[date.toJdn() % 7];

/// (79) The Arabic name of an Islamic month (1 to 12).
String islamicMonthName(int month) => _islamicMonthNamesAr[month - 1];

/// (80) The English name of an Islamic month.
String islamicMonthNameEn(int month) => _islamicMonthNamesEn[month - 1];

/// (81) Adds (or subtracts) a number of days to an Islamic date.
IslamicDate islamicAddDays(IslamicDate date, int days) =>
    IslamicDate.fromJdn(date.toJdn() + days);

/// (82) Adds (or subtracts) a number of months; the day is clamped to the
/// last day of the target month if needed.
IslamicDate islamicAddMonths(IslamicDate date, int months) {
  final totalMonths = date.year * 12 + (date.month - 1) + months;
  final newYear = (totalMonths - totalMonths % 12) ~/ 12;
  final newMonth = totalMonths % 12 + 1;
  final maxDay = getMonthDays(newYear, newMonth, IslamicDate.new);
  final newDay = date.dayOfMonth > maxDay ? maxDay : date.dayOfMonth;
  return IslamicDate(newYear, newMonth, newDay);
}

/// (83) Adds (or subtracts) a number of years; the day is clamped if
/// needed.
IslamicDate islamicAddYears(IslamicDate date, int years) {
  final newYear = date.year + years;
  final maxDay = getMonthDays(newYear, date.month, IslamicDate.new);
  final newDay = date.dayOfMonth > maxDay ? maxDay : date.dayOfMonth;
  return IslamicDate(newYear, date.month, newDay);
}

/// (84) The total number of days in an Islamic year (354 or 355, depending
/// on the active calculation method).
int islamicDaysInYear(int year) {
  final thisYearStart = IslamicDate(year, 1, 1).toJdn();
  final nextYearStart = IslamicDate(year + 1, 1, 1).toJdn();
  return nextYearStart - thisYearStart;
}

/// (85) The day-of-year number for an Islamic date (1 to 354 or 355).
int islamicDayOfYear(IslamicDate date) =>
    date.toJdn() - IslamicDate(date.year, 1, 1).toJdn() + 1;

/// (86) Is this date equal to today (based on the system clock)?
bool islamicIsToday(IslamicDate date) => isSameDay(date, _todayIslamic());

// Islamic events: key "month-day" → list of event names.
const Map<String, List<String>> _islamicEvents = {
  '1-9': ['Tasu\'a of Husayn'],
  '1-10': ['Ashura of Husayn'],
  '2-20': ['Arba\'een of Husayn'],
  '2-28': ["Death of the Prophet Muhammad", 'Martyrdom of Imam Hasan'],
  '3-12': ["Mawlid of the Prophet Muhammad (Sunni tradition)"],
  '3-17': [
    "Mawlid of the Prophet Muhammad (Shia tradition)",
    'Birth of Imam Ja\'far al-Sadiq',
  ],
  '6-3': ['Martyrdom of Fatima al-Zahra (one narration)'],
  '7-13': ['Birth of Imam Ali'],
  '7-27': ["Mab'ath (the Prophet's first revelation)"],
  '8-15': ['Birth of Imam Mahdi'],
  '9-1': ['Start of Ramadan'],
  '9-21': ['Martyrdom of Imam Ali'],
  '10-1': ['Eid al-Fitr'],
  '12-9': ['Day of Arafah'],
  '12-10': ['Eid al-Adha'],
  '12-18': ['Eid al-Ghadir'],
};

/// (87) A list of well-known religious/historical events associated with a
/// specific Islamic date (month and day), independent of the year. Returns
/// an empty list if no event is recorded for that day.
///
/// **Note:** this is a curated selection of well-known events, not an
/// exhaustive or official source, and may vary by school of thought /
/// tradition.
List<String> islamicGetEvents(IslamicDate date) =>
    _islamicEvents['${date.month}-${date.dayOfMonth}'] ?? const [];

/// (88) A 6x7 grid of the days of an Islamic month, for rendering a
/// calendar widget (the week starts on Saturday). Cells outside the range
/// of the month are filled with `null`.
List<List<int?>> islamicGetMonthGrid(int year, int month) {
  final firstDayCanonical = getFirstDayOfMonth(year, month, IslamicDate.new);
  final firstDaySaturdayIndexed = (firstDayCanonical + 2) % 7;
  final daysInMonth = getMonthDays(year, month, IslamicDate.new);

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
