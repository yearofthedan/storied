import 'package:flutter/material.dart';
import 'package:storied/common/device/responsiveness.dart';

class ResponsiveFilledButton extends StatelessWidget {
  const ResponsiveFilledButton({
    super.key,
    required this.label,
    required this.onSubmit,
    required this.controller,
  });

  final Function(String p1) onSubmit;
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.responsive(300, sm: 400),
        ),
        child: (FilledButton(
            onPressed: () => onSubmit(controller.text), child: Text(label))));
  }
}
