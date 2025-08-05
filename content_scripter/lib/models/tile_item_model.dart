import 'package:flutter/material.dart' show IconData, immutable, Icons;

@immutable
class TileItem {
  final IconData icon;
  final String title;

  const TileItem({
    required this.icon,
    required this.title,
  });

  static const tiles = {
    "Account": [
      TileItem(
        icon: Icons.person_outline,
        title: "Personal Info",
      ),
      TileItem(
        title: "Password Manager",
        icon: Icons.lock,
      ),
      TileItem(
        icon: Icons.security_outlined,
        title: "Security",
      ),
    ],
    "About": [
      TileItem(
        icon: Icons.help_center_outlined,
        title: "Help Center",
      ),
      TileItem(
        title: "Privacy Policy",
        icon: Icons.policy,
      ),
      TileItem(
        icon: Icons.accessibility_sharp,
        title: "Terms And Services",
      ),
    ],
    "Settings": [
      TileItem(
        icon: Icons.logout_outlined,
        title: "Logout",
      ),
    ],
  };
}
