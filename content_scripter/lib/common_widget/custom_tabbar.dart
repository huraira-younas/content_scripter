import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final Function(int)? onChange;
  final List<String> tabs;
  const CustomTabBar({
    required this.controller,
    required this.tabs,
    this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      onTap: onChange,
      dividerColor: AppColors.borderColor,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.primaryColor,
          width: 5,
        ),
        insets: EdgeInsets.symmetric(horizontal: 16),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      indicatorColor: AppColors.primaryColor,
      labelStyle: myStyle(
        size: AppConstants.subtitle,
        family: AppFonts.semibold,
      ),
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: AppColors.greyColor,
      labelPadding: const EdgeInsets.symmetric(vertical: 10),
      unselectedLabelStyle: myStyle(size: AppConstants.subtitle),
      tabs: List.generate(tabs.length, (idx) => Text(tabs[idx])),
    );
  }
}
