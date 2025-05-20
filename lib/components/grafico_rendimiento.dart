import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompactFinanceChart extends StatelessWidget {
  final double saldoTotal;
  final double ingresos;
  final double gastos;
  final List<Map<String, dynamic>> transacciones;

  const CompactFinanceChart({
    super.key,
    required this.saldoTotal,
    required this.ingresos,
    required this.gastos,
    required this.transacciones,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final positiveColor = Color(0xFF66BB6A); // Modern Green
    final negativeColor = Color(0xFFEF5350); // Modern Red
    final textColor = isDark ? Colors.white70 : Colors.black87;

    // Procesar datos para líneas acumulativas
    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    double cumulativeIncome = 0;
    double cumulativeExpense = 0;
    double maxCumulativeValue = 0;

    // Asegurar que las transacciones están ordenadas por fecha para el cálculo acumulativo
    List<Map<String, dynamic>> sortedTransactions = List.from(transacciones);
    sortedTransactions.sort((a, b) => DateTime.parse(a['fecha']).compareTo(DateTime.parse(b['fecha'])));

    for (var t in sortedTransactions) {
      final date = DateTime.parse(t['fecha']);
      final amount = (t['monto'] as num).toDouble();
      final epochMillis = date.millisecondsSinceEpoch.toDouble();

      if (t['tipo'] == 'ingreso') {
        cumulativeIncome += amount;
      } else {
        cumulativeExpense += amount;
      }
      incomeSpots.add(FlSpot(epochMillis, cumulativeIncome));
      expenseSpots.add(FlSpot(epochMillis, cumulativeExpense));
      
      if (cumulativeIncome > maxCumulativeValue) maxCumulativeValue = cumulativeIncome;
      if (cumulativeExpense > maxCumulativeValue) maxCumulativeValue = cumulativeExpense;
    }
    
    // Si no hay spots, agregar uno dummy para que el gráfico no falle y tenga un rango X
    if (incomeSpots.isEmpty) {
        final nowEpoch = DateTime.now().millisecondsSinceEpoch.toDouble();
        incomeSpots.add(FlSpot(nowEpoch, 0));
        expenseSpots.add(FlSpot(nowEpoch, 0));
    }

    return SizedBox(
      width: 180, // Mismo ancho que la card
      height: 200, // Aumentamos la altura
      child: Column(
        children: [
          // Gráfico compacto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: incomeSpots.first.x,
                  maxX: incomeSpots.last.x,
                  minY: 0,
                  maxY: maxCumulativeValue * 1.1, // Un poco de padding superior
                  lineBarsData: [
                    // Línea de Ingresos Acumulados
                    LineChartBarData(
                      spots: incomeSpots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: positiveColor, // Color para ingresos
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            positiveColor.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Línea de Gastos Acumulados
                    LineChartBarData(
                      spots: expenseSpots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: negativeColor, // Color para gastos
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            negativeColor.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => isDark 
                          ? Colors.grey[800]!.withOpacity(0.95)
                          : Colors.white.withOpacity(0.95),
                      tooltipRoundedRadius: 4,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot spot) {
                          final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                          String title;
                          Color lineColor;
                          if (spot.barIndex == 0) { // Ingresos
                            title = 'Ingresos Acum.:';
                            lineColor = positiveColor;
                          } else { // Gastos
                            title = 'Gastos Acum.:';
                            lineColor = negativeColor;
                          }
                          return LineTooltipItem(
                            '$title\n${spot.y.toStringAsFixed(2)}€',
                            TextStyle(
                              color: lineColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: '\n${DateFormat('dd MMM yyyy').format(date)}',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                            textAlign: TextAlign.center,
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}