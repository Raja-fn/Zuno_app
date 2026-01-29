import 'package:flutter/material.dart';
import '../../core/design/zuno_colors.dart';
import '../../core/design/zuno_radius.dart';
import '../../core/design/zuno_spacing.dart';

class ZunoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const ZunoCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: ZunoSpacing.md),
      padding: padding ?? const EdgeInsets.all(ZunoSpacing.md),
      decoration: BoxDecoration(
        color: ZunoColors.card,
        borderRadius: BorderRadius.circular(ZunoRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
