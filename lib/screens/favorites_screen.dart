import 'package:adkhar_project/services/language_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorite_service.dart';
import '../models/adhkar_data.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoriteService>().favorites;

    if (favs.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No favorites yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<LanguageService>().t('Your Favorite Adhkar')),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: favs.length,
        itemBuilder: (context, index) {
          final Dhikr dhikr = favs[index];
          return _FavoriteCard(dhikr: dhikr);
        },
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
    final isFav = favService.isFavorite(dhikr);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color.fromRGBO(229, 231, 235, 1), width: 1),
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
                    getCategoryTitle(context, dhikr.categoryId),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                getCategoryTitle(context, dhikr.categoryId),
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
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                dhikr.arabic,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Translation
            Text(
              dhikr.translation,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
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
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Helpers to resolve category title properly
String getCategoryTitle(BuildContext context, String categoryId) {
  final lang = context.read<LanguageService>();
  final category = AdhkarData.categories.firstWhere(
    (c) => c.id == categoryId,
    orElse: () => AdhkarCategory(
      id: categoryId,
      title: categoryId,
      arabicTitle: categoryId,
      arabicDescription: '',
      description: '',
      count: 0,
    ),
  );

  return lang.isArabic ? category.arabicTitle : category.title;
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
