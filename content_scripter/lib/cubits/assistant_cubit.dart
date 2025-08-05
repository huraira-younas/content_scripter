import 'package:content_scripter/models/assistant_model.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:content_scripter/services/exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert' show jsonDecode;
import 'dart:developer' show log;

class AssistantCubit extends Cubit<AssistantState> {
  AssistantCubit() : super(const AssistantState()) {
    getData();
  }

  final Map<String, List<AssistantModel>> _assistants = {};
  Map<String, List<AssistantModel>> get assistatns => _assistants;

  void getData() async {
    if (state.loading || _assistants.isNotEmpty) return;

    try {
      _emit(loading: true);
      final response = await ApiService.sendGetRequest(
        ApiRoutes.getAllAssistants,
      );

      final body = jsonDecode(response['body']);
      if (response['status'] != 200) throw body['error'];

      for (var e in (body as List<dynamic>)) {
        final model = AssistantModel.fromJson(e);
        if (_assistants.containsKey(model.category)) {
          _assistants[model.category]!.add(model);
        } else {
          _assistants[model.category] = [model];
        }
      }

      _emit(assistants: _assistants);
    } catch (e) {
      log(e.toString());
      _emit(
        error: AssistantErrorState(
          message: e.toString(),
          title: "Error",
        ),
      );
    }
  }

  void filterAssistants({required String filter}) {
    if (filter == state.filter) return;

    log("Filtering: $filter");
    final isAll = filter == "All";
    final filtered = _assistants[filter] ?? [];
    _emit(
      filter: filter,
      assistants: isAll ? _assistants : {filter: filtered},
    );
  }

  void _emit({
    Map<String, List<AssistantModel>>? assistants,
    AssistantErrorState? error,
    bool loading = false,
    String? filter,
  }) {
    emit(AssistantState(
      assistants: assistants ?? state.assistants,
      tabs: _assistants.keys.toList(),
      filter: filter ?? state.filter,
      loading: loading,
      error: error,
    ));
  }
}

@immutable
final class AssistantState {
  final Map<String, List<AssistantModel>> assistants;
  final AssistantErrorState? error;
  final List<String> tabs;
  final String filter;
  final bool loading;

  const AssistantState({
    this.assistants = const {},
    this.tabs = const [],
    this.loading = false,
    this.filter = "All",
    this.error,
  });
}

@immutable
class AssistantErrorState {
  final String title;
  final String message;

  const AssistantErrorState({
    required this.title,
    required this.message,
  });
}
