import 'package:flutter/material.dart';
import 'package:pharma_management/core/component/app_text.dart';
import 'package:pharma_management/core/component/app_text_style.dart';
import 'package:pharma_management/core/constant/app_color_path.dart';
import 'package:pharma_management/core/constant/app_icon_path.dart';
import 'package:pharma_management/core/constant/app_image_path.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                AppImagePath.imageAppBarBackGround,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 40,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              AppImagePath.imageLogo,
                              color: AppColorPath.white,
                            ),
                            const Spacer(),
                            Image.asset(AppIconPath.iconUser),
                            const SizedBox(width: 30),
                            Image.asset(AppIconPath.iconNotification),
                            const SizedBox(width: 15),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextField(
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
                        ),
                        const SizedBox(height: 20),
                        Image.asset(AppImagePath.imageDoctorHealth, scale: 0.5),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              Image.asset(AppImagePath.imageEllipse2),
              const SizedBox(width: 10),
              Image.asset(AppImagePath.imageEllipse3, color: AppColorPath.blue),
              const SizedBox(width: 10),
              Image.asset(AppImagePath.imageEllipse3),
            ],
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  content: "Shop By Category",
                  style: AppTextStyle.text10Bold,
                ),
                AppText(
                  content: "See All",
                  style: AppTextStyle.text10Bold.copyWith(
                    color: AppColorPath.blue,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),)
        ],
      ),
    );
  }
}
