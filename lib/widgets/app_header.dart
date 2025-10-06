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
          color: const Color.fromARGB(255, 34, 129, 218),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: widget.onBack,
                )
              else
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: widget.onMenuClick,
                ),

              // Logo
              const _AppLogo(),
              const SizedBox(width: 6),

              const Spacer(),

              // Title
              Text(
                widget.title ?? languageService.t('app_title'),
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),

              const Spacer(),

              // Language toggle
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
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _langButton(
            label: 'English',
            active: !languageService.isArabic,
            onTap: () => languageService.setLanguage(false),
          ),
          _langButton(
            label: 'العربية',
            active: languageService.isArabic,
            onTap: () => languageService.setLanguage(true),
          ),
        ],
      ),
    );
  }

  Widget _langButton({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? const Color.fromARGB(255, 76, 180, 228) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? const Color.fromARGB(255, 5, 5, 5) : const Color.fromARGB(255, 0, 0, 0),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: rootBundle.load('assets/no_background_logo.png'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return SizedBox(
            width: 60,
            height: 65,
            child: Image.asset('assets/no_background_logo.png', fit: BoxFit.contain),
          );
        }
        return const CircleAvatar(
          radius: 11,
          backgroundColor: Color(0xFF3B82F6),
          child: Icon(Icons.auto_awesome, color: Colors.white, size: 14),
        );
      },
    );
  }
}
