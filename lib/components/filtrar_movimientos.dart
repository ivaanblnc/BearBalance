import 'package:flutter/material.dart'; // Cambiado de cupertino a material
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';

class SelectorFechaDialogo {
  static Future<DateTime?> mostrarDialogoFecha(
      BuildContext context, AhorrosControlador ahorro) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // O la fecha actual del filtro si existe
      firstDate: DateTime(2000), // Rango de fechas seleccionables
      lastDate: DateTime(2101),
      // Puedes añadir `builder` aquí para personalizar el tema del DatePicker si es necesario
      // builder: (BuildContext context, Widget? child) {
      //   return Theme(
      //     data: ThemeData.light().copyWith(
      //       // Personalizaciones de color, etc.
      //     ),
      //     child: child!,
      //   );
      // },
    );
    return fechaSeleccionada;
  }
}

