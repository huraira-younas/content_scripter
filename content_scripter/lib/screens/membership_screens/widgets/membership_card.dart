import 'package:content_scripter/models/membership_model/exports.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:flutter/material.dart';

class MembershipCard extends StatelessWidget {
  final bool isReview;
  final bool isCurrent;
  final VoidCallback? onSubTap;
  final MembershipPricing price;
  final MembershipModel membership;
  final VoidCallback? onSelectPlan;
  const MembershipCard({
    super.key,
    this.onSubTap,
    this.onSelectPlan,
    required this.price,
    this.isReview = false,
    required this.isCurrent,
    required this.membership,
  });

  @override
  Widget build(BuildContext context) {
    final memPrice = AppUtils.formatCurrency(price.amount, decimal: 2);
    final time = AppUtils.formatMembershipTime(price.days);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(10),
            ),
            border: Border.all(
              color: AppColors.cardColor,
              width: 2,
            ),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                MyText(
                  text: membership.title,
                  family: AppFonts.semibold,
                  color: Colors.white,
                  size: AppConstants.titleLarge,
                ),
                if (isCurrent) ...[
                  const SizedBox(height: 2),
                  const MyText(
                    text: "Your current plan",
                    color: Colors.white,
                    size: AppConstants.subtitle,
                  ),
                ]
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
            border: Border.all(
              color: AppColors.cardColor,
              width: 2,
            ),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ...List.generate(
                  membership.features.length,
                  (index) {
                    return Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.cardColor,
                              width: 1.4,
                            ),
                          ),
                          child: const Icon(
                            size: 12,
                            Icons.check,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MyText(
                            text: membership.features[index],
                            size: AppConstants.subtitle,
                            family: AppFonts.medium,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                if (membership.price > 0 && !isReview) ...[
                  Divider(
                    height: 40,
                    color: AppColors.greyColor.withValues(alpha: 0.1),
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      CustomButton(
                        width: double.infinity,
                        bgColor: AppColors.cardColor,
                        textColor: AppColors.primaryColor,
                        text: "$memPrice $time",
                        onPressed: onSubTap,
                      ),
                      const Positioned(
                        right: 20,
                        child: Icon(
                          size: 30,
                          Icons.keyboard_arrow_down,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: "Select Plan",
                    onPressed: onSelectPlan,
                  ),
                ],
              ]),
        ),
      ],
    );
  }
}
