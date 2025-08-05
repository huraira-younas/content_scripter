import 'package:content_scripter/common_widget/animated_logo.dart';
import 'package:content_scripter/screens/assistants_screen/widgets/checkbox_tile.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/models/assistant_model.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';

class PromptScreen extends StatefulWidget {
  final AssistantModel assistant;
  final String sid;
  const PromptScreen({
    required this.assistant,
    required this.sid,
    super.key,
  });

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final _controllers = List.generate(3, (idx) => TextEditingController());
  final _keys = List.generate(2, (idx) => GlobalKey<FormState>());
  late final _assistant = widget.assistant;
  final _maxDesc = 100, _maxTopic = 30;
  late final _sid = widget.sid;
  bool _isUserInfo = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: customAppBar(
          title: _assistant.category,
          context: context,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.padding,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.padding + 10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedLogo(
                        iconUrl: _assistant.iconUrl,
                        size: 100,
                        tag: _assistant.id,
                      ),
                      const SizedBox(height: 20),
                      MyText(
                        text: _assistant.topic,
                        size: AppConstants.title,
                        family: AppFonts.bold,
                      ),
                      MyText(
                        text: _assistant.description,
                        isCenter: true,
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _keys[0],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: CustomTextField(
                          onChange: (p0) => setState(() {}),
                          controller: _controllers[0],
                          hint: "Enter Topic",
                          label: "Topic",
                          validator: (p0) {
                            if (p0 == null || p0.trim().isEmpty) {
                              return "Please enter a topic";
                            }
                            final msg = p0.trim();
                            if (msg.length >= _maxTopic) {
                              return "Topic is too long";
                            }
                            if (msg.length < 5) {
                              return "Topic is too short";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MyText(
                          text:
                              "char: ${_controllers[0].text.length}/$_maxTopic",
                          size: 10,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _keys[1],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: CustomTextField(
                          hint: "Enter Short Description",
                          controller: _controllers[1],
                          onChange: (p0) => setState(() {}),
                          validator: (p0) {
                            if (p0 == null || p0.trim().isEmpty) {
                              return "Please enter a short description";
                            }
                            final msg = p0.trim();
                            if (msg.length >= _maxDesc) {
                              return "Description is too long";
                            }
                            if (msg.length < 10) {
                              return "Description is too short";
                            }
                            return null;
                          },
                          label: "Short Description",
                          minLines: null,
                          maxLines: 5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: MyText(
                          text:
                              "char: ${_controllers[1].text.length}/$_maxDesc",
                          size: 10,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: _controllers[2],
                        label: "Keywords",
                        hint: "You can copy paste keywords from interest",
                        minLines: 5,
                        maxLines: 8,
                      ),
                      const SizedBox(height: 10),
                      CheckboxTile(
                        title: "Personal Info",
                        value: _isUserInfo,
                        onTap: (v) => setState(
                          () => _isUserInfo = v ?? false,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomButton(
                      onPressed: () => Navigator.of(context).pop(),
                      borderColor: AppColors.borderColor,
                      bgColor: Colors.transparent,
                      text: "Cancel",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: "Submit",
                      onPressed: sendPrompt,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void sendPrompt() {
    if (_keys.any((e) => !e.currentState!.validate())) return;

    final user = context.read<UserBloc>().user!;
    final description = _controllers[1].text.trim();
    final hashtags = _controllers[2].text.trim();
    final title = _controllers[0].text.trim();
    final prompt =
        "Consider you are a ${_assistant.category} specialist. ${_assistant.prompt}, ${_isUserInfo ? "use my personal info: ${user.name}, email: ${user.email}, phone: ${user.phone}" : ""} Generate a script related to the above details ${hashtags.isNotEmpty ? "use these hashtags which are trending right now $hashtags" : ""}\nTopic: ${_assistant.topic}, Title: $title, Description: $description.";

    Navigator.of(context).pushReplacementNamed(
      AppRoutes.startChattingScreen,
      arguments: {
        'title': _assistant.topic,
        "assistant": _assistant,
        'prompt': prompt,
        'sid': _sid,
      },
    );
  }

  @override
  void deactivate() {
    context.read<ChatCubit>().deleteChatIfEmpty(
          sid: _sid,
        );
    super.deactivate();
  }

  @override
  void dispose() {
    _controllers.asMap().forEach((idx, v) => v.dispose);
    super.dispose();
  }
}
