import 'package:content_scripter/common_widget/custom_checkbox.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class CheckboxTile extends StatelessWidget {
  final bool value;
  final String title;
  final Function(bool? value) onTap;
  const CheckboxTile({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.cardColor,
      onTap: () => onTap(!value),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.only(
        right: 20,
        left: 20,
      ),
      title: MyText(
        size: AppConstants.subtitle,
        family: AppFonts.medium,
        text: title,
      ),
      trailing: CustomCheckBox(isChecked: value),
    );
  }
}
