import 'package:flutter/material.dart';
import '../views/metas.dart';
import '../controllers/metascontrollador.dart';

class ModificarMetasDialog {
  static void mostrarDialogo(
    BuildContext context,
    MetasViewState metasView,
    MetasControlador controller,
    VoidCallback cargarMetas, {
    Map<String, dynamic>? meta,
  }) {
    String nombreMeta = meta?['titulo'] ?? '';
    double cantidadAhorrada = meta?['cantidad_ahorrada']?.toDouble() ?? 0.0;
    double cantidadObjetivo = meta?['cantidad_objetivo']?.toDouble() ?? 0.0;
    DateTime fechaMeta =
        meta != null ? DateTime.parse(meta['fecha_limite']) : DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(meta == null ? 'Nueva Meta' : 'Actualizar Meta'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration:
                          InputDecoration(labelText: 'Nombre de la Meta'),
                      onChanged: (valor) => nombreMeta = valor,
                      controller: TextEditingController(text: nombreMeta),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration:
                          InputDecoration(labelText: 'Cantidad Ahorrada'),
                      keyboardType: TextInputType.number,
                      onChanged: (valor) =>
                          cantidadAhorrada = double.tryParse(valor) ?? 0.0,
                      controller: TextEditingController(
                          text: cantidadAhorrada.toStringAsFixed(2)),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration:
                          InputDecoration(labelText: 'Cantidad Objetivo'),
                      keyboardType: TextInputType.number,
                      onChanged: (valor) =>
                          cantidadObjetivo = double.tryParse(valor) ?? 0.0,
                      controller: TextEditingController(
                          text: cantidadObjetivo.toStringAsFixed(2)),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                              'Fecha Límite: ${fechaMeta.day}/${fechaMeta.month}/${fechaMeta.year}'),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: fechaMeta,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != fechaMeta) {
                              setState(() {
                                fechaMeta = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(meta == null ? 'Crear' : 'Actualizar'),
                  onPressed: () {
                    if (nombreMeta.isNotEmpty && cantidadObjetivo > 0) {
                      if (meta == null) {
                        controller.agregarMeta(
                          nombreMeta,
                          cantidadAhorrada,
                          cantidadObjetivo,
                          fechaMeta.toIso8601String(),
                          cargarMetas,
                        );
                      } else {
                        controller.actualizarMeta(
                          meta['id'],
                          nombreMeta,
                          cantidadAhorrada,
                          cantidadObjetivo,
                          fechaMeta.toIso8601String(),
                          cargarMetas,
                        );
                      }
                      cargarMetas();
                    }
                    Navigator.of(context).pop();
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
