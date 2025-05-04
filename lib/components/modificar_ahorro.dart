import 'package:flutter/cupertino.dart';
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

    showCupertinoDialog(
      context: contexto,
      builder: (contextoDialogo) {
        return StatefulBuilder(
          builder:
              (BuildContext contextoBuilder, StateSetter actualizarEstado) {
            String categoriaActual = categoria;

            return CupertinoAlertDialog(
              title: Text(ahorro == null
                  ? 'Nuevo Movimiento'
                  : 'Actualizar Movimiento'),
              content: Column(
                children: [
                  if (tipoMovimiento == 'gasto')
                    CupertinoTextField(
                      placeholder: 'Categoría',
                      onChanged: (valor) => categoriaActual = valor,
                      controller: TextEditingController(text: categoriaActual),
                    ),
                  if (tipoMovimiento == 'gasto') const SizedBox(height: 10),
                  CupertinoTextField(
                    placeholder: 'Cantidad',
                    keyboardType: TextInputType.number,
                    onChanged: (valor) =>
                        cantidad = double.tryParse(valor) ?? 0.0,
                    controller:
                        TextEditingController(text: cantidad.toString()),
                  ),
                  const SizedBox(height: 10),
                  Text('Tipo: $tipoMovimiento'),
                  const SizedBox(height: 10),
                  CupertinoButton(
                    child: Text(
                        'Seleccionar Fecha: ${DateFormat('dd/MM/yyyy').format(fechaRegistro.toLocal())}'),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: contextoDialogo,
                        builder: (BuildContext builder) {
                          return Container(
                            height: MediaQuery.of(contextoDialogo)
                                    .copyWith()
                                    .size
                                    .height *
                                0.25,
                            color: CupertinoColors.white,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: fechaRegistro,
                              onDateTimeChanged: (DateTime nuevaFecha) {
                                actualizarEstado(() {
                                  fechaRegistro = nuevaFecha;
                                });
                              },
                            ),
                          );
                        },
                      );
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
                    final String? categoriaParaGuardar =
                        tipoMovimiento == 'ingreso'
                            ? null
                            : categoriaActual.isNotEmpty
                                ? categoriaActual
                                : categoriaOriginal ?? '';

                    print(
                        'Valor de categoria antes de la validación: "$categoriaParaGuardar"');

                    if (cantidad >= 0 &&
                        (tipoMovimiento == 'ingreso' ||
                            (tipoMovimiento == 'gasto' &&
                                categoriaParaGuardar!.isNotEmpty))) {
                      try {
                        print('ID del ahorro a actualizar: ${ahorro?['id']}');
                        print(
                            'Datos del ahorro a actualizar: {categoria: $categoriaParaGuardar, cantidad: $cantidad, fecha_registro: ${fechaRegistro.toIso8601String()}, tipo: $tipoMovimiento}'); // Depuración

                        if (ahorro == null) {
                          await AhorrosControlador().agregarAhorro({
                            'categoria': categoriaParaGuardar,
                            'cantidad': cantidad,
                            'fecha_registro': fechaRegistro.toIso8601String(),
                            'tipo': tipoMovimiento,
                          });
                        } else {
                          await AhorrosControlador()
                              .actualizarAhorro(ahorro['id'], {
                            'categoria': categoriaParaGuardar,
                            'cantidad': cantidad,
                            'fecha_registro': fechaRegistro.toIso8601String(),
                            'tipo': tipoMovimiento,
                          });
                        }
                        cargarAhorros();
                        Navigator.pop(contextoDialogo);
                      } catch (e) {
                        print('Error al actualizar: $e');
                      }
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
}
