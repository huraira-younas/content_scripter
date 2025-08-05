import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:content_scripter/models/prompt_model.dart';
import 'package:content_scripter/services/exports.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async' show StreamSubscription;
import 'dart:developer' show log;

class ChatCubit extends Cubit<ChatState> {
  late final GenerativeModel _model;
  PromptModel? _promptModel;

  final Map<String, List<MessageModel>> _messages = {};
  final Map<String, ChatSession> _chats = {};
  Map<String, dynamic>? _userPref;
  String _activeSession = "";
  List<String> _keywords = [];
  List<String> _prompts = [];
  StreamSubscription? _sub;
  SharedPreferences? _sp;
  ImageFile? _file;

  ChatCubit() : super(const ChatState()) {
    setupModel();
  }

  Future<void> startChat({
    required String sid,
    bool isHistory = false,
  }) async {
    _activeSession = sid;

    await getAllMessages(sid: sid, isHistory: isHistory);
    if (_chats.containsKey(sid)) {
      return;
    }

    log("Creating a new chat");
    final history = <Content>[];

    if (_messages[_activeSession]?.isNotEmpty ?? false) {
      history.addAll(_messages[_activeSession]!.map(
        (e) => Content(e.role, [TextPart(e.message)]),
      ));
    }

    final chat = _model.startChat(
      history: history,
      generationConfig: GenerationConfig(
        maxOutputTokens: 10000,
      ),
    );
    _chats.putIfAbsent(sid, () => chat);
    _emit();
  }

  void handleImageInput(ImageFile? imageFile) async {
    if (imageFile != null) {
      log("Path: ${imageFile.image.path}");
      log("Url: ${imageFile.url}");
    }
    _file = imageFile;
  }

  Future<void> sendMessage({
    required String membershipId,
    required String message,
    required String userId,
    bool isCustom = true,
  }) async {
    _sub?.cancel();
    _messages.putIfAbsent(_activeSession, () => []);
    final chat = _chats[_activeSession]!;
    String userMsg = message;
    Content content = Content.text(message);

    if (_file != null) {
      final image = _file!.image;
      final bytes = await image.readAsBytes();
      final imageData = (image.mimeType ?? "image/png", bytes);

      content = Content.multi([
        TextPart(message),
        DataPart(imageData.$1, imageData.$2),
      ]);
    }

    if (!isCustom) {
      userMsg = message.split("\n").last;
    }

    final userMessage = MessageModel(
      imageUrl: _file?.url,
      time: DateTime.now(),
      userId: userId,
      message: userMsg,
      role: "user",
    );

    _messages[_activeSession]?.insert(0, userMessage);
    _saveMessage(userMessage, membershipId, true);
    _file = null;

    String msg = "";
    bool isPlaced = false;
    _sub = chat.sendMessageStream(content).listen(
      (event) {
        msg += event.text ?? "";
        if (!isPlaced) {
          _messages[_activeSession]?.insert(
            0,
            MessageModel(
              time: DateTime.now(),
              userId: userId,
              role: "model",
              message: msg,
            ),
          );
          isPlaced = true;
        } else {
          _messages[_activeSession]?[0] =
              _messages[_activeSession]!.first.copyWith(message: msg);
        }
        _emit(typing: true);
      },
    );
    _sub?.onDone(() {
      _sub?.cancel();
      var msg = _messages[_activeSession]!.first;
      if (msg.message.split("#").join().trim().isEmpty) {
        msg = msg.copyWith(message: AppConstants.unknownError);
        _messages[_activeSession]![0] = msg;
      }
      if (msg.message.isEmpty) {
        return _emit();
      }
      _saveMessage(msg, membershipId, false);
    });

    _sub?.onError((e) {
      _sub?.cancel();

      final error = MessageModel(
        message: AppConstants.internalError,
        time: DateTime.now(),
        userId: userId,
        role: "model",
      );
      _messages[_activeSession]?.insert(0, error);

      log("Error Generating Response: $e");
      _saveMessage(error, membershipId, false);
    });
  }

  void cancelGeneration() {
    _sub?.cancel();
    _emit();
  }

  Future<void> getAllMessages({
    bool isRefresh = false,
    bool isHistory = true,
    required String sid,
  }) async {
    try {
      if (!isRefresh && (_messages[sid]?.isNotEmpty ?? false)) {
        return _emit();
      }
      if (!isHistory) return;

      _emit(loading: !isRefresh);
      final response = await ApiService.sendGetRequest(
        "${ApiRoutes.getAllMessage}/$sid",
      );

      final body = jsonDecode(response['body']);
      if (response['status'] != 200) throw body['error'];
      final list = body as List<dynamic>;

      _messages[sid] = list.map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      log(e.toString());
    }
    _emit();
  }

