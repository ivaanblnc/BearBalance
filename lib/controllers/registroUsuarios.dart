import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_ivandelllanoblanco/models/usuarios.dart';
import 'package:tfg_ivandelllanoblanco/views/InicioDeSesion.dart';

class RegistroControlador {
  final RegistroModelo modelo = RegistroModelo();

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
      showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text("Enhorabuena"),
            content: const Text("Usuario registrado correctamente"),
            actions: [
              TextButton(
                child: const Text("Aceptar"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const InicioSesion()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    } on AuthException catch (e) {
      String mensajeError = "Error al registrar usuario.";
      if (e.message
          .contains('duplicate key value violates unique constraint')) {
        if (e.message.contains('users_email_key')) {
          mensajeError = "El correo electrónico ya está registrado.";
        } else if (e.message.contains('users_username_key')) {
          mensajeError = "El nombre de usuario ya existe.";
        }
      } else if (e.message.contains('User already registered')) {
        mensajeError = "El usuario ya está registrado.";
      } else if (e.message.contains('invalid email') ||
          e.message.contains('Unable to validate email address')) {
        mensajeError = "El correo electrónico no es válido.";
      } else if (e.message
          .contains('Password should be at least 6 characters')) {
        mensajeError = "La contraseña debe tener al menos 6 caracteres.";
      } else if (e.message.contains('empty email') ||
          e.message.contains('empty password')) {
        mensajeError =
            "Por favor, introduce el correo electrónico y la contraseña.";
      } else if (e.message.contains('Anonymous sign-ins are disabled')) {
        mensajeError = "El registro anónimo está deshabilitado.";
      }
      _mostrarErrorDialog(context, mensajeError);
    } catch (e) {
      String mensajeError =
          "Ocurrió un error inesperado durante el registro: ${e.toString()}";
      if (e.toString().contains('Anonymous sign-ins are disabled')) {
        mensajeError = "El registro anónimo está deshabilitado.";
      }
      _mostrarErrorDialog(context, mensajeError);
    }
  }

  void _mostrarErrorDialog(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: const Text("Aceptar"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
