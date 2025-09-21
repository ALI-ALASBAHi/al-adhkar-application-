import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  bool _isArabic = false;

  bool get isArabic => _isArabic;
  bool get isRTL => _isArabic;

  void toggleLanguage() {
    _isArabic = !_isArabic;
    notifyListeners();
  }

  void setLanguage(bool isArabic) {
    _isArabic = isArabic;
    notifyListeners();
  }

  String timesTranslation(String number) {
    if (isArabic) {
      return _arabicTranslations[number] ?? '$number مرات';
    } else {
      return _englishTranslations[number] ?? 'Times: $number';
    }
  }

  // Translation methods
  String t(String key) {
    return _isArabic
        ? _arabicTranslations[key] ?? key
        : _englishTranslations[key] ?? key;
  }

  // English translations
  static const Map<String, String> _englishTranslations = {
    // App
    'app_title': 'Adhkar',
    'app_subtitle': 'أذكار',

    // Greetings
    'good_morning': 'Good Morning',
    'good_afternoon': 'Good Afternoon',
    'good_evening': 'Good Evening',
    'good_night': 'Good Night',

    // Home Screen
    'recommended_for_you': 'Recommended For You',
    'recent_adhkar': 'Recent Adhkar',
    'start': 'Start',

    // Adhkar Categories
    'morning': 'Morning Adhkar',
    'evening': 'Evening Adhkar',
    'after-prayer': 'After Prayer Adhkar',
    'before-sleep': 'Before Sleep Adhkar',

    // Subtitles
    'start_day_remembrance': 'Start your day with remembrance',
    'end_day_dhikr': 'End your day with dhikr',
    'post_prayer_remembrance': 'Post-prayer remembrance',
    'night_time_remembrance': 'Night time remembrance',

    // Navigation
    'home': 'Home',
    'dhikr': 'Dhikr',
    'favorites': 'Favorites',
    'settings': 'Settings',
    'prayer_Times': 'Prayer Times',

    // Sidebar
    'settings_section': 'SETTINGS',
    'dark_mode': 'Dark Mode',
    'language': 'Language',
    'arabic_font_size': 'Arabic Font Size',
    'prayer_reminders': 'Prayer Reminders',
    'audio_pronunciation': 'Audio Pronunciation',
    'islamic_tools': 'ISLAMIC TOOLS',
    'prayer_times': 'Prayer Times',
    'qibla_direction': 'Qibla Direction',
    'islamic_calendar': 'Islamic Calendar',
    'app_section': 'APP',
    'reading_statistics': 'Reading Statistics',
    'backup_sync': 'Backup & Sync',
    'about': 'About',
    'support_faq': 'Support & FAQ',
    'app_version': 'Adhkar App v1.2.0',

    // Headers
    'prayer_times_title': 'Prayer Times',
    'qibla_title': 'Qibla Direction',
    'statistics_title': 'Statistics',
    'calendar_title': 'Islamic Calendar',
    'backup_title': 'Backup & Sync',

    // Dhikr Screen
    'Adhkar Categories': 'Adhkar Categories',
    'Choose a category': 'Choose a category',

    // Times to read
    '1': 'One Time',
    '2': 'Two Times',
    '3': 'Three Times',
    '4': 'Four Times',
    '5': 'Five Times',
    '6': 'Six Times',
    '7': 'Seven Times',
    '8': 'Eight Times',
    '9': 'Nine Times',
    '10': 'Ten Times',

    //Time to read translation
    'One Time': 'One Time',
    'Two Times': 'Two Times',
    'Three Times': 'Three Times',
    'Four Times': 'Four Times',
    'Five Times': 'Five Times',
    'Six Times': 'Six Times',
    'Seven Times': 'Seven Times',
    'Eight Times': 'Eight Times',
    'Nine Times': 'Nine Times',
    'Ten Times': 'Ten Times',

    // Favorites Screen
    'Your Favorite Adhkar': 'Your Favorite Adhkar',
    'share': 'Share',
    'read_full': 'Read Full',
  };

  // Arabic translations
  static const Map<String, String> _arabicTranslations = {
    // App
    'app_title': 'أذكار',
    'app_subtitle': 'Adhkar',

    // Greetings
    'good_morning': 'صباح الخير',
    'good_afternoon': 'مساء الخير',
    'good_evening': 'مساء الخير',
    'good_night': 'تصبح على خير',

    // Home Screen
    'recommended_for_you': 'موصى لك',
    'recent_adhkar': 'الأذكار الأخيرة',
    'start': 'ابدأ',

    // Adhkar Categories
    'morning': 'أذكار الصباح',
    'evening': 'أذكار المساء',
    'after-prayer': 'أذكار بعد الصلاة',
    'before-sleep': 'أذكار قبل النوم',

    // Subtitles
    'start_day_remembrance': 'ابدأ يومك بالذكر',
    'end_day_dhikr': 'اختتم يومك بالذكر',
    'post_prayer_remembrance': 'ذكر بعد الصلاة',
    'night_time_remembrance': 'ذكر وقت الليل',

    // Navigation
    'Home': 'الرئيسية',
    'Dhikr': 'الأذكار',
    'Favorites': 'المفضلة',
    'Settings': 'الإعدادات',
    'Prayer Times': 'مواعيد الصلاه',
    // Sidebar
    'settings_section': 'الإعدادات',
    'dark_mode': 'الوضع المظلم',
    'language': 'اللغة',
    'arabic_font_size': 'حجم الخط العربي',
    'prayer_reminders': 'تذكيرات الصلاة',
    'audio_pronunciation': 'النطق الصوتي',
    'islamic_tools': 'الأدوات الإسلامية',
    'prayer_times': 'مواعيد الصلاه',
    'qibla_direction': 'اتجاه القبلة',
    'islamic_calendar': 'التقويم الهجري',
    'app_section': 'التطبيق',
    'reading_statistics': 'إحصائيات القراءة',
    'backup_sync': 'النسخ الاحتياطي والمزامنة',
    'about': 'حول',
    'support_faq': 'الدعم والأسئلة الشائعة',
    'app_version': 'تطبيق الأذكار الإصدار 1.2.0',

    // Headers
    'prayer_times_title': 'أوقات الصلاة',
    'qibla_title': 'اتجاه القبلة',
    'statistics_title': 'الإحصائيات',
    'calendar_title': 'التقويم الهجري',
    'backup_title': 'النسخ الاحتياطي والمزامنة',

    // Dhikr Screen
    'Adhkar Categories': 'تصنيفات الأذكار',
    'Choose a category': 'اختر تصنيفًا',

    //Time to read translation
    'One Time': 'مرة واحدة',
    'Two Times': 'مرتين',
    'Three Times': 'ثلاث مرات',
    'Four Times': 'أربع مرات',
    'Five Times': 'خمس مرات',
    'Six Times': 'ست مرات',
    'Seven Times': 'سبع مرات',
    'Eight Times': 'ثماني مرات',
    'Nine Times': 'تسع مرات',
    'Ten Times': 'عشر مرات',

    // Favorites Screen
    'Your Favorite Adhkar': 'الأذكار المفضلة',
    'share': 'مشاركة',
    'read_full': 'قراءة كاملة',
  };
}
