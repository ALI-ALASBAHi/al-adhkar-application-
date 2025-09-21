import 'package:flutter/material.dart';

class ScreenLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const ScreenLoader({super.key, required this.isLoading, required this.child, this.message});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              if (message != null) ...[
                const SizedBox(height: 12),
                Text(message!, style: Theme.of(context).textTheme.bodySmall),
              ]
            ],
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: child,
    );
  }
}


