import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../models/perfilModelo.dart';

class PerfilControlador {
  // Instancia del modelo de perfil
  final PerfilModelo _perfilModelo = PerfilModelo();

  // Método para obtener los datos del usuario
  Future<Map<String, dynamic>?> obtenerDatosUsuario() async {
    return await _perfilModelo.obtenerDatosUsuario();
  }

  // Método para obtener los nombres de usuario registrados
  Future<List<Map<String, dynamic>>?> obtenerNombresUsuario() async {
    return await _perfilModelo.obtenerNombresUsuario();
  }

  // Método para actualizar los datos del usuario
  Future<Map<String, dynamic>> actualizarDatosUsuario(
      Map<String, dynamic> datosActualizados, BuildContext context) async {
    final resultado = await _perfilModelo.actualizarDatosUsuario(datosActualizados);
    
    // Si hay un error y estamos actualizando el nombre de usuario, mostramos un mensaje
    if (!resultado['success'] && 
        datosActualizados.containsKey('nombre_usuario') && 
        resultado['message'] == 'El nombre de usuario ya existe') {
      
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se puede actualizar: El nombre de usuario ya existe'),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: Duration(seconds: 3),
        ),
      );
    }
    
    return resultado;
  }

  // Método para cerrar la sesión del usuario
  Future<void> cerrarSesion(BuildContext context) async {
    try {
      await _perfilModelo.cerrarSesion();
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

  // Método que implementa la subida de imagen y actualización de la URL en la BD
  Future<void> subirYActualizarImagen(
      Function(String?) updateImageUrl, BuildContext context) async {
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

      final nombreArchivo = await _perfilModelo.subirImagen(imagen);
      if (nombreArchivo != null) {
        final urlImagen = await _perfilModelo.obtenerUrlPublica(nombreArchivo);
        if (urlImagen != null) {
          await _perfilModelo.actualizarImagenPerfil(urlImagen);
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
