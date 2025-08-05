import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_assets.dart';
import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final String? text;
  const TypingIndicator({
    required this.text,
    super.key,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppAssets.appLogoPng, height: 26),
        MyText(text: " ${widget.text ?? ""}"),
        const SizedBox(width: 4),
        ...List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Opacity(
                opacity:
                    (1 - (_animation.value - index * 0.3).abs()).clamp(0, 1),
                child: child,
              );
            },
            child: const Dot(),
          );
        }),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
