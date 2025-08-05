import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:content_scripter/common_widget/card_button.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PromptsBuilder extends StatelessWidget {
  final Function(String) onTap;
  const PromptsBuilder({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ChatCubit, ChatState>(
        buildWhen: (p, c) => p.loadingPrompts != c.loadingPrompts,
        builder: (context, state) {
          final loading = state.loadingPrompts;
          final prompts = state.prompts;
          return Scrollbar(
            thickness: 2,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: loading
                  ? Shimmer.fromColors(
                      highlightColor: AppColors.shimmerHColor,
                      baseColor: AppColors.shimmerBColor,
                      child: const BuildPrompts(),
                    )
                  : BuildPrompts(
                      prompts: prompts,
                      onTap: onTap,
                    ),
            ),
          );
        },
      ),
    );
  }
}

class BuildPrompts extends StatelessWidget {
  final List<String> prompts;
  final Function(String)? onTap;
  const BuildPrompts({
    this.prompts = const [],
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isloading = onTap == null;
    final p = isloading
        ? List.generate(4, (idx) => "This is a test prompt")
        : prompts;
    return AnimationLimiter(
      child: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 120,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          crossAxisCount: 2,
        ),
        children: List.generate(p.length, (index) {
          final data = p[index];
          int firstCodePoint = data.runes.first;
          String firstCharacter = String.fromCharCode(firstCodePoint);
          final prompt = data.substring(firstCharacter.length);

          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 500),
            columnCount: p.length,
            child: FadeInAnimation(
              child: ScaleAnimation(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CardButton(
                    color: isloading ? Colors.grey : null,
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    onTap: () => onTap?.call(data),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MyText(text: firstCharacter, size: 22),
                        const SizedBox(height: 10),
                        MyText(
                          text: prompt.trim(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
