import 'package:content_scripter/cubits/membership_cubit.dart';
import 'package:content_scripter/screens/chat_screen/widgets/chat_body.dart';
import 'package:content_scripter/screens/chat_screen/widgets/user_drawer.dart';
import 'package:content_scripter/screens/chat_screen/widgets/chat_bottom.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/dialog_boxs.dart'
    show confirmDialogue;
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/models/assistant_model.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_assets.dart';
import 'package:content_scripter/cubits/history_cubit.dart';
import 'package:content_scripter/services/api_service.dart';
import 'package:content_scripter/models/history_model.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:content_scripter/cubits/tts_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

class StartChatScreen extends StatefulWidget {
  final String sid;
  final String? prompt;
  final String? title;
  final AssistantModel? assistant;
  const StartChatScreen({
    required this.sid,
    this.assistant,
    this.prompt,
    this.title,
    super.key,
  });

  @override
  State<StartChatScreen> createState() => _StartChatScreenState();
}

class _StartChatScreenState extends State<StartChatScreen> {
  late final _historyCubit = context.read<HistoryCubit>();
  late final _memBloc = context.read<MembershipCubit>();
  late final _userBloc = context.read<UserBloc>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final _assistant = widget.assistant;
  final _controller = ScrollController();

  Future<void> onRefresh(bool isHistory) async {
    context.read<ChatCubit>().getAllMessages(
          isHistory: isHistory,
          sid: widget.sid,
          isRefresh: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final history = _historyCubit.getHistory(widget.sid);
        final showAction = history != null && history.shared.isNotEmpty;
        final user = _userBloc.user!;
        return Scaffold(
          key: _scaffoldKey,
          drawer: UserDrawer(
            history: history,
            uid: user.uid,
            onTap: (name) => _handleOnTap(name, history!),
            onAdd: (email) => _historyCubit.handleMenu(
              option: HistoryMenu.share,
              history: history!,
              email: email,
            ),
          ),
          appBar: customAppBar(
            title: widget.title ?? "Custom Chat",
            context: context,
            actions: [
              if (showAction)
                IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(Icons.group),
                ),
              SizedBox(width: showAction ? 4 : 20),
            ],
          ),
          body: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              scrollToBottom();
              return PopScope(
                canPop: !state.typing,
                child: Column(
                  children: <Widget>[
                    if (!state.loading && state.messages.isEmpty)
                      const BuildEmpty()
                    else
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => onRefresh(history != null),
                          backgroundColor: AppColors.secondaryColor,
                          color: AppColors.primaryColor,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _controller,
                            child: ChatBody(
                              users: history?.shared ?? [],
                              userProfile: user.profileUrl,
                              messages: state.messages,
                              loading: state.loading,
                              uid: user.uid,
                            ),
                          ),
                        ),
                      ),
                    ChatBottom(
                      enabled: widget.title == null ||
                          history?.category == "Custom Chat",
                      onSend: (m, f) => sendMessage(m, isFile: f),
                      loading: state.loading,
                      typing: state.typing,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void scrollToBottom({bool jump = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        final maxScroll = _controller.position.maxScrollExtent;

        if (jump) {
          _controller.jumpTo(maxScroll);
        } else {
          _controller.animateTo(
            maxScroll,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    scrollToBottom(jump: true);
    if (widget.prompt != null) {
      sendMessage(widget.prompt!, isCustom: false);
    }
    _fetchTags();
  }

  void _fetchTags() async {
    if (widget.assistant != null) {
      final topic = widget.assistant!.topic;
      try {
        context.read<ChatCubit>().setPreference(topic);
        final tags = await ApiService.fetchTrendingHashtags(query: topic);
        log(tags.toString());
      } catch (e) {
        log(e.toString());
      }
    }
  }

  void _handleOnTap(String name, HistoryModel history) {
    confirmDialogue(
      context: context,
      title: "Remove $name",
      message: "Do you want to remove $name's access to history?",
    ).then((c) {
      if (!c) return;
      final shared = [...history.shared];
      shared.removeWhere((e) => e.name == name);
      _historyCubit.handleMenu(
        option: HistoryMenu.update,
        history: history.copyWith(shared: shared),
      );
    });
  }

  void sendMessage(
    String message, {
    bool isCustom = true,
    bool isFile = false,
  }) {
    if (message.trim().isEmpty) return;
    if (!incrementPrompt(isFile: isFile)) return;

    final msg = getMessage(message, isCustom);
    final user = _userBloc.user!;

    context
        .read<ChatCubit>()
        .sendMessage(
          membershipId: user.membershipId,
          isCustom: isCustom,
          message: message,
          userId: user.uid,
        )
        .then((v) {
      _historyCubit.addHistory(HistoryModel(
        iconUrl: _assistant?.iconUrl ?? AppAssets.appLogoPng,
        category: _assistant?.category ?? "Custom Chat",
        created: DateTime.now(),
        sessionId: widget.sid,
        userId: user.uid,
        text: msg,
      ));
    });
  }

  String getMessage(String message, bool isCustom) {
    try {
      return isCustom
          ? message
          : "${_assistant?.topic} ${message.split("\n").last.split(",")[1].split(": ").last}";
    } catch (e) {
      log(e.toString());
      return message;
    }
  }

  bool incrementPrompt({bool isFile = false}) {
    final feature = _memBloc.feature!;
    final flag = isFile ? feature.fileInput.image : feature.promptsLimit;
    final msg = isFile ? "file input" : "prompt";
    if (flag.current >= flag.max) {
      Fluttertoast.showToast(msg: "Your $msg limit has reached");
      return false;
    }

    final count = flag.copyWith(current: flag.current + 1);
    _memBloc.updateFeature(feature.copyWith(
      promptsLimit: isFile ? null : count,
      fileInput: feature.fileInput.copyWith(
        image: !isFile ? null : count,
      ),
    ));
    return true;
  }

  @override
  void deactivate() {
    context.read<TtsCubit>().forceStop();
    context.read<ChatCubit>().deleteChatIfEmpty(
          sid: widget.sid,
        );
    super.deactivate();
  }
}
