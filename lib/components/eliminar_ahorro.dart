import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';

class EliminarAhorroDialog {
  static Future<void> mostrarDialogoEliminar(
    BuildContext context,
    int idAhorro,
    Future<void> Function() cargarDatos,
  ) async {
    final AhorrosControlador controladorAhorros = AhorrosControlador();

    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Eliminar Movimiento?'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar este movimiento? Esta acción no se puede deshacer.'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error),
              child: const Text('Eliminar'),
              onPressed: () async {
                try {
                  await controladorAhorros.eliminarAhorro(idAhorro);
                  await cargarDatos();
                  if (context.mounted) Navigator.of(context).pop();
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Error al eliminar: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
