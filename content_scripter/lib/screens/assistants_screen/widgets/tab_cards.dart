import 'package:content_scripter/screens/assistants_screen/prompt_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:content_scripter/common_widget/cache_image.dart';
import 'package:content_scripter/common_widget/card_button.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/models/assistant_model.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AssistantBuilder extends StatelessWidget {
  final Map<String, List<AssistantModel>> assistants;
  const AssistantBuilder({
    required this.assistants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: assistants.entries.map((entry) {
        final cards = entry.value;
        final title = entry.key;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: MyText(
                size: AppConstants.titleLarge,
                family: AppFonts.bold,
                text: title,
              ),
            ),
            AnimationLimiter(
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 170,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  crossAxisCount: 2,
                ),
                children: List.generate(
                  cards.length,
                  (index) => AnimationConfiguration.staggeredGrid(
                    key: UniqueKey(),
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    columnCount: cards.length,
                    child: FadeInAnimation(
                      child: ScaleAnimation(
                        child: TabCard(card: cards[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }
}

class TabCard extends StatelessWidget {
  final AssistantModel card;
  const TabCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return CardButton(
      onTap: () async {
        final sid = const Uuid().v4();
        context.read<ChatCubit>().startChat(sid: sid);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PromptScreen(
            assistant: card,
            sid: sid,
          ),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: card.id,
            child: CacheImage(
              url: card.iconUrl,
              height: 50,
              width: 50,
            ),
          ),
          const SizedBox(height: 16),
          MyText(
            overflow: TextOverflow.ellipsis,
            size: AppConstants.subtitle,
            family: AppFonts.bold,
            text: card.topic,
          ),
          const SizedBox(height: 4),
          MyText(
            maxLines: 2,
            height: 1.1,
            text: card.description,
            color: AppColors.greyColor,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
