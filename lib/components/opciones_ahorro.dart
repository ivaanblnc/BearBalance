import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Opciones de Movimiento',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.visibility_outlined,
                    color: theme.colorScheme.secondary),
                title: const Text('Ver Detalles'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleAhorroVista(ahorro: ahorro),
                    ),
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.edit_outlined, color: theme.colorScheme.primary),
                title: const Text('Actualizar'),
                onTap: () {
                  Navigator.pop(context);

                  FormularioMovimientoDialogo.mostrarDialogo(
                    context,
                    cargarAhorros,
                    ahorro: ahorro,
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.delete_outline, color: theme.colorScheme.error),
                title: Text('Eliminar',
                    style: TextStyle(color: theme.colorScheme.error)),
                onTap: () async {
                  Navigator.pop(context);
                  await EliminarAhorroDialog.mostrarDialogoEliminar(
                    context,
                    ahorro['id'],
                    cargarAhorros,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
