import 'package:content_scripter/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
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
  final Function()? onTap;
  const CardButton({
    super.key,
    this.height,
    this.padding,
    this.child,
    this.margin,
    this.width,
    this.color,
    this.constraints,
    this.radius = 10,
    this.customRadius,
    this.thickness = 1,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: onTap,
      padding: EdgeInsets.zero,
      color: color ?? AppColors.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: customRadius ?? BorderRadius.circular(radius),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: customRadius ?? BorderRadius.circular(radius),
        ),
        margin: margin,
        padding: padding ?? const EdgeInsets.all(20),
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
