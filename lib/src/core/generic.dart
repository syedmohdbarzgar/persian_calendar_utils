// Category 1: Generic (calendar-agnostic) functions — usable with all four
// calendar systems (PersianDate, CivilDate, IslamicDate, NepaliDate) since
// they all extend AbstractDate and implement toJdn().
//
// Important technical note about this implementation:
// Unlike languages such as Kotlin/Java, Dart does not support calling a
// "virtual static constructor" on a generic type T (i.e. you cannot write
// T.fromJdn(x)), because Dart does not dispatch static members virtually.
// Because of this, wherever a T needs to be reconstructed from
// year/month/day or from a JDN, the constructor function itself is passed
// in as a parameter, e.g. `CivilDate.fromJdn` or
// `(y, m, d) => PersianDate(y, m, d)`.
//
// Weekday-index convention:
// In getFirstDayOfMonth, the returned number follows the `jdn % 7` formula,
// which corresponds to 0=Monday, 1=Tuesday, 2=Wednesday, 3=Thursday,
// 4=Friday, 5=Saturday, 6=Sunday (exactly equivalent to Dart's
// `DateTime.weekday` convention, where Monday is 1, minus one). The
// weekday-naming functions built in categories 2-5 are based on this same
// convention, with an appropriate remapping for each culture (e.g. the
// Iranian week, which starts on Saturday).

import 'package:persian_calendar/persian_calendar.dart';

/// Converts any date from any calendar system to its Julian Day Number (JDN).
///
/// Parameters:
/// - [date]: a date of type [T], a subclass of [AbstractDate]
///   (such as [PersianDate], [CivilDate], [IslamicDate], or [NepaliDate]).
///
/// Returns: the integer JDN equivalent to that date.
///
/// Example:
/// ```dart
/// final jdn = toJdn(PersianDate(1404, 1, 1));
/// print(jdn); // 2460756 (equal to 1 Farvardin 1404 / March 21, 2025)
/// ```
int toJdn<T extends AbstractDate>(T date) => date.toJdn();

/// Builds a date of type [T] from a Julian Day Number (JDN).
///
/// Because Dart has no way to call a static constructor generically
/// (`T.fromJdn`), the constructor itself must be passed in as the
/// [constructor] parameter.
///
/// Parameters:
/// - [jdn]: the Julian Day Number.
/// - [constructor]: a constructor function that takes an [int] (the JDN)
///   and returns an object of type [T]; e.g. `CivilDate.fromJdn` or
///   `IslamicDate.fromJdn`.
///
/// Returns: a date object of type [T].
///
/// Example:
/// ```dart
/// final date = fromJdn<CivilDate>(2460756, CivilDate.fromJdn);
/// print(date); // CivilDate(2025, 3, 21)
/// ```
T fromJdn<T extends AbstractDate>(int jdn, T Function(int jdn) constructor) =>
    constructor(jdn);

/// Computes the difference between two dates in days (always non-negative).
///
/// Parameters:
/// - [d1]: the first date.
/// - [d2]: the second date.
///
/// Returns: the absolute value of the day difference between the two dates.
///
/// Example:
/// ```dart
/// final days = daysBetween(PersianDate(1404, 1, 1), PersianDate(1404, 2, 1));
/// print(days); // 31
/// ```
int daysBetween<T extends AbstractDate>(T d1, T d2) =>
    (d1.toJdn() - d2.toJdn()).abs();

/// Checks whether two dates are exactly equal (year, month, and day).
///
/// This function works by comparing the Julian Day Number of both dates,
/// which is the most accurate and efficient way to determine whether two
/// dates represent the same day.
///
/// Parameters:
/// - [d1]: the first date.
/// - [d2]: the second date.
///
/// Returns: `true` if both dates are exactly the same day.
///
/// Example:
/// ```dart
/// isSameDay(PersianDate(1404, 1, 1), PersianDate(1404, 1, 1)); // true
/// ```
bool isSameDay<T extends AbstractDate>(T d1, T d2) => d1.toJdn() == d2.toJdn();

