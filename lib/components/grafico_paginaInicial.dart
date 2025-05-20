import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../entidades/Ahorros.dart';
// import 'package:tfg_ivandelllanoblanco/models/themeProvider.dart';
// import 'package:provider/provider.dart';

class GraficoAhorros extends StatelessWidget {
  final List<Ahorros> ahorrosList;

  const GraficoAhorros({super.key, required this.ahorrosList});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.months,
        dateFormat: DateFormat.MMM(),
        labelStyle:
            TextStyle(color: CupertinoColors.label.resolveFrom(context)),
        minimum: DateTime(DateTime.now().year, 1),
        maximum: DateTime(DateTime.now().year, 12),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: " Cantidad (€)",
          textStyle:
              TextStyle(color: CupertinoColors.label.resolveFrom(context)),
        ),
        labelStyle:
            TextStyle(color: CupertinoColors.label.resolveFrom(context)),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Ahorros, DateTime>>[
        SplineAreaSeries<Ahorros, DateTime>(
          name: "Saldo",
          dataSource: ahorrosList,
          xValueMapper: (Ahorros ahorro, _) => ahorro.fecha,
          yValueMapper: (Ahorros ahorro, _) => ahorro.saldo,
          gradient: LinearGradient(colors: [
            CupertinoColors.systemBlue.withOpacity(0.6),
            CupertinoColors.systemBlue.withOpacity(0.1)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderColor: CupertinoColors.systemBlue,
          borderWidth: 2,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
        SplineSeries<Ahorros, DateTime>(
          name: "Ingresos",
          dataSource: ahorrosList,
          xValueMapper: (Ahorros ahorro, _) => ahorro.fecha,
          yValueMapper: (Ahorros ahorro, _) => ahorro.ingresos,
          color: CupertinoColors.systemGreen,
          width: 2,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
        SplineSeries<Ahorros, DateTime>(
          name: "Gastos",
          dataSource: ahorrosList,
          xValueMapper: (Ahorros ahorro, _) => ahorro.fecha,
          yValueMapper: (Ahorros ahorro, _) => ahorro.gastos,
          color: CupertinoColors.systemRed,
          width: 2,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
    );
  }
}
