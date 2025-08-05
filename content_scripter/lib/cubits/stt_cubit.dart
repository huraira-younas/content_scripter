import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "dart:developer" show log;

class SttCubit extends Cubit<SttState> {
  final _speechToText = SpeechToText();
  bool speechEnabled = false;

  SttCubit() : super(SttState()) {
    _initSpeech();
  }

  void startListening() async {
    log("Started Listening...");
    await _speechToText.listen(onResult: _onSpeechResult);
    emit(SttState(
      lastWord: state.lastWord,
      listening: true,
    ));
  }

  void stopListening() async {
    log("Stopped Listening...");
    if (_speechToText.isListening) {
      await _speechToText.stop();
      await _speechToText.cancel();
    }
    emit(SttState(
      listening: false,
      lastWord: "",
    ));
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    emit(SttState(
      lastWord: result.recognizedWords,
      listening: true,
    ));
  }

  void _initSpeech() async {
    speechEnabled = await _speechToText.initialize(
      onError: (errorNotification) {
        log(errorNotification.errorMsg.toString());
        emit(SttState(lastWord: ""));
      },
    );
  }

  @override
  Future<void> close() {
    _speechToText.cancel();
    return super.close();
  }
}

class SttState {
  final String lastWord;
  final bool listening;

  SttState({
    this.listening = false,
    this.lastWord = "",
  });
}
