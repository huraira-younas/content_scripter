import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class UILoader extends StatelessWidget {
  final double size;
  final double stroke;
  final Color color;
  const UILoader({
    this.color = AppColors.primaryColor,
    this.stroke = 4,
    this.size = 35,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: stroke,
        color: color,
      ),
    );
  }
}

class UIError extends StatelessWidget {
  final double topPad;
  final String message;
  final VoidCallback onRetry;
  const UIError({
    super.key,
    this.topPad = 0.45,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return CenterWidget(
      topPad: topPad,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.error_rounded,
            color: AppColors.primaryColor,
            size: 40,
          ),
          const SizedBox(height: 20),
          MyText(
            family: AppFonts.medium,
            isCenter: true,
            text: message,
            maxLines: 3,
          ),
          const SizedBox(height: 30),
          CustomButton(
            width: width * 0.3,
            onPressed: onRetry,
            text: "Retry",
          ),
        ],
      ),
    );
  }
}

class CenterWidget extends StatelessWidget {
  final Widget child;
  final double topPad;
  const CenterWidget({
    super.key,
    required this.child,
    this.topPad = 0.45,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox(
        height: size.height * topPad,
        width: size.width * 0.7,
        child: Center(child: child),
      ),
    );
  }
}
