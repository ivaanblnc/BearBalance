import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_ivandelllanoblanco/models/usuarios.dart';

// Clase para gestionar el registro de usuarios
class RegistroControlador {
  final RegistroModelo modelo = RegistroModelo();

  //Método para registrar un nuevo usuario
  Future<void> registrarUsuario(
      String nombre,
      String apellidos,
      String correoElectronico,
      String nombreUsuario,
      String contrasena,
      BuildContext context) async {
    try {
      await modelo.registrarUsuario(
          nombre, apellidos, correoElectronico, nombreUsuario, contrasena);
      showCupertinoDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: Text("Enhorabuena"),
            content: Text("Usuario registrado correctamente"),
            actions: [
              CupertinoDialogAction(
                child: Text("Aceptar"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    } on AuthException catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: Text("Error"),
            content: Text("Error al registrar usuario: ${e.message}"),
            actions: [
              CupertinoDialogAction(
                child: Text("Aceptar"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showCupertinoDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (builder) {
          return CupertinoAlertDialog(
            title: Text("Error"),
            content: Text("Error al registrar usuario: $e"),
            actions: [
              CupertinoDialogAction(
                child: Text("Aceptar"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }
}
