import 'package:flutter/foundation.dart';
import '../models/adhkar_data.dart';

class FavoriteService extends ChangeNotifier {
  final List<Dhikr> _favorites = [];

  List<Dhikr> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Dhikr dhikr) {
    return _favorites.any(
      (f) => f.id == dhikr.id && f.categoryId == dhikr.categoryId,
    );
  }

  void toggleFavorite(Dhikr dhikr) {
    if (isFavorite(dhikr)) {
      _favorites.removeWhere(
        (f) => f.id == dhikr.id && f.categoryId == dhikr.categoryId,
      );
    } else {
      _favorites.add(dhikr);
    }
    debugPrint("Favorites now: ${_favorites.length}");
    notifyListeners();
    debugPrint("Favorites now: ${_favorites.length}");
  }
}
