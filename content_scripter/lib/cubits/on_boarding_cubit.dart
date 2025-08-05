import 'package:content_scripter/models/on_boarding_model.dart';
import 'package:content_scripter/services/api_service.dart';
import 'package:content_scripter/services/api_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert' show jsonDecode;

class OnBoardingCubit extends Cubit<OnBoardingState> {
  final List<OnBoardingModel> _pages = [];

  OnBoardingCubit() : super(OnBoardingState()) {
    getOnBoarding();
  }

  void getOnBoarding() async {
    try {
      emit(OnBoardingState(loading: true));

      final response = await ApiService.sendGetRequest(
        ApiRoutes.getAllPages,
      );
      final body = jsonDecode(response['body']);

      if (response['status'] != 200) throw body['error'];
      final data = body as List<dynamic>;

      _pages.addAll(data.map((e) => OnBoardingModel.fromJson(e)));
      _pages.sort((a, b) => a.index.compareTo(b.index));

      emit(OnBoardingState(pages: _pages));
    } catch (e) {
      emit(OnBoardingState(
        error: ErrorState(title: "Error", message: e.toString()),
      ));
    }
  }
}

final class OnBoardingState {
  final List<OnBoardingModel> pages;
  final ErrorState? error;
  final bool loading;

  OnBoardingState({
    this.loading = false,
    this.pages = const [],
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
