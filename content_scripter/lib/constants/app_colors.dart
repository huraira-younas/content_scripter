import 'package:flutter/material.dart';

class AppColors {
  static const whiteColor = Color.fromARGB(255, 225, 225, 225);
  static const greyColor = Color.fromARGB(255, 185, 194, 199);
  static const cardColor = Color.fromARGB(255, 33, 33, 46);
  static const secondaryColor = Color(0xFF11101E);
  static const primaryColor = Color(0xFF55DEE9);
  static final borderColor = primaryColor.withValues(alpha: 0.1);
  // static const borderColor = Color(0xFF55DEE9);

  static final shimmerBColor = greyColor.withValues(alpha: 0.1);
  static final shimmerHColor = greyColor.withValues(alpha: 0.16);

  static final colorTheme = ThemeData.light(useMaterial3: true).copyWith(
    primaryIconTheme: const IconThemeData(color: whiteColor),
    iconTheme: const IconThemeData(color: whiteColor),
    splashColor: primaryColor.withValues(alpha: 0.6),
    scaffoldBackgroundColor: secondaryColor,
    secondaryHeaderColor: secondaryColor,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      surfaceTint: secondaryColor,
      primary: primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: secondaryColor,
      backgroundColor: secondaryColor,
      foregroundColor: whiteColor,
      centerTitle: true,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
  );
}
