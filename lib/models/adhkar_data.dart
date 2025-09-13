class AdhkarCategory {
  final String id;
  final String title;
  final String arabicTitle;
  final String description;
  final int count;

  const AdhkarCategory({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.description,
    required this.count,
  });
}

class Dhikr {
  final int id;
  final String arabic;
  final String transliteration;
  final String translation;
  final int count;
  final String source;

  const Dhikr({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.count,
    required this.source,
  });
}

class AdhkarData {
  static const List<AdhkarCategory> categories = [
    AdhkarCategory(id: 'morning', title: 'Morning Adhkar', arabicTitle: 'أذكار الصباح', description: 'Remembrances to be recited in the morning', count: 12),
    AdhkarCategory(id: 'evening', title: 'Evening Adhkar', arabicTitle: 'أذكار المساء', description: 'Remembrances to be recited in the evening', count: 11),
    AdhkarCategory(id: 'after-prayer', title: 'After Prayer', arabicTitle: 'أذكار بعد الصلاة', description: 'Dhikr to recite after the five daily prayers', count: 8),
  ];

  static final Map<String, List<Dhikr>> _adhkarData = {
    'morning': [
      Dhikr(
        id: 1,
        arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ...',
        transliteration: "Aṣbaḥnā wa aṣbaḥa'l-mulku lillāh...",
        translation: 'We have reached the morning...',
        count: 3,
        source: 'Muslim 2723',
      ),
    ],
    'evening': [
      Dhikr(
        id: 1,
        arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ...',
        transliteration: "Amsaynā wa amsa'l-mulku lillāh...",
        translation: 'We have reached the evening...',
        count: 3,
        source: 'Muslim 2723',
      ),
    ],
  };

  static List<Dhikr> getAdhkarList(String categoryId) {
    return _adhkarData[categoryId] ?? [];
  }
}


