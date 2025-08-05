import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:content_scripter/common_widget/tab_button.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:flutter/material.dart';

class TabsBuilder extends StatefulWidget {
  final Function(String tab) onTap;
  final List<String> tabs;
  final String currentTab;

  const TabsBuilder({
    required this.currentTab,
    required this.onTap,
    required this.tabs,
    super.key,
  });

  @override
  State<TabsBuilder> createState() => _TabsBuilderState();
}

class _TabsBuilderState extends State<TabsBuilder> {
  final scrollController = ScrollController();
  late final keys = List.generate(
    widget.tabs.length,
    (index) => GlobalKey(),
  );

  void _scrollToCurrentTab() {
    final idx = widget.tabs.indexOf(widget.currentTab);
    if (idx >= 0 && keys[idx].currentContext != null) {
      Scrollable.ensureVisible(
        keys[idx].currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTab();
    });

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding),
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: AnimationLimiter(
        child: Row(
          children: List.generate(
            widget.tabs.length,
            (index) => AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 300),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: TabButton(
                    key: keys[index],
                    onPressed: () {
                      widget.onTap(widget.tabs[index]);
                      setState(() {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToCurrentTab();
                        });
                      });
                    },
                    isActive: widget.tabs[index] == widget.currentTab,
                    title: widget.tabs[index],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
