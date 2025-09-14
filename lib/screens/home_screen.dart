import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current quote index for rotation
  int _currentQuoteIndex = 0;
  
  // Timer for updating time-based content
  Timer? _timeUpdateTimer;
  
  // Static quotes database - can be moved to a separate file later
  final List<Map<String, String>> _quotes = [
    {
      'text': '"Remember Allah often, so that you may be successful"',
      'reference': 'Quran 62:10',
    },
    {
      'text': '"And whoever turns away from My remembrance - indeed, he will have a depressed life"',
      'reference': 'Quran 20:124',
    },
    {
      'text': '"So remember Me; I will remember you"',
      'reference': 'Quran 2:152',
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

  /// Rotates the quote to show a different one
  void _rotateQuote() {
    setState(() {
      _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
    });
  }


  /// Gets current time formatted for display
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
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
        'title': languageService.t('morning_adhkar'),
        'subtitle': languageService.t('start_day_remembrance'),
        'category': 'morning',
      };
    }
    // Afternoon (Duha to Asr: 10 AM - 3 PM)
    else if (hour >= 10 && hour < 15) {
      return {
        'title': languageService.t('after_prayer'),
        'subtitle': languageService.t('post_prayer_remembrance'),
        'category': 'after-prayer',
      };
    }
    // Evening (Maghrib to Isha: 6 PM - 9 PM)
    else if (hour >= 18 && hour < 21) {
      return {
        'title': languageService.t('evening_adhkar'),
        'subtitle': languageService.t('end_day_dhikr'),
        'category': 'evening',
      };
    }
    // Night (Isha to Fajr: 9 PM - 5 AM)
    else {
      return {
        'title': languageService.t('before_sleep'),
        'subtitle': languageService.t('night_time_remembrance'),
        'category': 'before-sleep',
      };
    }
  }

  /// Handles navigation to specific adhkar category
  void _navigateToAdhkar(String category) {
    // TODO: Implement navigation to adhkar screen with specific category
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $category adhkar...')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return _buildHomeScreen(languageService);
      },
    );
  }

  /// Main home screen content
  Widget _buildHomeScreen(LanguageService languageService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Language toggle button
          _buildLanguageToggle(languageService),
          const SizedBox(height: 16),
          _buildRecommendedCard(languageService),
          const SizedBox(height: 24),
          _buildRecentAdhkarSection(languageService),
          const SizedBox(height: 24),
          _buildQuoteSection(),
        ],
      ),
    );
  }

  /// Language toggle button
  Widget _buildLanguageToggle(LanguageService languageService) {
    return Row(
      mainAxisAlignment: languageService.isRTL ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => languageService.setLanguage(false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: languageService.isArabic ? Colors.transparent : const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'EN',
                    style: TextStyle(
                      color: languageService.isArabic ? const Color(0xFF6B7280) : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => languageService.setLanguage(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: languageService.isArabic ? const Color(0xFF3B82F6) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'عربي',
                    style: TextStyle(
                      color: languageService.isArabic ? Colors.white : const Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  /// Time-based recommendation card with Arabic support
  Widget _buildRecommendedCard(LanguageService languageService) {
    final greeting = _getTimeBasedGreeting(languageService);
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
                // Current time display
                Text(
                  _getCurrentTime(),
                  style: const TextStyle(
                    color: Color(0xFF93C5FD),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                // Time-based greeting
                Text(
                  greeting,
                  style: const TextStyle(
                    color: Color(0xFF93C5FD),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
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
        Row(
          children: [
            // Morning Dhikr button
            Expanded(
              child: _buildCircularButton(
                icon: Icons.wb_sunny,
                label: languageService.t('morning_adhkar'),
                onTap: () => _navigateToAdhkar('morning'),
              ),
            ),
            const SizedBox(width: 16),
            // Evening Dhikr button
            Expanded(
              child: _buildCircularButton(
                icon: Icons.nightlight_round,
                label: languageService.t('evening_adhkar'),
                onTap: () => _navigateToAdhkar('evening'),
              ),
            ),
          ],
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
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
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
  Widget _buildQuoteSection() {
    final currentQuote = _quotes[_currentQuoteIndex];
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Star icon
          const Icon(
            Icons.star_outline,
            color: Color(0xFF3B82F6),
            size: 24,
          ),
          const SizedBox(height: 16),
          // Quote text
          Text(
            currentQuote['text']!,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Reference (tappable in future)
          GestureDetector(
            onTap: () {
              // TODO: Open full ayah in Quran page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening ${currentQuote['reference']}...')),
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
            ),
          ),
        ],
      ),
    );
  }
}


