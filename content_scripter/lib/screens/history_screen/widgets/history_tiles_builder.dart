import 'package:content_scripter/screens/history_screen/widgets/history_tile.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/models/history_model.dart';
import 'package:flutter/material.dart';

class HistoryTilesBuilder extends StatelessWidget {
  final List<HistoryModel> history;
  final Set<String> selected;
  final Function(HistoryModel history)? onTap;
  final bool loading;
  const HistoryTilesBuilder({
    this.selected = const {},
    required this.history,
    this.loading = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.padding),
        itemCount: history.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final tile = history[index];
          final isSelected = selected.contains(tile.sessionId);
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: FadeInAnimation(
              child: SlideAnimation(
                child: HistoryTile(
                  selected: isSelected,
                  loading: loading,
                  onTap: onTap,
                  tile: tile,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
