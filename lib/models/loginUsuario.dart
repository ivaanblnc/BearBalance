import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class InicioSesionModelo {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool esUsuarioGoogle() {
    final user = _supabase.auth.currentUser;
    return user?.appMetadata['provider'] == 'google';
  }

  //Metodo para iniciar sesion con el OAUHT de email
  Future<AuthResponse> loginUser(
      String correoElectronico, String contrasena) async {
    try {
      final respuesta = await _supabase.auth.signInWithPassword(
        email: correoElectronico,
        password: contrasena,
      );
      return respuesta;
    } catch (e) {
      print("Error en loginUser: ${e.toString()}");
      rethrow;
    }
  }

  //Metodo para obtener el nombre de usuario por su ID
  Future<Map<String, dynamic>?> obtenerNombreUsuario(String userId) async {
    try {
      final respuesta = await _supabase
          .from('usuarios')
          .select('nombre_usuario')
          .eq('id', userId)
          .maybeSingle();
      print("nombre de usuario: $respuesta");
      return respuesta;
    } catch (e) {
      return null;
    }
  }

  //Metodo para insertar un nuevo usuario en la base de datos
  Future<void> insertarUsuario(Map<String, dynamic> datosUsuario) async {
    try {
      final datosSinContrasena = Map<String, dynamic>.from(datosUsuario);
      datosSinContrasena.remove('contrasena');

      final respuesta =
          await _supabase.from('usuarios').insert(datosSinContrasena);

      if (respuesta.data == null || (respuesta.data as List).isEmpty) {
        throw Exception('Error al insertar el usuario: respuesta vacía');
      }
      print("Usuario insertado correctamente");
    } catch (e) {
      print("Error en insertarUsuario: ${e.toString()}");
      rethrow;
    }
  }

  //Metodo para iniciar sesion con el OAUHT de Google
  Future<bool> loginConGoogle() async {
    String redireccion;
    //Si estamos en web redirigimos a localhost
    if (kIsWeb) {
      redireccion = 'http://localhost:5000/auth/callback';
      //Si estamos en movil redirigimos a una url personalizada
    } else {
      redireccion = 'miapp://login-callback';
    }

    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redireccion,
      );
      print("Redirección iniciada correctamente");
      return true;
    } catch (e) {
      print("Error en loginConGoogle");
      return false;
    }
  }

  // Método para cambiar la contraseña del usuario autenticado
  Future<void> cambiarContrasena(String nuevaContrasena) async {
    try {
      final usuario = _supabase.auth.currentUser;
      if (usuario == null) {
        throw Exception('No hay usuario autenticado');
      }
      // Si el usuario es de Google, no puede cambiar la contraseña
      if (usuario.appMetadata['provider'] == 'google') {
        throw Exception('No puedes cambiar la contraseña de una cuenta de Google.');
      }
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: nuevaContrasena),
      );
      if (response.user == null) {
        throw Exception('No se pudo actualizar la contraseña. Vuelve a iniciar sesión e inténtalo de nuevo.');
      }
      print("Contraseña actualizada correctamente");
    } catch (e) {
      print("Error al cambiar la contraseña: \x1B[31m${e.toString()}\x1B[0m");
      rethrow;
    }
  }

  // Método para cambiar el email del usuario autenticado
  Future<void> cambiarEmail(String nuevoEmail) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado.');
      }
      // Si el usuario es de Google, no puede cambiar el email
      if (user.appMetadata['provider'] == 'google') {
        throw Exception('No puedes cambiar el correo electrónico de una cuenta de Google.');
      }
      final response = await _supabase.auth.updateUser(
        UserAttributes(email: nuevoEmail),
      );
      if (response.user == null) {
        throw Exception('No se pudo actualizar el correo electrónico. Vuelve a iniciar sesión e inténtalo de nuevo.');
      }
      print("Solicitud de cambio de correo electrónico procesada. Si es necesario, revisa tu bandeja de entrada para confirmar el cambio.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
