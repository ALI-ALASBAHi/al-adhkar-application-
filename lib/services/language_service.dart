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

  // Translation methods
  String t(String key) {
    return _isArabic ? _arabicTranslations[key] ?? key : _englishTranslations[key] ?? key;
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
    'morning_adhkar': 'Morning Adhkar',
    'evening_adhkar': 'Evening Adhkar',
    'after_prayer': 'After Prayer',
    'before_sleep': 'Before Sleep',
    
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
    'morning_adhkar': 'أذكار الصباح',
    'evening_adhkar': 'أذكار المساء',
    'after_prayer': 'أذكار بعد الصلاة',
    'before_sleep': 'أذكار قبل النوم',
    
    // Subtitles
    'start_day_remembrance': 'ابدأ يومك بالذكر',
    'end_day_dhikr': 'اختتم يومك بالذكر',
    'post_prayer_remembrance': 'ذكر بعد الصلاة',
    'night_time_remembrance': 'ذكر وقت الليل',
    
    // Navigation
    'home': 'الرئيسية',
    'dhikr': 'الأذكار',
    'favorites': 'المفضلة',
    'settings': 'الإعدادات',
    
    // Sidebar
    'settings_section': 'الإعدادات',
    'dark_mode': 'الوضع المظلم',
    'language': 'اللغة',
    'arabic_font_size': 'حجم الخط العربي',
    'prayer_reminders': 'تذكيرات الصلاة',
    'audio_pronunciation': 'النطق الصوتي',
    'islamic_tools': 'الأدوات الإسلامية',
    'prayer_times': 'أوقات الصلاة',
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
  };
}
