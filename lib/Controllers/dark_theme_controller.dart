import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/dark_theme.dart';

class ThemeSwitchTile extends StatelessWidget {
  const ThemeSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return SwitchListTile(
          title: Text(
            currentMode == ThemeMode.dark ? 'Modo oscuro' : 'Modo claro',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          value: isDarkMode(),
          onChanged: (val) {
            toggleTheme();
          },
          secondary: Icon(
            isDarkMode() ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            color: colorScheme.primary,
          ),
        );
      },
    );
  }
}