  Future<void> _saveMessage(
      MessageModel message, String membershipId, bool typing) async {
    try {
      _emit(typing: typing);
      if (message.message.isEmpty) return;

      final response = await ApiService.sendRequest(ApiRoutes.addMessage, {
        "membershipId": membershipId,
        "sessionId": _activeSession,
        ...message.toJson(),
      });

      log(response.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  void _emit({
    bool loadingKeywords = false,
    bool loadingPrompts = false,
    bool loading = false,
    bool typing = false,
    bool error = false,
  }) {
    emit(ChatState(
      messages: _messages[_activeSession] ?? [],
      loadingKeywords: loadingKeywords,
      loadingPrompts: loadingPrompts,
      keywords: _keywords,
      prompts: _prompts,
      loading: loading,
      typing: typing,
      error: error,
    ));
  }

  void deleteChatIfEmpty({required String sid}) {
    _file = null;
    final messages = _messages[sid] ?? [];
    if (messages.isEmpty) {
      log("Deleting Chat Because it is empty");
      _messages.remove(sid);
      _activeSession = "";
      _chats.remove(sid);
    }
  }

  Future<void> generateKeywords(String keyword) async {
    try {
      _emit(loadingKeywords: true);
      final prompt =
          "Generate 15-20 keywords related to $keyword, your response must be in a json list of String";
      final result = await _model.generateContent([Content.text(prompt)]);
      _keywords = _extractJsonList(result.text.toString());
      log(_keywords.toString());
      _emit();
    } catch (e) {
      log("Error generating keywords: $e");
      _emit();
    }
  }

  void setupModel() async {
    if (_promptModel != null) return;

    try {
      await _getPromptModel();

      _model = GenerativeModel(
        apiKey: _promptModel!.modelApiKey,
        model: _promptModel!.model,
        safetySettings: <SafetySetting>[
          SafetySetting(
            HarmCategory.dangerousContent,
            HarmBlockThreshold.low,
          ),
          SafetySetting(
            HarmCategory.harassment,
            HarmBlockThreshold.low,
          ),
          SafetySetting(
            HarmCategory.sexuallyExplicit,
            HarmBlockThreshold.low,
          ),
          SafetySetting(
            HarmCategory.hateSpeech,
            HarmBlockThreshold.low,
          ),
        ],
        generationConfig: GenerationConfig(
          responseMimeType: "text/plain",
          maxOutputTokens: 500,
          temperature: 1.0,
          topP: 0.95,
          topK: 64,
        ),
        systemInstruction: Content.system(
          _promptModel!.defaultPrompt,
        ),
      );

      _emit(loadingPrompts: true);

      _sp ??= await SharedPreferences.getInstance();
      final data = _sp!.getString(AppConstants.userPrefKey);
      final prompts = _sp!.getString(AppConstants.userPromptsKey);
      if (data != null) {
        _userPref = jsonDecode(data);
      }
      if (prompts != null) {
        final decodedPrompts = List<String>.from(jsonDecode(prompts));
        _prompts = decodedPrompts;
      }
      log("User Pref: $_userPref");

      String prompt = AppConstants.promptsGenerator;
      if (_userPref != null) {
        prompt = "${AppConstants.userPrefPrompt}$_userPref $prompt";
        log(prompt);
      }

      final res = await _model.generateContent([
        Content.text(prompt),
      ]);
      log(res.text!.trim().toString());

      _prompts = _extractJsonList(res.text!);
      log("Prompts: $_prompts");

      await _sp!.setString(
        AppConstants.userPromptsKey,
        jsonEncode(_prompts),
      );
      _emit();
    } catch (e) {
      _emit(error: true);
      log(e.toString());
    }
  }

  Future<void> _getPromptModel() async {
    try {
      _emit(loading: true);
      final res = await ApiService.sendGetRequest(
        ApiRoutes.getPrompts,
      );

      final body = jsonDecode(res['body']);
      if (res['status'] != 200) throw body['error'];
      log(body.toString());

      _promptModel = PromptModel.fromJson(body);
      _emit(loading: false);
    } catch (e) {
      rethrow;
    }
  }

  void setPreference(String category) async {
    final cat = category.split(" ").join().toLowerCase();
    if (_userPref == null) {
      _userPref = {cat: 1};
    } else {
      _userPref![cat] = (_userPref![cat] ?? 0) + 1;
    }

    _sp ??= await SharedPreferences.getInstance();
    _sp!.setString(
      AppConstants.userPrefKey,
      jsonEncode(_userPref),
    );
  }

  List<String> _extractJsonList(String rawString) {
    final jsonArrayRegex = RegExp(r'\[.*?\]', dotAll: true);
    final match = jsonArrayRegex.firstMatch(rawString.trim());

    if (match != null) {
      String jsonString = match.group(0)!;
      return List<String>.from(jsonDecode(jsonString));
    } else {
      return [];
    }
  }

  void reset() {
    _messages.clear();
    _chats.clear();
    _sub?.cancel();
  }

  @override
  Future<void> close() {
    reset();
    return super.close();
  }
}

@immutable
final class ChatState {
  final List<MessageModel> messages;
  final List<String> keywords;
  final List<String> prompts;
  final bool loadingKeywords;
  final bool loadingPrompts;
  final bool loading;
  final bool typing;
  final bool error;

  const ChatState({
    this.loadingKeywords = false,
    this.loadingPrompts = false,
    this.keywords = const [],
    this.messages = const [],
    this.prompts = const [],
    this.loading = false,
    this.typing = false,
    this.error = false,
  });
}

@immutable
class ImageFile {
  final XFile image;
  final String url;

  const ImageFile({
    required this.image,
    required this.url,
  });

  ImageFile copyWith({
    XFile? image,
    String? url,
  }) =>
      ImageFile(
        image: image ?? this.image,
        url: url ?? this.url,
      );
}
