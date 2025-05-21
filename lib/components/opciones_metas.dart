import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/views/metas.dart';

class OpcionesMetaDialog {
  static void mostrarOpcionesMeta(BuildContext context,
      Map<String, dynamic> meta, MetasViewState metasView) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Opciones de Meta',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Actualizar'),
                onTap: () {
                  Navigator.pop(context);
                  metasView.mostrarDialogoCrearModificarMeta(context,
                      meta: meta);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.error),
                title: Text('Eliminar',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
                onTap: () {
                  Navigator.pop(context);
                  metasView.eliminarItemMeta(meta['id']);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancelar'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
