import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

@immutable
class HistoryMenuItem {
  final String title;
  final IconData icon;
  final Color color;

  const HistoryMenuItem({
    required this.title,
    required this.icon,
    required this.color,
  });

  static const items = [
    HistoryMenuItem(
      icon: Icons.edit_note,
      color: Colors.brown,
      title: "Rename",
    ),
    HistoryMenuItem(
      color: Colors.blue,
      icon: Icons.share,
      title: "Share",
    ),
    HistoryMenuItem(
      color: Colors.amber,
      icon: Icons.star,
      title: "Pin",
    ),
    HistoryMenuItem(
      color: Colors.redAccent,
      icon: Icons.delete,
      title: "Delete",
    ),
  ];

  HistoryMenuItem copyWith({
    IconData? icon,
    String? title,
    Color? color,
  }) {
    return HistoryMenuItem(
      title: title ?? this.title,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}

Future<int> getOptionSheet({
  List<HistoryMenuItem> buttons = HistoryMenuItem.items,
  required BuildContext context,
  String title = "History Menu",
}) async {
  int idx = -1;
  await showModalBottomSheet(
    backgroundColor: AppColors.cardColor,
    context: context,
    builder: (ctx) {
      return Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 16,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: MyText(
                    size: AppConstants.title,
                    family: AppFonts.bold,
                    text: title,
                  ),
                ),
              ],
            ),
            Divider(
              height: 30,
              color: AppColors.greyColor.withValues(alpha: 0.1),
            ),
            Wrap(
              children: List.generate(
                buttons.length,
                (index) => _button(
                  buttons[index],
                  () {
                    idx = index;
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
  return idx;
}

Widget _button(HistoryMenuItem item, VoidCallback onTap) {
  return MaterialButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(vertical: 8),
    onPressed: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.color,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(item.icon, color: AppColors.whiteColor),
        ),
        MyText(
          text: item.title,
          family: AppFonts.semibold,
          color: AppColors.whiteColor,
        ),
      ],
    ),
  );
}
