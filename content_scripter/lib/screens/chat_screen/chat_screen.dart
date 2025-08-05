import 'package:content_scripter/screens/chat_screen/widgets/chat_feature_builder.dart';
import 'package:content_scripter/screens/chat_screen/widgets/prompts_builder.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/cubits/membership_cubit.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/models/feature_model.dart';
import 'package:content_scripter/cubits/timer_cubit.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;
import 'package:uuid/uuid.dart';
import 'dart:async' show Timer;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final _memBloc = context.read<MembershipCubit>();
  late final _timerCubit = context.read<TimerCubit>();
  late final _userBloc = context.read<UserBloc>();
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.padding),
      child: BlocConsumer<MembershipCubit, MembershipState>(
        listener: (context, state) {
          if (state.error == null && state.feature != null) {
            log("Triggering Timers");
            triggerTimers(state.feature!);
          }
        },
        builder: (context, state) {
          final loading = state.feature == null;
          return Column(
            children: <Widget>[
              ChatFeatureBuilder(
                loading: state.loading,
                feature: state.feature,
              ),
              const SizedBox(height: 50),
              PromptsBuilder(
                onTap: (prompt) => sendMessage(
                  message: prompt,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                isLoading: loading,
                text: "Start Chatting",
                onPressed: sendMessage,
              ),
            ],
          );
        },
      ),
    );
  }

  void sendMessage({String? message}) async {
    final sid = const Uuid().v4();
    context.read<ChatCubit>().startChat(sid: sid);
    Navigator.of(context).pushNamed(
      AppRoutes.startChattingScreen,
      arguments: {'prompt': message, "sid": sid},
    );
  }

  void triggerTimers(FeatureModel feature) {
    log("feature: $feature");
    final currentTime = DateTime.now();
    final endTimeP = currentTime.add(Duration(
      seconds: feature.remPromptTime,
    ));
    _timerCubit.startGenTimer(
      key: AppConstants.promptTimerKey,
      currentTime: currentTime,
      isForceStart: true,
      endTime: endTimeP,
      onEnd: () {
        final oldFeature = _memBloc.feature!;
        final promptsLimit = oldFeature.promptsLimit.copyWith(
          current: 0,
        );
        final updatedFeature = oldFeature.copyWith(
          remPromptTime: oldFeature.resetDuration.prompts,
          promptsLimit: promptsLimit,
        );
        _memBloc.updateFeature(updatedFeature);
        triggerTimers(updatedFeature);
      },
    );

    final endTimeF = currentTime.add(Duration(
      seconds: feature.remFileTime,
    ));

    _timerCubit.startGenTimer(
      key: AppConstants.fileTimerKey,
      currentTime: currentTime,
      isForceStart: true,
      endTime: endTimeF,
      onEnd: () {
        final oldFeature = _memBloc.feature!;
        final imageLimit = oldFeature.fileInput.image.copyWith(
          current: 0,
        );
        final updatedFeature = oldFeature.copyWith(
          remFileTime: oldFeature.resetDuration.fileInput,
          fileInput: oldFeature.fileInput.copyWith(
            image: imageLimit,
          ),
        );
        _memBloc.updateFeature(updatedFeature);
        triggerTimers(updatedFeature);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getFeatures();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void getFeatures() {
    final timer = _timerCubit.getTimer(AppConstants.fileTimerKey);
    if (timer != null) return;
    _memBloc.getFeature(_userBloc.user!.email);
  }
}
