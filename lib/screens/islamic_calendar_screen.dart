import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/hijri_service.dart';

class IslamicCalendarScreen extends StatefulWidget {
  const IslamicCalendarScreen({super.key});

  @override
  State<IslamicCalendarScreen> createState() => _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends State<IslamicCalendarScreen> {
  bool _isHijriMode = true; // Default to Hijri calendar
  DateTime _currentDate = DateTime.now();
  final HijriService _hijriService = HijriService();

  // Navigation state for Hijri calendar
  int _currentHijriYear = 1447;
  int _currentHijriMonth = 4; // Rabi' al-thani

  @override
  void initState() {
    super.initState();
    // Initialize with current Hijri date
    final currentHijri = _hijriService.getCurrentHijriDate();
    _currentHijriYear = currentHijri['year']!;
    _currentHijriMonth = currentHijri['month']!;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar Header Container
                _buildCalendarHeader(languageService),
                const SizedBox(height: 20),

                // Monthly Calendar Header
                _buildMonthHeader(languageService),
                const SizedBox(height: 16),

                // Calendar Grid
                _buildCalendarGrid(languageService),
                const SizedBox(height: 20),

                // Legend
                _buildLegend(languageService),
                const SizedBox(height: 20),

                // Important Dates Section
                _buildImportantDatesSection(languageService),
                const SizedBox(height: 20),


              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarHeader(LanguageService languageService) {
    final now = DateTime.now();
    final hijriDate = _hijriService.gregorianToHijri(now);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with Calendar Icon
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Color(0xFF3B82F6),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                languageService.t('calendar'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Mode Toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isHijriMode = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            _isHijriMode
                                ? const Color(0xFF3B82F6)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.nights_stay,
                            color:
                                _isHijriMode ? Colors.white : Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            languageService.t('hijri'),
                            style: TextStyle(
                              color:
                                  _isHijriMode
                                      ? Colors.white
                                      : Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isHijriMode = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            !_isHijriMode
                                ? const Color(0xFF3B82F6)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wb_sunny,
                            color:
                                !_isHijriMode ? Colors.white : Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            languageService.t('gregorian'),
                            style: TextStyle(
                              color:
                                  !_isHijriMode
                                      ? Colors.white
                                      : Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Current Date Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Large date number
                Text(
                  _convertToArabicNumbers(
                    _isHijriMode
                        ? hijriDate['day']!.toString()
                        : now.day.toString(),
                    languageService,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Month and year
                Text(
                  _isHijriMode
                      ? '${_hijriService.getHijriMonthName(hijriDate['month']!, languageService.isArabic)} ${_convertToArabicNumbers(hijriDate['year']!.toString(), languageService)}'
                      : '${_hijriService.getGregorianMonthName(now.month, languageService.isArabic)} ${_convertToArabicNumbers(now.year.toString(), languageService)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),

                // Day of week
                Text(
                  _hijriService.getDayOfWeekName(
                    now.weekday,
                    languageService.isArabic,
                  ),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),

                // Correspondence
                Text(
                  _isHijriMode
                      ? '${languageService.t('corresponding_to')} ${_hijriService.getGregorianMonthName(now.month, languageService.isArabic)} ${_convertToArabicNumbers(now.year.toString(), languageService)}'
                      : '${languageService.t('corresponding_to')} ${_hijriService.getHijriMonthName(hijriDate['month']!, languageService.isArabic)} ${_convertToArabicNumbers(hijriDate['year']!.toString(), languageService)}',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(LanguageService languageService) {
    final monthName =
        _isHijriMode
            ? _hijriService.getHijriMonthName(
              _currentHijriMonth,
              languageService.isArabic,
            )
            : _hijriService.getGregorianMonthName(
              _currentDate.month,
              languageService.isArabic,
            );
    final year = _convertToArabicNumbers(
      _isHijriMode
          ? _currentHijriYear.toString()
          : _currentDate.year.toString(),
      languageService,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isHijriMode) {
                  // Navigate to previous Hijri month
                  _currentHijriMonth--;
                  if (_currentHijriMonth < 1) {
                    _currentHijriMonth = 12;
                    _currentHijriYear--;
                  }
                } else {
                  // Navigate to previous Gregorian month
                  _currentDate = DateTime(
                    _currentDate.year,
                    _currentDate.month - 1,
                  );
                }
              });
            },
            icon: const Icon(Icons.chevron_left, color: Color(0xFF3B82F6)),
          ),
          Column(
            children: [
              Text(
                '$monthName $year',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              if (_isHijriMode) ...[
                const SizedBox(height: 4),
                Text(
                  _hijriService.getHijriMonthName(_currentHijriMonth, true),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF3B82F6),
                    fontFamily: 'Amiri',
                  ),
                ),
                const SizedBox(height: 2),
              ],
            ],
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (_isHijriMode) {
                  // Navigate to next Hijri month
                  _currentHijriMonth++;
                  if (_currentHijriMonth > 12) {
                    _currentHijriMonth = 1;
                    _currentHijriYear++;
                  }
                } else {
                  // Navigate to next Gregorian month
                  _currentDate = DateTime(
                    _currentDate.year,
                    _currentDate.month + 1,
                  );
                }
              });
            },
            icon: const Icon(Icons.chevron_right, color: Color(0xFF3B82F6)),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(LanguageService languageService) {
    final now = DateTime.now();
    final hijriDate = _hijriService.gregorianToHijri(now);

    // Get current month and year based on mode
    int currentMonth, currentYear;
    if (_isHijriMode) {
      currentMonth = _currentHijriMonth;
      currentYear = _currentHijriYear;
    } else {
      currentMonth = _currentDate.month;
      currentYear = _currentDate.year;
    }

    final firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    final lastDayOfMonth = DateTime(currentYear, currentMonth + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    // Get Islamic events for current month
    final monthEvents =
        _isHijriMode
            ? _hijriService.getEventsForMonth(currentMonth, currentYear)
            : <int, Map<String, dynamic>>{};

    // Days of week headers
    final weekdays =
        languageService.isArabic
            ? ['س', 'أ', 'إ', 'ث', 'ج', 'خ', 'ج']
            : ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children:
                weekdays
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 8),

          // Calendar grid
          ...List.generate(6, (weekIndex) {
            return Row(
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 2;
                final isCurrentMonth =
                    dayNumber > 0 && dayNumber <= daysInMonth;

                // Check if this is today
                bool isToday = false;
                if (_isHijriMode) {
                  isToday =
                      isCurrentMonth &&
                      currentYear == hijriDate['year'] &&
                      currentMonth == hijriDate['month'] &&
                      dayNumber == hijriDate['day'];
                } else {
                  isToday =
                      isCurrentMonth &&
                      currentYear == now.year &&
                      currentMonth == now.month &&
                      dayNumber == now.day;
                }

                final hasEvent =
                    isCurrentMonth && monthEvents.containsKey(dayNumber);

                return Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(2),
                    child:
                        isCurrentMonth
                            ? Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color:
                                          isToday
                                              ? const Color(0xFF3B82F6)
                                              : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        _convertToArabicNumbers(
                                          dayNumber.toString(),
                                          languageService,
                                        ),
                                        style: TextStyle(
                                          color:
                                              isToday
                                                  ? Colors.white
                                                  : const Color(0xFF374151),
                                          fontWeight:
                                              isToday
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (hasEvent && !isToday)
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            )
                            : const SizedBox(),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLegend(LanguageService languageService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                languageService.t('today'),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                languageService.t('islamic_event'),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImportantDatesSection(LanguageService languageService) {
    // Get events for current month
    final monthEvents =
        _isHijriMode
            ? _hijriService.getEventsForMonth(
              _currentHijriMonth,
              _currentHijriYear,
            )
            : <int, Map<String, dynamic>>{};

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_outline, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                languageService.t('important_dates_this_month'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (monthEvents.isEmpty)
          SizedBox(
            width: double.infinity, 
            child: Center(
              child: Text(languageService.isArabic
                  ? 'لا توجد مناسبات إسلامية هذا الشهر'
                  : 'No Islamic events this month',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),)),)
          else
            ...monthEvents.entries.map((entry) {
              final day = entry.key;
              final event = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[100]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _convertToArabicNumbers(
                            day.toString(),
                            languageService,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageService.isArabic
                                ? event['ar']!
                                : event['en']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            languageService.isArabic
                                ? event['description_ar']!
                                : event['description_en']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
