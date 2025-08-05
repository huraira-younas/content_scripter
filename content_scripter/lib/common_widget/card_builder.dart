import 'package:content_scripter/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CardBuilder extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final Widget? child;
  final double radius;
  final BorderRadius? customRadius;
  final double thickness;
  final Color? color;
  final Color? borderColor;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;
  const CardBuilder({
    super.key,
    this.height,
    this.padding,
    this.child,
    this.margin,
    this.width,
    this.color,
    this.constraints,
    this.radius = 12,
    this.customRadius,
    this.thickness = 1,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      clipBehavior: Clip.antiAlias,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? AppColors.cardColor,
        borderRadius: customRadius ?? BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? AppColors.primaryColor.withValues(alpha: 0.1),
          width: thickness,
        ),
      ),
      child: child,
    );
  }
}
