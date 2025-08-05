import 'package:content_scripter/models/membership_model/exports.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

void showSubscription({
  Function(int subs)? onTap,
  required BuildContext context,
  required MembershipModel membership,
  required List<MembershipTimePeriod> periods,
}) async {
  await showModalBottomSheet(
    backgroundColor: AppColors.cardColor,
    context: context,
    builder: (ctx) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  const MyText(
                    text: "Membership: ",
                    family: AppFonts.semibold,
                    color: AppColors.primaryColor,
                    size: AppConstants.titleLarge,
                  ),
                  MyText(
                    text: membership.title,
                    family: AppFonts.semibold,
                    color: AppColors.primaryColor,
                    size: AppConstants.titleLarge,
                  ),
                ],
              ),
            ),
            Divider(
              height: 20,
              color: AppColors.greyColor.withValues(alpha: 0.1),
            ),
            ...List.generate(periods.length, (index) {
              final period = periods[index];
              final title = AppUtils.formatMembershipTime(period.days);
              final subscription = AppUtils.formatCurrency(
                period.days * membership.price,
                decimal: 2,
              );
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                onTap: () {
                  Navigator.of(context).pop();
                  onTap?.call(period.days);
                },
                leading: const Icon(
                  Icons.card_membership_rounded,
                  color: AppColors.primaryColor,
                ),
                subtitle: MyText(
                  text: title,
                  color: AppColors.greyColor,
                  size: AppConstants.subtitle,
                ),
                title: MyText(
                  size: AppConstants.title,
                  family: AppFonts.semibold,
                  text: subscription,
                ),
              );
            }),
          ],
        ),
      );
    },
  );
}
