import 'package:content_scripter/screens/interests_screen/widgets/custom_line_chart.dart';
import 'package:content_scripter/screens/interests_screen/widgets/keywords_builder.dart';
import 'package:content_scripter/screens/interests_screen/widgets/stories_trends.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/common_widget/ui_loader.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/cubits/interest_cubit.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  late final _interestCubit = context.read<InterestCubit>();
  final _controller = TextEditingController();

  void _fetchInterest() async {
    FocusScope.of(context).unfocus();
    final q = _controller.text.trim();
    if (q.isEmpty) return;

    await (
      context.read<ChatCubit>().generateKeywords(q),
      _interestCubit.fetchInterest([q])
    ).wait;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: <Widget>[
            CustomTextField(
              prefixIcon: const Icon(Icons.search),
              onChange: (v) => setState(() {}),
              hint: "Enter Keywords...",
              label: "Search Keywords",
              controller: _controller,
              suffixIcon: _controller.text.trim().isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(
                        () => _controller.clear(),
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<InterestCubit, InterestState>(
              builder: (context, state) {
                final valid = _controller.text.trim().isEmpty;
                final data = state.data;
                if (state.error != null) {
                  final error = state.error!;
                  return UIError(
                    message: error.message,
                    onRetry: _fetchInterest,
                    topPad: 0.62,
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CustomButton(
                      onPressed: valid ? null : _fetchInterest,
                      isLoading: state.loading,
                      text: "Search",
                    ),
                    const SizedBox(height: 30),
                    if (data.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomLineChart(
                            keyword: state.keyword,
                            data: data,
                          ),
                          const SizedBox(height: 30),
                          const KeywordsBuilder(),
                        ],
                      ),
                    const SizedBox(height: 30),
                    StoriesTrends(
                      loading: state.trendsLoading,
                      keyword: state.trendKeyword,
                      trending: state.trending,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
