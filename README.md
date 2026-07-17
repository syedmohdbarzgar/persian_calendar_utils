<!--
  README.md for persian_calendar_utils
  Generated based on repository analysis.
-->

# Persian Calendar Utils

A comprehensive utility-function library for working with four calendar systems—Persian/Jalali, Gregorian, Islamic/Hijri, and Nepali/Bikram Sambat—built on top of the [`persian_calendar`](https://github.com/syedmohdbarzgar/persian_calendar) package.

This package provides conversion, formatting, date arithmetic, status checks, and helper functions for building calendar widgets, making it ideal for developers who need robust multi-calendar support in Dart and Flutter applications.

---

## Badges

| Badge | Status |
|-------|--------|
| Version | `1.0.0` |
| Dart SDK | `^3.12.2` |
| License | [MIT](LICENCE) |
| Platform | Dart VM / Flutter |

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Why Use This Library?](#why-use-this-library)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Core Concepts](#core-concepts)
- [API Overview](#api-overview)
- [Usage Examples](#usage-examples)
- [Project Architecture](#project-architecture)
- [Supported Platforms](#supported-platforms)
- [Best Practices](#best-practices)
- [Testing](#testing)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)
- [Changelog](#changelog)

---

## Overview

**Persian Calendar Utils** is a Dart library that extends the `persian_calendar` package with a rich set of utility functions. It supports four calendar systems:

- **Persian/Jalali** – the official calendar of Iran and Afghanistan
- **Gregorian** – the internationally used civil calendar
- **Islamic/Hijri** – the lunar calendar used in many Muslim countries
- **Nepali/Bikram Sambat** – the official calendar of Nepal

The library is designed to be calendar-agnostic where possible, while also providing calendar-specific functions for formatting, conversion, date arithmetic, and validation.

All functions are built on top of the `AbstractDate` base class from `persian_calendar`, ensuring consistency and interoperability across calendar systems.

---

## Features

- **111 utility functions** across 6 categories
- **Cross-calendar conversion** – convert any date to any supported calendar
- **Flexible formatting** – custom patterns and strftime-style formats
- **Date arithmetic** – add/subtract days, months, years with proper clamping
- **Date comparison** – equality, ordering, and range operations
- **Calendar-specific helpers** – month names, weekday names, seasons, zodiac signs
- **Leap year detection** – accurate per-calendar leap year checks
- **Age calculation** – precise age in years, months, and days
- **Date validation** – verify year/month/day combinations
- **Grid helpers** – first day of month and month-day counts for widget building

---

## Why Use This Library?

- **Eliminates boilerplate** – no need to reimplement common calendar operations
- **Consistent API** – all calendars share the same interface via `AbstractDate`
- **Accurate conversions** – built on the reliable `persian_calendar` package
- **Developer-friendly** – functions are named clearly and documented with examples
- **Widget-ready** – includes helpers like `getFirstDayOfMonth` and `getMonthDays` for building calendar UIs
- **Pure Dart** – works on all platforms supported by Dart

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  persian_calendar_utils:
    git:
      url: https://github.com/syedmohdbarzgar/persian_calendar_utils.git
```

Then run:

```bash
dart pub get
```

> **Note:** This package is not yet published on pub.dev. It is available via Git dependency.

---

## Quick Start

```dart
import 'package:persian_calendar_utils/persian_calendar_utils.dart';

void main() {
  // Create a Persian date
  final persianDate = PersianDate(1404, 1, 1); // 1 Farvardin 1404

  // Convert to Gregorian
  final gregorianDate = convertToGregorian(persianDate);
  print(gregorianDate); // CivilDate(2025, 3, 21)

  // Format the Persian date
  print(persianToFullString(persianDate)); // جمعه ۱ فروردین ۱۴۰۴

  // Check if it's a leap year
  print(isPersianLeapYear(1404)); // false

  // Add 10 days
  final later = persianAddDays(persianDate, 10);
  print(later); // PersianDate(1404, 1, 11)
}
```

---

## Core Concepts

### AbstractDate

All calendar date classes (`PersianDate`, `CivilDate`, `IslamicDate`, `NepaliDate`) extend `AbstractDate`, which provides:

- `toJdn()` – convert to Julian Day Number
- `year`, `month`, `dayOfMonth` – basic date components
- `fromDate()` – construct from another date
- `fromJdn()` – construct from a Julian Day Number

### Julian Day Number (JDN)

The library uses JDN as the internal representation for date arithmetic and comparison. This ensures accuracy and consistency across calendar systems.

### Constructor Passing Pattern

Because Dart does not support virtual static constructors, functions that need to reconstruct a date of a generic type require the constructor to be passed as a parameter. For example:

```dart
final date = fromJdn(2460756, CivilDate.fromJdn);
```

---

## API Overview

### Core (Calendar-Agnostic) Functions

| Function | Description |
|----------|-------------|
| `toJdn(T date)` | Converts any date to Julian Day Number |
| `fromJdn(int jdn, T Function(int) constructor)` | Builds a date from JDN |
| `daysBetween(T d1, T d2)` | Absolute day difference between two dates |
| `isSameDay(T d1, T d2)` | Checks if two dates are the same day |
| `isSameMonth(T d1, T d2)` | Checks if two dates are in the same month |
| `isBefore(T d1, T d2)` | Checks if first date is earlier |
| `isAfter(T d1, T d2)` | Checks if first date is later |
| `compareTo(T d1, T d2)` | Compares two dates (-1, 0, 1) |
| `minDate(List<T> dates)` | Returns the oldest date in a list |
| `maxDate(List<T> dates)` | Returns the newest date in a list |
| `getDateRange(T start, T end, T Function(int) fromJdnCtor)` | Generates a list of dates in a range |
| `isValidDate(int year, int month, int day, T Function(int,int,int) constructor)` | Validates a date |
| `getMonthDays(int year, int month, T Function(int,int,int) constructor)` | Returns days in a month |
| `getFirstDayOfMonth(int year, int month, T Function(int,int,int) constructor)` | Returns weekday index of first day |

### Cross-Calendar Conversion Functions

| Function | Description |
|----------|-------------|
| `convertDate(AbstractDate source, Type destinationType)` | Converts to any calendar at runtime |
| `convertToPersian(AbstractDate date)` | Converts to Persian calendar |
| `convertToGregorian(AbstractDate date)` | Converts to Gregorian calendar |
| `convertToIslamic(AbstractDate date)` | Converts to Islamic calendar |
| `convertToNepali(AbstractDate date)` | Converts to Nepali calendar |

### Persian-Specific Functions

| Function | Description |
|----------|-------------|
| `persianToPersianString(PersianDate date)` | Numeric display with Persian digits |
| `persianToFullString(PersianDate date)` | Full display with weekday and month |
| `persianFormat(PersianDate date, String pattern)` | Custom pattern formatting |
| `persianFormatStrftime(PersianDate date, String format)` | Strftime-style formatting |
| `persianToGregorian(PersianDate date)` | Converts to Gregorian |
| `persianToIslamic(PersianDate date)` | Converts to Islamic |
| `persianToNepali(PersianDate date)` | Converts to Nepali |
| `isPersianLeapYear(int year)` | Checks if Persian year is leap |
| `persianWeekdayName(PersianDate date)` | Persian weekday name |
| `persianWeekdayNameEn(PersianDate date)` | English weekday name |
| `persianWeekdayNameShort(PersianDate date)` | Short Persian weekday name |
| `persianMonthName(int month)` | Persian month name |
| `persianMonthNameEn(int month)` | English transliterated month name |
| `persianSeason(int month)` | Season name in Persian |
| `persianZodiacSign(PersianDate date)` | Zodiac sign |
| `persianAddDays(PersianDate date, int days)` | Adds/subtracts days |
| `persianAddMonths(PersianDate date, int months)` | Adds/subtracts months with clamping |
| `persianAddYears(PersianDate date, int years)` | Adds/subtracts years with clamping |
| `persianAge(PersianDate birthDate, [PersianDate? today])` | Calculates age |
| `persianDaysInYear(int year)` | Total days in a Persian year |
| `persianDayOfYear(PersianDate date)` | Day of year |
| `persianWeekOfYear(PersianDate date)` | Week of year |
| `persianIsToday(PersianDate date)` | Checks if date is today |

> **Note:** Similar function sets exist for Gregorian (`gregorian_utils.dart`), Islamic (`islamic_utils.dart`), Nepali (`nepali_utils.dart`), and Kurdish (`kurdish_utils.dart`) calendars.

---

## Usage Examples

### Basic Conversion

```dart
import 'package:persian_calendar_utils/persian_calendar_utils.dart';

void main() {
  // Persian to Gregorian
  final persian = PersianDate(1404, 1, 1);
  final gregorian = convertToGregorian(persian);
  print(gregorian); // CivilDate(2025, 3, 21)

  // Gregorian to Persian
  final civil = CivilDate(2025, 3, 21);
  final converted = convertToPersian(civil);
  print(converted); // PersianDate(1404, 1, 1)
}
```

### Formatting

```dart
final date = PersianDate(1404, 1, 1);

// Persian digits: ۱۴۰۴/۰۱/۰۱
print(persianToPersianString(date));

// Full string: جمعه ۱ فروردین ۱۴۰۴
print(persianToFullString(date));

// Custom pattern: 01 فروردین 1404
print(persianFormat(date, 'DD MMMM YYYY'));

// Strftime: 1404/01/01
print(persianFormatStrftime(date, '%Y/%m/%d'));
```

### Date Arithmetic

```dart
final date = PersianDate(1404, 1, 1);

// Add 10 days
final plus10 = persianAddDays(date, 10); // 11 Farvardin

// Add 3 months (clamps if needed)
final plus3Months = persianAddMonths(date, 3); // 1 Tir

// Add 1 year (clamps Esfand days)
final plus1Year = persianAddYears(date, 1); // 1 Farvardin 1405
```

### Date Comparison and Range

```dart
final d1 = PersianDate(1404, 1, 1);
final d2 = PersianDate(1404, 1, 15);

print(isBefore(d1, d2)); // true
print(daysBetween(d1, d2)); // 14

// Generate a range of dates
final range = getDateRange(d1, d2, PersianDate.fromJdn);
print(range.length); // 15
```

### Age Calculation

```dart
final birth = PersianDate(1370, 5, 10);
final today = PersianDate(1404, 1, 1);
final age = persianAge(birth, today);
print('${age['years']} years, ${age['months']} months, ${age['days']} days');
// 33 years, 7 months, 21 days
```

### Building a Calendar Grid

```dart
final year = 1404;
final month = 1;

// Get the number of days in the month
final daysInMonth = getMonthDays(year, month, PersianDate.new);

// Get the weekday of the first day (0=Monday, 6=Sunday)
final firstWeekday = getFirstDayOfMonth(year, month, PersianDate.new);

// The Iranian week starts on Saturday, so you may want to remap:
final iranianFirstWeekday = (firstWeekday + 2) % 7; // Saturday=0 ... Friday=6
```

---

## Project Architecture

```
lib/
├── persian_calendar_utils.dart      # Main entry point, exports all modules
├── src/
│   ├── core/
│   │   ├── generic.dart             # Calendar-agnostic functions (toJdn, daysBetween, etc.)
│   │   └── converters.dart          # Cross-calendar conversion functions
│   ├── persian/
│   │   └── persian_utils.dart       # Persian-specific functions
│   ├── gregorian/
│   │   └── gregorian_utils.dart     # Gregorian-specific functions
│   ├── islamic/
│   │   └── islamic_utils.dart       # Islamic-specific functions
│   ├── nepali/
│   │   └── nepali_utils.dart        # Nepali-specific functions
│   └── kurdish/
│       └── kurdish_utils.dart       # Kurdish calendar functions
```

---

## Supported Platforms

- **Dart VM** – all platforms supported by Dart
- **Flutter** – Android, iOS, Web, Windows, macOS, Linux

The library is pure Dart with no platform-specific dependencies.

---

## Best Practices

### Use JDN for Reliable Comparisons

Always use `toJdn()` for date comparisons and arithmetic. This ensures accuracy across calendar systems.

```dart
// Good
final diff = date1.toJdn() - date2.toJdn();

// Avoid manual year/month/day arithmetic across calendars
```

### Pass Constructors Explicitly

When using generic functions like `fromJdn` or `getDateRange`, always pass the appropriate constructor:

```dart
// Correct
final date = fromJdn(jdn, PersianDate.fromJdn);
final range = getDateRange(start, end, CivilDate.fromJdn);

// Incorrect – will not compile
final date = fromJdn(jdn); // missing constructor parameter
```

### Validate Dates Before Construction

Use `isValidDate` to validate user input before constructing date objects:

```dart
if (isValidDate(year, month, day, PersianDate.new)) {
  final date = PersianDate(year, month, day);
} else {
  // Handle invalid input
}
```

### Handle Month Clamping

Functions like `persianAddMonths` and `persianAddYears` clamp the day to the last valid day of the target month. Be aware of this behavior when performing date arithmetic.

---

## Testing

Run the test suite with:

```bash
dart test
```

The package uses the `test` package for unit testing.

---

## Documentation

- **API Documentation** – inline documentation is provided in all source files
- **Examples** – see the `/example` folder for more usage examples
- **Source Code** – [GitHub Repository](https://github.com/syedmohdbarzgar/persian_calendar_utils)

---

## License

This project is licensed under the MIT License. See the [LICENCE](LICENCE) file for details.

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

---

*Built with ❤️ for the Dart and Flutter community.*