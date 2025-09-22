import 'package:adkhar_project/services/language_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorite_service.dart';
import '../services/theme_service.dart';
import '../models/adhkar_data.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoriteService>().favorites;
    final lang = context.watch<LanguageService>();
    final themeService = context.watch<ThemeService>();

    final readingTheme = themeService.getReadingTheme();
    final isReadingDark = themeService.isReadingDarkMode;

    if (favs.isEmpty) {
      return Theme(
        data: readingTheme,
        child: Center(
          child: Text(
            lang.t('No favorites yet'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isReadingDark ? Colors.white70 : Colors.black,
            ),
          ),
        ),
      );
    }

    return Theme(
      data: readingTheme,
      child: Column(
        children: [
          // Custom header to match the app design
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              lang.t('Your Favorite Adhkar'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isReadingDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // List of favorites
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: favs.length,
              itemBuilder: (context, index) {
                final Dhikr dhikr = favs[index];
                return _FavoriteCard(dhikr: dhikr);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Dhikr dhikr;

  const _FavoriteCard({required this.dhikr});

  @override
  Widget build(BuildContext context) {
    final favService = context.read<FavoriteService>();
    final lang = context.watch<LanguageService>();
    final themeService = context.watch<ThemeService>();
    final isFav = favService.isFavorite(dhikr);
    final isReadingDark = themeService.isReadingDarkMode;

    return Card(
      color: isReadingDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isReadingDark
                  ? const Color(0xFF334155)
                  : const Color.fromRGBO(229, 231, 235, 1),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Favorite icon
            Row(
              children: [
                Expanded(
                  child: Text(
                    () {
                      final category = AdhkarData.categories.firstWhere(
                        (c) => c.id == dhikr.categoryId,
                        orElse:
                            () => AdhkarCategory(
                              id: dhikr.categoryId,
                              title: dhikr.categoryId,
                              arabicTitle: dhikr.categoryId,
                              arabicDescription: '',
                              description: '',
                              count: 0,
                            ),
                      );
                      return lang.isArabic
                          ? category.arabicTitle
                          : category.title;
                    }(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isReadingDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () => favService.toggleFavorite(dhikr),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: categoryColor(dhikr.categoryId),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                () {
                  final category = AdhkarData.categories.firstWhere(
                    (c) => c.id == dhikr.categoryId,
                    orElse:
                        () => AdhkarCategory(
                          id: dhikr.categoryId,
                          title: dhikr.categoryId,
                          arabicTitle: dhikr.categoryId,
                          arabicDescription: '',
                          description: '',
                          count: 0,
                        ),
                  );
                  return lang.isArabic ? category.arabicTitle : category.title;
                }(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Arabic text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isReadingDark
                        ? const Color(0xFF334155)
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                dhikr.arabic,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color:
                      isReadingDark
                          ? Colors.white
                          : const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Translation
            Text(
              dhikr.translation,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 13,
                color: isReadingDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: navigate to DhikrReaderScreen with this dhikr
                  },
                  icon: const Icon(Icons.menu_book, size: 18),
                  label: Text(lang.t('read_full')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isReadingDark
                            ? const Color(0xFF334155)
                            : const Color.fromARGB(255, 255, 255, 255),
                    foregroundColor:
                        isReadingDark ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: implement share logic
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: Text(lang.t('share')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isReadingDark ? const Color(0xFF334155) : Colors.blue,
                    foregroundColor:
                        isReadingDark ? Colors.white : Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color categoryColor(String id) {
  switch (id) {
    case 'morning':
      return Colors.orange;
    case 'evening':
      return Colors.indigo;
    case 'after-prayer':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
