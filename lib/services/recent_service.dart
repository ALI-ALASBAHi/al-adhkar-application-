import 'package:flutter/foundation.dart';

/// Stores recently read adhkar category ids for quick access on Home.
class RecentService extends ChangeNotifier {
  static const int _maxItems = 8;

  final List<String> _recent = <String>[];

  List<String> get recent => List.unmodifiable(_recent);

  void addRecent(String categoryId) {
    // Move existing to front or insert new
    _recent.remove(categoryId);
    _recent.insert(0, categoryId);
    // Trim
    if (_recent.length > _maxItems) {
      _recent.removeRange(_maxItems, _recent.length);
    }
    notifyListeners();
  }

  void clear() {
    if (_recent.isEmpty) return;
    _recent.clear();
    notifyListeners();
  }
}



