import 'package:flutter/cupertino.dart';
import 'package:tfg_ivandelllanoblanco/components/eliminar_ahorro.dart';
import 'package:tfg_ivandelllanoblanco/components/modificar_ahorro.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:tfg_ivandelllanoblanco/views/detallesAhorro.dart';

class OpcionesAhorroDialog {
  static void mostrarOpcionesAhorro(
    BuildContext context,
    Map<String, dynamic> ahorro,
    AhorrosControlador controlador,
    Future<void> Function() cargarAhorros,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Opciones de Movimiento'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: const Text('Ver Detalles'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => DetalleAhorroVista(ahorro: ahorro),
                  ),
                );
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Actualizar'),
              onPressed: () {
                Navigator.pop(context);
                CupertinoAhorroDialogo.mostrarCupertinoDialogo(
                  context,
                  controlador,
                  cargarAhorros,
                  ahorro: ahorro,
                );
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Eliminar',
                  style: TextStyle(color: CupertinoColors.destructiveRed)),
              onPressed: () async {
                Navigator.pop(context);
                await EliminarAhorroDialog.mostrarDialogoEliminar(
                  context,
                  ahorro['id'],
                  cargarAhorros,
                );
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
        );
      },
    );
  }
}
