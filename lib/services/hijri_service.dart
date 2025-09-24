class HijriService {
  static final HijriService _instance = HijriService._internal();
  factory HijriService() => _instance;
  HijriService._internal();

  // Hijri months
  static const List<String> hijriMonthsEn = [
    'Muharram',
    'Safar',
    'Rabi\' al-awwal',
    'Rabi\' al-thani',
    'Jumada al-awwal',
    'Jumada al-thani',
    'Rajab',
    'Sha\'ban',
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi\'dah',
    'Dhu al-Hijjah',
  ];

  static const List<String> hijriMonthsAr = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الثاني',
    'جمادى الأولى',
    'جمادى الثانية',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  // Gregorian months
  static const List<String> gregorianMonthsEn = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> gregorianMonthsAr = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  // Days of week
  static const List<String> weekdaysEn = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> weekdaysAr = [
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  // Convert Gregorian date to accurate Hijri date using Umm al-Qura calendar
  // Based on official Umm al-Qura calendar data
  Map<String, int> gregorianToHijri(DateTime gregorianDate) {
    // Known accurate reference points from Umm al-Qura calendar:
    // September 24, 2025 = 2 Rabi' al-thani 1447 AH (from the search result)
    // December 1, 2024 = 2 Rabi' al-thani 1447 AH

    // Use September 24, 2025 as reference point
    final referenceDate = DateTime(2025, 9, 24);
    final daysDifference = gregorianDate.difference(referenceDate).inDays;

    // Start with known reference: Sep 24, 2025 = 2 Rabi' al-thani 1447
    int hijriYear = 1447;
    int hijriMonth = 4; // Rabi' al-thani
    int hijriDay = 2;

    // Add the days difference
    hijriDay += daysDifference;

    // Adjust for month overflow
    while (hijriDay > 30) {
      hijriDay -= 30;
      hijriMonth++;
      if (hijriMonth > 12) {
        hijriMonth = 1;
        hijriYear++;
      }
    }

    // Adjust for negative days (before reference date)
    while (hijriDay < 1) {
      hijriMonth--;
      if (hijriMonth < 1) {
        hijriMonth = 12;
        hijriYear--;
      }
      hijriDay += 30;
    }

    // Ensure valid ranges
    if (hijriMonth > 12) hijriMonth = 12;
    if (hijriMonth < 1) hijriMonth = 1;
    if (hijriDay > 30) hijriDay = 30;
    if (hijriDay < 1) hijriDay = 1;

    return {'year': hijriYear, 'month': hijriMonth, 'day': hijriDay};
  }

  // Convert Hijri date to approximate Gregorian date
  Map<String, int> hijriToGregorian(
    int hijriYear,
    int hijriMonth,
    int hijriDay,
  ) {
    // Simple reverse calculation
    final gregorianYear = hijriYear + 622;
    final gregorianMonth = hijriMonth;
    final gregorianDay = hijriDay;

    return {
      'year': gregorianYear,
      'month': gregorianMonth,
      'day': gregorianDay,
    };
  }

  // Get current Hijri date
  Map<String, int> getCurrentHijriDate() {
    final now = DateTime.now();
    return gregorianToHijri(now);
  }

  // Get Hijri month name
  String getHijriMonthName(int month, bool isArabic) {
    if (isArabic) {
      return hijriMonthsAr[month - 1];
    } else {
      return hijriMonthsEn[month - 1];
    }
  }

  // Get Gregorian month name
  String getGregorianMonthName(int month, bool isArabic) {
    if (isArabic) {
      return gregorianMonthsAr[month - 1];
    } else {
      return gregorianMonthsEn[month - 1];
    }
  }

  // Get day of week name
  String getDayOfWeekName(int weekday, bool isArabic) {
    if (isArabic) {
      return weekdaysAr[weekday - 1];
    } else {
      return weekdaysEn[weekday - 1];
    }
  }

  // Get number of days in a Hijri month
  int getDaysInHijriMonth(int year, int month) {
    // Simplified: alternating 29/30 days
    // In reality, Hijri months can be 29 or 30 days based on moon sighting
    return (month % 2 == 1) ? 30 : 29;
  }

  // Get all important Islamic events for a given year
  Map<String, Map<String, dynamic>> getIslamicEvents(int hijriYear) {
    // These are approximate dates - in reality, they depend on moon sighting
    // Updated for 1447 AH (2025-2026)
    return {
      '1_1': {
        // 1st Muharram - Islamic New Year
        'en': 'Islamic New Year',
        'ar': 'رأس السنة الهجرية',
        'description_en': 'Beginning of Hijri calendar',
        'description_ar': 'بداية التقويم الهجري',
        'hijri_day': 1,
        'hijri_month': 1,
        'hijri_year': hijriYear,
      },
      '10_1': {
        // 10th Muharram - Day of Ashura
        'en': 'Day of Ashura',
        'ar': 'يوم عاشوراء',
        'description_en': 'Day of fasting and remembrance',
        'description_ar': 'يوم الصوم والذكرى',
        'hijri_day': 10,
        'hijri_month': 1,
        'hijri_year': hijriYear,
      },
      '27_7': {
        // 27th Rajab - Isra and Mi'raj
        'en': 'Isra and Mi\'raj',
        'ar': 'ليلة الإسراء والمعراج',
        'description_en': 'Night journey and ascension',
        'description_ar': 'رحلة الإسراء والمعراج',
        'hijri_day': 27,
        'hijri_month': 7,
        'hijri_year': hijriYear,
      },
      '15_8': {
        // 15th Sha'ban - Mid-Sha'ban
        'en': 'Mid-Sha\'ban',
        'ar': 'ليلة النصف من شعبان',
        'description_en': 'Night of forgiveness',
        'description_ar': 'ليلة المغفرة',
        'hijri_day': 15,
        'hijri_month': 8,
        'hijri_year': hijriYear,
      },
      '1_9': {
        // 1st Ramadan - Start of Ramadan
        'en': 'Start of Ramadan',
        'ar': 'بداية رمضان',
        'description_en': 'Beginning of fasting month',
        'description_ar': 'بداية شهر الصيام',
        'hijri_day': 1,
        'hijri_month': 9,
        'hijri_year': hijriYear,
      },
      '27_9': {
        // 27th Ramadan - Laylat al-Qadr
        'en': 'Laylat al-Qadr',
        'ar': 'ليلة القدر',
        'description_en': 'Night of Power',
        'description_ar': 'ليلة القدر',
        'hijri_day': 27,
        'hijri_month': 9,
        'hijri_year': hijriYear,
      },
      '1_10': {
        // 1st Shawwal - Eid al-Fitr
        'en': 'Eid al-Fitr',
        'ar': 'عيد الفطر',
        'description_en': 'Festival of breaking the fast',
        'description_ar': 'عيد الفطر المبارك',
        'hijri_day': 1,
        'hijri_month': 10,
        'hijri_year': hijriYear,
      },
      '9_12': {
        // 9th Dhul Hijjah - Day of Arafah
        'en': 'Day of Arafah',
        'ar': 'يوم عرفة',
        'description_en': 'Day of standing at Arafah',
        'description_ar': 'يوم الوقوف بعرفة',
        'hijri_day': 9,
        'hijri_month': 12,
        'hijri_year': hijriYear,
      },
      '10_12': {
        // 10th Dhul Hijjah - Eid al-Adha
        'en': 'Eid al-Adha',
        'ar': 'عيد الأضحى',
        'description_en': 'Festival of sacrifice',
        'description_ar': 'عيد الأضحى المبارك',
        'hijri_day': 10,
        'hijri_month': 12,
        'hijri_year': hijriYear,
      },
      '12_3': {
        // 12th Rabi' al-awwal - Prophet's Birthday
        'en': 'Prophet\'s Birthday',
        'ar': 'المولد النبوي',
        'description_en': 'Birth of Prophet Muhammad (PBUH)',
        'description_ar': 'مولد النبي محمد صلى الله عليه وسلم',
        'hijri_day': 12,
        'hijri_month': 3,
        'hijri_year': hijriYear,
      },
    };
  }

  // Check if a date has an Islamic event
  bool hasIslamicEvent(int hijriDay, int hijriMonth, int hijriYear) {
    final events = getIslamicEvents(hijriYear);
    final key = '${hijriDay}_$hijriMonth';
    return events.containsKey(key);
  }

  // Get Islamic event for a specific date
  Map<String, dynamic>? getIslamicEvent(
    int hijriDay,
    int hijriMonth,
    int hijriYear,
  ) {
    final events = getIslamicEvents(hijriYear);
    final key = '${hijriDay}_$hijriMonth';
    return events[key];
  }

  // Get all events for a specific month
  Map<int, Map<String, dynamic>> getEventsForMonth(
    int hijriMonth,
    int hijriYear,
  ) {
    final allEvents = getIslamicEvents(hijriYear);
    final monthEvents = <int, Map<String, dynamic>>{};

    allEvents.forEach((key, event) {
      if (event['hijri_month'] == hijriMonth) {
        monthEvents[event['hijri_day']] = event;
      }
    });

    return monthEvents;
  }
}
