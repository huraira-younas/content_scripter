import 'package:content_scripter/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isChecked;
  final Color? borderColor;
  const CustomCheckBox({
    super.key,
    required this.isChecked,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: isChecked
              ? AppColors.primaryColor
              : (borderColor ?? AppColors.primaryColor),
          width: 3,
        ),
        color: isChecked ? AppColors.primaryColor : null,
        borderRadius: BorderRadius.circular(5),
      ),
      child: isChecked
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 12,
            )
          : null,
    );
  }
}
