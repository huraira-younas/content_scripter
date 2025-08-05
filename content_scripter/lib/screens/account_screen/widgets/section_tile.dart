import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class SectionTile extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final String title;
  final bool isLast;
  const SectionTile({
    required this.title,
    required this.icon,
    this.isLast = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: isLast ? AppColors.primaryColor : AppColors.whiteColor,
          ),
          const SizedBox(width: 10),
          MyText(
            text: title,
            size: AppConstants.subtitle,
            family: AppFonts.semibold,
            color: isLast ? AppColors.primaryColor : AppColors.whiteColor,
          ),
        ],
      ),
    );
  }
}
