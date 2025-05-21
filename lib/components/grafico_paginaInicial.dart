import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../entidades/Ahorros.dart';

class GraficoPrincipal extends StatelessWidget {
  final List<Ahorros> ahorrosList;

  const GraficoPrincipal({super.key, required this.ahorrosList});

  @override
  Widget build(BuildContext context) {
    final bool esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    final Color colorTexto = esModoOscuro ? Colors.white70 : Colors.black54;
    final Color colorFondo =
        esModoOscuro ? Colors.grey[900]! : Colors.grey[50]!;

    if (ahorrosList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorFondo,
        ),
        child: Center(
          child: Text(
            'No hay datos para mostrar.',
            style: TextStyle(
                color: colorTexto, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final theme = Theme.of(context);

    final Color colorIngresos = theme.colorScheme.primary;
    final Color colorGastos = Colors.orangeAccent;
    final Color colorSaldo = Colors.purpleAccent;

    // Procesamos los datos por trimestre
    final quarterData = <DateTime, Map<String, double>>{};
    final spotsIngresos = <FlSpot>[];
    final spotsGastos = <FlSpot>[];
    final spotsSaldo = <FlSpot>[];
    double maxY = 0;

    for (final ahorro in ahorrosList) {
      final quarterStart =
          DateTime(ahorro.fecha.year, (ahorro.fecha.month - 1) ~/ 3 * 3 + 1, 1);
      final quarterKey = DateTime(quarterStart.year, quarterStart.month);

      quarterData.update(quarterKey, (value) {
        return {
          'ingresos': value['ingresos']! + ahorro.ingresos,
          'gastos': value['gastos']! + ahorro.gastos,
        };
      },
          ifAbsent: () => {
                'ingresos': ahorro.ingresos,
                'gastos': ahorro.gastos,
              });
    }

    quarterData.forEach((quarter, values) {
      final ingresos = values['ingresos']!;
      final gastos = values['gastos']!;
      final saldo = ingresos - gastos;
      final x = quarter.millisecondsSinceEpoch.toDouble();

      spotsIngresos.add(FlSpot(x, ingresos));
      spotsGastos.add(FlSpot(x, gastos));
      spotsSaldo.add(FlSpot(x, saldo));

      maxY =
          [maxY, ingresos, gastos, saldo.abs()].reduce((a, b) => a > b ? a : b);
    });

    // Calculamos los totales
    final totalIngresos = spotsIngresos.fold(0.0, (sum, spot) => sum + spot.y);
    final totalGastos = spotsGastos.fold(0.0, (sum, spot) => sum + spot.y);
    final saldoTotal = totalIngresos - totalGastos;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorFondo,
      ),
      child: Column(
        children: [
          // Encabezado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rendimiento Financiero',
                    style: TextStyle(
                      color: colorTexto,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Resumen por Trimestre',
                    style: TextStyle(
                      color: colorTexto.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: esModoOscuro ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${saldoTotal >= 0 ? '+' : ''}${NumberFormat.currency(locale: 'es', symbol: '€').format(saldoTotal)}',
                  style: TextStyle(
                    color: saldoTotal >= 0 ? colorIngresos : colorGastos,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gráfico
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: esModoOscuro ? Colors.white12 : Colors.black12,
                    strokeWidth: 0.5,
                    dashArray: [4],
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: _calcularIntervaloTrimestral(
                          quarterData.keys.toList()),
                      getTitlesWidget: (value, meta) {
                        final date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Text(
                          'Q${(date.month - 1) ~/ 3 + 1}\n${date.year}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorTexto,
                            fontSize: 10,
                            height: 1.2,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: maxY / 3,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatearValor(value),
                          style: TextStyle(
                            color: colorTexto,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: quarterData.keys.first.millisecondsSinceEpoch.toDouble(),
                maxX: quarterData.keys.last.millisecondsSinceEpoch.toDouble(),
                minY: 0,
                maxY: maxY * 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: spotsIngresos,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: colorIngresos,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          colorIngresos.withOpacity(0.15),
                          Colors.transparent
                        ],
                        stops: [0.1, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: spotsGastos,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: colorGastos,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          colorGastos.withOpacity(0.15),
                          Colors.transparent
                        ],
                        stops: [0.1, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: spotsSaldo,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: colorSaldo,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    dashArray: [5, 5],
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipMargin: 16.0,
                    getTooltipColor: (_) => esModoOscuro
                        ? Colors.black.withOpacity(0.85)
                        : Colors.white.withOpacity(0.85),
                    tooltipRoundedRadius: 8,
                    tooltipPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((barSpot) {
                        final date = DateTime.fromMillisecondsSinceEpoch(
                            barSpot.x.toInt());
                        final tipo =
                            ['Ingresos', 'Gastos', 'Saldo'][barSpot.barIndex];
                        final color = [
                          colorIngresos,
                          colorGastos,
                          colorSaldo
                        ][barSpot.barIndex];

                        return LineTooltipItem(
                          tipo,
                          TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '\n${NumberFormat.currency(locale: 'es', symbol: '€').format(barSpot.y)}',
                              style: TextStyle(
                                color:
                                    esModoOscuro ? Colors.white : Colors.black,
                                fontSize: 9,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '\nQ${(date.month - 1) ~/ 3 + 1} ${date.year}',
                              style: TextStyle(
                                color: esModoOscuro
                                    ? Colors.white70
                                    : Colors.black54,
                                fontSize: 8,
                                height: 1.4,
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
          const SizedBox(height: 8),
          // Leyenda
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LeyendaItem(color: colorIngresos, texto: 'Ingresos'),
              const SizedBox(width: 16),
              _LeyendaItem(color: colorGastos, texto: 'Gastos'),
              const SizedBox(width: 16),
              _LeyendaItem(color: colorSaldo, texto: 'Saldo'),
            ],
          ),
        ],
      ),
    );
  }

  //Metodo para calcular el intervalo entre trimestres
  double _calcularIntervaloTrimestral(List<DateTime> quarters) {
    if (quarters.length <= 1) return 1;
    return quarters.length > 1
        ? (quarters[1].millisecondsSinceEpoch -
                quarters[0].millisecondsSinceEpoch)
            .toDouble()
        : const Duration(days: 90).inMilliseconds.toDouble();
  }

  //Metodo para formatear el valor
  String _formatearValor(double valor) {
    if (valor >= 1000000) return '${(valor / 1000000).toStringAsFixed(1)}M';
    if (valor >= 1000) return '${(valor / 1000).toStringAsFixed(1)}K';
    return valor.toInt().toString();
  }
}

//Clase para la leyenda
class _LeyendaItem extends StatelessWidget {
  final Color color;
  final String texto;

  const _LeyendaItem({required this.color, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}
