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

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        Color colorFor(String tab) =>
            activeTab == tab ? Colors.blue : Colors.grey;

        Widget buildItem({
          required IconData icon,
          required String label,
          required String tab,
        }) {
          final isActive = activeTab == tab;

          Widget animatedIcon;

          switch (tab) {
            case 'home':
              // animation
              animatedIcon = AnimatedScale(
                scale: isActive ? 1.3 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Icon(icon, color: colorFor(tab)),
              );
              break;

            case 'dhikr':
              // animation
              animatedIcon = AnimatedScale(
                scale: isActive ? 1.3 : 1.0,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 400),
                child: Icon(icon, color: colorFor(tab)),
              );
              break;

            case 'favorites':
              // animation
              animatedIcon = AnimatedScale(
                scale: isActive ? 1.3 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Icon(icon, color: colorFor(tab)),
              );
              break;

            case 'settings':
              // animation
              animatedIcon = AnimatedScale(
                scale: isActive ? 1.3 : 1.0,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 500),
                child: Icon(icon, color: colorFor(tab)),
              );
              break;

            default:
              animatedIcon = Icon(icon, color: colorFor(tab));
          }

          return InkWell(
            onTap: () => onTabChange(tab),
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  animatedIcon,
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: colorFor(tab),
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          color: Colors.white,
          elevation: 8,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                // Left group (Home + Dhikr)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildItem(
                        icon: Icons.home_outlined,
                        label: languageService.t('Home'),
                        tab: 'home',
                      ),
                      buildItem(
                        icon: Icons.menu_book_sharp,
                        label: languageService.t('Dhikr'),
                        tab: 'dhikr',
                      ),
                    ],
                  ),
                ),
                // FAB gap
                Tooltip(
                  message: languageService.t('Prayer Times'),
                  child: Text(
                    languageService.t('Prayer Times'),
                    style: TextStyle(
                      color:
                          activeTab == 'prayer-times'
                              ? Colors.blue
                              : Colors.grey,
                      fontSize: 12,
                      height: 7.1,
                      fontWeight:
                          activeTab == 'prayer-times'
                              ? FontWeight.w600
                              : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),

                // Right group (Favorites + Settings)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildItem(
                        icon: Icons.favorite_border,
                        label: languageService.t('Favorites'),
                        tab: 'favorites',
                      ),
                      buildItem(
                        icon: Icons.settings_outlined,
                        label: languageService.t('Settings'),
                        tab: 'settings',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
