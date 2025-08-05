import 'package:content_scripter/common_widget/profile_avt.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/models/user_model.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final Function()? onTap;
  final bool showTrailing;
  final double imageSize;
  final UserModel user;
  final bool isOwner;
  final Color color;
  const UserTile({
    this.color = AppColors.cardColor,
    this.showTrailing = true,
    this.isOwner = false,
    this.imageSize = 60,
    required this.user,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: color,
      leading: Hero(
        tag: user.uid,
        child: ProfileAvt(
          url: user.profileUrl,
          size: imageSize,
          iconSize: 35,
        ),
      ),
      title: Row(
        children: <Widget>[
          Flexible(
            child: MyText(
              text: user.name,
              size: AppConstants.subtitle,
              family: AppFonts.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 3),
          if (isOwner)
            const Icon(
              Icons.workspace_premium,
              color: Colors.amber,
              size: 18,
            ),
        ],
      ),
      subtitle: MyText(
        text: user.email,
        color: AppColors.greyColor,
      ),
      trailing: showTrailing
          ? const Icon(
              Icons.chevron_right,
              color: AppColors.greyColor,
            )
          : null,
    );
  }
}
