import 'package:flutter/cupertino.dart';
// Importamos Material para el Text de error
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:intl/intl.dart';

class CupertinoAhorroDialogo {
  static void mostrarCupertinoDialogo(
    BuildContext contexto,
    dynamic estadoVista,
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

    showCupertinoDialog(
      context: contexto,
      builder: (contextoDialogo) {
        return StatefulBuilder(
          builder:
              (BuildContext contextoBuilder, StateSetter actualizarEstado) {
            String categoriaActual = categoria;
            double cantidadActual = cantidad;

            return CupertinoAlertDialog(
              title: Text(ahorro == null
                  ? 'Nuevo Movimiento'
                  : 'Actualizar Movimiento'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tipoMovimiento == 'gasto')
                    CupertinoTextField(
                      placeholder: 'Descripción (opcional)',
                      onChanged: (valor) => categoriaActual = valor,
                      controller: TextEditingController(text: categoriaActual),
                    ),
                  if (tipoMovimiento == 'gasto') const SizedBox(height: 10),
                  CupertinoTextField(
                    placeholder: 'Cantidad',
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    onChanged: (valor) {
                      final parsed = double.tryParse(valor);
                      if (parsed == null) {
                        cantidadError.value = 'Introduce un número válido.';
                      } else {
                        cantidadActual = parsed;
                        cantidadError.value = null;
                      }
                    },
                    controller:
                        TextEditingController(text: cantidadActual.toString()),
                  ),
                  ValueListenableBuilder<String?>(
                    valueListenable: cantidadError,
                    builder: (context, error, _) {
                      return error != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                error,
                                style: const TextStyle(
                                    color: CupertinoColors.destructiveRed),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 10),
                  Text('Tipo: $tipoMovimiento'),
                  const SizedBox(height: 10),
                  CupertinoButton(
                    child: Text(
                      _fechaLimiteTexto(fechaRegistro),
                    ),
                    onPressed: () {
                      _mostrarSelectorFecha(
                          contextoDialogo, fechaRegistro, actualizarEstado,
                          (DateTime nuevaFecha) {
                        fechaRegistro = nuevaFecha;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.pop(contextoDialogo),
                ),
                CupertinoDialogAction(
                  child: Text(ahorro == null
                      ? 'Agregar Movimiento'
                      : 'Actualizar Movimiento'),
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
                    } else {
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
    return 'Seleccionar Fecha: ${DateFormat('dd/MM/yyyy').format(fecha.toLocal())}';
  }

  static void _mostrarSelectorFecha(
    BuildContext contextoDialogo,
    DateTime fechaInicial,
    StateSetter actualizarEstado,
    ValueChanged<DateTime> onFechaSeleccionada,
  ) {
    showCupertinoModalPopup(
      context: contextoDialogo,
      builder: (BuildContext builder) {
        final brightness = CupertinoTheme.of(contextoDialogo).brightness;

        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: brightness,
          ),
          child: Container(
            height: MediaQuery.of(contextoDialogo).size.height * 0.25,
            color:
                CupertinoColors.systemBackground.resolveFrom(contextoDialogo),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: fechaInicial,
              onDateTimeChanged: (DateTime nuevaFecha) {
                actualizarEstado(() {
                  onFechaSeleccionada(nuevaFecha);
                });
              },
            ),
          ),
        );
      },
    );
  }
}
