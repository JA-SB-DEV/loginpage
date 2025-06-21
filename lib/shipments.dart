import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShipmentsScreen extends StatelessWidget {
  const ShipmentsScreen({super.key});

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
          'Envíos',
          style: GoogleFonts.inter(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Aquí gestionarás los envíos de mercancía.',
          style: GoogleFonts.inter(
            color: colorScheme.onBackground,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
