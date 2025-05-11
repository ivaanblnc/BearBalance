import 'package:flutter/cupertino.dart';
import '../views/metas.dart';
import '../controllers/metascontrollador.dart';

class CupertinoMetaDialog {
  static void mostrarCupertinoDialog(
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

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return CupertinoAlertDialog(
              title: Text(meta == null ? 'Nueva Meta' : 'Actualizar Meta'),
              content: Column(
                children: [
                  CupertinoTextField(
                    placeholder: 'Nombre de la Meta',
                    onChanged: (valor) => nombreMeta = valor,
                    controller: TextEditingController(text: nombreMeta),
                  ),
                  SizedBox(height: 10),
                  CupertinoTextField(
                    placeholder: 'Cantidad Ahorrada',
                    keyboardType: TextInputType.number,
                    onChanged: (valor) =>
                        cantidadAhorrada = double.tryParse(valor) ?? 0.0,
                    controller: TextEditingController(
                        text: cantidadAhorrada.toString()),
                  ),
                  SizedBox(height: 10),
                  CupertinoTextField(
                    placeholder: 'Cantidad Objetivo',
                    keyboardType: TextInputType.number,
                    onChanged: (valor) =>
                        cantidadObjetivo = double.tryParse(valor) ?? 0.0,
                    controller: TextEditingController(
                        text: cantidadObjetivo.toString()),
                  ),
                  SizedBox(height: 10),
                  CupertinoButton(
                    child: Text(
                        'Seleccionar Fecha: ${fechaMeta.toLocal().day}/${fechaMeta.toLocal().month}/${fechaMeta.toLocal().year}'),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext builder) {
                          final brightness =
                              CupertinoTheme.of(context).brightness;

                          return CupertinoTheme(
                            data: CupertinoThemeData(
                              brightness: brightness,
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              color: CupertinoColors.systemBackground
                                  .resolveFrom(context),
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: fechaMeta,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() {
                                    fechaMeta = newDate;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: Text(meta == null ? 'Agregar' : 'Actualizar'),
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
                    Navigator.pop(context);
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
