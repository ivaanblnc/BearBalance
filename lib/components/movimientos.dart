import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tfg_ivandelllanoblanco/components/opciones_ahorro.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:tfg_ivandelllanoblanco/views/aniadirAhorros.dart';
import 'package:tfg_ivandelllanoblanco/components/animated_movement_indicator.dart';

class DetalleMovimientos extends StatelessWidget {
  const DetalleMovimientos({
    super.key,
    required this.ahorros,
    required this.cargarAhorros,
    required this.controlador,
  });

  final List<Map<String, dynamic>> ahorros;
  final Future<void> Function() cargarAhorros;
  final AhorrosControlador controlador;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Detalle de movimientos",
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant)),
              IconButton(
                icon: Icon(Icons.add_circle_outline,
                    color: theme.colorScheme.primary, size: 28),
                tooltip: 'Añadir movimiento',
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NuevoAhorroGastoVista()),
                  );
                  if (resultado == true && context.mounted) {
                    cargarAhorros();
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(child: _construirContenidoLista(context)),
      ],
    );
  }

  Widget _construirContenidoLista(BuildContext context) {
    final theme = Theme.of(context);

    if (ahorros.isEmpty) {
      return const Center(
          child: Text("No hay movimientos registrados",
              style: TextStyle(fontSize: 16, color: Colors.grey)));
    }

    return ListView.builder(
      itemCount: ahorros.length,
      itemBuilder: (context, index) {
        final ahorro = ahorros[index];
        final esIngreso = ahorro['tipo'] == 'ingreso';
        final tipoColor =
            esIngreso ? Colors.green.shade600 : Colors.red.shade500;
        final cantidad = (ahorro['cantidad'] as num).toDouble();
        final fecha = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(ahorro['fecha_registro']));
        final tituloMovimiento =
            '${ahorro['tipo'].toString().replaceFirstMapped(RegExp(r'\w'), (match) => match.group(0)!.toUpperCase())} - $fecha';

        return Card(
          elevation: 1.5,
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: AnimatedMovementIndicator(
              isIncome: esIngreso,
              size: 22,
            ),
            title: Text(tituloMovimiento,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500)),
            subtitle: ahorro['descripcion'] != null &&
                    ahorro['descripcion'].toString().isNotEmpty
                ? Text(ahorro['descripcion'].toString(),
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)
                : null,
            trailing: Text(
              '${esIngreso ? '' : '-'}${NumberFormat.currency(locale: 'es_ES', symbol: '€').format(cantidad)}',
              style: theme.textTheme.titleSmall?.copyWith(
                color: tipoColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => OpcionesAhorroDialog.mostrarOpcionesAhorro(
              context,
              ahorro,
              controlador,
              cargarAhorros,
            ),
          ),
        );
      },
    );
  }
}
