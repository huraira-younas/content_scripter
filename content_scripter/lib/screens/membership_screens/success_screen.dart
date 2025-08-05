import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final int days;
  const SuccessScreen({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.padding + 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      color: AppColors.whiteColor,
                      Icons.check,
                      size: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const MyText(
                    text: "Congratulations!",
                    family: AppFonts.semibold,
                    size: AppConstants.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  MyText(
                    text:
                        "You have successfully subscribed ${AppUtils.formatMembershipTime(days)} Plan. You can download your E-Reciept now",
                    size: AppConstants.subtitle,
                    color: AppColors.greyColor,
                    isCenter: true,
                  ),
                ],
              ),
            ),
          ),
          CustomButton(
            width: MediaQuery.sizeOf(context).width * 0.7,
            text: "View E-Reciept",
            onPressed: () => Navigator.of(context).pushNamed(
              AppRoutes.eRecieptScreen,
            ),
          ),
          const SizedBox(height: 8),
          CustomButton(
            width: MediaQuery.sizeOf(context).width * 0.7,
            text: "Go To Home",
            textColor: AppColors.primaryColor,
            bgColor: Colors.transparent,
            onPressed: () => Navigator.of(context).popUntil((route) {
              return route.settings.name == AppRoutes.routesScreen;
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
