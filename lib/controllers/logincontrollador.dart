import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_ivandelllanoblanco/views/paginaInicio.dart';
import 'package:tfg_ivandelllanoblanco/models/loginUsuario.dart';

//Clase para gestionar el inicio de sesion de los usuarios
class LoginControlador {
  final InicioSesionModelo modelo = InicioSesionModelo();
  String nombreUsuario = "";

//Metodo para iniciar sesion con el correo y contraseña
  Future<bool> iniciarSesion(
      String correoElectronico, String contrasena, BuildContext context) async {
    try {
      final respuesta = await modelo.loginUser(correoElectronico, contrasena);
      //Si la sesion no es null, significa que se inicio sesion correctamente
      if (respuesta.session != null) {
        //Obtenemos el id del usuario y el nombre de usuario
        //y lo guardamos en la variable nombreUsuario
        final usuarioId = respuesta.user!.id;
        final datosUsuario = await modelo.obtenerNombreUsuario(usuarioId);
        nombreUsuario = datosUsuario?['nombre_usuario'] as String;

        //Navegamos a la pagina de inicio de la app
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          CupertinoPageRoute(
            builder: (context) => PaginaInicioVista(nombreUsuario),
          ),
        );
        return true;
      } else {
        // ignore: use_build_context_synchronously
        mostrarError(context, "Correo electrónico o contraseña incorrectos");
        return false;
      }
      //Manejamos las posibles excepciones
    } on AuthException catch (e) {
      // ignore: use_build_context_synchronously
      mostrarError(context, e.message);
      return false;
    } catch (e) {
      // ignore: use_build_context_synchronously
      mostrarError(context, "Error al iniciar sesión: ${e.toString()}");
      return false;
    }
  }

  //Metodo para iniciar sesion con el OAUHT de Google
  Future<void> loginConGoogle(BuildContext context) async {
    print("Botón de Google presionado");
    final respuesta = await modelo.loginConGoogle();
    //Si la respuesta no es null, significa que se inicio correctamente
    if (respuesta) {
      //Añadimos un listener para escuchar cualquier cambio de estado de la sesion
      await Supabase.instance.client.auth.onAuthStateChange
          .firstWhere((data) => data.session != null)
          .then((data) async {
        //Obtenemos los datos del usuario de su cuenta
        final session = data.session!;
        final user = session.user;
        final id = user.id;
        final nombre = user.userMetadata?["full_name"] ?? "Usuario";
        final imagen = user.userMetadata?["avatar_url"] ?? "";
        final correo = user.email;
        String nuevoNombreUsuario = "nuevousuario${Random().nextInt(99999)}";

        print(
            "Datos obtenidos del usuario: nombre: $nombre, correo: $correo, imagen: $imagen, id: $id");

        try {
          final respuesta = await modelo.obtenerNombreUsuario(id);
          //Comprobamos que el usuario no exista ya en la base de datos
          if (respuesta == null || respuesta.isEmpty) {
            print("El usuario no existe");
            //Insertamos el nuevo usuario en la base de datos
            await modelo.insertarUsuario({
              'id': id,
              'nombre_usuario': nuevoNombreUsuario,
              'nombre': nombre,
              'apellidos': nombre,
              'correo_electronico': correo,
              'imagen_perfil': imagen,
              'contrasena': 'oauth_login'
            });
            print("Usuario insertado correctamente");
            nombreUsuario = nuevoNombreUsuario;
          } else {
            print("El usuario ya existe en la base de datos");
            nombreUsuario = respuesta['nombre_usuario'] as String;
          }
          //Si el widget sigue activo
          if (context.mounted) {
            //Navegamos a la pagina de inicio de la app
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => PaginaInicioVista(nombreUsuario),
              ),
            );
          }
        } catch (error) {
          // ignore: use_build_context_synchronously
          mostrarError(context, "Error al verificar o registrar el usuario");
        }
      });
    } else {
      mostrarError(
          // ignore: use_build_context_synchronously
          context,
          "No se pudo iniciar el inicio de sesión con Google");
    }
  }

  //Metodo para mostrar un mensaje de error
  void mostrarError(BuildContext context, String mensaje) {
    showCupertinoDialog(
      context: context,
      builder: (builder) {
        return CupertinoAlertDialog(
          title: const Text("Error"),
          content: Text(mensaje),
          actions: [
            CupertinoDialogAction(
              child: const Text("Aceptar"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

//Metodo para obtener el nombre de usuario
  String getNomreUsuario() {
    return nombreUsuario;
  }
}
