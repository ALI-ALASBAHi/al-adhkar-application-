import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

class AppHeader extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack)
              else
                IconButton(icon: const Icon(Icons.menu), onPressed: onMenuClick),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: languageService.isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(title ?? languageService.t('app_title'), style: Theme.of(context).textTheme.titleLarge),
                  Text(languageService.t('app_subtitle'), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}


