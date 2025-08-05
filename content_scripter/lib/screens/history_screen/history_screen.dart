import 'package:content_scripter/screens/history_screen/widgets/history_tiles_builder.dart';
import 'package:content_scripter/screens/history_screen/widgets/empty_widget.dart';
import 'package:content_scripter/common_widget/loading/loading_screen.dart';
import 'package:content_scripter/common_widget/custom_tabbar.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/ui_loader.dart';
import 'package:content_scripter/models/history_model.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/cubits/history_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final _historyCubit = context.read<HistoryCubit>();
  late final TabController _controller;
  final _tabs = ["All", "History", "Shared"];
  final _loader = LoadingScreen.instance();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _tabs.length, vsync: this);
    refresh();
  }

  Future<void> refresh({bool refresh = false}) async {
    final user = context.read<UserBloc>().user!;
    await _historyCubit.cacheHistory(
      userId: user.uid,
      refresh: refresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryCubit, HistoryState>(
      listener: (context, state) {
        _loader.hide();
        if (state.loading != null) {
          final loading = state.loading!;
          _loader.show(
            title: loading.title,
            text: loading.text,
            context: context,
          );
        } else if (state.isRefresh) {
          Fluttertoast.showToast(
            backgroundColor: AppColors.secondaryColor,
            msg: "Refreshed",
          );
        }
      },
      builder: (context, state) {
        final list = state.history;
        return Column(
          children: <Widget>[
            CustomTabBar(
              onChange: (tab) => _historyCubit.changeTab(tab),
              controller: _controller,
              tabs: _tabs,
            ),
            Expanded(
              child: state.error != null
                  ? UIError(message: state.error!.text, onRetry: refresh)
                  : RefreshIndicator(
                      backgroundColor: AppColors.secondaryColor,
                      color: AppColors.primaryColor,
                      onRefresh: () => refresh(refresh: true),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: state.isCaching
                            ? Shimmer.fromColors(
                                highlightColor: AppColors.shimmerHColor,
                                baseColor: AppColors.shimmerBColor,
                                child: HistoryTilesBuilder(
                                  history: HistoryModel.dummyHistory,
                                  loading: true,
                                ),
                              )
                            : list.isEmpty
                                ? const EmptyWidget()
                                : HistoryTilesBuilder(history: list),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  void deactivate() {
    _historyCubit.changeTab(0);
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
