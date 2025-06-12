import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class PerfilModelo {
  final _supabase = Supabase.instance.client;

  // Método para obtener los datos del usuario
  Future<Map<String, dynamic>?> obtenerDatosUsuario() async {
    try {
      // Obtenemos el usuario actual y comprobamos si es nulo
      final usuarioActual = _supabase.auth.currentUser;
      if (usuarioActual == null) {
        return null;
      }
      // Obtenemos los datos del usuario de la base de datos
      final respuesta = await _supabase
          .from('usuarios')
          .select('*')
          .eq('id', usuarioActual.id)
          .maybeSingle();

      return respuesta;
    } catch (e) {
      return null;
    }
  }

  // Método para obtener los nombres de usuario registrados
  Future<List<Map<String, dynamic>>?> obtenerNombresUsuario() async {
    try {
      final respuesta = await _supabase
          .from('usuarios')
          .select('nombre_usuario') as List<dynamic>;

      return respuesta.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  // Método para verificar si un nombre de usuario ya existe
  Future<bool> nombreUsuarioExiste(String nombreUsuario) async {
    try {
      final respuesta = await _supabase
          .from('usuarios')
          .select('id')
          .eq('nombre_usuario', nombreUsuario)
          .maybeSingle();

      // Si encontramos algún resultado, el nombre de usuario ya existe
      return respuesta != null;
    } catch (e) {
      print('Error al verificar nombre de usuario: $e');
      // En caso de error, asumimos que el nombre podría existir para evitar conflictos
      return true;
    }
  }

  // Método para actualizar los datos del usuario
  Future<Map<String, dynamic>> actualizarDatosUsuario(
      Map<String, dynamic> datosActualizados) async {
    try {
      // Obtenemos el usuario actual y comprobamos si es nulo
      final usuarioActual = _supabase.auth.currentUser;
      if (usuarioActual == null) {
        return {'success': false, 'message': 'Usuario no autenticado'};
      }

      // Verificamos si se está actualizando el nombre de usuario
      if (datosActualizados.containsKey('nombre_usuario')) {
        String nuevoNombreUsuario = datosActualizados['nombre_usuario'];

        // Obtenemos los datos actuales del usuario para comparar
        final usuarioActualDatos = await obtenerDatosUsuario();
        if (usuarioActualDatos != null &&
            usuarioActualDatos['nombre_usuario'] != nuevoNombreUsuario) {
          // Verificamos si el nuevo nombre de usuario ya existe
          bool existe = await nombreUsuarioExiste(nuevoNombreUsuario);
          if (existe) {
            return {
              'success': false,
              'message': 'El nombre de usuario ya existe'
            };
          }
        }
      }

      // Actualizamos los datos del usuario en la base de datos
      await _supabase
          .from('usuarios')
          .update(datosActualizados)
          .eq('id', usuarioActual.id);

      // Almacenamos los nuevos datos actualizados
      final usuarioActualizado = await _supabase
          .from('usuarios')
          .select('*')
          .eq('id', usuarioActual.id)
          .maybeSingle();

      return {'success': true, 'data': usuarioActualizado};
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al actualizar: ${e.toString()}'
      };
    }
  }

  // Método para cerrar la sesión del usuario en Supabase
  Future<void> cerrarSesion() async {
    try {
      await _supabase.auth.signOut();
      print("Sesión cerrada en Supabase");
    } catch (e) {
      print('Error al cerrar sesión: $e');
      rethrow;
    }
  }

  // Método para subir la imagen a Supabase Storage
  Future<String?> subirImagen(dynamic imagen) async {
    try {
      if (imagen is! File) {
        print('El objeto proporcionado no es un archivo válido');
        return null;
      }

      final nombreArchivo =
          'fotoPerfil/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await _supabase.storage
          .from('imagenesperfil')
          .upload(nombreArchivo, imagen);
      return nombreArchivo;
    } catch (e) {
      print('Error al subir la imagen: $e');
      return null;
    }
  }

  // Obtener URL pública de una imagen ya subida
  Future<String?> obtenerUrlPublica(String nombreArchivo) async {
    try {
      final urlPublica =
          _supabase.storage.from('imagenesperfil').getPublicUrl(nombreArchivo);
      return urlPublica;
    } catch (e) {
      print('Error al obtener la URL pública: $e');
      return null;
    }
  }

  // Actualiza la URL de imagen del perfil del usuario actual en la BD
  Future<void> actualizarImagenPerfil(String urlImagen) async {
    try {
      final usuarioActual = _supabase.auth.currentUser;
      if (usuarioActual == null) {
        throw Exception('Usuario no autenticado');
      }

      await _supabase
          .from('usuarios')
          .update({'imagen_perfil': urlImagen}).eq('id', usuarioActual.id);
    } catch (e) {
      print('Error al actualizar la imagen de perfil: $e');
    }
  }
}
