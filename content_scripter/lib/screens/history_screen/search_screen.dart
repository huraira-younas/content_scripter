import 'package:content_scripter/screens/history_screen/widgets/empty_widget.dart';
import 'package:content_scripter/screens/history_screen/widgets/history_tiles_builder.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/cubits/history_cubit.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/models/history_model.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<HistoryModel> history = [];
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: customAppBar(
          title: "Search History",
          context: context,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.padding,
                vertical: 16,
              ),
              child: CustomTextField(
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.greyColor),
                onChange: (p0) => setState(() {}),
                suffixIcon: _controller.text.trim().isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(
                          () => _controller.clear(),
                        ),
                      ),
                hint: "Search history...",
                controller: _controller,
                label: "Search History",
              ),
            ),
            Divider(
              color: AppColors.greyColor.withValues(alpha: 0.1),
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.padding,
                vertical: 10,
              ),
              child: MyText(
                text: "R E S U L T S",
                size: AppConstants.subtitle,
                family: AppFonts.bold,
              ),
            ),
            BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                final history = searchHistory();

                return Expanded(
                  child: history.isEmpty
                      ? const EmptyWidget()
                      : HistoryTilesBuilder(history: history),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<HistoryModel> searchHistory() {
    if (history.isEmpty) {
      history = context.read<HistoryCubit>().history;
    }

    final query = _controller.text.trim();
    if (query.isEmpty) {
      return history;
    }

    final filtered = history.where((item) {
      final lowerQuery = query.toLowerCase();
      return item.text.toLowerCase().contains(lowerQuery) ||
          item.category.toLowerCase().contains(lowerQuery) ||
          item.created.toString().toLowerCase().contains(lowerQuery);
    }).toList();
    return filtered;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
