import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTimeRange? selectedRange;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Estadísticas',
          style: GoogleFonts.inter(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: isDesktop ? 24 : 20,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16), // Menos padding en móvil
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Selector de rango de fechas
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      selectedRange == null
                          ? 'Seleccionar rango de fechas'
                          : '${selectedRange!.start.day}/${selectedRange!.start.month}/${selectedRange!.start.year} - '
                              '${selectedRange!.end.day}/${selectedRange!.end.month}/${selectedRange!.end.year}',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(now.year - 2),
                        lastDate: DateTime(now.year + 1),
                        initialDateRange: selectedRange,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(colorScheme: colorScheme),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => selectedRange = picked);
                        // Aquí puedes filtrar tus datos según el rango seleccionado
                      }
                    },
                  ),
                ),
                const SizedBox(height: 18),
                // Resumen rápido (opcional)
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _SummaryCard(
                      icon: Icons.local_shipping,
                      label: 'Total envíos',
                      value: '53',
                      color: colorScheme.primary,
                    ),
                    _SummaryCard(
                      icon: Icons.attach_money,
                      label: 'Total dinero',
                      value: '\$1,280',
                      color: colorScheme.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Gráfica de envíos
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bar_chart, color: colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Envíos por día de la semana',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                            const Spacer(),
                            Tooltip(
                              message: 'Cantidad de envíos realizados cada día',
                              child: Icon(
                                Icons.info_outline,
                                size: 18,
                                color: colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width:
                              double.infinity, // Ocupa todo el ancho disponible
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: colorScheme.primary,
                                  getTooltipItem: (
                                    group,
                                    groupIndex,
                                    rod,
                                    rodIndex,
                                  ) {
                                    return BarTooltipItem(
                                      '${rod.toY.toInt()} envíos',
                                      GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    getTitlesWidget:
                                        (value, meta) => Text(
                                          value.toInt().toString(),
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const days = [
                                        'L',
                                        'M',
                                        'M',
                                        'J',
                                        'V',
                                        'S',
                                        'D',
                                      ];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          days[value.toInt()],
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 5,
                                      gradient: LinearGradient(
                                        colors: [
                                          colorScheme.primary,
                                          colorScheme.primary.withOpacity(0.5),
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 8,
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 6,
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 3,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 7,
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 4,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 4,
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 5,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 9,
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 6,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 3,
                                      color: colorScheme.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                              ],
                              gridData: FlGridData(show: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Gráfica de dinero
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.show_chart,
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Dinero por día de la semana',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width:
                              double.infinity, // Ocupa todo el ancho disponible
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: colorScheme.secondary,
                                  getTooltipItem: (
                                    group,
                                    groupIndex,
                                    rod,
                                    rodIndex,
                                  ) {
                                    return BarTooltipItem(
                                      '\$${rod.toY.toInt()}',
                                      GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    getTitlesWidget:
                                        (value, meta) => Text(
                                          value.toInt().toString(),
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const days = [
                                        'L',
                                        'M',
                                        'M',
                                        'J',
                                        'V',
                                        'S',
                                        'D',
                                      ];
                                      return Text(
                                        days[value.toInt()],
                                        style: GoogleFonts.inter(
                                          color: colorScheme.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 120,
                                      color: colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 180,
                                      color: colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 150,
                                      color: colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 3,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 200,
                                      color: colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 4,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 170,
                                      color: colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 5,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 220,
                                      color: colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 6,
                                  barRods: [
                                    BarChartRodData(
                                      toY: 140,
                                      color: colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ],
                                ),
                              ],
                              gridData: FlGridData(show: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget para resumen rápido
class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 140, maxWidth: 220),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: color.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: color,
                      ),
                    ),
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
