import 'package:content_scripter/screens/routes_screen/widgets/nav_button.dart';
import 'package:content_scripter/models/nav_button_model.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final Function(int) onNavigate;
  final int index;
  const CustomNavbar({
    super.key,
    required this.index,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(NavButtonModel.navBtns.length, (idx) {
          final btn = NavButtonModel.navBtns[idx];
          return NavButton(
            isActive: index == idx,
            onTap: () => onNavigate(idx),
            idx: idx,
            btn: btn,
          );
        }),
      ),
    );
  }
}
