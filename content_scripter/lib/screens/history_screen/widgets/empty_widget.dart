import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_assets.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            AppAssets.emptyPng,
            height: 100,
          ),
          const SizedBox(height: 10),
          const MyText(
            text: "No History Found",
            family: AppFonts.semibold,
            size: AppConstants.subtitle,
            color: AppColors.greyColor,
          )
        ],
      ),
    );
  }
}
