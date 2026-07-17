import 'package:test/test.dart';
import 'package:persian_calendar_utils/persian_calendar_utils.dart';

void main() {
  group('Generic (calendar-agnostic) functions', () {
    test('toJdn and fromJdn', () {
      final p = PersianDate(1404, 1, 1);
      final jdn = toJdn(p);
      final p2 = fromJdn<PersianDate>(jdn, PersianDate.fromJdn);
      expect(p2.year, 1404);
      expect(p2.month, 1);
      expect(p2.dayOfMonth, 1);
    });

    test('daysBetween and isSameDay', () {
      final p1 = PersianDate(1404, 1, 1);
      final p2 = PersianDate(1404, 1, 2);
      expect(daysBetween(p1, p2), 1);
      expect(isSameDay(p1, p2), false);
      expect(isSameDay(p1, p1), true);
    });

    test('isBefore / isAfter / compareTo', () {
      final p1 = PersianDate(1404, 1, 1);
      final p2 = PersianDate(1404, 1, 2);
      expect(isBefore(p1, p2), true);
      expect(isAfter(p1, p2), false);
      expect(compareTo(p1, p2), -1);
      expect(compareTo(p2, p1), 1);
    });

    test('minDate / maxDate', () {
      final dates = [
        PersianDate(1403, 12, 29),
        PersianDate(1404, 1, 1),
        PersianDate(1402, 1, 1),
      ];
      final min = minDate(dates)!;
      final max = maxDate(dates)!;
      expect(min.year, 1402);
      expect(max.year, 1404);
    });

    test('getDateRange', () {
      final start = CivilDate(2025, 3, 20);
      final end = CivilDate(2025, 3, 22);
      final range = getDateRange(start, end, CivilDate.fromJdn);
      expect(range.length, 3);
      expect(range[0].dayOfMonth, 20);
      expect(range[2].dayOfMonth, 22);
    });

    test('isValidDate and getMonthDays', () {
      expect(
        isValidDate(1404, 1, 31, (y, m, d) => PersianDate(y, m, d)),
        true,
      );
      expect(
        isValidDate(1404, 12, 30, (y, m, d) => PersianDate(y, m, d)),
        false,
      );
      expect(
        getMonthDays(1404, 1, (y, m, d) => PersianDate(y, m, d)),
        31,
      );
    });

    test('getFirstDayOfMonth', () {
      final firstDay = getFirstDayOfMonth(
        1404,
        1,
        (y, m, d) => PersianDate(y, m, d),
      );
      // The result must be between 0 and 6 (Monday to Sunday)
      expect(firstDay, greaterThanOrEqualTo(0));
      expect(firstDay, lessThanOrEqualTo(6));
    });
  });

  group('Persian‑specific functions', () {
    test('persianToPersianString / persianToFullString', () {
      final date = PersianDate(1404, 1, 1);
      expect(persianToPersianString(date), '۱۴۰۴/۰۱/۰۱');
      expect(
        persianToFullString(date),
        contains('فروردین'), // month name appears
      );
    });

    test('persianFormat / persianFormatStrftime', () {
      final date = PersianDate(1404, 1, 1);
      expect(persianFormat(date, 'YYYY/MM/DD'), '1404/01/01');
      expect(persianFormatStrftime(date, '%Y/%m/%d'), '1404/01/01');
    });

    test('Conversions from Persian', () {
      final p = PersianDate(1404, 1, 1);
      final g = persianToGregorian(p);
      expect(g.year, 2025);
      expect(g.month, 3);
      expect(g.dayOfMonth, 21);

      final islamic = persianToIslamic(p);
      expect(islamic.year, greaterThan(1400));
    });

    test('isPersianLeapYear / persianDaysInYear', () {
      expect(isPersianLeapYear(1403), true);
      expect(isPersianLeapYear(1404), false);
      expect(persianDaysInYear(1404), 365);
    });

    test('persianMonthName / persianSeason / persianZodiacSign', () {
      expect(persianMonthName(1), 'فروردین');
      expect(persianSeason(1), 'بهار');
      final date = PersianDate(1404, 1, 1);
      expect(persianZodiacSign(date), 'حمل');
    });

    test('persianAddDays / AddMonths / AddYears', () {
      final p = PersianDate(1404, 1, 1);
      expect(persianAddDays(p, 1).dayOfMonth, 2);
      expect(persianAddMonths(p, 1).month, 2);
      expect(persianAddYears(p, 1).year, 1405);
    });

    test('persianAge', () {
      final birth = PersianDate(1370, 5, 10);
      final now = PersianDate(1404, 1, 1);
      final age = persianAge(birth, now);
      expect(age['years'], 33);
      expect(age['months'], 7);
      expect(age['days'], 21);
    });

    test('persianIsHoliday', () {
      final nowruz = PersianDate(1404, 1, 1);
      expect(persianIsHoliday(nowruz), true);
      final normal = PersianDate(1404, 1, 10);
      // Just check that it returns a boolean (no specific value)
      expect(persianIsHoliday(normal), isA<bool>());
    });

    test('persianGetMonthGrid / persianGetWeekGrid', () {
      final grid = persianGetMonthGrid(1404, 1);
      expect(grid.length, 6);
      expect(grid.every((row) => row.length == 7), true);
      final week = persianGetWeekGrid(1404, 1, 0);
      expect(week.length, 7);
    });
  });

  group('Gregorian‑specific functions', () {
    test('gregorianToString / gregorianToFullString', () {
      final date = CivilDate(2025, 3, 21);
      expect(gregorianToString(date), '2025-03-21');
      expect(gregorianToFullString(date), contains('March'));
    });

    test('gregorianFormat / gregorianFormatStrftime', () {
      final date = CivilDate(2025, 3, 21);
      expect(gregorianFormat(date, 'DD/MM/YYYY'), '21/03/2025');
      expect(gregorianFormatStrftime(date, '%d/%m/%Y'), '21/03/2025');
    });

    test('isGregorianLeapYear', () {
      expect(isGregorianLeapYear(2024), true);
      expect(isGregorianLeapYear(2025), false);
    });

    test('gregorianAddMonths / AddYears (clamping)', () {
      final date = CivilDate(2025, 1, 31);
      final newDate = gregorianAddMonths(date, 1);
      expect(newDate.month, 2);
      expect(newDate.dayOfMonth, 28); // clamped to Feb 28
    });

    test('gregorianAge', () {
      final birth = CivilDate(1990, 5, 15);
      final now = CivilDate(2025, 3, 21);
      final age = gregorianAge(birth, now);
      expect(age['years'], 34);
    });
  });

  group('Islamic‑specific functions', () {
    test('islamicToString / islamicToFullString', () {
      final date = IslamicDate(1446, 9, 1);
      expect(islamicToString(date), contains('٩')); // Arabic digit for 9
    });

    test('islamicIsLeapYear', () {
      // Depends on the global calculation method; just check it returns a bool.
      expect(islamicIsLeapYear(1446), isA<bool>());
    });

    test('islamicAddMonths', () {
      final date = IslamicDate(1446, 1, 1);
      final newDate = islamicAddMonths(date, 1);
      expect(newDate.month, 2);
    });
  });

  group('Nepali‑specific functions', () {
    test('nepaliToString / nepaliToFullString', () {
      final date = NepaliDate(2081, 12, 1);
      expect(nepaliToString(date), contains('२०८१'));
    });

    test('nepaliIsLeapYear', () {
      expect(nepaliIsLeapYear(2081), isA<bool>());
    });
  });

  group('Cross‑calendar conversions', () {
    test('convertDate', () {
      final p = PersianDate(1404, 1, 1);
      final g = convertDate(p, CivilDate) as CivilDate;
      expect(g.year, 2025);
      expect(g.month, 3);
      expect(g.dayOfMonth, 21);
    });

    test('convertToPersian / convertToGregorian / etc.', () {
      final g = CivilDate(2025, 3, 21);
      final p = convertToPersian(g);
      expect(p.year, 1404);
      expect(convertToGregorian(p).year, 2025);
    });
  });
}