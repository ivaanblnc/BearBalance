import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // For CupertinoColors
import '../controllers/metascontrollador.dart';

class EliminarMetaDialog {
  static void eliminarItemMeta(
    BuildContext context,
    int id,
    MetasControlador controlador,
    VoidCallback cargarMetas,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Eliminar Meta"),
        content: const Text("¿Seguro que quieres eliminar esta meta?"),
        actions: [
          TextButton(
            onPressed: () {
              controlador.eliminarMeta(id, cargarMetas);
              // cargarMetas(); // This is already called within controlador.eliminarMeta via the callback
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: CupertinoColors.activeBlue,
            ),
            child: const Text("Eliminar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }
}
