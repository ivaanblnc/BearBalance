import 'package:supabase_flutter/supabase_flutter.dart';

// Clase para manejar la lógica de registro de usuarios
class RegistroModelo {
  // Inicializa el cliente de Supabase
  final SupabaseClient _supabase = Supabase.instance.client;

  // Método para registrar un nuevo usuario
  Future<void> registrarUsuario(
    String nombre,
    String apellidos,
    String correoElectronico,
    String nombreUsuario,
    String contrasena,
  ) async {
    try {
      // Verifica si el correo electrónico o el nombre de usuario ya existen
      final existeCorreo = await _supabase
          .from('usuarios')
          .select()
          .eq('correo_electronico', correoElectronico)
          .maybeSingle();

      final existeNombreUsuario = await _supabase
          .from('usuarios')
          .select()
          .eq('nombre_usuario', nombreUsuario)
          .maybeSingle();

      if (existeCorreo != null) {
        throw Exception("El correo electrónico ya existe.");
      }

      if (existeNombreUsuario != null) {
        throw Exception("El nombre de usuario ya existe.");
      }

      final respuestaSignUp = await _supabase.auth.signUp(
        email: correoElectronico,
        password: contrasena,
      );

      if (respuestaSignUp.user == null) {
        throw Exception("Error al registrar usuario en autenticación.");
      }

      await _supabase.from('usuarios').insert({
        'id': respuestaSignUp.user!.id,
        'nombre': nombre,
        'apellidos': apellidos,
        'correo_electronico': correoElectronico,
        'nombre_usuario': nombreUsuario,
        'contrasena': contrasena,
      });
    } on AuthException catch (e) {
      throw Exception("Error de autenticación: ${e.message}");
    } catch (e) {
      rethrow;
    }
  }
}
