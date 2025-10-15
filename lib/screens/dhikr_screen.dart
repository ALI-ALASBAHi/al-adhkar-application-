import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/adhkar_data.dart';
import '../services/language_service.dart';
import 'dhikr_reader_screen.dart';

class DhikrScreen extends StatelessWidget {
  const DhikrScreen({super.key});

  // --- NEW: List of icon paths in order ---
  // This makes it much cleaner to manage your icons.
  // Just make sure the order here matches the order of your categories in AdhkarData.
  final List<String> _iconPaths = const [
    'assets/icons/ramadan-sunrise.png',          // For category 0
    'assets/icons/isha-prayer.png',              // For category 1
    'assets/icons/islamic-friday-prayer.png',    // For category 2
    'assets/icons/sleeping.png',                 // For category 3
    'assets/icons/travel-around-the-world.png',  // For category 4
    // Add paths for new categories here
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, language, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Center(
              child: Text(
                language.t('Adhkar Categories'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                language.t('Choose a category'),
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: AdhkarData.categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, i) {
                  final c = AdhkarData.categories[i];
                  return _CategoryCard(
                    titleEn: c.title,
                    titleAr: c.arabicTitle,
                    subtitle:
                        language.isArabic ? c.arabicDescription : c.description,
                    count: c.count,
                    // --- UPDATED: Use the list to get the icon path ---
                    iconPath: _iconPaths[i],
                    isArabic: language.isArabic,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DhikrReaderScreen(
                            categoryId: c.id,
                            title: language.isArabic ? c.arabicTitle : c.title,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// No changes needed for _CategoryCard or _Pill widgets below this line...

class _CategoryCard extends StatelessWidget {
  final String titleEn;
  final String titleAr;
  final String subtitle;
  final int count;
  final String iconPath;
  final VoidCallback onTap;
  final bool isArabic;

  const _CategoryCard({
    required this.titleEn,
    required this.titleAr,
    required this.subtitle,
    required this.count,
    required this.iconPath,
    required this.onTap,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromRGBO(229, 231, 235, 1)),
        ),
        constraints: const BoxConstraints(minHeight: 88),
        padding: const EdgeInsets.all(25),
        child: Row(
          children: [
            Image.asset(
              // Adhkar icons
              iconPath,
              width: 75,
              height: 75,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isArabic ? titleAr : titleEn,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      _Pill(count: count),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final int count;
  const _Pill({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
      ),
    );
  }
}