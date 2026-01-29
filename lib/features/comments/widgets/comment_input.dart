import 'package:flutter/material.dart';

import '../../../core/design/zuno_spacing.dart';
import '../../../core/design/zuno_text.dart';

class CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmit;

  const CommentInput({Key? key, required this.controller, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: (text) => onSubmit(text),
      decoration: InputDecoration(
        hintText: 'Add a comment...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
