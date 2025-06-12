import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_ivandelllanoblanco/models/metas.dart';
import 'package:tfg_ivandelllanoblanco/entidades/informacionMetas.dart';
import 'package:url_launcher/url_launcher.dart';

//Clase para gestionar las metas del usuario junto con la base de datos
class MetasControlador {
  final MetasModelo modelo = MetasModelo();

  //Metodo para obtener las metas del usuario
  Future<List<Map<String, dynamic>>> obtenerMetas() async {
    final usuarioId = Supabase.instance.client.auth.currentUser!.id;
    return modelo.obtenerMetas(usuarioId);
  }

  //Metodo para agregar una nueva meta
  Future<String?> agregarMeta(
      String titulo,
      double cantidadAhorrada,
      double cantidadObjetivo,
      String fechaLimite,
      Function() onMetaAgregada) async {
    // Validaciones
    if (titulo.trim().isEmpty) {
      return "El nombre de la meta no puede estar vacío.";
    }
    if (cantidadAhorrada < 0 || cantidadObjetivo < 0) {
      return "Las cantidades deben ser positivas.";
    }
    if (cantidadAhorrada > cantidadObjetivo) {
      return "La cantidad ahorrada no puede ser mayor que la cantidad objetivo.";
    }
    try {
      final fechaLimiteDate = DateTime.parse(fechaLimite);
      if (fechaLimiteDate.isBefore(DateTime.now())) {
        return "La fecha límite no puede ser anterior al día de hoy.";
      }
    } catch (e) {
      return "Formato de fecha inválido.";
    }

    final usuarioId = Supabase.instance.client.auth.currentUser!.id;
    await modelo.agregarMeta(
        titulo, cantidadAhorrada, cantidadObjetivo, fechaLimite, usuarioId);
    onMetaAgregada();
    return null;
  }

  //Metodo para eliminar una meta
  Future<void> eliminarMeta(int id, Function() onMetaEliminada) async {
    await modelo.eliminarMeta(id);
    onMetaEliminada();
  }

  //Metodo para actualizar una meta
  Future<String?> actualizarMeta(
      int id,
      String titulo,
      double cantidadAhorrada,
      double cantidadObjetivo,
      String fechaLimite,
      Function() onMetaActualizada) async {
    // Validaciones
    if (titulo.trim().isEmpty) {
      return "El nombre de la meta no puede estar vacío.";
    }
    if (cantidadAhorrada < 0 || cantidadObjetivo < 0) {
      return "Las cantidades deben ser positivas.";
    }
    if (cantidadAhorrada > cantidadObjetivo) {
      return "La cantidad ahorrada no puede ser mayor que la cantidad objetivo.";
    }
    try {
      final fechaLimiteDate = DateTime.parse(fechaLimite);
      if (fechaLimiteDate.isBefore(DateTime.now())) {
        return "La fecha límite no puede ser anterior al día de hoy.";
      }
    } catch (e) {
      return "Formato de fecha inválido.";
    }

    final usuarioId = Supabase.instance.client.auth.currentUser!.id;
    await modelo.actualizarMeta(
        id, titulo, cantidadAhorrada, cantidadObjetivo, fechaLimite, usuarioId);
    onMetaActualizada();
    return null;
  }

  //Metodo para abrir el navegador y mostrar la pagina de cursos
  Future<void> lanzarNavegador() async {
    final Uri enlace =
        Uri.parse('https://www.udemy.com/topic/personal-finance/');

    if (await canLaunchUrl(enlace)) {
      await launchUrl(enlace, mode: LaunchMode.externalApplication);
    }
  }

  //Metodo para convertir un mapa a una meta
  Informacionmetas convertirMapaAMeta(Map<String, dynamic> mapa) {
    return Informacionmetas(
      nombre: mapa['titulo'],
      cantidadAhorrada: (mapa['cantidad_ahorrada'] as num).toDouble(),
      cantidadObjetivo: (mapa['cantidad_objetivo'] as num).toDouble(),
      fecha: mapa['fecha_limite'],
    );
  }
}
