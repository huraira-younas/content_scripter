import 'package:content_scripter/models/history_model.dart';
import 'package:content_scripter/services/api_routes.dart';
import 'package:content_scripter/services/api_service.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert' show jsonDecode;
import "dart:developer" show log;

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(const HistoryState());

  List<HistoryModel> get history => _history;
  final List<HistoryModel> _history = [];
  List<HistoryModel> _filtered = [];
  bool _isCached = false;

  HistoryModel? getHistory(String sid) {
    final idx = _history.indexWhere((e) => e.sessionId == sid);
    if (idx == -1) return null;
    return _history[idx];
  }

  List<HistoryModel> getUserHistory(String userId) {
    return _history.where((e) => e.userId == userId).toList();
  }

  Future<void> cacheHistory({
    required String userId,
    bool refresh = false,
  }) async {
    if (state.isCaching || !refresh && (_history.isNotEmpty && _isCached)) {
      return;
    }

    _emit(isCaching: !refresh);
    log("Caching history");

    try {
      final response = await ApiService.sendGetRequest(
        "${ApiRoutes.getHistory}/$userId",
      );

      final body = jsonDecode(response['body']);
      if (response['status'] != 200) throw body['error'];
      _history.clear();

      final hlist = body['history'] as List<dynamic>;
      final slist = body['shared'] as List<dynamic>;

      _history.addAll(hlist.map((e) => HistoryModel.fromJson(e)));
      _history.addAll(slist.map((e) => HistoryModel.fromJson(e)));
      _filtered = _history;
      _isCached = true;

      _sortHistory(refresh: refresh);
    } catch (e) {
      log(e.toString());
      _emit(
        error: CustomState(
          title: "History Error",
          text: e.toString(),
        ),
      );
    }
  }

  Future<void> addHistory(HistoryModel history, {bool isUpdate = false}) async {
    if (!isUpdate && _history.any((t) => t.sessionId == history.sessionId)) {
      return;
    }

    try {
      final response = await ApiService.sendRequest(
        isUpdate ? ApiRoutes.updateHistory : ApiRoutes.addHistory,
        history.toJson(),
      );

      final body = jsonDecode(response['body']);
      if (response['status'] != 200) throw body['error'];
      final newHistory = HistoryModel.fromJson(body);

      if (isUpdate) {
        final idx = _history.indexWhere((h) => h.id == history.id);
        _history[idx] = newHistory;
      } else {
        _history.insert(0, newHistory);
      }
    } catch (e) {
      if (isUpdate) rethrow;
      log(e.toString());
    }
    _sortHistory();
  }

  Future<void> deleteHistory({required List<String> sids}) async {
    if (_history.isEmpty) return;

    try {
      _emit(
        loading: const CustomState(
          title: "Deleting History",
          text: "Please wait...",
        ),
      );
      final response = await ApiService.sendRequest(
        ApiRoutes.deleteHistory,
        {"sessionIds": sids},
      );

      log(response.toString());
      final body = jsonDecode(response['body']);
      if (response['status'] != 200) throw body['error'];

      for (final sid in sids) {
        _history.removeWhere((e) => e.sessionId == sid);
      }

      _sortHistory();
    } catch (e) {
      log(e.toString());
      _emit(
        error: CustomState(
          title: "History Error",
          text: e.toString(),
        ),
      );
    }
  }

  void handleMenu({
    required HistoryMenu option,
    required HistoryModel history,
    String? email,
  }) {
    log(option.toString());
    switch (option) {
      case HistoryMenu.rename:
        _updateHistory(history, "Renaming History");
        break;
      case HistoryMenu.share:
        if (email == null) return;
        _handleSharedUser(email, history);
        break;
      case HistoryMenu.pin:
        final msg = history.pinned ? "Unpin History" : "Pin History";
        _updateHistory(
          history.copyWith(pinned: !history.pinned),
          msg,
        );
        break;
      case HistoryMenu.delete:
        deleteHistory(sids: [history.sessionId]);
        break;
      case HistoryMenu.update:
        _updateHistory(history, "Removing User");
        break;
    }
  }

  void _updateHistory(HistoryModel history, String title) async {
    try {
      _emit(
        loading: CustomState(
          title: title,
          text: "Please wait...",
        ),
      );
      await addHistory(history, isUpdate: true);
      _sortHistory();
    } catch (e) {
      log(e.toString());
      _emit(
        error: CustomState(
          title: "History Error",
          text: e.toString(),
        ),
      );
    }
  }

  void _handleSharedUser(String email, HistoryModel history) async {
    try {
      _emit(
        loading: const CustomState(
          title: "Adding User",
          text: "Please wait...",
        ),
      );

      final response = await ApiService.sendRequest(ApiRoutes.addSharedUser, {
        "_id": history.id,
        "email": email,
      });

      final body = jsonDecode(response['body']);
      if (response['status'] != 200) throw body['error'];

      final idx = _history.indexWhere((h) => h.id == history.id);
      _history[idx] = HistoryModel.fromJson(body);

      _sortHistory();
    } catch (e) {
      log(e.toString());
      _emit(
        error: CustomState(
          title: "History Error",
          text: e.toString(),
        ),
      );
    }
  }

  void _sortHistory({bool refresh = false}) {
    _history.sort((a, b) {
      int pinnedComparison = (b.pinned ? 1 : 0).compareTo(a.pinned ? 1 : 0);
      if (pinnedComparison != 0) {
        return pinnedComparison;
      }
      return b.created.compareTo(a.created);
    });

    changeTab(state.tab, refresh: refresh, forced: true);
  }

  void changeTab(
    int tab, {
    bool refresh = false,
    bool forced = false,
  }) {
    log("Tab No: $tab, State Tab: ${state.tab}");
    if (state.tab == tab && !forced) return;
    log("Nav To $tab");

    switch (tab) {
      case 0:
        _filtered = _history;
        break;
      case 2:
        _filtered = _history.where((e) => e.shared.length > 1).toList();
        break;
      case 1:
        _filtered = _history.where((e) => e.shared.length == 1).toList();
        break;
    }

    _emit(isRefresh: refresh, tab: tab);
  }

  void reset() {
    _history.clear();
    _emit();
  }

  void _emit({
    bool isRefresh = false,
    bool isCaching = false,
    CustomState? loading,
    CustomState? error,
    int? tab,
  }) {
    emit(HistoryState(
      tab: tab ?? state.tab,
      isRefresh: isRefresh,
      isCaching: isCaching,
      history: _filtered,
      loading: loading,
      error: error,
    ));
  }

  @override
  Future<void> close() {
    reset();
    return super.close();
  }
}

enum HistoryMenu { rename, share, pin, delete, update }

@immutable
final class HistoryState {
  final List<HistoryModel> history;
  final CustomState? loading;
  final CustomState? error;
  final bool isRefresh;
  final bool isCaching;
  final int tab;

  const HistoryState({
    this.history = const [],
    this.isRefresh = false,
    this.isCaching = false,
    this.loading,
    this.tab = 0,
    this.error,
  });
}

@immutable
class CustomState {
  final String title;
  final String text;

  const CustomState({
    required this.title,
    required this.text,
  });
}
