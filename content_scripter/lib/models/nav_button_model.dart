import 'package:content_scripter/constants/app_assets.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class NavButtonModel {
  final String activeIcon;
  final String icon;
  final String title;

  const NavButtonModel({
    required this.activeIcon,
    required this.icon,
    required this.title,
  });

  static const navBtns = [
    NavButtonModel(
      activeIcon: AppAssets.activeChatPng,
      icon: AppAssets.chatPng,
      title: "Chat",
    ),
    NavButtonModel(
      activeIcon: AppAssets.activeAssistantsPng,
      icon: AppAssets.assistantsPng,
      title: "Assistants",
    ),
    NavButtonModel(
      activeIcon: AppAssets.interestsPng,
      icon: AppAssets.interestsPng,
      title: "Interests",
    ),
    NavButtonModel(
      activeIcon: AppAssets.activeHistoryPng,
      icon: AppAssets.historyPng,
      title: "Activity",
    ),
    NavButtonModel(
      activeIcon: AppAssets.activeAccountPng,
      icon: AppAssets.accountPng,
      title: "Account",
    ),
  ];
}
