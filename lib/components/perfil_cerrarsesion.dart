import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/controllers/perfilControlador.dart';

class PerfilCerrarSesion extends StatelessWidget {
  final PerfilControlador controlador;
  final BuildContext context;

  const PerfilCerrarSesion({
    super.key,
    required this.controlador,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => controlador.cerrarSesion(context),
      child: Text(
        "Cerrar Sesión", 
        style: TextStyle(color: Theme.of(context).colorScheme.error)
      ),
    );
  }
}