/// Checks whether two dates fall in the same month (same year and month,
/// regardless of day).
///
/// Parameters:
/// - [d1]: the first date.
/// - [d2]: the second date.
///
/// Returns: `true` if both dates are in the same year and month.
///
/// Example:
/// ```dart
/// isSameMonth(PersianDate(1404, 1, 1), PersianDate(1404, 1, 20)); // true
/// ```
bool isSameMonth<T extends AbstractDate>(T d1, T d2) =>
    d1.year == d2.year && d1.month == d2.month;

/// Is the first date earlier than the second date?
///
/// Parameters:
/// - [d1]: the first date.
/// - [d2]: the second date.
///
/// Returns: `true` if [d1] comes before [d2].
///
/// Example:
/// ```dart
/// isBefore(PersianDate(1404, 1, 1), PersianDate(1404, 1, 2)); // true
/// ```
bool isBefore<T extends AbstractDate>(T d1, T d2) => d1.toJdn() < d2.toJdn();

/// Is the first date later than the second date?
///
/// Parameters:
/// - [d1]: the first date.
/// - [d2]: the second date.
///
/// Returns: `true` if [d1] comes after [d2].
///
/// Example:
/// ```dart
/// isAfter(PersianDate(1404, 2, 1), PersianDate(1404, 1, 1)); // true
/// ```
bool isAfter<T extends AbstractDate>(T d1, T d2) => d1.toJdn() > d2.toJdn();

/// Compares two dates, similar to the standard `compareTo` contract.
///
/// Parameters:
/// - [d1]: the first date.
/// - [d2]: the second date.
///
/// Returns:
/// - `-1` if `d1 < d2`
/// - `0` if `d1 == d2`
/// - `1` if `d1 > d2`
///
/// Example:
/// ```dart
/// compareTo(PersianDate(1404, 1, 1), PersianDate(1404, 1, 2)); // -1
/// ```
int compareTo<T extends AbstractDate>(T d1, T d2) {
  final diff = d1.toJdn() - d2.toJdn();
  if (diff < 0) return -1;
  if (diff > 0) return 1;
  return 0;
}

/// Finds the smallest (oldest) date in a list.
///
/// Parameters:
/// - [dates]: a list of dates of a single type.
///
/// Returns: the oldest date, or `null` if the list is empty.
///
/// Example:
/// ```dart
/// final oldest = minDate([
///   PersianDate(1404, 3, 1),
///   PersianDate(1403, 1, 1),
/// ]);
/// print(oldest); // PersianDate(1403, 1, 1)
/// ```
T? minDate<T extends AbstractDate>(List<T> dates) {
  if (dates.isEmpty) return null;
  return dates.reduce((a, b) => a.toJdn() <= b.toJdn() ? a : b);
}

/// Finds the largest (newest) date in a list.
///
/// Parameters:
/// - [dates]: a list of dates of a single type.
///
/// Returns: the newest date, or `null` if the list is empty.
///
/// Example:
/// ```dart
/// final newest = maxDate([
///   PersianDate(1404, 3, 1),
///   PersianDate(1403, 1, 1),
/// ]);
/// print(newest); // PersianDate(1404, 3, 1)
/// ```
T? maxDate<T extends AbstractDate>(List<T> dates) {
  if (dates.isEmpty) return null;
  return dates.reduce((a, b) => a.toJdn() >= b.toJdn() ? a : b);
}

/// Builds a list of every date between two dates (inclusive of both ends).
///
/// Note: unlike the original prompt's table, this function needs an extra
/// parameter, [fromJdnCtor], because reconstructing each day in the range
/// from its JDN requires the target class's constructor (due to the lack of
/// virtual dispatch on static members in Dart; see the note at the top of
/// this file).
///
/// Parameters:
/// - [start]: the start of the range.
/// - [end]: the end of the range.
/// - [fromJdnCtor]: a constructor function to rebuild [T] from a JDN, e.g.
///   `CivilDate.fromJdn`.
///
/// Returns: a list of dates from oldest to newest, including both ends of
/// the range, regardless of whether [start] was given earlier than [end]
/// or the other way around.
///
/// Example:
/// ```dart
/// final range = getDateRange(
///   CivilDate(2025, 3, 20),
///   CivilDate(2025, 3, 22),
///   CivilDate.fromJdn,
/// );
/// print(range.length); // 3
/// ```
List<T> getDateRange<T extends AbstractDate>(
  T start,
  T end,
  T Function(int jdn) fromJdnCtor,
) {
  final startJdn = start.toJdn();
  final endJdn = end.toJdn();
  final lower = startJdn <= endJdn ? startJdn : endJdn;
  final upper = startJdn <= endJdn ? endJdn : startJdn;
  return [for (var jdn = lower; jdn <= upper; jdn++) fromJdnCtor(jdn)];
}

