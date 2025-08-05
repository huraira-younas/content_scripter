import 'package:content_scripter/common_widget/tab_button.dart';
import 'package:content_scripter/cubits/help_center_cubit.dart';
import 'package:content_scripter/models/help_center_model.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CenterBtnBuilder extends StatelessWidget {
  final List<FaqModel> faqs;
  const CenterBtnBuilder({super.key, required this.faqs});

  @override
  Widget build(BuildContext context) {
    final keys = List.generate(faqs.length, (index) => GlobalKey());
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.padding,
      ),
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: BlocBuilder<HelpCenterCubit, HelpCenterState>(
        builder: (context, state) {
          final currentIndex = state.currentPage;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Scrollable.ensureVisible(
              keys[currentIndex].currentContext!,
              alignment: 0.5,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
          return Row(
            children: List.generate(
              faqs.length,
              (index) => TabButton(
                key: keys[index],
                title: faqs[index].catName,
                isActive: currentIndex == index,
                onPressed: () => context
                    .read<HelpCenterCubit>()
                    .navigateTo(index, jump: true),
              ),
            ),
          );
        },
      ),
    );
  }
}
