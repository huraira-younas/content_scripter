import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

void showErrorSnack({
  required BuildContext context,
  required String message,
  Function()? onRetry,
}) {
  final retry = onRetry != null;
  final scfx = ScaffoldMessenger.of(context);
  scfx.hideCurrentSnackBar();
  scfx.showSnackBar(
    SnackBar(
      backgroundColor: AppColors.cardColor,
      duration: Duration(seconds: retry ? 5 * 60 : 3),
      content: MyText(
        text: message,
        overflow: TextOverflow.ellipsis,
        size: AppConstants.subtitle,
        family: AppFonts.medium,
        maxLines: 2,
      ),
      action: SnackBarAction(
        textColor: AppColors.whiteColor,
        onPressed: () => onRetry?.call(),
        label: !retry ? "OK" : "Retry",
      ),
    ),
  );
}
