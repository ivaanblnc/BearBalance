import 'package:flutter/cupertino.dart';
import 'package:tfg_ivandelllanoblanco/views/metas.dart';

class OpcionesMetaDialog {
  static void mostrarOpcionesMeta(BuildContext context,
      Map<String, dynamic> meta, MetasViewState metasView) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Opciones de Meta'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: const Text('Actualizar'),
              onPressed: () {
                Navigator.pop(context);
                metasView.mostrarDialogoCrearModificarMeta(context, meta: meta);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Eliminar',
                  style: TextStyle(color: CupertinoColors.destructiveRed)),
              onPressed: () {
                Navigator.pop(context);
                metasView.eliminarItemMeta(meta['id']);
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
