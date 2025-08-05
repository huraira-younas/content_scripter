import 'package:content_scripter/common_widget/cache_image.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileAvt extends StatelessWidget {
  final double size;
  final String url;
  final double iconSize;
  const ProfileAvt({
    super.key,
    required this.size,
    required this.iconSize,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.secondaryColor,
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.1)),
      ),
      child: CacheImage(
        url: url,
        errorWidget: Center(
          child: Icon(
            color: AppColors.primaryColor,
            Icons.person,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
