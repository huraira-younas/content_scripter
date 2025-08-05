import 'package:content_scripter/models/help_center_model.dart';
import 'package:content_scripter/services/api_service.dart';
import 'package:content_scripter/services/api_routes.dart';
import 'package:flutter/widgets.dart' show PageController;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert' show jsonDecode;
import 'dart:developer' show log;

class HelpCenterCubit extends Cubit<HelpCenterState> {
  HelpCenterModel? _helpCenter;

  int _currentPage = 0;
  final controller = PageController();

  HelpCenterCubit() : super(HelpCenterState());

  Future<void> getData() async {
    try {
      if (state.loading || _helpCenter != null) return;
      _emit(loading: true);

      final response = await ApiService.sendGetRequest(
        ApiRoutes.getHelpCenter,
      );

      if (response['status'] != 200) {
        throw "Please check network connection and try again.";
      }
      final helpCenterData = jsonDecode(response['body']);

      _helpCenter = HelpCenterModel.fromJson(helpCenterData);
      _helpCenter!.faq.insert(
          0,
          FaqModel(
            catName: "All",
            items: _helpCenter!.faq.fold<List<HelperModel>>(
              [],
              (previousValue, element) => previousValue..addAll(element.items),
            ),
          ));

      _emit();
    } catch (e) {
      log(e.toString());
      _emit(
          error: HelpCenterError(
        title: "Error",
        message: e.toString(),
      ));
    }
  }

  void navigateTo(int value, {bool jump = false}) {
    if (_currentPage == value) return;
    log("Current Page: $value");
    _currentPage = value;
    if (jump) {
      controller.jumpToPage(value);
    }
    _emit();
  }

  void _emit({
    HelpCenterError? error,
    bool loading = false,
  }) {
    emit(HelpCenterState(
      currentPage: _currentPage,
      helpCenter: _helpCenter,
      loading: loading,
      error: error,
    ));
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}

final class HelpCenterState {
  final HelpCenterModel? helpCenter;
  final HelpCenterError? error;
  final int currentPage;
  final bool loading;

  HelpCenterState({
    this.currentPage = 1,
    this.loading = false,
    this.helpCenter,
    this.error,
  });
}

final class HelpCenterError {
  final String title;
  final String message;

  HelpCenterError({
    required this.title,
    required this.message,
  });
}
