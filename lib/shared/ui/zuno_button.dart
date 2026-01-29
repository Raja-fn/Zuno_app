import 'package:flutter/material.dart';
import '../../core/design/zuno_colors.dart';
import '../../core/design/zuno_radius.dart';
import '../../core/design/zuno_text.dart';

class ZunoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ZunoButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ZunoColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ZunoRadius.xl),
          ),
        ),
        child: Text(text, style: ZunoText.button()),
      ),
    );
  }
}
