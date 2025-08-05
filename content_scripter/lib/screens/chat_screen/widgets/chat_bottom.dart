import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/screens/chat_screen/widgets/typing_indicator.dart';
import 'package:content_scripter/screens/chat_screen/widgets/image_builder.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/cubits/membership_cubit.dart';
import 'package:content_scripter/services/api_service.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/services/api_routes.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:content_scripter/cubits/stt_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

class ChatBottom extends StatefulWidget {
  final Function(String message, bool isFile) onSend;
  final bool enabled;
  final bool loading;
  final bool typing;
  const ChatBottom({
    super.key,
    required this.enabled,
    required this.loading,
    required this.typing,
    required this.onSend,
  });

  @override
  State<ChatBottom> createState() => _ChatBottomState();
}

class _ChatBottomState extends State<ChatBottom> {
  late final _chatCubit = context.read<ChatCubit>();
  final _controller = TextEditingController();
  bool _isValid = false, _isUploaded = false;
  final _focusNode = FocusNode();
  String? _imagePath, _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_imagePath != null)
            BuildImage(
              isUploaded: _isUploaded,
              imagePath: _imagePath!,
              onClose: _deleteImage,
            ),
          BlocBuilder<SttCubit, SttState>(
            builder: (context, state) {
              if (!widget.typing && !state.listening) {
                return const SizedBox.shrink();
              }
              final text = widget.typing ? null : "Listening";
              return Column(
                children: [
                  TypingIndicator(text: text),
                  const SizedBox(height: 6),
                ],
              );
            },
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: CustomTextField(
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  maxLines: 4,
                  hint: widget.enabled
                      ? "Enter prompt..."
                      : "Only custom chats can continue",
                  controller: _controller,
                  onChange: (p0) {
                    final isText = p0?.trim().isNotEmpty ?? true;
                    if (isText != _isValid) {
                      _isValid = isText;
                      setState(() {});
                    }
                  },
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.photo,
                      color: AppColors.whiteColor,
                      size: 30,
                    ),
                    onPressed: _handlePick,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              BlocConsumer<SttCubit, SttState>(
                listener: (context, state) {
                  if (state.listening) {
                    _controller.text = state.lastWord;
                  } else {
                    _isValid = _controller.text.isNotEmpty;
                  }
                },
                builder: (context, state) {
                  final grey = widget.typing || state.listening;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: widget.loading
                            ? null
                            : () => handleMessage(state.listening),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.all(widget.typing ? 10 : 0.0),
                          height: 53,
                          width: 53,
                          decoration: BoxDecoration(
                            color: !widget.loading && !grey && widget.enabled
                                ? AppColors.primaryColor
                                : AppColors.greyColor.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            !grey
                                ? _isValid
                                    ? Icons.send
                                    : Icons.mic
                                : Icons.close,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handlePick() {
    final memBloc = context.read<MembershipCubit>();
    final userBloc = context.read<UserBloc>();
    final feature = memBloc.feature!;
    final img = feature.fileInput.image;
    if (img.current >= img.max) {
      Fluttertoast.showToast(msg: "Your file input limit has reached");
      return;
    }
    AppUtils.pickImage(isCamera: false).then((res) async {
      if (res == null) return;
      final uid = userBloc.user!.uid;
      setState(() => _imagePath = res.path);
      if (!mounted) return;

      FocusScope.of(context).requestFocus(_focusNode);

      try {
        await ApiService.uploadFile(
          url: ApiRoutes.uploadFile,
          filePath: res.path,
          uid: uid,
        ).then((url) {
          setState(() {
            _isUploaded = true;
            _imageUrl = url;
          });
          _chatCubit.handleImageInput(ImageFile(
            image: res,
            url: url,
          ));
        });
      } catch (e) {
        setState(() => _imagePath = null);
        log("Uploading Error: $e");
      }
    });
  }

  void _deleteImage({bool isBack = false}) async {
    try {
      _chatCubit.handleImageInput(null);
      ApiService.sendFormDataRequest(
        ApiRoutes.deleteFile,
        {'file_path': _imageUrl},
      ).then((v) {
        log(v.toString());
      });
    } catch (e) {
      log("Deleting Error: $e");
    }
    if (!isBack) {
      setState(() {
        _isUploaded = false;
        _imagePath = null;
        _imageUrl = null;
      });
    }
  }

  void handleMessage(bool listening) {
    if (widget.typing) {
      _chatCubit.cancelGeneration();
      return;
    }

    if (!widget.enabled) return;

    if (!_isValid && !listening) {
      context.read<SttCubit>().startListening();
      return;
    }

    if (listening) {
      context.read<SttCubit>().stopListening();
    } else {
      sendMessage();
    }
  }

  void sendMessage() {
    final text = _controller.text.trim();
    widget.onSend(text, _imageUrl != null);
    _controller.clear();
    _isUploaded = false;
    _imagePath = null;
    _imageUrl = null;
    _isValid = false;
  }

  @override
  void deactivate() {
    context.read<SttCubit>().stopListening();
    if (_imageUrl != null) {
      _deleteImage(isBack: true);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}
