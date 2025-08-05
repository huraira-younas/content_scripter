import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

AppBar customAppBar({
  required BuildContext context,
  String title = "",
  bool back = true,
  bool centerTitle = true,
  Function()? onBackPress,
  List<Widget> actions = const [],
}) {
  return AppBar(
    centerTitle: centerTitle,
    automaticallyImplyLeading: false,
    leading: back
        ? Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: MaterialButton(
              onPressed: onBackPress ?? () => Navigator.of(context).pop(),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.zero,
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.primaryColor,
              ),
            ),
          )
        : null,
    actions: actions,
    title: MyText(
      text: title,
      family: AppFonts.semibold,
      size: AppConstants.titleLarge,
    ),
  );
}
