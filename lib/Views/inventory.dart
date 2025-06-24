import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginpage/Controllers/dark_theme_controller.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Inventario',
          style: GoogleFonts.inter(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
        actions: const [ThemeToggleButton()],
      ),
      body: Center(
        child: Text(
          'Aquí verás y gestionarás el inventario.',
          style: GoogleFonts.inter(
            color: colorScheme.onBackground,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
