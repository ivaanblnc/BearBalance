import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class PerfilControlador {
  final _supabase = Supabase.instance.client;

//Metodo para obtener los datos del usuario
  Future<Map<String, dynamic>?> obtenerDatosUsuario() async {
    try {
      //Obtenemos el usuario actual y comprobamos si es nulo
      final usuarioActual = _supabase.auth.currentUser;
      if (usuarioActual == null) {
        return null;
      }
      //Obtenemos los datos del usuario de la base de datos
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

  //Metodo para obtener los nombres de usuario registrados
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

  //Metodo para actualizar los datos del usuario
  Future<Map<String, dynamic>?> actualizarDatosUsuario(
      Map<String, dynamic> datosActualizados) async {
    try {
      //Obtenemos el usuario actual y comprobamos si es nulo
      final usuarioActual = _supabase.auth.currentUser;
      if (usuarioActual == null) {
        return null;
      }
      //Actualizamos los datos del usuario en la base de datos
      final respuesta = await _supabase
          .from('usuarios')
          .update(datosActualizados)
          .eq('id', usuarioActual.id);

      //almacenamos los nuevos datos actualizados
      final usuarioActualizado = await _supabase
          .from('usuarios')
          .select('*')
          .eq('id', usuarioActual.id)
          .maybeSingle();

      return usuarioActualizado;
    } catch (e) {
      return null;
    }
  }

  //Metodo para cerrar la sesion del usuario
  Future<void> cerrarSesion(BuildContext context) async {
    try {
      // Cierra la sesión en Supabase
      await _supabase.auth.signOut();
      print("Sesión cerrada en Supabase");

      // Mandamos al usuario a la pantalla de inicio de sesión
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

// Método para cargar imagen de la galería del dispositivo
  Future<dynamic> CargarImagen() async {
    final ImagePicker picker = ImagePicker();
    final imagenSeleccionada =
        await picker.pickImage(source: ImageSource.gallery);

    if (imagenSeleccionada != null) {
      // Si no es web, devolvemos el archivo
      if (kIsWeb) {
        return null;
      } else {
        return File(imagenSeleccionada.path);
      }
    } else {
      // Si no se seleccionó imagen devolvemos null
      return null;
    }
  }

// Método para subir la imagen a Supabase Storage
  Future<String?> subirImagen(dynamic imagen) async {
    try {
      // Bloqueamos subida si es desde web
      if (kIsWeb) {
        print('Subida de imágenes no permitida desde la web');
        return null;
      }

      final nombreArchivo =
          'fotoPerfil/${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (imagen is File) {
        await _supabase.storage
            .from('imagenesperfil')
            .upload(nombreArchivo, imagen);
        return nombreArchivo;
      } else {
        return null;
      }
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

// Netodo que implementa la subida de imagen y actualización de la URL en la BD
  Future<void> subirYActualizarImagen(
      Function(String?) updateImageUrl, context) async {
    final imagen = await CargarImagen();
    if (imagen != null) {
      // En la web mostramos una alerta porque no está permitido
      if (kIsWeb) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Advertencia"),
            content:
                Text("La selección de imágenes no está permitida en la web"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );
        return;
      }

      // Subimos la imagen
      final nombreArchivo = await subirImagen(imagen);
      if (nombreArchivo != null) {
        // Obtenemos la URL
        final urlImagen = await obtenerUrlPublica(nombreArchivo);
        if (urlImagen != null) {
          await actualizarImagenPerfil(urlImagen);
          print('Imagen de perfil actualizada con éxito');
          updateImageUrl(urlImagen);
        } else {
          print('Error al obtener la URL pública');
        }
      } else {
        print('Error al subir la imagen');
      }
    } else {
      print('No se seleccionó ninguna imagen');
    }
  }
}
