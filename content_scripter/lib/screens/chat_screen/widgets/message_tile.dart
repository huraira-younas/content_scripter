import 'package:content_scripter/common_widget/cache_image.dart';
import 'package:content_scripter/common_widget/profile_avt.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/models/message_model.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:content_scripter/cubits/tts_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final MessageModel message;
  final String profileUrl;
  final bool isSentByMe;
  final bool isModel;
  final bool loading;
  final String name;
  const MessageTile({
    required this.profileUrl,
    required this.isSentByMe,
    required this.isModel,
    required this.message,
    required this.loading,
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final color =
        isSentByMe || !isModel ? AppColors.primaryColor : AppColors.greyColor;
    return Column(
      crossAxisAlignment:
          isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: width * 0.85,
            minWidth: 100,
          ),
          padding: EdgeInsets.only(
            bottom: isSentByMe || !isModel ? 12 : 0,
            right: 12,
            left: 12,
            top: 12,
          ),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: loading ? 1 : 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment:
                isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              if (message.imageUrl != null) ...[
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(maxHeight: width),
                  child: CacheImage(url: message.imageUrl!),
                ),
                const SizedBox(height: 10),
              ],
              MarkdownBody(
                data: message.message,
                onTapLink: (text, href, title) {
                  AppUtils.launchURL(href ?? "");
                },
                styleSheet: MarkdownStyleSheet.fromTheme(
                  ThemeData.dark().copyWith(
                    textTheme: TextTheme(
                      bodyMedium: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MyText(
                    text: AppUtils.formatTimeAgo(message.time),
                    size: 10,
                  ),
                  if (!isSentByMe && isModel) ...[
                    const SizedBox(width: 5),
                    Material(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(
                            text: message.message,
                          ));
                          Fluttertoast.showToast(msg: "Copied");
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.copy, size: 12),
                              SizedBox(width: 6),
                              MyText(
                                family: AppFonts.medium,
                                text: "Copy Response",
                                size: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<TtsCubit, TtsState>(
                      builder: (context, state) {
                        final isPlaying = state.event == TtsEvent.playing;
                        final isCurrent =
                            isPlaying && state.nowPlaying == message.message;
                        return IconButton(
                          icon: Icon(
                            isCurrent ? Icons.stop : Icons.volume_up_rounded,
                          ),
                          onPressed: () {
                            context.read<TtsCubit>().playStop(
                                  message.message,
                                  isPlay: !isCurrent,
                                );
                          },
                          iconSize: 20,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (!isSentByMe) ...[
              ProfileAvt(
                size: 25,
                iconSize: 20,
                url: profileUrl,
              ),
              const SizedBox(width: 8),
            ],
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: MyText(
                backgroundColor: loading ? AppColors.secondaryColor : null,
                text: loading ? "Loading... $name" : name,
              ),
            ),
            if (isSentByMe) ...[
              const SizedBox(width: 8),
              ProfileAvt(
                url: profileUrl,
                iconSize: 20,
                size: 25,
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
