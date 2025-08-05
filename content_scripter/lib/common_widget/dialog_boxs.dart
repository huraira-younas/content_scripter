import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

Future<void> errorDialogue({
  required BuildContext context,
  required String title,
  required String message,
  Map<String, String> action = const {"ok": "OK"},
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        surfaceTintColor: AppColors.cardColor,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 16,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            MyText(
              text: title,
              family: AppFonts.bold,
              size: AppConstants.title,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: AppColors.cardColor,
        content: MyText(
          text: message,
          size: AppConstants.subtitle,
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: action['ok']!,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<bool> confirmDialogue({
  required BuildContext context,
  required String title,
  required String message,
  Color confirmColor = AppColors.primaryColor,
  Map<String, String> actions = const {
    "cancel": "Cancel",
    "confirm": "Confirm",
  },
}) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: AppColors.cardColor,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 16,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              MyText(
                text: title,
                family: AppFonts.bold,
                size: AppConstants.title,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: AppColors.cardColor,
          content: MyText(
            text: message,
            size: AppConstants.subtitle,
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomButton(
                    bgColor: Colors.transparent,
                    borderColor: AppColors.primaryColor,
                    textColor: AppColors.primaryColor,
                    text: actions['cancel']!,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    bgColor: confirmColor,
                    onPressed: () => Navigator.of(context).pop(true),
                    text: actions['confirm']!,
                  ),
                ),
              ],
            ),
          ],
        );
      }).then(
    (value) => value ?? false,
  );
}
