import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loginpage/Controllers/dark_theme_controller.dart';
import 'package:loginpage/Views/statistics.dart';
import 'package:loginpage/Views/add_product_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Panel principal',
          style: GoogleFonts.inter(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
        actions: [ThemeToggleButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Resumen',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DashboardCard(
                  icon: Icons.inventory_2_outlined,
                  label: 'Inventario',
                  value: '120',
                  color: Colors.teal,
                ),
                _DashboardCard(
                  icon: Icons.local_shipping_outlined,
                  label: 'Envíos',
                  value: '8',
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Accesos rápidos eliminados para un dashboard más limpio.
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add_box_outlined),
            label: 'Nuevo producto',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.local_shipping),
            label: 'Nuevo envío',
            onTap: () {
              // Acción para agregar envío
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.bar_chart_outlined),
            label: 'Estadísticas',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.inter(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
