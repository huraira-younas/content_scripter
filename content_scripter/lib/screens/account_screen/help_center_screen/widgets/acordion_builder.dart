import 'package:content_scripter/common_widget/cache_image.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/models/help_center_model.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class AcordionBuilder extends StatelessWidget {
  final FaqModel faq;
  const AcordionBuilder({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.padding,
      ),
      child: Column(
        children: List.generate(
          faq.items.length,
          (index) => AccordionCard(
            isFirst: index == 0,
            item: faq.items[index],
          ),
        ),
      ),
    );
  }
}

class AccordionCard extends StatelessWidget {
  final bool isUnderlined;
  final HelperModel item;
  final String? leading;
  final bool isFirst;
  final Function()? onTap;
  const AccordionCard({
    super.key,
    this.onTap,
    this.leading,
    required this.item,
    required this.isFirst,
    this.isUnderlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: AppColors.greyColor.withValues(alpha: 0.1)),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        collapsedIconColor: AppColors.primaryColor,
        childrenPadding: const EdgeInsets.all(16),
        expandedAlignment: Alignment.centerLeft,
        backgroundColor: AppColors.cardColor,
        iconColor: AppColors.primaryColor,
        initiallyExpanded: isFirst,
        collapsedShape: shape,
        dense: true,
        shape: shape,
        leading: leading != null
            ? SizedBox(
                height: 20,
                width: 20,
                child: CacheImage(
                  url: leading!,
                  errorWidget: const Icon(Icons.wallpaper_outlined),
                  color: AppColors.primaryColor,
                ),
              )
            : null,
        title: MyText(
          size: AppConstants.subtitle,
          text: item.title,
          family: AppFonts.medium,
        ),
        children: [
          GestureDetector(
            onTap: onTap,
            child: MyText(
              text: (isUnderlined ? "• " : "") + item.text,
              underline: isUnderlined,
              size: AppConstants.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}
