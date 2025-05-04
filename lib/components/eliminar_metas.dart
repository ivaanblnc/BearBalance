import 'package:flutter/cupertino.dart';
import '../views/metas.dart';
import '../controllers/metascontrollador.dart';

class EliminarMetaDialog {
  static void eliminarItemMeta(
    BuildContext context,
    int id,
    MetasViewState vistaMetas,
    MetasControlador controlador,
    VoidCallback cargarMetas,
  ) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Eliminar Meta"),
        content: const Text("¿Seguro que quieres eliminar esta meta?"),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              controlador.eliminarMeta(id, cargarMetas);
              cargarMetas();
              Navigator.pop(context);
            },
            isDestructiveAction: true,
            child: const Text("Eliminar"),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }
}
