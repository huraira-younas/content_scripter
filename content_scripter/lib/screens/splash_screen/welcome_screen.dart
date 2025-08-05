import 'package:content_scripter/screens/splash_screen/widgets/slide_page.dart';
import 'package:content_scripter/models/on_boarding_model.dart';
import 'package:content_scripter/cubits/on_boarding_cubit.dart';
import 'package:content_scripter/common_widget/ui_loader.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void goToRoute() {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.loginScreen,
        (route) => false,
      );
    }

    return Scaffold(
      body: BlocBuilder<OnBoardingCubit, OnBoardingState>(
        builder: (context, state) {
          final loading = state.loading;

          if (state.error != null) {
            final error = state.error!;
            return UIError(
              message: error.message,
              onRetry: () => context.read<OnBoardingCubit>().getOnBoarding(),
            );
          }

          final pages = state.pages;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: loading
                ? Shimmer.fromColors(
                    highlightColor: AppColors.shimmerHColor,
                    baseColor: AppColors.shimmerBColor,
                    child: SliderBuilder(
                      pages: [OnBoardingModel.dummyData],
                      route: goToRoute,
                    ),
                  )
                : SliderBuilder(route: goToRoute, pages: pages),
          );
        },
      ),
    );
  }
}

class SliderBuilder extends StatelessWidget {
  final List<OnBoardingModel> pages;
  final Function() route;
  const SliderBuilder({
    required this.route,
    required this.pages,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      isShowPrevBtn: true,
      indicatorConfig: const IndicatorConfig(
        colorActiveIndicator: AppColors.primaryColor,
        colorIndicator: AppColors.greyColor,
      ),
      onDonePress: route,
      onSkipPress: route,
      listCustomTabs: List.generate(pages.length, (idx) {
        final page = pages[idx];
        return SlidePage(page: page);
      }),
    );
  }
}
