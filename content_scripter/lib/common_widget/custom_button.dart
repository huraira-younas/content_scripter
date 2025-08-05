import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;
  final IconData? icon;
  final (double, double) padding;
  final bool isLoading;
  final double? width;
  const CustomButton({
    super.key,
    this.onPressed,
    this.icon,
    this.bgColor,
    this.textColor,
    this.borderColor,
    this.isLoading = false,
    this.padding = (20, 13),
    this.width,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final kWidth = MediaQuery.sizeOf(context).width * 0.6;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: bgColor ?? AppColors.primaryColor,
        minimumSize: Size(width ?? kWidth, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: padding.$1,
          vertical: padding.$2 + (borderColor == null ? -1.5 : 0),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: isLoading
            ? const SizedBox(
                height: 23,
                width: 23,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.whiteColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyText(
                    text: text,
                    color: textColor ?? AppColors.whiteColor,
                    size: AppConstants.subtitle,
                    family: AppFonts.bold,
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 4),
                    Icon(icon!, size: 20, color: AppColors.whiteColor),
                  ]
                ],
              ),
      ),
    );
  }
}
