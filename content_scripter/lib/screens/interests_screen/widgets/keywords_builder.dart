import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:content_scripter/common_widget/card_builder.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class KeywordsBuilder extends StatefulWidget {
  const KeywordsBuilder({super.key});

  @override
  State<KeywordsBuilder> createState() => _KeywordsBuilderState();
}

class _KeywordsBuilderState extends State<KeywordsBuilder> {
  final _selectedKeywords = <String>[];

  void copyKeyword() {
    Clipboard.setData(
      ClipboardData(text: _selectedKeywords.toString()),
    ).then((v) => Fluttertoast.showToast(
          msg: "Copied Keywords",
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (c, p) => !listEquals(c.keywords, p.keywords),
      listener: (context, state) {
        _selectedKeywords.clear();
      },
      buildWhen: (p, c) => c.loadingKeywords != p.loadingKeywords,
      builder: (context, state) {
        final loading = state.loadingKeywords;
        final keywords = state.keywords;

        return Column(
          children: [
            Keywords(
              title: "Related Keywords",
              skeywords: _selectedKeywords,
              keywords: keywords,
              loading: loading,
              onTap: (keyword) {
                setState(() {
                  if (_selectedKeywords.contains(keyword)) {
                    _selectedKeywords.remove(keyword);
                    return;
                  }
                  if (_selectedKeywords.length >= 5) {
                    Fluttertoast.showToast(msg: "You can select 5 keywords");
                    return;
                  }
                  _selectedKeywords.add(keyword);
                });
              },
            ),
            const SizedBox(height: 10),
            if (_selectedKeywords.isNotEmpty) ...[
              CustomButton(
                onPressed: copyKeyword,
                text: "Copy ${_selectedKeywords.length} Keywords",
              ),
              const SizedBox(height: 20),
            ],
          ],
        );
      },
    );
  }
}

class Keywords extends StatelessWidget {
  final Function(String keyword)? onTap;
  final List<String> keywords;
  final List<String> skeywords;
  final bool loading;
  final String title;
  const Keywords({
    required this.skeywords,
    required this.keywords,
    required this.loading,
    required this.title,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            MyText(
              size: AppConstants.subtitle,
              family: AppFonts.bold,
              text: title,
            ),
            const Spacer(),
            MyText(
              text: keywords.length.toString(),
              family: AppFonts.semibold,
            ),
          ],
        ),
        const MyText(
          text: "You can select max 5 keywords",
          color: AppColors.greyColor,
        ),
        const SizedBox(height: 10),
        CardBuilder(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Wrap(
                    spacing: 5,
                    children: keywords.map((keyword) {
                      final isSelected = skeywords.contains(keyword);
                      return TextButton(
                        key: UniqueKey(),
                        onPressed: () => onTap?.call(keyword),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              isSelected ? AppColors.primaryColor : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: AppColors.borderColor),
                          ),
                        ),
                        child: MyText(
                          family: AppFonts.semibold,
                          text: keyword,
                          size: 12,
                          color:
                              isSelected ? Colors.white : AppColors.greyColor,
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }
}
