import 'package:supabase_flutter/supabase_flutter.dart';

// Clase para manejar la lógica de registro de usuarios
class RegistroModelo {
  // Inicializa el cliente de Supabase
  final SupabaseClient _supabase = Supabase.instance.client;

  // Metodo para registrar un nuevo usuario
  Future<void> registrarUsuario(
    String nombre,
    String apellidos,
    String correoElectronico,
    String nombreUsuario,
    String contrasena,
  ) async {
    try {
      // Verifica si el nombre de usuario ya existe
      final existeNombreUsuario = await _supabase
          .from('usuarios')
          .select()
          .eq('nombre_usuario', nombreUsuario)
          .maybeSingle();

      if (existeNombreUsuario != null) {
        throw Exception("El nombre de usuario ya existe.");
      }

      // Llamamos a Supabase Auth para registrar al usuario
      final respuestaSignUp = await _supabase.auth.signUp(
        email: correoElectronico,
        password: contrasena,
      );

      if (respuestaSignUp.user == null) {
        throw Exception("Error al registrar usuario en autenticación.");
      }

      // Insertamos los datos adicionales en la tabla 'usuarios'
      await _supabase.from('usuarios').insert({
        'id': respuestaSignUp.user!.id,
        'nombre': nombre,
        'apellidos': apellidos,
        'nombre_usuario': nombreUsuario,
      });
    } on AuthException catch (e) {
      throw Exception("Error de autenticación: ${e.message}");
    } catch (e) {
      rethrow;
    }
  }
}
