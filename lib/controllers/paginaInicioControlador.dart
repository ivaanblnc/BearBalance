import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/models/paginaInicio.dart';
import 'package:tfg_ivandelllanoblanco/views/perfilUsuario.dart';

// Clase para hacer el llamado a la clase logica de la página de inicio
class PaginaInicioControlador {
  // Instancia de la clase PaginaInicioModel
  final PaginaInicioModelo modelo = PaginaInicioModelo();
  final String nombreUsuario;

  PaginaInicioControlador(this.nombreUsuario);

  //Metodo para obtener los datos del usuario
  Future<Map<String, dynamic>?> obtenerDatosUsuario(String userId) async {
    try {
      return modelo.obtenerDatosUsuarioPorId(userId);
    } catch (e) {
      print('Error en el controlador: $e');
      return null;
    }
  }

  //Metodo para navegar a la vista del perfil de usuario
  void navegarAPerfil(BuildContext context) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PerfilVista(),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Error al obtener datos del usuario.'),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
