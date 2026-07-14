import 'package:test/test.dart';
import 'package:persian_calendar/persian_calendar.dart';
import 'package:persian_calendar_utils/persian_calendar_utils.dart';

void main() {
  group('Generic functions', () {
    final pDate = PersianDate(1404, 1, 1);
    final gDate = CivilDate(2025, 3, 21);

    test('toJdn and fromJdn', () {
      final jdn = toJdn(pDate);
      expect(jdn, 2460756);
      final reconstructed = fromJdn<CivilDate>(jdn, CivilDate.fromJdn);
      expect(reconstructed, gDate);
    });

    test('daysBetween', () {
      final later = PersianDate(1404, 2, 1);
      expect(daysBetween(pDate, later), 31);
    });

    test('isSameDay', () {
      expect(isSameDay(pDate, PersianDate(1404, 1, 1)), isTrue);
      expect(isSameDay(pDate, PersianDate(1404, 1, 2)), isFalse);
    });

    test('isSameMonth', () {
      expect(isSameMonth(pDate, PersianDate(1404, 1, 20)), isTrue);
      expect(isSameMonth(pDate, PersianDate(1404, 2, 1)), isFalse);
    });

    test('isBefore / isAfter / compareTo', () {
      final earlier = PersianDate(1403, 12, 29);
      expect(isBefore(earlier, pDate), isTrue);
      expect(isAfter(pDate, earlier), isTrue);
      expect(compareTo(earlier, pDate), -1);
    });

    test('minDate / maxDate', () {
      final dates = [
        PersianDate(1404, 1, 1),
        PersianDate(1404, 2, 1),
        PersianDate(1403, 1, 1),
      ];
      expect(minDate(dates), PersianDate(1403, 1, 1));
      expect(maxDate(dates), PersianDate(1404, 2, 1));
    });

    test('getDateRange', () {
      final range = getDateRange(
        CivilDate(2025, 3, 20),
        CivilDate(2025, 3, 22),
        CivilDate.fromJdn,
      );
      expect(range.length, 3);
      expect(range.first, CivilDate(2025, 3, 20));
      expect(range.last, CivilDate(2025, 3, 22));
    });

    test('isValidDate', () {
      expect(
        isValidDate(1404, 1, 31, (y, m, d) => PersianDate(y, m, d)),
        isTrue,
      );
      expect(
        isValidDate(1404, 12, 30, (y, m, d) => PersianDate(y, m, d)),
        isFalse,
      );
    });

    test('getMonthDays', () {
      expect(getMonthDays(1404, 1, PersianDate.new), 31);
      expect(getMonthDays(2025, 2, CivilDate.new), 28);
    });

    test('getFirstDayOfMonth', () {
      // 1 March 2025 is Saturday (canonical index 5)
      final firstDay = getFirstDayOfMonth(2025, 3, CivilDate.new);
      expect(firstDay, 5);
    });
  });

  group('Persian functions', () {
    final persian = PersianDate(1404, 1, 1);

    test('persianToPersianString', () {
      expect(persianToPersianString(persian), '۱۴۰۴/۰۱/۰۱');
    });

    test('persianToFullString', () {
      final full = persianToFullString(persian);
      expect(full, contains('۱۴۰۴'));
      expect(full, contains('فروردین'));
    });

    test('persianFormat', () {
      expect(persianFormat(persian, 'YYYY-MM-DD'), '1404-01-01');
      expect(persianFormat(persian, 'DD MMMM YYYY'), '01 فروردین 1404');
    });

    test('persianFormatStrftime', () {
      expect(persianFormatStrftime(persian, '%Y/%m/%d'), '1404/01/01');
    });

    test('Conversions', () {
      expect(persianToGregorian(persian), CivilDate(2025, 3, 21));
      expect(() => persianToIslamic(persian), returnsNormally);
      expect(() => persianToNepali(persian), returnsNormally);
    });

    test('isPersianLeapYear', () {
      expect(isPersianLeapYear(1403), isTrue);
      expect(isPersianLeapYear(1404), isFalse);
    });

    test('Names and seasons', () {
      expect(persianWeekdayName(persian), 'جمعه');
      expect(persianWeekdayNameShort(persian), 'ج');
      expect(persianMonthName(1), 'فروردین');
      expect(persianSeason(1), 'بهار');
      expect(persianZodiacSign(persian), 'حمل');
    });

    test('Arithmetic', () {
      expect(persianAddDays(persian, 10), PersianDate(1404, 1, 11));
      expect(persianAddMonths(persian, 1), PersianDate(1404, 2, 1));
      expect(persianAddYears(persian, 1), PersianDate(1405, 1, 1));
    });

    test('persianAge', () {
      final birth = PersianDate(1370, 5, 10);
      final today = PersianDate(1404, 1, 1);
      final age = persianAge(birth, today);
      expect(age['years'], 33);
      expect(age['months'], 7);
      expect(age['days'], 21);
    });

    test('Day of year / Days in year / Week of year', () {
      expect(persianDayOfYear(persian), 1);
      expect(persianDaysInYear(1404), 365);
      expect(persianWeekOfYear(persian), 1);
    });

    test('persianIsToday', () {
      expect(() => persianIsToday(persian), returnsNormally);
    });

    test('Weekend and holiday', () {
      expect(persianIsFriday(persian), isTrue);
      expect(persianIsWeekend(persian), isTrue);
      expect(persianIsWeekday(persian), isFalse);
    });

    test('persianGetHolidays', () {
      final holidays = persianGetHolidays(1404);
      expect(holidays, contains(PersianDate(1404, 1, 1)));
    });

    test('persianGetMonthGrid', () {
      final grid = persianGetMonthGrid(1404, 1);
      expect(grid.length, 6);
      expect(grid[0][0], null);
      expect(grid[0][6], 1);
    });

    test('persianGetWeekGrid', () {
      final week = persianGetWeekGrid(1404, 1, 0);
      expect(week.length, 7);
      expect(week[6], 1);
    });
  });

  group('Gregorian functions', () {
    final gregorian = CivilDate(2025, 3, 21);

    test('gregorianToString', () {
      expect(gregorianToString(gregorian), '2025-03-21');
    });

    test('gregorianToFullString', () {
      expect(gregorianToFullString(gregorian), 'Friday, March 21, 2025');
    });

    test('gregorianFormat', () {
      expect(gregorianFormat(gregorian, 'DD MMM YYYY'), '21 Mar 2025');
    });

    test('gregorianFormatStrftime', () {
      expect(gregorianFormatStrftime(gregorian, '%d/%m/%Y'), '21/03/2025');
    });

    test('Conversions', () {
      expect(gregorianToPersian(gregorian), PersianDate(1404, 1, 1));
      expect(() => gregorianToIslamic(gregorian), returnsNormally);
      expect(() => gregorianToNepali(gregorian), returnsNormally);
    });

    test('isGregorianLeapYear', () {
      expect(isGregorianLeapYear(2024), isTrue);
      expect(isGregorianLeapYear(2025), isFalse);
    });

    test('Names', () {
      expect(gregorianWeekdayName(gregorian), 'Friday');
      expect(gregorianWeekdayNameShort(gregorian), 'Fri');
      expect(gregorianMonthName(3), 'March');
    });

    test('Arithmetic', () {
      expect(gregorianAddDays(gregorian, 10), CivilDate(2025, 3, 31));
      expect(gregorianAddMonths(gregorian, 1), CivilDate(2025, 4, 21));
      expect(gregorianAddYears(gregorian, 1), CivilDate(2026, 3, 21));
    });

    test('gregorianAge', () {
      final birth = CivilDate(1990, 5, 15);
      final today = CivilDate(2025, 3, 21);
      final age = gregorianAge(birth, today);
      expect(age['years'], 34);
      expect(age['months'], 10);
      expect(age['days'], 6);
    });

    test('Days in year / Day of year / Week of year', () {
      expect(gregorianDaysInYear(2025), 365);
      expect(gregorianDayOfYear(gregorian), 80);
      expect(gregorianWeekOfYear(gregorian), 12);
    });

    test('Is today / Weekend / Weekday', () {
      expect(() => gregorianIsToday(gregorian), returnsNormally);
      expect(gregorianIsWeekend(gregorian), isFalse);
      expect(gregorianIsWeekday(gregorian), isTrue);
    });

    test('gregorianGetMonthGrid', () {
      final grid = gregorianGetMonthGrid(2025, 3);
      expect(grid[0][5], 1);
    });
  });

  group('Islamic functions', () {
    // اصلاح: استفاده از اول سال (محرم) به جای رمضان
    final islamic = IslamicDate(1446, 1, 1);

    test('islamicToString', () {
      expect(islamicToString(islamic), '١٤٤٦/٠١/٠١');
    });

    test('islamicToFullString', () {
      final full = islamicToFullString(islamic);
      expect(full, contains('محرم'));
      expect(full, contains('١٤٤٦'));
    });

    test('islamicFormat', () {
      expect(islamicFormat(islamic, 'DD MMMM YYYY'), '01 Muharram 1446');
    });

    test('Conversions', () {
      expect(() => islamicToPersian(islamic), returnsNormally);
      expect(() => islamicToGregorian(islamic), returnsNormally);
      expect(() => islamicToNepali(islamic), returnsNormally);
    });

    test('Calculation method', () {
      final oldMethod = islamicGetCalculationMethod();
      islamicSetCalculationMethod(true);
      expect(islamicGetCalculationMethod(), isTrue);
      islamicSetCalculationMethod(false);
      expect(islamicGetCalculationMethod(), isFalse);
      islamicSetCalculationMethod(oldMethod);
    });

    test('islamicIsLeapYear', () {
      expect(() => islamicIsLeapYear(1446), returnsNormally);
    });

    test('Names', () {
      expect(islamicWeekdayName(islamic), isNotEmpty);
      expect(islamicWeekdayNameEn(islamic), isNotEmpty);
      expect(islamicMonthName(1), 'محرم');
      expect(islamicMonthNameEn(1), 'Muharram');
    });

    test('Arithmetic', () {
      expect(() => islamicAddDays(islamic, 10), returnsNormally);
      expect(() => islamicAddMonths(islamic, 1), returnsNormally);
      expect(() => islamicAddYears(islamic, 1), returnsNormally);
    });

    test('islamicDaysInYear / islamicDayOfYear', () {
      // اصلاح: روز اول سال باید ۱ باشد
      expect(islamicDaysInYear(1446), greaterThan(350));
      expect(
        islamicDayOfYear(islamic),
        1,
      ); // قبلاً 239 بود که با این اصلاح برابر ۱ شد
    });

    test('islamicGetEvents', () {
      // برای اول محرم رویدادی تعریف نشده، پس لیست خالی است
      final events = islamicGetEvents(islamic);
      expect(events, isEmpty);
    });

    test('islamicGetMonthGrid', () {
      final grid = islamicGetMonthGrid(1446, 1);
      expect(grid.length, 6);
    });
  });

  group('Nepali functions', () {
    // اصلاح: استفاده از ماه ۱۱ (फाल्गुन) به جای ۱۲ (चैत्र)
    final nepali = NepaliDate(2081, 11, 1); // ۱ فالگون ۲۰۸۱

    test('nepaliToString', () {
      expect(nepaliToString(nepali), '२०८१/११/०१');
    });

    test('nepaliToFullString', () {
      final full = nepaliToFullString(nepali);
      expect(full, contains('फाल्गुन')); // اصلاح شد
      expect(full, contains('२०८१'));
    });

    test('nepaliFormat', () {
      expect(
        nepaliFormat(nepali, 'DD MMMM YYYY'),
        '01 Falgun 2081',
      ); // اصلاح شد
    });

    test('Conversions', () {
      expect(() => nepaliToPersian(nepali), returnsNormally);
      expect(() => nepaliToGregorian(nepali), returnsNormally);
      expect(() => nepaliToIslamic(nepali), returnsNormally);
    });

    test('nepaliIsLeapYear', () {
      expect(() => nepaliIsLeapYear(2081), returnsNormally);
    });

    test('Names', () {
      expect(nepaliWeekdayName(nepali), isNotEmpty);
      expect(nepaliWeekdayNameEn(nepali), isNotEmpty);
      expect(nepaliMonthName(11), 'फाल्गुन'); // اصلاح شد
      expect(nepaliMonthNameEn(11), 'Falgun'); // اصلاح شد
    });

    test('Arithmetic', () {
      expect(() => nepaliAddDays(nepali, 10), returnsNormally);
      expect(() => nepaliAddMonths(nepali, 1), returnsNormally);
      expect(() => nepaliAddYears(nepali, 1), returnsNormally);
    });

    test('nepaliDaysInYear / nepaliDayOfYear', () {
      // برای تست day of year از اول سال استفاده می‌کنیم
      final firstDay = NepaliDate(2081, 1, 1);
      expect(nepaliDaysInYear(2081), greaterThan(350));
      expect(nepaliDayOfYear(firstDay), 1); // اصلاح شد
    });

    test('nepaliGetMonthGrid', () {
      final grid = nepaliGetMonthGrid(2081, 11);
      expect(grid.length, 6);
    });
  });

  group('Cross-calendar converters', () {
    final pDate = PersianDate(1404, 1, 1);
    final gDate = CivilDate(2025, 3, 21);

    test('convertDate', () {
      expect(convertDate(pDate, CivilDate), gDate);
      expect(convertDate(gDate, PersianDate), pDate);
      expect(() => convertDate(pDate, String), throwsArgumentError);
    });

    test('convertToPersian', () {
      expect(convertToPersian(gDate), pDate);
    });

    test('convertToGregorian', () {
      expect(convertToGregorian(pDate), gDate);
    });

    test('convertToIslamic', () {
      expect(() => convertToIslamic(gDate), returnsNormally);
    });

    test('convertToNepali', () {
      expect(() => convertToNepali(gDate), returnsNormally);
    });
  });
}
