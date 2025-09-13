import 'package:flutter/material.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title ?? 'Adhkar', style: Theme.of(context).textTheme.titleLarge),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}


