import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

class CustomBottomNavigation extends StatelessWidget {
  final String activeTab;
  final ValueChanged<String> onTabChange;

  const CustomBottomNavigation({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  int _indexFromTab(String tab) {
    switch (tab) {
      case 'dhikr':
        return 1;
      case 'favorites':
        return 2;
      case 'settings':
        return 3;
      default:
        return 0;
    }
  }

  String _tabFromIndex(int index) {
    switch (index) {
      case 1:
        return 'dhikr';
      case 2:
        return 'favorites';
      case 3:
        return 'settings';
      default:
        return 'home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return BottomNavigationBar(
          currentIndex: _indexFromTab(activeTab),
          onTap: (i) => onTabChange(_tabFromIndex(i)),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: languageService.t('home')),
            BottomNavigationBarItem(icon: Icon(Icons.dark_mode_outlined), label: languageService.t('dhikr')),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: languageService.t('favorites')),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: languageService.t('settings')),
          ],
        );
      },
    );
  }
}


