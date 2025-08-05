import 'package:content_scripter/screens/history_screen/widgets/history_menu.dart';
import 'package:content_scripter/common_widget/menu_dialog.dart';
import 'package:content_scripter/common_widget/cache_image.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/models/history_model.dart';
import 'package:content_scripter/cubits/history_cubit.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final Function(HistoryModel history)? onTap;
  final HistoryModel tile;
  final bool selected;
  final bool loading;
  const HistoryTile({
    required this.selected,
    required this.loading,
    required this.tile,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void execMenu(history, option, email) =>
        context.read<HistoryCubit>().handleMenu(
              history: history,
              option: option,
              email: email,
            );

    return Card(
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 12, right: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.borderColor),
        ),
        onLongPress: () {
          if (loading) return;

          final uid = context.read<UserBloc>().user!.uid;
          HistoryModel history = tile;
          if (uid != tile.userId) return;

          final buttons = [...HistoryMenuItem.items];
          if (tile.pinned) {
            buttons[2] = buttons[2].copyWith(
              icon: Icons.star_outline,
              title: "Unpin",
            );
          }
          getOptionSheet(
            context: context,
            buttons: buttons,
          ).then((idx) async {
            if (idx == -1 || !context.mounted) return;

            final option = HistoryMenu.values[idx];
            String? data;
            if (option == HistoryMenu.rename) {
              data = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MenuDialog(
                    title: "Rename History",
                    value: tile.text,
                  );
                },
              );
              if (data == null) return;
              history = history.copyWith(text: data);
            } else if (option == HistoryMenu.share) {
              data = await showDialog(
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
            }

            execMenu(history, option, data);
          });
        },
        onTap: () {
          onTap?.call(tile);

          if (loading) return;
          context.read<ChatCubit>().startChat(
                sid: tile.sessionId,
                isHistory: true,
              );

          Navigator.of(context).pushNamed(
            AppRoutes.startChattingScreen,
            arguments: {
              'sid': tile.sessionId,
              'title': tile.text,
            },
          );
        },
        tileColor: AppColors.cardColor,
        leading: SizedBox(
          height: 40,
          width: 40,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: selected
                ? const Icon(
                    Icons.check,
                    color: AppColors.primaryColor,
                    size: 30,
                  )
                : CacheImage(url: tile.iconUrl),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: MyText(
                text: tile.text,
                size: AppConstants.subtitle,
                family: AppFonts.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            MyText(
              text: "(${tile.category.toUpperCase()})",
              color: AppColors.greyColor,
            )
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: MyText(
                text: AppUtils.formatTimeAgo(tile.created),
                color: AppColors.greyColor,
              ),
            ),
            if (tile.shared.length > 1) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.share,
                color: AppColors.primaryColor,
                size: 15,
              ),
            ],
            if (tile.pinned) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 18,
              ),
            ],
          ],
        ),
        trailing: loading
            ? null
            : const Icon(
                Icons.chevron_right,
                color: AppColors.greyColor,
              ),
      ),
    );
  }
}
