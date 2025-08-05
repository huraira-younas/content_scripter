import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  final String title;
  final String text;
  const ReviewTile({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        MyText(
          text: title,
          size: AppConstants.subtitle,
          color: AppColors.greyColor,
          family: AppFonts.medium,
        ),
        MyText(
          text: text,
          color: AppColors.whiteColor,
          size: AppConstants.subtitle,
          family: AppFonts.medium,
        ),
      ],
    );
  }
}
