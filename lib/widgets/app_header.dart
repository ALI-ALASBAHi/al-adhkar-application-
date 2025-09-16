import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;
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
              const SizedBox(width: 4),
              // App logo next to menu
              const _AppLogo(),
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

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    // Try to load the asset; if it doesn't exist, gracefully fall back without throwing logs
    return FutureBuilder(
      future: rootBundle.load('assets/logo.png'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError) {
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


