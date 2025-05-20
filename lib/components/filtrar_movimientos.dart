import 'package:flutter/cupertino.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';

class SelectorFechaDialogo {
  static Future<DateTime?> mostrarDialogoFecha(
      BuildContext context, AhorrosControlador ahorro) async {
    DateTime fechaSeleccionada = DateTime.now();

    return showCupertinoDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Seleccionar Fecha'),
          content: SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: fechaSeleccionada,
              onDateTimeChanged: (DateTime newDate) {
                fechaSeleccionada = newDate;
              },
            ),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(fechaSeleccionada);
              },
            ),
          ],
        );
      },
    );
  }
}
