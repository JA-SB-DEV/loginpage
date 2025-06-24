import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void toggleTheme() {
  themeNotifier.value =
      themeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}

bool isDarkMode() {
  return themeNotifier.value == ThemeMode.dark;
}
