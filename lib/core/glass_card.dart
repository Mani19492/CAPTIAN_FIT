import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final String? semanticsLabel;

  const GlassCard({
    super.key,
    required this.child,
    this.radius = 22,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          child: child,
        ),
      ),
    );

    if (semanticsLabel != null) {
      return Semantics(
        label: semanticsLabel,
        child: content,
      );
    }
    return content;
  }
}
