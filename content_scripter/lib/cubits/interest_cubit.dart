import 'package:content_scripter/models/trending_search_model.dart';
import 'package:content_scripter/services/exports.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert' show jsonDecode;
import 'dart:developer' show log;

class InterestCubit extends Cubit<InterestState> {
  InterestCubit() : super(const InterestState()) {
    fetchTrends("t", "Sci/Tech");
  }

  Future<void> fetchInterest(List<String> queries) async {
    try {
      log("Fetching Interest...");
      _emit(loading: true, trendsLoading: state.trendsLoading);

      final res = await ApiService.sendRequest(ApiRoutes.getInterest, {
        "keywords": queries,
      });

      final body = jsonDecode(res['body']);
      if (res['status'] != 200) throw body['error'];
      if (body is! Map) throw "Keyword trends not found";

      final rawData = (body['default']['timelineData'] as List)
          .map((item) => InterestData.fromJson(item))
          .toList();

      final data = _calculateYearlyAverage(rawData);
      _emit(
        trendsLoading: state.trendsLoading,
        keyword: queries.first,
        data: data,
      );
    } catch (e) {
      log(e.toString());
      _emit(
        trendsLoading: state.trendsLoading,
        error: ErrorState(
          message: e.toString(),
          title: "Error",
        ),
      );
    }
  }

  Future<void> fetchTrends(String category, String value) async {
    try {
      log("Fetching Trending...");
      _emit(
        trendKeyword: value,
        loading: state.loading,
        trendsLoading: true,
      );

      final res = await ApiService.sendRequest(ApiRoutes.getTrends, {
        "category": category,
      });

      final body = jsonDecode(res['body']);
      if (res['status'] != 200) throw body['error'];
      if (body is! List) throw "Realtime Trends not found";

      final rawData =
          body.map((item) => TrendingSearch.fromJson(item)).toList();

      log(rawData.toString());
      _emit(
        loading: state.loading,
        trendKeyword: value,
        trending: rawData,
      );
    } catch (e) {
      log(e.toString());
      _emit(
        loading: state.loading,
        error: ErrorState(
          message: e.toString(),
          title: "Error",
        ),
      );
    }
  }

  void _emit({
    List<TrendingSearch>? trending,
    bool trendsLoading = false,
    List<InterestData>? data,
    bool loading = false,
    String? trendKeyword,
    ErrorState? error,
    String? keyword,
  }) {
    emit(InterestState(
      trendKeyword: trendKeyword ?? state.trendKeyword,
      trending: trending ?? state.trending,
      keyword: keyword ?? state.keyword,
      trendsLoading: trendsLoading,
      data: data ?? state.data,
      loading: loading,
      error: error,
    ));
  }

  List<InterestData> _calculateYearlyAverage(List<InterestData> data) {
    final Map<int, List<int>> yearlyData = {};

    for (final item in data) {
      final year = item.time.year;
      if (!yearlyData.containsKey(year)) {
        yearlyData[year] = [];
      }
      yearlyData[year]!.add(item.value);
    }

    final List<InterestData> averagedData = [];
    yearlyData.forEach((year, values) {
      final averageValue = values.reduce((a, b) => a + b) / values.length;
      averagedData.add(InterestData(
        time: DateTime(year),
        value: averageValue.round(),
      ));
    });

    return averagedData;
  }
}

@immutable
final class InterestState {
  final List<TrendingSearch> trending;
  final List<InterestData> data;
  final String trendKeyword;
  final bool trendsLoading;
  final ErrorState? error;
  final String keyword;
  final bool loading;

  const InterestState({
    this.trendsLoading = false,
    this.trending = const [],
    this.trendKeyword = "",
    this.loading = false,
    this.data = const [],
    this.keyword = "",
    this.error,
  });
}

final class ErrorState {
  final String message;
  final String title;

  ErrorState({
    required this.message,
    required this.title,
  });
}
