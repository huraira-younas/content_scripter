import 'package:content_scripter/common_widget/square_progress_indicator.dart';
import 'package:content_scripter/common_widget/animated_logo.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/models/feature_model.dart';
import 'package:content_scripter/constants/app_assets.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/cubits/timer_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatFeatureBuilder extends StatelessWidget {
  final FeatureModel? feature;
  final bool loading;
  const ChatFeatureBuilder({
    required this.feature,
    required this.loading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: const MyText(
            text: AppConstants.startChatText,
            color: AppColors.greyColor,
            size: AppConstants.subtitle,
            isCenter: true,
          ),
        ),
        const SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FeatureBuilder(
              timerkey: AppConstants.promptTimerKey,
              feature: !loading ? feature : null,
              title: "Prompts",
            ),
            const AnimatedLogo(
              iconUrl: AppAssets.appLogoPng,
              tag: "app_logo",
              size: 80,
            ),
            FeatureBuilder(
              timerkey: AppConstants.fileTimerKey,
              feature: !loading ? feature : null,
              title: "Images",
            ),
          ],
        ),
      ],
    );
  }
}

class FeatureBuilder extends StatelessWidget {
  final FeatureModel? feature;
  final String timerkey;
  final String title;
  const FeatureBuilder({
    required this.timerkey,
    required this.feature,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int maxDur = 1;
    late final Count count;
    if (title == "Prompts") {
      count = feature?.promptsLimit ?? Count();
      maxDur = feature?.resetDuration.prompts ?? 0;
    } else {
      count = feature?.fileInput.image ?? Count();
      maxDur = feature?.resetDuration.fileInput ?? 0;
    }

    const size = 80.0;
    final isLock = count.current >= count.max;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: feature == null
          ? Shimmer.fromColors(
              highlightColor: AppColors.shimmerHColor,
              baseColor: AppColors.shimmerBColor,
              child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.secondaryColor,
                ),
              ),
            )
          : Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  _IndicatorBuilder(
                    timerkey: timerkey,
                    maxDur: maxDur,
                    isLock: isLock,
                    count: count,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MyText(
                        family: AppFonts.semibold,
                        text: "${count.current}/${count.max}",
                      ),
                      const SizedBox(height: 3),
                      MyText(
                        family: AppFonts.semibold,
                        text: title,
                        size: 12,
                      ),
                    ],
                  ),
                  if (isLock)
                    Container(
                      height: size - 10,
                      width: size - 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      child: const Icon(
                        color: AppColors.greyColor,
                        Icons.lock_clock,
                        size: 30,
                      ),
                    ),
                  TimerTextBuilder(timerkey: timerkey),
                ],
              ),
            ),
    );
  }
}

class _IndicatorBuilder extends StatelessWidget {
  final String timerkey;
  final bool isLock;
  final Count count;
  final int maxDur;
  const _IndicatorBuilder({
    required this.timerkey,
    required this.maxDur,
    required this.isLock,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BlocBuilder<TimerCubit, Map<String, TimerState>>(
        buildWhen: (p, c) => (c[timerkey]?.isRunning ?? false) && isLock,
        builder: (context, state) {
          final rem = state[timerkey]?.duration ?? 0;
          final progress = isLock ? (rem / maxDur) * 100 : count.progress;
          return SquareProgressIndicator(progress: progress);
        },
      ),
    );
  }
}

class TimerTextBuilder extends StatelessWidget {
  final String timerkey;
  const TimerTextBuilder({
    required this.timerkey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -20,
      child: BlocBuilder<TimerCubit, Map<String, TimerState>>(
        buildWhen: (p, c) => (c[timerkey]?.isRunning ?? false),
        builder: (context, state) {
          final rem = state[timerkey]?.duration ?? 0;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: rem == 0
                ? Shimmer.fromColors(
                    highlightColor: AppColors.shimmerHColor,
                    baseColor: AppColors.shimmerBColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildText(rem),
                    ),
                  )
                : _buildText(rem),
          );
        },
      ),
    );
  }

  MyText _buildText(int rem) {
    return MyText(
      text: "Reset in ${AppUtils.formatTimeDuration(rem)}",
      backgroundColor: AppColors.secondaryColor,
      color: AppColors.primaryColor,
      family: AppFonts.semibold,
      align: TextAlign.justify,
      size: 10,
    );
  }
}
