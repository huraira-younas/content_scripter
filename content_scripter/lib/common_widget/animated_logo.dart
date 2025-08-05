import 'package:content_scripter/common_widget/cache_image.dart';
import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  final String iconUrl;
  final double size;
  final String tag;
  const AnimatedLogo({
    required this.iconUrl,
    required this.size,
    required this.tag,
    super.key,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.1),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Hero(
        tag: widget.tag,
        child: CacheImage(
          url: widget.iconUrl,
          height: widget.size,
          width: widget.size,
        ),
      ),
    );
  }
}
