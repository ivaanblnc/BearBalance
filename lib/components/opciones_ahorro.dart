import 'package:flutter/material.dart'; // Cambiado de cupertino a material
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
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.visibility_outlined, color: theme.colorScheme.secondary),
                title: const Text('Ver Detalles'),
                onTap: () {
                  Navigator.pop(context); // Cierra el bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute( // Usar MaterialPageRoute
                      builder: (context) => DetalleAhorroVista(ahorro: ahorro),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.edit_outlined, color: theme.colorScheme.primary),
                title: const Text('Actualizar'),
                onTap: () {
                  Navigator.pop(context); // Cierra el bottom sheet
                  // TODO: Reemplazar CupertinoAhorroDialogo con un diálogo/pantalla Material
                  // TODO: Revisar si el parámetro 'controlador' aquí es adecuado para 'FormularioMovimientoDialogo.mostrarDialogo'
                  // El segundo parámetro de 'mostrarCupertinoDialogo' era 'estadoVista' y se eliminó en la nueva firma.
                  // 'controlador' (AhorrosControlador) podría no ser el argumento esperado si 'estadoVista' tenía otro propósito.
                  // Por ahora, se asume que cargarAhorros y ahorro son los correctos.
                  FormularioMovimientoDialogo.mostrarDialogo(
                    context,
                    // estadoVista, // Este parámetro fue eliminado de la firma de mostrarDialogo
                    cargarAhorros,
                    ahorro: ahorro,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                title: Text('Eliminar', style: TextStyle(color: theme.colorScheme.error)),
                onTap: () async {
                  Navigator.pop(context); // Cierra el bottom sheet
                  // TODO: Reemplazar EliminarAhorroDialog con un diálogo Material
                  // Por ahora, mantenemos la llamada original.
                  await EliminarAhorroDialog.mostrarDialogoEliminar(
                    context,
                    ahorro['id'],
                    cargarAhorros,
                  );
                },
              ),
              // ListTile para Cancelar (opcional, ya que se puede deslizar)
              // const Divider(),
              // ListTile(
              //   leading: Icon(Icons.cancel_outlined, color: Colors.grey),
              //   title: const Text('Cancelar'),
              //   onTap: () {
              //     Navigator.pop(context); // Cierra el bottom sheet
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

}
