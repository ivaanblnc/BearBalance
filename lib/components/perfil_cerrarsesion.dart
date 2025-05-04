import 'package:flutter/cupertino.dart';
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
    return CupertinoButton(
      onPressed: () => controlador.cerrarSesion(context),
      child: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
    );
  }
}
