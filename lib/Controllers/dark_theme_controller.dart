import 'package:flutter/material.dart';
import '../Widgets/dark_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        isDarkMode() ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: colorScheme.primary,
      ),
      tooltip: 'Cambiar modo',
      onPressed: toggleTheme,
    );
  }
}
