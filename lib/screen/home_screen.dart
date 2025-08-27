import 'package:flutter/material.dart';
import 'package:pharma_management/core/constant/app_image_path.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Image.asset(
        AppImagePath.imageAppBarBackGround,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
