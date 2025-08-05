import 'package:content_scripter/screens/account_screen/widgets/section_tile.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/models/tile_item_model.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/models/user_model.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';

class SectionsBuilder extends StatelessWidget {
  final UserModel user;
  final Function() logout;
  const SectionsBuilder({
    required this.logout,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    final actionMap = {
      0: {
        1: () => nav.pushNamed(AppRoutes.passwordManagerScreen),
        0: () => nav.pushNamed(
              AppRoutes.personalInfoScreen,
              arguments: user,
            ),
      },
      1: {
        2: () => nav.pushNamed(AppRoutes.termAndServicesScreen),
        1: () => nav.pushNamed(AppRoutes.privacyPolicyScreen),
        0: () => nav.pushNamed(AppRoutes.helpCenterScreen),
      },
      2: {0: logout},
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(TileItem.tiles.length, (keyIdx) {
        final keys = TileItem.tiles.keys.toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyText(
              text: keys[keyIdx],
              size: AppConstants.title,
              family: AppFonts.semibold,
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.cardColor,
              ),
              child: Column(
                children: List.generate(TileItem.tiles[keys[keyIdx]]!.length,
                    (tileIdx) {
                  final tile = TileItem.tiles[keys[keyIdx]]![tileIdx];
                  return SectionTile(
                    onTap: () => actionMap[keyIdx]?[tileIdx]?.call(),
                    isLast: keyIdx == 2,
                    title: tile.title,
                    icon: tile.icon,
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}
