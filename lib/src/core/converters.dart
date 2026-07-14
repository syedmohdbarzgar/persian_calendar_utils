// Category 6: cross-calendar conversion functions — 5 functions (#107
// through #111).
//
// Note on convertDate: Dart has no `dart:mirrors`-style reflection
// available in normal (non-VM-only) contexts, so a generic "construct any
// AbstractDate subtype from a runtime Type token" cannot be done via
// reflection. Instead, convertDate compares [destinationType] against the
// four known concrete classes and dispatches to the matching `.fromDate`
// constructor, throwing an [ArgumentError] for anything else.

import 'package:persian_calendar/persian_calendar.dart';

/// (107) Converts any date to any other calendar system, chosen at runtime
/// via a [Type] token.
///
/// Parameters:
/// - [source]: the source date (of any of the four supported calendars).
/// - [destinationType]: the target type, e.g. `PersianDate`, `CivilDate`,
///   `IslamicDate`, or `NepaliDate`.
///
/// Returns: the equivalent date in the target calendar, as an
/// [AbstractDate].
///
/// Throws: [ArgumentError] if [destinationType] is not one of the four
/// supported calendar classes.
///
/// Example:
/// ```dart
/// final result = convertDate(PersianDate(1404, 1, 1), CivilDate);
/// print(result); // CivilDate(2025, 3, 21)
/// ```
AbstractDate convertDate(AbstractDate source, Type destinationType) {
  if (destinationType == PersianDate) return PersianDate.fromDate(source);
  if (destinationType == CivilDate) return CivilDate.fromDate(source);
  if (destinationType == IslamicDate) return IslamicDate.fromDate(source);
  if (destinationType == NepaliDate) return NepaliDate.fromDate(source);
  throw ArgumentError.value(
    destinationType,
    'destinationType',
    'Unsupported destination calendar type. Expected one of PersianDate, '
        'CivilDate, IslamicDate, or NepaliDate.',
  );
}

/// (108) Converts any date to a Persian date.
///
/// Example: `convertToPersian(CivilDate(2025, 3, 21))` → `PersianDate(1404, 1, 1)`
PersianDate convertToPersian(AbstractDate date) => PersianDate.fromDate(date);

/// (109) Converts any date to a Gregorian date.
///
/// Example: `convertToGregorian(PersianDate(1404, 1, 1))` → `CivilDate(2025, 3, 21)`
CivilDate convertToGregorian(AbstractDate date) => CivilDate.fromDate(date);

/// (110) Converts any date to an Islamic date (based on whichever
/// calculation method is active in [IslamicDate.useUmmAlQura]).
IslamicDate convertToIslamic(AbstractDate date) => IslamicDate.fromDate(date);

/// (111) Converts any date to a Nepali date.
NepaliDate convertToNepali(AbstractDate date) => NepaliDate.fromDate(date);
