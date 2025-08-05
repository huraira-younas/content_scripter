import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final bool isActive;
  const TabButton({
    super.key,
    required this.onPressed,
    this.isActive = false,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: isActive ? 33 : 35,
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : AppColors.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? AppColors.primaryColor.withValues(alpha: 0.5)
                : AppColors.primaryColor.withValues(alpha: 0.1),
          ),
        ),
        constraints: const BoxConstraints(minWidth: 80.0),
        child: Center(
          child: MyText(
            text: title,
            color: isActive ? Colors.white : AppColors.greyColor,
            size: AppConstants.subtitle,
            family: isActive ? AppFonts.semibold : AppFonts.regular,
          ),
        ),
      ),
    );
  }
}
