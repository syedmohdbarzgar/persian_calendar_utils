import 'package:persian_calendar/persian_calendar.dart';
import 'package:persian_calendar_utils/persian_calendar_utils.dart';

void main() {
  print('══════════════════════════════════════════════════════════════════');
  print('📅 persian_calendar_utils – Examples');
  print('══════════════════════════════════════════════════════════════════\n');

  // ──────────────────────────────────────────────────────────────────────
  // 1. Generic (calendar-agnostic) functions
  // ──────────────────────────────────────────────────────────────────────
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('1. Generic Functions');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  final pDate = PersianDate(1404, 1, 1);
  final gDate = CivilDate(2025, 3, 21);
  final iDate = IslamicDate(1446, 9, 1); // استفاده خواهد شد
  final nDate = NepaliDate(2081, 12, 1); // استفاده خواهد شد

  // نمایش متغیرهای تعریف‌شده برای رفع اخطار unused_local_variable
  print('PersianDate example: $pDate');
  print('CivilDate example: $gDate');
  print('IslamicDate example: $iDate');
  print('NepaliDate example: $nDate');
  print('');

  print('toJdn(PersianDate(1404,1,1)) → ${toJdn(pDate)}');
  print(
    'fromJdn(2460756, CivilDate.fromJdn) → ${fromJdn(2460756, CivilDate.fromJdn)}',
  );
  print(
    'daysBetween(1404/1/1, 1404/2/1) → ${daysBetween(pDate, PersianDate(1404, 2, 1))}',
  );
  print(
    'isSameDay(1404/1/1, 1404/1/1) → ${isSameDay(pDate, PersianDate(1404, 1, 1))}',
  );
  print(
    'isSameMonth(1404/1/1, 1404/1/20) → ${isSameMonth(pDate, PersianDate(1404, 1, 20))}',
  );
  print(
    'isBefore(1403/12/29, 1404/1/1) → ${isBefore(PersianDate(1403, 12, 29), pDate)}',
  );
  print(
    'isAfter(1404/1/1, 1403/12/29) → ${isAfter(pDate, PersianDate(1403, 12, 29))}',
  );
  print(
    'compareTo(1403/12/29, 1404/1/1) → ${compareTo(PersianDate(1403, 12, 29), pDate)}',
  );

  final dateList = [pDate, PersianDate(1404, 2, 1), PersianDate(1403, 1, 1)];
  print('minDate(list) → ${minDate(dateList)}');
  print('maxDate(list) → ${maxDate(dateList)}');

  final range = getDateRange(
    CivilDate(2025, 3, 20),
    CivilDate(2025, 3, 22),
    CivilDate.fromJdn,
  );
  print('getDateRange(2025-03-20 → 2025-03-22) → $range');

  print(
    'isValidDate(1404,1,31, PersianDate.new) → ${isValidDate(1404, 1, 31, (y, m, d) => PersianDate(y, m, d))}',
  );
  print(
    'getMonthDays(1404,1, PersianDate.new) → ${getMonthDays(1404, 1, PersianDate.new)}',
  );
  print(
    'getFirstDayOfMonth(2025,3, CivilDate.new) → ${getFirstDayOfMonth(2025, 3, CivilDate.new)}',
  );

  // ──────────────────────────────────────────────────────────────────────
  // 2. Persian-specific functions
  // ──────────────────────────────────────────────────────────────────────
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('2. Persian (Jalali) Functions');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  final persian = PersianDate(1404, 1, 1);
  print('persianToPersianString → ${persianToPersianString(persian)}');
  print('persianToFullString → ${persianToFullString(persian)}');
  print(
    'persianFormat (DD MMMM YYYY) → ${persianFormat(persian, 'DD MMMM YYYY')}',
  );
  print(
    'persianFormatStrftime (%Y/%m/%d) → ${persianFormatStrftime(persian, '%Y/%m/%d')}',
  );
  print('persianToGregorian → ${persianToGregorian(persian)}');
  print('persianToIslamic → ${persianToIslamic(persian)}');
  print('persianToNepali → ${persianToNepali(persian)}');
  print('isPersianLeapYear(1404) → ${isPersianLeapYear(1404)}');
  print('persianWeekdayName → ${persianWeekdayName(persian)}');
  print('persianWeekdayNameShort → ${persianWeekdayNameShort(persian)}');
  print('persianMonthName(1) → ${persianMonthName(1)}');
  print('persianSeason(1) → ${persianSeason(1)}');
  print('persianZodiacSign → ${persianZodiacSign(persian)}');
  print('persianAddDays (+10) → ${persianAddDays(persian, 10)}');
  print('persianAddMonths (+1) → ${persianAddMonths(persian, 1)}');
  print('persianAddYears (+1) → ${persianAddYears(persian, 1)}');

  final age = persianAge(PersianDate(1370, 5, 10), PersianDate(1404, 1, 1));
  print('persianAge (1370/5/10 → 1404/1/1) → $age');
  print('persianDayOfYear → ${persianDayOfYear(persian)}');
  print('persianDaysInYear(1404) → ${persianDaysInYear(1404)}');
  print('persianWeekOfYear → ${persianWeekOfYear(persian)}');
  print('persianIsToday → ${persianIsToday(persian)}');
  print('persianIsFriday → ${persianIsFriday(persian)}');
  print('persianIsWeekend → ${persianIsWeekend(persian)}');
  print('persianIsWeekday → ${persianIsWeekday(persian)}');

  final holidays = persianGetHolidays(1404);
  print('persianGetHolidays(1404) first 5 → ${holidays.take(5).toList()}');
  print('persianIsHoliday(1404/1/1) → ${persianIsHoliday(persian)}');
  print(
    'persianGetMonthGrid(1404,1) first row → ${persianGetMonthGrid(1404, 1)[0]}',
  );
  print('persianGetWeekGrid(1404,1,0) → ${persianGetWeekGrid(1404, 1, 0)}');

  // ──────────────────────────────────────────────────────────────────────
  // 3. Gregorian-specific functions
  // ──────────────────────────────────────────────────────────────────────
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('3. Gregorian Functions');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  final gregorian = CivilDate(2025, 3, 21);
  print('gregorianToString → ${gregorianToString(gregorian)}');
  print('gregorianToFullString → ${gregorianToFullString(gregorian)}');
  print(
    'gregorianFormat (DD MMM YYYY) → ${gregorianFormat(gregorian, 'DD MMM YYYY')}',
  );
  print(
    'gregorianFormatStrftime (%A, %B %d) → ${gregorianFormatStrftime(gregorian, '%A, %B %d')}',
  );
  print('gregorianToPersian → ${gregorianToPersian(gregorian)}');
  print('gregorianToIslamic → ${gregorianToIslamic(gregorian)}');
  print('gregorianToNepali → ${gregorianToNepali(gregorian)}');
  print('isGregorianLeapYear(2024) → ${isGregorianLeapYear(2024)}');
  print('gregorianWeekdayName → ${gregorianWeekdayName(gregorian)}');
  print('gregorianWeekdayNameShort → ${gregorianWeekdayNameShort(gregorian)}');
  print('gregorianMonthName(3) → ${gregorianMonthName(3)}');
  print('gregorianAddDays (+10) → ${gregorianAddDays(gregorian, 10)}');
  print('gregorianAddMonths (+1) → ${gregorianAddMonths(gregorian, 1)}');
  print('gregorianAddYears (+1) → ${gregorianAddYears(gregorian, 1)}');

  final ageG = gregorianAge(CivilDate(1990, 5, 15), CivilDate(2025, 3, 21));
  print('gregorianAge (1990-05-15 → 2025-03-21) → $ageG');
  print('gregorianDaysInYear(2025) → ${gregorianDaysInYear(2025)}');
  print('gregorianDayOfYear → ${gregorianDayOfYear(gregorian)}');
  print('gregorianWeekOfYear → ${gregorianWeekOfYear(gregorian)}');
  print('gregorianIsToday → ${gregorianIsToday(gregorian)}');
  print('gregorianIsWeekend → ${gregorianIsWeekend(gregorian)}');
  print('gregorianIsWeekday → ${gregorianIsWeekday(gregorian)}');
  print(
    'gregorianGetMonthGrid(2025,3) first row → ${gregorianGetMonthGrid(2025, 3)[0]}',
  );

  // ──────────────────────────────────────────────────────────────────────
  // 4. Islamic-specific functions
  // ──────────────────────────────────────────────────────────────────────
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('4. Islamic (Hijri) Functions');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  final islamic = iDate; // استفاده از متغیر تعریف‌شده قبلی
  print('islamicGetCalculationMethod → ${islamicGetCalculationMethod()}');
  print('islamicToString → ${islamicToString(islamic)}');
  print('islamicToFullString → ${islamicToFullString(islamic)}');
  print(
    'islamicFormat (DD MMMM YYYY) → ${islamicFormat(islamic, 'DD MMMM YYYY')}',
  );
  print('islamicToPersian → ${islamicToPersian(islamic)}');
  print('islamicToGregorian → ${islamicToGregorian(islamic)}');
  print('islamicToNepali → ${islamicToNepali(islamic)}');
  print('islamicIsLeapYear(1446) → ${islamicIsLeapYear(1446)}');
  print('islamicWeekdayName → ${islamicWeekdayName(islamic)}');
  print('islamicWeekdayNameEn → ${islamicWeekdayNameEn(islamic)}');
  print('islamicMonthName(9) → ${islamicMonthName(9)}');
  print('islamicMonthNameEn(9) → ${islamicMonthNameEn(9)}');
  print('islamicAddDays (+10) → ${islamicAddDays(islamic, 10)}');
  print('islamicAddMonths (+1) → ${islamicAddMonths(islamic, 1)}');
  print('islamicAddYears (+1) → ${islamicAddYears(islamic, 1)}');
  print('islamicDaysInYear(1446) → ${islamicDaysInYear(1446)}');
  print('islamicDayOfYear → ${islamicDayOfYear(islamic)}');
  print('islamicIsToday → ${islamicIsToday(islamic)}');
  print('islamicGetEvents → ${islamicGetEvents(islamic)}');
  print(
    'islamicGetMonthGrid(1446,9) first row → ${islamicGetMonthGrid(1446, 9)[0]}',
  );

  // ──────────────────────────────────────────────────────────────────────
  // 5. Nepali-specific functions
  // ──────────────────────────────────────────────────────────────────────
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('5. Nepali (Bikram Sambat) Functions');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  final nepali = nDate; // استفاده از متغیر تعریف‌شده قبلی
  print('nepaliToString → ${nepaliToString(nepali)}');
  print('nepaliToFullString → ${nepaliToFullString(nepali)}');
  print(
    'nepaliFormat (DD MMMM YYYY) → ${nepaliFormat(nepali, 'DD MMMM YYYY')}',
  );
  print('nepaliToPersian → ${nepaliToPersian(nepali)}');
  print('nepaliToGregorian → ${nepaliToGregorian(nepali)}');
  print('nepaliToIslamic → ${nepaliToIslamic(nepali)}');
  print('nepaliIsLeapYear(2081) → ${nepaliIsLeapYear(2081)}');
  print('nepaliWeekdayName → ${nepaliWeekdayName(nepali)}');
  print('nepaliWeekdayNameEn → ${nepaliWeekdayNameEn(nepali)}');
  print('nepaliMonthName(12) → ${nepaliMonthName(12)}');
  print('nepaliMonthNameEn(12) → ${nepaliMonthNameEn(12)}');
  print('nepaliAddDays (+10) → ${nepaliAddDays(nepali, 10)}');
  print('nepaliAddMonths (+1) → ${nepaliAddMonths(nepali, 1)}');
  print('nepaliAddYears (+1) → ${nepaliAddYears(nepali, 1)}');
  print('nepaliDaysInYear(2081) → ${nepaliDaysInYear(2081)}');
  print('nepaliDayOfYear → ${nepaliDayOfYear(nepali)}');
  print('nepaliIsToday → ${nepaliIsToday(nepali)}');
  print(
    'nepaliGetMonthGrid(2081,12) first row → ${nepaliGetMonthGrid(2081, 12)[0]}',
  );

  // ──────────────────────────────────────────────────────────────────────
  // 6. Cross-calendar conversion functions
  // ──────────────────────────────────────────────────────────────────────
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('6. Cross-Calendar Converters');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  print(
    'convertDate(PersianDate(1404,1,1), CivilDate) → ${convertDate(pDate, CivilDate)}',
  );
  print(
    'convertDate(CivilDate(2025,3,21), IslamicDate) → ${convertDate(gDate, IslamicDate)}',
  );
  print('convertToPersian(CivilDate(2025,3,21)) → ${convertToPersian(gDate)}');
  print(
    'convertToGregorian(PersianDate(1404,1,1)) → ${convertToGregorian(pDate)}',
  );
  print('convertToIslamic(CivilDate(2025,3,21)) → ${convertToIslamic(gDate)}');
  print('convertToNepali(CivilDate(2025,3,21)) → ${convertToNepali(gDate)}');

  print('\n══════════════════════════════════════════════════════════════════');
  print('✅ مثال‌ها با موفقیت اجرا شدند.');
  print('══════════════════════════════════════════════════════════════════');
}
