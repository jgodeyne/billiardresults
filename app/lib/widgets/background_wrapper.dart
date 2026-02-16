import 'package:flutter/material.dart';

/// A widget that wraps content with the app's background image
class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final double opacity;

  const BackgroundWrapper({
    super.key,
    required this.child,
    this.opacity = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Opacity(
            opacity: opacity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/CaromStatsBackground.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        // Content on top
        child,
      ],
    );
  }
}
