import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:content_scripter/models/trending_search_model.dart';
import 'package:content_scripter/common_widget/cache_image.dart';
import 'package:content_scripter/common_widget/card_button.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/cubits/interest_cubit.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';

class StoriesTrends extends StatelessWidget {
  final List<TrendingSearch> trending;
  final String keyword;
  final bool loading;
  const StoriesTrends({
    super.key,
    required this.trending,
    required this.keyword,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat("MMM d, yyyy").format(DateTime.now());

    void handleTrend() {
      showModalBottomSheet(
        backgroundColor: AppColors.cardColor,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                ...List.generate(TrendingSearch.searchEnum.length, (idx) {
                  final search = TrendingSearch.searchEnum[idx];
                  return ListTile(
                      title: Center(
                        child: MyText(
                          family: AppFonts.semibold,
                          text: search.title,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<InterestCubit>().fetchTrends(
                              search.value,
                              search.title,
                            );
                      });
                }),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const MyText(
                    text: "Stories Trending right now",
                    size: AppConstants.subtitle,
                    family: AppFonts.bold,
                  ),
                  MyText(
                    color: AppColors.greyColor,
                    text: "Last Refreshed: $date",
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: handleTrend,
              child: MyText(text: keyword),
            )
          ],
        ),
        const SizedBox(height: 10),
        if (loading)
          const SizedBox(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          )
        else
          AnimationLimiter(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trending.length,
              shrinkWrap: true,
              itemBuilder: (context, idx) {
                final trend = trending[idx];
                return AnimationConfiguration.staggeredList(
                  position: idx,
                  duration: const Duration(milliseconds: 300),
                  child: ScaleAnimation(
                    child: SlideAnimation(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: CardButton(
                          padding: const EdgeInsets.all(0),
                          onTap: () => AppUtils.launchURL(trend.image.newsUrl),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CacheImage(
                                url: trend.image.imgUrl,
                                fit: BoxFit.fill,
                                height: 180,
                              ),
                              if (trend.articles.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: MyText(
                                    text: trend.articles[0].articleTitle,
                                    size: AppConstants.subtitle,
                                  ),
                                ),
                              StoryKeywords(keywords: trend.keywords),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class StoryKeywords extends StatelessWidget {
  final List<String> keywords;
  const StoryKeywords({super.key, required this.keywords});

  @override
  Widget build(BuildContext context) {
    final len = keywords.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 10),
          child: MyText(
            text: "Keywords",
            color: AppColors.greyColor,
          ),
        ),
        Wrap(
          children: List.generate(len, (idx) {
            final text = "${keywords[idx].trim()}${len - 1 != idx ? "," : ""}";
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: MyText(text: text),
            );
          }),
        ),
      ],
    );
  }
}
