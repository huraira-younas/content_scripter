import 'dart:developer' show log;
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);
  int _currentIdx = 0;

  void navigateTo(int event) {
    if (event == _currentIdx) return;

    log("Navigate to: $event screen");
    _currentIdx = event;
    emit(event);
  }
}
