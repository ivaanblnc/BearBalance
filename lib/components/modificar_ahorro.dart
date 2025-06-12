import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:intl/intl.dart';

class FormularioMovimientoDialogo {
  static void mostrarDialogo(
    BuildContext contexto,
    Future<void> Function() cargarAhorros, {
    Map<String, dynamic>? ahorro,
  }) {
    String categoria = ahorro?['categoria'] ?? '';
    final String? categoriaOriginal = ahorro?['categoria'];
    double cantidad = ahorro?['cantidad']?.toDouble() ?? 0.0;
    DateTime fechaRegistro = ahorro != null
        ? DateTime.parse(ahorro['fecha_registro'])
        : DateTime.now();
    String tipoMovimiento = ahorro?['tipo'] ?? 'ingreso';

    ValueNotifier<String?> cantidadError = ValueNotifier(null);

    final theme = Theme.of(contexto);

    showDialog(
      context: contexto,
      builder: (contextoDialogo) {
        return StatefulBuilder(
          builder:
              (BuildContext contextoBuilder, StateSetter actualizarEstado) {
            String categoriaActual = categoria;
            double cantidadActual = cantidad;

            final InputDecoration modernInputDecoration = InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              labelStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8)),
            );

            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              title: Text(ahorro == null
                  ? 'Nuevo Movimiento'
                  : 'Actualizar Movimiento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tipoMovimiento == 'gasto')
                      TextField(
                        decoration: modernInputDecoration.copyWith(
                            labelText: 'Descripción (opcional)'),
                        onChanged: (valor) => categoriaActual = valor,
                        controller:
                            TextEditingController(text: categoriaActual),
                      ),
                    if (tipoMovimiento == 'gasto') SizedBox(height: 16),
                    TextField(
                      decoration:
                          modernInputDecoration.copyWith(labelText: 'Cantidad'),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      onChanged: (valor) {
                        final parsed = double.tryParse(valor);
                        if (parsed == null || parsed <= 0) {
                          cantidadError.value =
                              'Introduce un número válido y mayor a 0.';
                        } else {
                          cantidadActual = parsed;
                          cantidadError.value = null;
                        }
                      },
                      controller: TextEditingController(
                          text: cantidadActual > 0
                              ? cantidadActual.toString()
                              : ''),
                    ),
                    ValueListenableBuilder<String?>(
                      valueListenable: cantidadError,
                      builder: (context, error, _) {
                        return error != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  error,
                                  style: TextStyle(
                                      color: theme.colorScheme.error,
                                      fontSize: 12),
                                ),
                              )
                            : SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: 16),
                    SegmentedButton<String>(
                      segments: <ButtonSegment<String>>[
                        ButtonSegment<String>(
                            value: 'ingreso',
                            label: Text('Ingreso'),
                            icon: Icon(Icons.add_circle_outline)),
                        ButtonSegment<String>(
                            value: 'gasto',
                            label: Text('Gasto'),
                            icon: Icon(Icons.remove_circle_outline)),
                      ],
                      selected: <String>{tipoMovimiento},
                      onSelectionChanged: (Set<String> newSelection) {
                        actualizarEstado(() {
                          tipoMovimiento = newSelection.first;
                          if (tipoMovimiento == 'ingreso' &&
                              ahorro == null &&
                              (categoriaOriginal == null ||
                                  categoriaOriginal.isEmpty)) {
                            categoria = '';
                            categoriaActual = '';
                          }
                        });
                      },
                      style: SegmentedButton.styleFrom(
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        selectedForegroundColor: theme.colorScheme.onPrimary,
                        selectedBackgroundColor: theme.colorScheme.primary,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                      showSelectedIcon: false,
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        final nuevaFecha = await _mostrarSelectorFechaMaterial(
                          contextoBuilder,
                          fechaRegistro,
                        );
                        if (nuevaFecha != null) {
                          actualizarEstado(() {
                            fechaRegistro = nuevaFecha;
                          });
                        }
                      },
                      child: Container(
                        padding:
                            (modernInputDecoration.contentPadding as EdgeInsets)
                                .copyWith(right: 12.0),
                        decoration: BoxDecoration(
                          color: modernInputDecoration.fillColor,
                          borderRadius: (modernInputDecoration.border
                                  as OutlineInputBorder)
                              .borderRadius,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _fechaLimiteTexto(fechaRegistro),
                              style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.9)),
                            ),
                            Icon(Icons.calendar_today,
                                color: theme.colorScheme.primary, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancelar',
                      style: TextStyle(color: theme.colorScheme.primary)),
                  onPressed: () => Navigator.pop(contextoDialogo),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary),
                  child: Text(ahorro == null ? 'Agregar' : 'Actualizar'),
                  onPressed: () async {
                    if (cantidadActual > 0) {
                      final String? categoriaParaGuardar =
                          tipoMovimiento == 'ingreso' ? null : categoriaActual;
                      try {
                        if (ahorro == null) {
                          await AhorrosControlador().agregarAhorro({
                            'categoria': categoriaParaGuardar,
                            'cantidad': cantidadActual,
                            'fecha_registro': fechaRegistro.toIso8601String(),
                            'tipo': tipoMovimiento,
                          });
                        } else {
                          await AhorrosControlador()
                              .actualizarAhorro(ahorro['id'], {
                            'categoria': categoriaParaGuardar,
                            'cantidad': cantidadActual,
                            'fecha_registro': fechaRegistro.toIso8601String(),
                            'tipo': tipoMovimiento,
                          });
                        }
                        cargarAhorros();
                        Navigator.pop(contextoDialogo);
                      } catch (e) {
                        print('Error al actualizar: $e');
                      }
                    } else if (cantidadActual <= 0) {
                      cantidadError.value = 'La cantidad debe ser mayor que 0.';
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static String _fechaLimiteTexto(DateTime fecha) {
    return 'Fecha: ${DateFormat('dd/MM/yyyy').format(fecha.toLocal())}';
  }

  static Future<DateTime?> _mostrarSelectorFechaMaterial(
    BuildContext context,
    DateTime fechaInicial,
  ) async {
    final theme = Theme.of(context);
    return await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: 'SELECCIONAR FECHA',
      cancelText: 'CANCELAR',
      confirmText: 'ACEPTAR',
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              surface: theme.colorScheme.surface,
              onSurface: theme.colorScheme.onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
