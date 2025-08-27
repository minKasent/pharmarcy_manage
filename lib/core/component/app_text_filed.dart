import 'package:flutter/material.dart';
import 'app_text_style.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: AppTextStyle.text12Regular,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: UnderlineInputBorder(),
      ),
    );

  }
}