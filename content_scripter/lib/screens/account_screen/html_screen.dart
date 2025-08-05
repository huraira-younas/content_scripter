import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/cubits/help_center_cubit.dart';
import 'package:content_scripter/common_widget/ui_loader.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HTMLScreen extends StatelessWidget {
  final int stx;
  const HTMLScreen({
    required this.stx,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context.read<HelpCenterCubit>().getData();
    final title = stx == 1 ? "Privacy Policy" : "Terms And Services";
    return Scaffold(
      appBar: customAppBar(context: context, title: title),
      body: BlocBuilder<HelpCenterCubit, HelpCenterState>(
        builder: (context, state) {
          if (state.error != null) {
            final error = state.error!;
            return UIError(
              message: error.message,
              onRetry: () => context.read<HelpCenterCubit>().getData(),
            );
          }
          if (state.loading || state.helpCenter == null) {
            return const Center(child: UILoader());
          }

          final privacyPolicy = stx == 1
              ? state.helpCenter!.privacyPolicy
              : state.helpCenter!.termAndServices;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: HtmlWidget(
              privacyPolicy,
              textStyle: const TextStyle(
                color: AppColors.whiteColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
