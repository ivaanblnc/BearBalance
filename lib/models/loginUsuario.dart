// loginUsuario.dart (Modelo)
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class InicioSesionModelo {
  final SupabaseClient _supabase = Supabase.instance.client;

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
      final respuesta = await _supabase.from('usuarios').insert(datosUsuario);

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
}
