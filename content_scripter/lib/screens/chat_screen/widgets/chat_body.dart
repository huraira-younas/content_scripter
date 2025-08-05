import 'package:content_scripter/constants/app_assets.dart';
import 'package:content_scripter/models/user_model.dart';
import 'package:content_scripter/screens/chat_screen/widgets/message_tile.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatBody extends StatelessWidget {
  final List<MessageModel> messages;
  final List<UserModel> users;
  final String userProfile;
  final bool loading;
  final String uid;
  const ChatBody({
    required this.userProfile,
    required this.messages,
    required this.loading,
    required this.users,
    required this.uid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: loading
          ? const ShowLoading()
          : BuildMessages(
              userProfile: userProfile,
              messages: messages,
              users: users,
              uid: uid,
            ),
    );
  }
}

class ShowLoading extends StatelessWidget {
  const ShowLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: AppColors.shimmerHColor,
      baseColor: AppColors.shimmerBColor,
      child: BuildMessages(
        messages: MessageModel.messages,
        loading: true,
      ),
    );
  }
}

class BuildEmpty extends StatelessWidget {
  const BuildEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.format_list_bulleted_add,
              size: 80,
              color: AppColors.greyColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 10),
            MyText(
              text: "No Messages Found",
              size: AppConstants.subtitle,
              color: AppColors.greyColor.withValues(alpha: 0.5),
            )
          ],
        ),
      ),
    );
  }
}

class BuildMessages extends StatelessWidget {
  final List<MessageModel> messages;
  final List<UserModel> users;
  final String userProfile;
  final bool loading;
  final String uid;
  const BuildMessages({
    this.messages = const [],
    this.userProfile = "",
    this.loading = false,
    this.users = const [],
    this.uid = "",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      reverse: !loading,
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final idx = users.indexWhere((e) => e.uid == message.userId);
        String profileUrl = AppAssets.appLogoPng;
        final isModel = message.role == "model";
        String name = "Content-Scripter";

        final isSentByMe =
            (!isModel && message.userId == uid) || (loading && !isModel);
        if (isSentByMe) {
          profileUrl = userProfile;
          name = "You";
        } else if (idx != -1 && !isModel) {
          profileUrl = users[idx].profileUrl;
          name = users[idx].name;
        } else if (!isModel) {
          name = "Past Participant";
          profileUrl = "";
        }

        return MessageTile(
          profileUrl: profileUrl,
          isSentByMe: isSentByMe,
          message: message,
          isModel: isModel,
          loading: loading,
          name: name,
        );
      },
    );
  }
}