/// Validates a date (year, month, day) before constructing the final object.
///
/// Since the date-class constructors in persian_calendar do not validate
/// their input on their own (they just store the values), this function
/// checks correctness by computing the real number of days in the month
/// (via [getMonthDays]).
///
/// Parameters:
/// - [year]: the year.
/// - [month]: the month (must be between 1 and 12, since all four supported
///   calendars have twelve months).
/// - [day]: the day.
/// - [constructor]: the constructor of the target date class, e.g.
///   `(y, m, d) => CivilDate(y, m, d)`.
///
/// Returns: `true` if the year/month/day combination is a valid date in
/// that calendar.
///
/// Example:
/// ```dart
/// isValidDate(1404, 12, 30, (y, m, d) => PersianDate(y, m, d)); // false in a common (non-leap) year
/// isValidDate(1404, 1, 31, (y, m, d) => PersianDate(y, m, d));  // true
/// ```
bool isValidDate<T extends AbstractDate>(
  int year,
  int month,
  int day,
  T Function(int year, int month, int day) constructor,
) {
  if (month < 1 || month > 12) return false;
  if (day < 1) return false;
  try {
    final monthLength = getMonthDays<T>(year, month, constructor);
    return day <= monthLength;
  } catch (_) {
    return false;
  }
}

/// The number of days in a given month, for any supported calendar.
///
/// This function works by computing the JDN distance between the first day
/// of the current month and the first day of the next month, so it does not
/// need any calendar-specific table or formula; it only assumes a 12-month
/// year, which holds true for all four supported calendars (Persian,
/// Gregorian, Islamic, Nepali).
///
/// Parameters:
/// - [year]: the year.
/// - [month]: the month (1 to 12).
/// - [constructor]: the constructor of the target date class.
///
/// Returns: the number of days in that month.
///
/// Example:
/// ```dart
/// getMonthDays(1404, 1, (y, m, d) => PersianDate(y, m, d)); // 31
/// getMonthDays(2025, 2, (y, m, d) => CivilDate(y, m, d));   // 28
/// ```
int getMonthDays<T extends AbstractDate>(
  int year,
  int month,
  T Function(int year, int month, int day) constructor,
) {
  final thisMonthStart = constructor(year, month, 1).toJdn();
  final nextYear = month == 12 ? year + 1 : year;
  final nextMonth = month == 12 ? 1 : month + 1;
  final nextMonthStart = constructor(nextYear, nextMonth, 1).toJdn();
  return nextMonthStart - thisMonthStart;
}

/// The weekday index of the first day of a given month.
///
/// Output convention: 0=Monday, 1=Tuesday, 2=Wednesday, 3=Thursday,
/// 4=Friday, 5=Saturday, 6=Sunday (based on `jdn % 7`; exactly equivalent to
/// Dart's `DateTime.weekday` convention, which treats Monday as 1, minus
/// one). The weekday-naming functions in the specialized categories that
/// follow (e.g. the Iranian week, which starts on Saturday) will convert
/// this number into the form appropriate for each culture.
///
/// Parameters:
/// - [year]: the year.
/// - [month]: the month.
/// - [constructor]: the constructor of the target date class.
///
/// Returns: a number between 0 and 6.
///
/// Example:
/// ```dart
/// getFirstDayOfMonth(2025, 3, (y, m, d) => CivilDate(y, m, d));
/// ```
int getFirstDayOfMonth<T extends AbstractDate>(
  int year,
  int month,
  T Function(int year, int month, int day) constructor,
) {
  final jdn = constructor(year, month, 1).toJdn();
  return jdn % 7;
}
