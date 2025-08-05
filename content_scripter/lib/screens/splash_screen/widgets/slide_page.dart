import 'package:content_scripter/common_widget/cache_image.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/models/on_boarding_model.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class SlidePage extends StatelessWidget {
  final OnBoardingModel page;
  const SlidePage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final radius = BorderRadius.circular(10);

    return Padding(
      padding: EdgeInsets.all(size.width * 0.13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: size.height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: radius,
            ),
            child: CacheImage(
              height: size.height * 0.3,
              url: page.imageUrl,
            ),
          ),
          SizedBox(height: size.height * 0.08),
          ClipRRect(
            borderRadius: radius,
            child: MyText(
              backgroundColor: AppColors.secondaryColor,
              size: AppConstants.titleLarge,
              family: AppFonts.bold,
              text: page.title,
              isCenter: true,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: radius,
            ),
            child: MyText(
              color: AppColors.greyColor,
              size: AppConstants.subtitle,
              align: TextAlign.justify,
              text: page.description,
            ),
          ),
        ],
      ),
    );
  }
}
