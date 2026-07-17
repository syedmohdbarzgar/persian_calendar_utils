// KurdishDate: a separate class for the Kurdish calendar (Kurdish:
// ڕۆژژمێری کوردی, Salnameya kurdî / Rojhelati calendar).
//
// The Kurdish calendar is a solar calendar that is structurally identical
// to the Persian/Jalali solar calendar: it starts on the same day (Newroz /
// Nowruz, the spring equinox) and uses exactly the same month lengths (the
// first 6 months have 31 days, the next 5 have 30 days, and the 12th month
// has 29 days, or 30 in a leap year). The only difference is the year
// count: the Kurdish calendar's epoch is conventionally placed at the
// founding of the Median Empire, 700 BCE, which works out to a constant
// offset of +1321 from the Persian year (equivalently +700 from the
// Gregorian year, for dates after Newroz):
//
//   kurdishYear == persianYear + kurdishYearOffset
//
// (Sources vary on the exact historical epoch -- some place it at the fall
// of Nineveh in 612 BCE instead of 700 BCE -- but +1321 from the Persian
// year is the offset in modern/official use, e.g. by the Kurdistan Region
// calendar and Kurdish media: Persian year 1404 <-> Kurdish year 2725
// <-> Gregorian 2025/2026.)
//
// Because of this 1:1 structural relationship, this class does not
// reimplement any solar-calendar astronomy; it simply delegates to
// [PersianDate] for the actual JDN math (via [asPersianDate]) and shifts
// the year by [kurdishYearOffset]. This keeps it exactly as accurate as
// the underlying PersianDate implementation and automatically consistent
// with it (e.g. leap years fall in the same place in both calendars).
//
// This class lives in persian_calendar_utils (rather than in the
// `persian_calendar` package itself) so it doesn't require a change to
// that package; it depends only on `persian_calendar`'s public API
// (PersianDate, AbstractDate, YearMonthDate), the same as every other
// calendar-specific file in this package.
import 'package:persian_calendar/persian_calendar.dart';

/// The constant offset between the Kurdish and Persian year counts.
///
/// `kurdishYear == persianYear + kurdishYearOffset`. See the file-level
/// comment above for the historical/sourcing notes behind this number.
const int kurdishYearOffset = 1321;

/// A date in the Kurdish calendar.
///
/// The Kurdish calendar shares its month/day structure exactly with the
/// Persian calendar (see the file-level comment), so [KurdishDate] is a
/// thin, year-shifted wrapper around [PersianDate] rather than an
/// independent astronomical implementation.
///
/// Example:
/// ```dart
/// final k = KurdishDate(2725, 1, 1); // Newroz
/// print(k.toJdn() == PersianDate(1404, 1, 1).toJdn()); // true
/// ```
class KurdishDate extends AbstractDate implements YearMonthDate<KurdishDate> {
  KurdishDate(super.year, super.month, super.dayOfMonth);

  /// Converts any date (of any calendar system supported by
  /// `persian_calendar`) to the equivalent Kurdish date.
  factory KurdishDate.fromDate(AbstractDate date) =>
      KurdishDate.fromJdn(date.toJdn());

  /// Builds a [KurdishDate] from a Julian Day Number.
  factory KurdishDate.fromJdn(int jdn) {
    final persian = PersianDate.fromJdn(jdn);
    return KurdishDate(
      persian.year + kurdishYearOffset,
      persian.month,
      persian.dayOfMonth,
    );
  }

  /// The Persian date that shares this date's month and day of month, i.e.
  /// the result of undoing the [kurdishYearOffset] year shift.
  ///
  /// This is a same-day identity, not a calendar conversion: since the
  /// Kurdish and Persian calendars lay out months and days identically,
  /// `KurdishDate(year, month, day).asPersianDate` always has the same JDN
  /// (and therefore the same Gregorian/Islamic/Nepali equivalents) as the
  /// original Kurdish date.
  PersianDate get asPersianDate =>
      PersianDate(year - kurdishYearOffset, month, dayOfMonth);

  // Converters
  @override
  int toJdn() => asPersianDate.toJdn();

  // Same month-arithmetic as PersianDate/CivilDate/IslamicDate/NepaliDate
  // (see persian_calendar's TwelveMonthsYear helper, which this mirrors):
  // both calendars have exactly 12 months per year, so the logic is
  // independent of month lengths and needs no calendar-specific data.
  @override
  KurdishDate monthStartOfMonthsDistance(int monthsDistance) {
    // make it zero based for easier calculations
    final month0 = monthsDistance + month - 1;
    final monthDiv12 = month0 ~/ 12;
    var newYear = year + monthDiv12;
    var newMonth = month0 - monthDiv12 * 12;
    if (newMonth < 0) {
      newYear -= 1;
      newMonth += 12;
    }
    return KurdishDate(newYear, newMonth + 1, 1);
  }

  @override
  int monthsDistanceTo(KurdishDate date) =>
      ((date.year - year) * 12) + date.month - month;

  @override
  String toString() => 'KurdishDate($year, $month, $dayOfMonth)';
}
