import 'package:flutter/cupertino.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';

class EliminarAhorroDialog {
  static Future<void> mostrarDialogoEliminar(
    BuildContext context,
    int idAhorro,
    Future<void> Function() cargarDatos,
  ) async {
    final AhorrosControlador controladorAhorros = AhorrosControlador();

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('¿Eliminar Movimiento?'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar este movimiento?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Eliminar',
                  style: TextStyle(color: CupertinoColors.destructiveRed)),
              onPressed: () async {
                await controladorAhorros.eliminarAhorro(idAhorro);
                await cargarDatos();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
