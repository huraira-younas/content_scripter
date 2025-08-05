import 'package:content_scripter/constants/app_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:developer' show log;

enum TtsEvent { playing, stopped, paused, continued }

class TtsCubit extends Cubit<TtsState> {
  final _flutterTts = FlutterTts();
  String _nowPlaying = "";

  TtsCubit() : super(TtsState()) {
    _setListeners();
  }

  Future playStop(String message, {bool isPlay = true}) async {
    await forceStop();
    if (isPlay) {
      final msg = AppUtils.removeSpecialCharacters(message);
      await _flutterTts.speak(msg);
      log("Started Speaking.. $msg");
      _nowPlaying = message;
    }
  }

  void _setListeners() async {
    _flutterTts
      ..setStartHandler(() => _emit(event: TtsEvent.playing))
      ..setCompletionHandler(() {
        _nowPlaying = "";
        _emit(event: TtsEvent.stopped);
      })
      ..setProgressHandler((
        String text,
        int startOffset,
        int endOffset,
        String word,
      ) {
        log(word);
      })
      ..setErrorHandler((msg) {
        _nowPlaying = "";
        _emit(event: TtsEvent.stopped);
      })
      ..setCancelHandler(() {
        _nowPlaying = "";
        _emit(event: TtsEvent.stopped);
      })
      ..setPauseHandler(() {
        _nowPlaying = "";
        _emit(event: TtsEvent.paused);
      })
      ..setContinueHandler(
        () => _emit(event: TtsEvent.continued),
      );
  }

  void _emit({TtsEvent event = TtsEvent.stopped}) {
    emit(TtsState(
      nowPlaying: _nowPlaying,
      event: event,
    ));
  }

  Future<void> forceStop() async {
    if (state.event == TtsEvent.playing) {
      log("Stopping Text to Speech");
      await _flutterTts.stop();
      _nowPlaying = "";
      _emit();
    }
  }

  @override
  Future<void> close() async {
    await forceStop();
    return super.close();
  }
}

class TtsState {
  final TtsEvent event;
  final String nowPlaying;

  TtsState({
    this.event = TtsEvent.stopped,
    this.nowPlaying = "",
  });
}
