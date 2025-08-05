import 'package:content_scripter/screens/account_screen/widgets/user_tile.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/menu_dialog.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/models/history_model.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  final Function(String email) onAdd;
  final Function(String name) onTap;
  final HistoryModel? history;
  final String uid;
  const UserDrawer({
    required this.onTap,
    required this.onAdd,
    required this.uid,
    this.history,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.8,
      color: AppColors.secondaryColor,
      height: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.07),
          BuildTop(len: history?.shared.length ?? 0),
          const SizedBox(height: 10),
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: history?.shared.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (_, idx) {
              final user = history!.shared[idx];
              final isOwner = history?.userId == user.uid;
              final you = history?.userId == uid;

              return UserTile(
                onTap: !you || isOwner ? null : () => onTap(user.name),
                color: Colors.transparent,
                showTrailing: false,
                isOwner: isOwner,
                imageSize: 45,
                user: user,
              );
            },
          ),
          const SizedBox(height: 30),
          if (uid == history?.userId)
            CustomButton(
              text: "Add User",
              onPressed: () async {
                final data = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const MenuDialog(
                      description: AppConstants.sharedHistoryText,
                      title: "Share History With Others",
                      isEmail: true,
                    );
                  },
                );
                if (data == null) return;
                onAdd(data);
              },
            ),
        ],
      ),
    );
  }
}

class BuildTop extends StatelessWidget {
  const BuildTop({super.key, required this.len});
  final int len;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.padding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const MyText(
            text: "History Shared With",
            size: AppConstants.title,
            family: AppFonts.bold,
          ),
          Divider(
            color: AppColors.borderColor.withValues(alpha: 0.1),
            height: 50,
          ),
          Row(
            children: <Widget>[
              Icon(len > 1 ? Icons.group : Icons.person, size: 20),
              const SizedBox(width: 5),
              MyText(
                text: "User${len > 1 ? "s" : ""}  $len",
                size: AppConstants.subtitle,
                family: AppFonts.medium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
