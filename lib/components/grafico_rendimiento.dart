import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficoRendimiento extends StatelessWidget {
  const GraficoRendimiento({
    super.key,
    required this.ahorros,
    required this.saldoActual,
  });

  final List<Map<String, dynamic>> ahorros;
  final double saldoActual;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 180,
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(isVisible: false),
        primaryYAxis: NumericAxis(isVisible: false),
        series: <CartesianSeries<Map<String, dynamic>, DateTime>>[
          LineSeries<Map<String, dynamic>, DateTime>(
            dataSource: ahorros,
            xValueMapper: (ahorro, _) =>
                DateTime.parse(ahorro['fecha_registro']),
            yValueMapper: (ahorro, _) => ahorro['tipo'] == 'ingreso'
                ? (ahorro['cantidad'] as num).toDouble()
                : -(ahorro['cantidad'] as num).toDouble(),
            color: saldoActual < 0 ? Colors.red : Colors.green,
            markerSettings: const MarkerSettings(isVisible: false),
          ),
        ],
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: const InteractiveTooltip(
            enable: true,
            format: 'point.x : point.y €',
          ),
        ),
      ),
    );
  }
}
