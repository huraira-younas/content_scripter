import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/models/nav_button_model.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class NavButton extends StatefulWidget {
  final NavButtonModel btn;
  final Function() onTap;
  final bool isActive;
  final int idx;
  const NavButton({
    this.isActive = false,
    required this.onTap,
    required this.btn,
    required this.idx,
    super.key,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _textAnimation;

  @override
  Widget build(BuildContext context) {
    Color? color = AppColors.greyColor;
    if (widget.isActive) {
      _animationController.forward();
      if (widget.idx == 2) {
        color = AppColors.primaryColor;
      } else {
        color = null;
      }
    } else {
      _animationController.animateBack(0.0);
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.secondaryColor,
        ),
        constraints: const BoxConstraints(minWidth: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FadeTransition(
              opacity: _animationController,
              child: Image.asset(
                widget.isActive ? widget.btn.activeIcon : widget.btn.icon,
                color: color,
                height: 28,
              ),
            ),
            const SizedBox(height: 4),
            FadeTransition(
              opacity: _animationController,
              child: ScaleTransition(
                scale: _textAnimation,
                child: MyText(
                  text: widget.btn.title,
                  family: widget.isActive ? AppFonts.medium : AppFonts.regular,
                  color: widget.isActive
                      ? AppColors.primaryColor
                      : AppColors.greyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      lowerBound: 0.6,
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    final active = widget.isActive;

    _textAnimation = Tween<double>(
      begin: active ? 1.0 : 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
