/// A comprehensive utility-function library for working with four calendar
/// systems (Persian/Jalali, Gregorian, Islamic/Hijri, and Nepali/Bikram
/// Sambat), built on top of the `persian_calendar` package.
///
/// Status: all 6 categories (111 functions total) are implemented:
/// 1. Generic (calendar-agnostic) functions — [src/core/generic.dart]
/// 2. Persian-specific functions — [src/persian/persian_utils.dart]
/// 3. Gregorian-specific functions — [src/gregorian/gregorian_utils.dart]
/// 4. Islamic-specific functions — [src/islamic/islamic_utils.dart]
/// 5. Nepali-specific functions — [src/nepali/nepali_utils.dart]
/// 6. Cross-calendar conversion functions — [src/core/converters.dart]
library;

export 'package:persian_calendar/persian_calendar.dart';
export 'src/core/generic.dart';
export 'src/core/converters.dart';
export 'src/persian/persian_utils.dart';
export 'src/gregorian/gregorian_utils.dart';
export 'src/islamic/islamic_utils.dart';
export 'src/nepali/nepali_utils.dart';
