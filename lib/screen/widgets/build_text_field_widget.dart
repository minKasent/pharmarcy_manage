import 'package:flutter/material.dart';
import 'package:pharma_management/core/constant/app_color_path.dart';
import 'package:pharma_management/core/constant/app_icon_path.dart';

class BuildTextFieldWidget extends StatelessWidget {
  const BuildTextFieldWidget({super.key});

  @override
  TextField build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for medicine',
        filled: true,
        fillColor: AppColorPath.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Image.asset(AppIconPath.iconSearch),
        contentPadding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 20,
        ),
      ),
    );
  }
}
