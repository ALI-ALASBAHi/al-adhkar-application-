import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/language_service.dart';
import '../models/adhkar_data.dart';
import '../services/recent_service.dart';
import '../widgets/screen_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current quote index for rotation
  int _currentQuoteIndex = 0;
  // Language switching loading flag
  bool _isSwitchingLanguage = false;

  // Timer for updating time-based content
  Timer? _timeUpdateTimer;

  // Quranic verses database with Arabic and English translations
  final List<Map<String, String>> _quotes = [
    {
      'text_en': '"Remember Allah often, so that you may be successful"',
      'text_ar': '"وَاذْكُرُوا اللَّهَ كَثِيرًا لَّعَلَّكُمْ تُفْلِحُونَ"',
      'reference': 'Quran 62:10',
    },
    {
      'text_en':
          '"And whoever turns away from My remembrance - indeed, he will have a depressed life"',
      'text_ar': '"وَمَنْ أَعْرَضَ عَن ذِكْرِي فَإِنَّ لَهُ مَعِيشَةً ضَنكًا"',
      'reference': 'Quran 20:124',
    },
    {
      'text_en': '"So remember Me; I will remember you"',
      'text_ar': '"فَاذْكُرُونِي أَذْكُرْكُمْ"',
      'reference': 'Quran 2:152',
    },
    {
      'text_en':
          '"And it is He who created the heavens and earth in truth. And the day He says, "Be," and it is, His word is the truth"',
      'text_ar':
          '"وَهُوَ الَّذِي خَلَقَ السَّمَاوَاتِ وَالْأَرْضَ بِالْحَقِّ ۖ وَيَوْمَ يَقُولُ كُن فَيَكُونُ ۚ قَوْلُهُ الْحَقُّ"',
      'reference': 'Quran 6:73',
    },
    {
      'text_en':
          '"And whoever relies upon Allah - then He is sufficient for him"',
      'text_ar': '"وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ"',
      'reference': 'Quran 65:3',
    },
    {
      'text_en':
          '"And whoever does righteous deeds, whether male or female, while being a believer - those will enter Paradise"',
      'text_ar':
          '"وَمَن يَعْمَلْ مِنَ الصَّالِحَاتِ مِن ذَكَرٍ أَوْ أُنثَىٰ وَهُوَ مُؤْمِنٌ فَأُولَٰئِكَ يَدْخُلُونَ الْجَنَّةَ"',
      'reference': 'Quran 4:124',
    },
    {
      'text_en': '"And whoever fears Allah - He will make for him a way out"',
      'text_ar': '"وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا"',
      'reference': 'Quran 65:2',
    },
    {
      'text_en':
          '"And whoever fears Allah - He will make for him ease in his matter"',
      'text_ar': '"وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مِنْ أَمْرِهِ يُسْرًا"',
      'reference': 'Quran 65:4',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Rotate quote on app start
    _rotateQuote();
    // Start timer to update time-based content every minute
    _startTimeUpdateTimer();
  }

  @override
  void dispose() {
    _timeUpdateTimer?.cancel();
    super.dispose();
  }

  /// Starts a timer to update time-based content every minute
  void _startTimeUpdateTimer() {
    _timeUpdateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          // This will trigger a rebuild with updated time
        });
      }
    });
  }

  /// Selects a random quote to show
  void _rotateQuote() {
    setState(() {
      final random = Random();
      int newIndex;
      do {
        newIndex = random.nextInt(_quotes.length);
      } while (newIndex == _currentQuoteIndex && _quotes.length > 1);
      _currentQuoteIndex = newIndex;
    });
  }

  /// Gets current time formatted for display with language support
  String _getCurrentTime(LanguageService languageService) {
    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return _convertToArabicNumbers(timeString, languageService);
  }

  /// Gets current AM/PM indicator with language support
  String _getAmPm(LanguageService languageService) {
    final now = DateTime.now();
    if (languageService.isArabic) {
      return now.hour >= 12 ? 'م' : 'ص';
    } else {
      return now.hour >= 12 ? 'PM' : 'AM';
    }
  }

  /// Converts numbers to Arabic numerals if language is Arabic
  String _convertToArabicNumbers(String text, LanguageService languageService) {
    if (!languageService.isArabic) return text;

    return text
        .replaceAll('0', '٠')
        .replaceAll('1', '١')
        .replaceAll('2', '٢')
        .replaceAll('3', '٣')
        .replaceAll('4', '٤')
        .replaceAll('5', '٥')
        .replaceAll('6', '٦')
        .replaceAll('7', '٧')
        .replaceAll('8', '٨')
        .replaceAll('9', '٩');
  }

  /// Gets current Gregorian date formatted for display with language support
  String _getGregorianDate(LanguageService languageService) {
    final now = DateTime.now();

    if (languageService.isArabic) {
      final weekdays = [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ];
      final months = [
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

      final weekday = weekdays[now.weekday - 1];
      final month = months[now.month - 1];
      final dateString = '$weekday، $month ${now.day}، ${now.year}';
      return _convertToArabicNumbers(dateString, languageService);
    } else {
      return DateFormat('EEEE, MMMM d, yyyy').format(now);
    }
  }

  /// Simple Hijri date conversion (approximate) with language support
  String _getHijriDate(LanguageService languageService) {
    final now = DateTime.now();
    // Simple approximation: Hijri year is roughly 622 years behind Gregorian
    // This is a basic implementation - for production use a proper Hijri library
    final hijriYear = now.year - 622;
    final hijriMonth = now.month;
    final hijriDay = now.day;

    if (languageService.isArabic) {
      final weekdays = [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ];
      final months = [
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

      final weekday = weekdays[now.weekday - 1];
      final month = months[hijriMonth - 1];
      final dateString = '$weekday، $hijriDay $month، $hijriYear هـ';
      return _convertToArabicNumbers(dateString, languageService);
    } else {
      final weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      final months = [
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

      final weekday = weekdays[now.weekday - 1];
      final month = months[hijriMonth - 1];
      return '$weekday, $hijriDay $month, $hijriYear AH';
    }
  }

  /// Gets appropriate time-based icon
  IconData _getTimeBasedIcon() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return Icons.wb_sunny; // Morning sun
    } else if (hour >= 12 && hour < 17) {
      return Icons.wb_sunny_outlined; // Afternoon sun
    } else if (hour >= 17 && hour < 21) {
      return Icons.wb_twilight; // Evening
    } else {
      return Icons.nightlight_round; // Night moon
    }
  }

  /// Gets time-based greeting using language service
  String _getTimeBasedGreeting(LanguageService languageService) {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return languageService.t('good_morning');
    } else if (hour >= 12 && hour < 17) {
      return languageService.t('good_afternoon');
    } else if (hour >= 17 && hour < 21) {
      return languageService.t('good_evening');
    } else {
      return languageService.t('good_night');
    }
  }

  /// Gets recommended adhkar based on current time using language service
  Map<String, String> _getRecommendedAdhkar(LanguageService languageService) {
    final now = DateTime.now();
    final hour = now.hour;

    // Morning time (Fajr to Duha: 5 AM - 10 AM)
    if (hour >= 5 && hour < 10) {
      return {
        'title': languageService.t('morning'),
        'subtitle': languageService.t('start_day_remembrance'),
        'category': 'morning',
      };
    }
    // Afternoon (Duha to Asr: 10 AM - 3 PM)
    else if (hour >= 10 && hour < 15) {
      return {
        'title': languageService.t('after-prayer'),
        'subtitle': languageService.t('post_prayer_remembrance'),
        'category': 'after-prayer',
      };
    }
    // Evening (Maghrib to Isha: 6 PM - 9 PM)
    else if (hour >= 18 && hour < 21) {
      return {
        'title': languageService.t('evening'),
        'subtitle': languageService.t('end_day_dhikr'),
        'category': 'evening',
      };
    }
    // Night (Isha to Fajr: 9 PM - 5 AM)
    else {
      return {
        'title': languageService.t('before-sleep'),
        'subtitle': languageService.t('night_time_remembrance'),
        'category': 'before-sleep',
      };
    }
  }

  /// Handles navigation to specific adhkar category
  void _navigateToAdhkar(String category) {
    // TODO: Implement navigation to adhkar screen with specific category
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $category adhkar...'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16, // keeps it above BottomAppBar + FAB
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return ScreenLoader(
          isLoading: _isSwitchingLanguage,
          message:
              languageService.isArabic
                  ? 'جاري تبديل اللغة...'
                  : 'Switching Language...',
          child: KeyedSubtree(
            key: ValueKey<bool>(languageService.isArabic),
            child: _buildHomeScreen(languageService),
          ),
        );
      },
    );
  }

  /// Main home screen content
  Widget _buildHomeScreen(LanguageService languageService) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting container
              _buildGreetingContainer(languageService),
              const SizedBox(height: 16),
              _buildRecommendedCard(languageService),
              const SizedBox(height: 24),
              _buildRecentAdhkarSection(languageService),
              const SizedBox(height: 24),
              _buildQuoteSection(languageService),
            ],
          ),
        ),
        if (_isSwitchingLanguage)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.15),
              child: const Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Greeting container with time, date, and Hijri date
  Widget _buildGreetingContainer(LanguageService languageService) {
    final greeting = _getTimeBasedGreeting(languageService);
    final timeIcon = _getTimeBasedIcon();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(timeIcon, color: const Color(0xFF3B82F6), size: 24),
              const SizedBox(width: 8),
              Text(
                greeting,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time and date row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Time with clock icon
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color(0xFF64748B),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_getCurrentTime(languageService)} ${_getAmPm(languageService)}',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Separator dot
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFCBD5E1),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),

              // Gregorian date
              Text(
                _getGregorianDate(languageService),
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Hijri date
          Center(
            child: Text(
              _getHijriDate(languageService),
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: languageService.isArabic ? 'Amiri' : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Time-based recommendation card with Arabic support
  Widget _buildRecommendedCard(LanguageService languageService) {
    final recommendation = _getRecommendedAdhkar(languageService);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 53, 97, 167),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main recommendation title
                Text(
                  languageService.t('recommended_for_you'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Recommendation title
                Text(
                  recommendation['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                // Recommendation subtitle
                Text(
                  recommendation['subtitle']!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          // Start button with Arabic support
          ElevatedButton(
            onPressed: () => _navigateToAdhkar(recommendation['category']!),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF93C5FD),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(languageService.t('start')),
          ),
        ],
      ),
    );
  }

  /// Recent Adhkar quick access section with Arabic support
  Widget _buildRecentAdhkarSection(LanguageService languageService) {
    final recents = context.watch<RecentService?>()?.recent ?? const <String>[];
    final recentCategories =
        recents
            .map(
              (id) => AdhkarData.categories.firstWhere(
                (c) => c.id == id,
                orElse: () => AdhkarData.categories.first,
              ),
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          languageService.t('recent_adhkar'),
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (recentCategories.isEmpty)
          Row(
            children: [
              Expanded(
                child: _buildCircularButton(
                  icon: Icons.wb_sunny,
                  label: languageService.t('morning_adhkar'),
                  onTap: () => _navigateToAdhkar('morning'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCircularButton(
                  icon: Icons.nightlight_round,
                  label: languageService.t('evening_adhkar'),
                  onTap: () => _navigateToAdhkar('evening'),
                ),
              ),
            ],
          )
        else
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                final c = recentCategories[i];
                final icon =
                    c.id == 'morning'
                        ? Icons.wb_sunny
                        : c.id == 'evening'
                        ? Icons.nightlight_round
                        : Icons.star;
                return SizedBox(
                  width: 120,
                  child: _buildCircularButton(
                    icon: icon,
                    label: languageService.isArabic ? c.arabicTitle : c.title,
                    onTap: () => _navigateToAdhkar(c.id),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: recentCategories.length,
            ),
          ),
      ],
    );
  }

  /// Circular button for quick access
  Widget _buildCircularButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Rotating quote section with Quran/Hadith references
  Widget _buildQuoteSection(LanguageService languageService) {
    final currentQuote = _quotes[_currentQuoteIndex];
    final isArabic = languageService.isArabic;
    final verseText =
        isArabic ? currentQuote['text_ar']! : currentQuote['text_en']!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row for icon + text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_outline,
                color: Color(0xFF3B82F6),
                size: 24,
              ),
              Text('  '),
              Text(languageService.t('daily_reflection')),
              const SizedBox(width: 8), // spacing between text and icon
            ],
          ),
          const SizedBox(height: 16),

          // Quote text
          Text(
            verseText,
            style: TextStyle(
              color: const Color(0xFF374151),
              fontSize: isArabic ? 18 : 16,
              height: 1.5,
              fontFamily: isArabic ? 'Amiri' : null,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Reference
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic
                        ? 'جاري فتح ${currentQuote['reference']}...'
                        : 'Opening ${currentQuote['reference']}...',
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black,
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: Text(
              currentQuote['reference']!,
              style: const TextStyle(
                color: Color(0xFF3B82F6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
