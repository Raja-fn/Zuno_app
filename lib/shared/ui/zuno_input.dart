import 'package:flutter/material.dart';
import 'package:zuno/core/design/zuno_colors.dart';
import 'package:zuno/core/design/zuno_radius.dart';
import 'package:zuno/core/design/zuno_spacing.dart';

class ZunoInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;

  const ZunoInput({
    super.key,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ZunoSpacing.md),
      padding: EdgeInsets.symmetric(horizontal: ZunoSpacing.md),
      decoration: BoxDecoration(
        color: ZunoColors.surface,
        borderRadius: BorderRadius.circular(ZunoRadius.xl),
        border: Border.all(color: ZunoColors.border),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: TextStyle(
          color: ZunoColors.textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: ZunoColors.textMuted,
          ),
        ),
      ),
    );
  }
}
