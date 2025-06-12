import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraficoAhorros extends StatelessWidget {
  final double saldoTotal;
  final double ingresos;
  final double gastos;
  final List<Map<String, dynamic>> transacciones;

  const GraficoAhorros({
    super.key,
    required this.saldoTotal,
    required this.ingresos,
    required this.gastos,
    required this.transacciones,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final positiveColor = Colors.greenAccent[400]!;
    final negativeColor = Colors.redAccent[400]!;
    final textColor = isDark ? Colors.white70 : Colors.black87;

    final spots = transacciones.map((t) {
      final date = DateTime.parse(t['fecha'] as String);
      final amount = (t['monto'] as num).toDouble();
      return FlSpot(
        date.millisecondsSinceEpoch.toDouble(),
        t['tipo'] == 'ingreso' ? amount : -amount,
      );
    }).toList();

    spots.sort((a, b) => a.x.compareTo(b.x));

    double minY = 0;
    double maxY = 1;
    if (spots.isNotEmpty) {
      minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
      maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
      if (minY == maxY) {
        minY = minY - (minY.abs() * 0.1 + 1);
        maxY = maxY + (maxY.abs() * 0.1 + 1);
      }
    }
    final yPadding = (maxY - minY) * 0.1;
    minY -= yPadding;
    maxY += yPadding;
    if (minY == 0 && maxY == 0) {
      minY = -1;
      maxY = 1;
    }

    return SizedBox(
      width: 180,
      height: 180,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: spots.isNotEmpty ? spots.first.x : 0,
                  maxX: spots.isNotEmpty ? spots.last.x : 1,
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: primaryColor,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      shadow: Shadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipMargin: 12.0,
                      getTooltipColor: (_) => isDark
                          ? Colors.grey[800]!.withOpacity(0.95)
                          : Colors.white.withOpacity(0.95),
                      tooltipRoundedRadius: 4,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final date = DateTime.fromMillisecondsSinceEpoch(
                              spot.x.toInt());
                          return LineTooltipItem(
                            DateFormat('dd MMM', 'es_ES').format(date),
                            TextStyle(
                              color: textColor,
                              fontSize: 9,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '\n${NumberFormat.currency(locale: 'es_ES', symbol: '€').format(spot.y)}',
                                style: TextStyle(
                                  color: spot.y >= 0
                                      ? positiveColor
                                      : negativeColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Ingresos',
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'es_ES', symbol: '€')
                          .format(ingresos),
                      style: TextStyle(
                        color: positiveColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Gastos',
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'es_ES', symbol: '€')
                          .format(gastos),
                      style: TextStyle(
                        color: negativeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
