import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Pantalla que muestra los detalles de un ahorro o gasto específico
class DetalleAhorroVista extends StatelessWidget {
  // Datos del ahorro que se mostrarán en la vista
  final Map<String, dynamic> ahorro;

  const DetalleAhorroVista({super.key, required this.ahorro});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final formatoFecha = DateFormat('dd/MM/yyyy HH:mm', 'es_ES');
    final formatoMoneda = NumberFormat.currency(locale: 'es_ES', symbol: '€');

    final positiveColor = Color(0xFF66BB6A);
    final negativeColor = Color(0xFFEF5350);

    Widget buildDetailRow(String label, String value,
        {Color? valueColor, FontWeight? valueWeight}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: textTheme.titleSmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: textTheme.bodyLarge?.copyWith(
                  color: valueColor ?? colorScheme.onSurface,
                  fontWeight: valueWeight ?? FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Movimiento'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 0.5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          color: colorScheme.surfaceContainerLowest,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildDetailRow(
                  'Tipo:',
                  ahorro['tipo'] == 'ingreso' ? 'Ingreso' : 'Gasto',
                  valueColor: ahorro['tipo'] == 'ingreso'
                      ? positiveColor
                      : negativeColor,
                  valueWeight: FontWeight.bold,
                ),
                Divider(color: colorScheme.outlineVariant.withOpacity(0.5)),
                buildDetailRow(
                  'Fecha:',
                  formatoFecha.format(
                      DateTime.parse(ahorro['fecha_registro']).toLocal()),
                ),
                Divider(color: colorScheme.outlineVariant.withOpacity(0.5)),
                buildDetailRow(
                  'Cantidad:',
                  formatoMoneda.format((ahorro['cantidad'] as num).toDouble()),
                  valueColor: ahorro['tipo'] == 'ingreso'
                      ? positiveColor
                      : negativeColor,
                  valueWeight: FontWeight.bold,
                ),
                if (ahorro['tipo'] == 'gasto' &&
                    ahorro['categoria'] != null &&
                    ahorro['categoria'].isNotEmpty) ...[
                  Divider(color: colorScheme.outlineVariant.withOpacity(0.5)),
                  buildDetailRow(
                    'Categoría:',
                    ahorro['categoria'],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
