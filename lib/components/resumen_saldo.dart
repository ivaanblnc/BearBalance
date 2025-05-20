import 'package:flutter/material.dart';

class SaldoResumen extends StatelessWidget {
  const SaldoResumen({
    super.key,
    required this.saldoActual,
    required this.totalIngresos,
    required this.totalGastos,
  });

  final double saldoActual;
  final double totalIngresos;
  final double totalGastos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(12.0),
      //   side: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
      // ),
      margin: EdgeInsets.zero, // Para que el Card se ajuste al espacio del Expanded en AhorrosVista
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente si es posible
          children: [
            Text(
              "Saldo total:",
              style: textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            Text(
              "${saldoActual.toStringAsFixed(2)} €",
              style: textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Ingresos:",
              style: textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            Text(
              "${totalIngresos.toStringAsFixed(2)} €",
              style: textTheme.titleMedium?.copyWith(color: Colors.green[700]),
            ),
            const SizedBox(height: 4),
            Text(
              "Gastos:",
              style: textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            Text(
              "${totalGastos.toStringAsFixed(2)} €",
              style: textTheme.titleMedium?.copyWith(color: Colors.red[700]),
            ),
          ],
        ),
      ),
    );
  }
  // _buildSaldoText ya no es necesario, se integra la lógica en build.
}
