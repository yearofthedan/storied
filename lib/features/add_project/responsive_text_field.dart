import 'package:flutter/material.dart';
import 'package:storied/common/device/responsiveness.dart';

class ResponsiveTextField extends StatelessWidget {
  const ResponsiveTextField({
    super.key,
    required this.label,
    required this.onSubmit,
    required this.onChange,
    required this.controller,
  });

  final Function(String p1) onSubmit;
  final Function(String p1) onChange;
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: context.responsive(300, sm: 400),
      ),
      child: TextField(
        onSubmitted: onSubmit,
        onChanged: onChange,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
