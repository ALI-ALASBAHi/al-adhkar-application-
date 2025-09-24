import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../services/language_service.dart';

class AppHeader extends StatefulWidget {
  final String? title;
  final String subtitle;
  final VoidCallback? onMenuClick;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AppHeader({
    super.key,
    this.title,
    this.subtitle = 'أذكار',
    this.onMenuClick,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Container(
          color: const Color.fromRGBO(33, 150, 243, 1),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              if (widget.showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: widget.onBack,
                )
              else
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: widget.onMenuClick,
                ),
              const SizedBox(width: 4),
              // App logo next to menu
              const _AppLogo(),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment:
                    languageService.isRTL
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title ?? languageService.t('app_title'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    languageService.t('app_subtitle'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              // Language toggle button
              _buildLanguageToggle(languageService),
            ],
          ),
        );
      },
    );
  }

  /// Language toggle button
  Widget _buildLanguageToggle(LanguageService languageService) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (!languageService.isArabic) return; // already EN
              languageService.setLanguage(false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    languageService.isArabic
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'EN',
                style: TextStyle(
                  color:
                      languageService.isArabic
                          ? Colors.white
                          : const Color(0xFF3B82F6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (languageService.isArabic) return; // already AR
              languageService.setLanguage(true);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    languageService.isArabic
                        ? Colors.white.withOpacity(0.9)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'عربي',
                style: TextStyle(
                  color:
                      languageService.isArabic
                          ? const Color(0xFF3B82F6)
                          : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    // Try to load the asset; if it doesn't exist, gracefully fall back without throwing logs
    return FutureBuilder(
      future: rootBundle.load('assets/logo.png'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return SizedBox(
            width: 28,
            height: 28,
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
          );
        }
        return const CircleAvatar(
          radius: 14,
          backgroundColor: Color(0xFF3B82F6),
          child: Icon(Icons.auto_awesome, color: Colors.white, size: 16),
        );
      },
    );
  }
}
