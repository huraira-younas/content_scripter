import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:math' show max, min;

class MyText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color color;
  final bool isCenter;
  final double? height;
  final bool underline;
  final TextOverflow? overflow;
  final Color? backgroundColor;
  final TextAlign? align;
  final String family;
  final int? maxLines;
  const MyText({
    super.key,
    required this.text,
    this.isCenter = false,
    this.underline = false,
    this.height,
    this.align,
    this.maxLines,
    this.color = AppColors.whiteColor,
    this.size = AppConstants.text,
    this.overflow,
    this.weight = FontWeight.normal,
    this.family = AppFonts.regular,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: myStyle(
        color: color,
        size: size,
        weight: weight,
        family: family,
        height: height,
        underline: underline,
        backgroundColor: backgroundColor,
      ),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: isCenter ? TextAlign.center : align,
      textScaler: TextScaler.linear(
        textScaleFactor(context),
      ),
    );
  }
}

TextStyle myStyle({
  Color color = AppColors.whiteColor,
  double size = AppConstants.text,
  FontWeight weight = FontWeight.normal,
  String family = AppFonts.regular,
  Color? backgroundColor,
  bool underline = false,
  double? height,
}) {
  return TextStyle(
    color: color,
    fontFamily: family,
    fontSize: size,
    backgroundColor: backgroundColor,
    decoration: underline ? TextDecoration.underline : null,
    decorationColor: color,
    fontWeight: weight,
    height: height,
  );
}

double textScaleFactor(
  BuildContext context, {
  double maxTextScaleFactor = 2,
}) {
  final width = MediaQuery.of(context).size.width;
  double val = (width / 1400) * maxTextScaleFactor;
  return max(1, min(val, maxTextScaleFactor));
}
