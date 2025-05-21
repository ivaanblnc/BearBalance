import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';

class SelectorFechaDialogo {
  static Future<DateTime?> mostrarDialogoFecha(
      BuildContext context, AhorrosControlador ahorro) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return fechaSeleccionada;
  }
}
