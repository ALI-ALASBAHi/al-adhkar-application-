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
    final lang = context.watch<LanguageService>();

    if (favs.isEmpty) {
      return Center(
        child: Text(
          lang.t('No favorites yet'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Custom header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            lang.t('Your Favorite Adhkar'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
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
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color.fromRGBO(229, 231, 235, 1),
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
                    lang.t(getCategoryKey(dhikr.categoryId)),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                lang.t(getCategoryKey(dhikr.categoryId)),
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
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Translation
            Text(
              dhikr.translation,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
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
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
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
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
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

// Map all possible IDs to the correct LanguageService keys
String getCategoryKey(String categoryId) {
  switch (categoryId) {
    case 'morning':
    case 'morning_adhkar':
    case 'Morning Adhkar':
      return 'morning';

    case 'evening':
    case 'evening_adhkar':
    case 'Evening Adhkar':
      return 'evening';

    case 'after-prayer':
    case 'after_prayer':
    case 'After Prayer Adhkar':
      return 'after-prayer';

    case 'before-sleep':
    case 'before_sleep':
    case 'Before Sleep Adhkar':
      return 'before-sleep';

    default:
      return categoryId; // fallback: return as-is
  }
}

Color categoryColor(String id) {
  switch (id) {
    case 'morning':
    case 'morning_adhkar':
    case 'Morning Adhkar':
      return Colors.orange;

    case 'evening':
    case 'evening_adhkar':
    case 'Evening Adhkar':
      return Colors.indigo;

    case 'after-prayer':
    case 'after_prayer':
    case 'After Prayer Adhkar':
      return Colors.green;

    case 'before-sleep':
    case 'before_sleep':
    case 'Before Sleep Adhkar':
      return Colors.purple;

    default:
      return Colors.grey;
  }
}
