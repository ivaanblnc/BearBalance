import 'package:supabase_flutter/supabase_flutter.dart';

//Clase para manejar la logca de negocio de las metas
class MetasModelo {
  //Instancia de la base de datos
  final _supabase = Supabase.instance.client;

  //Metodo para obtener las metas de un usuario
  Future<List<Map<String, dynamic>>> obtenerMetas(String usuarioId) async {
    try {
      final respuesta =
          await _supabase.from('metas').select('*').eq('usuario_id', usuarioId);

      //devolvemos la respuesta como una lista de mapas
      return (respuesta as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print("Error al obtener metas desde la clase modelo ");
      return [];
    }
  }

  //Metodo para agregar una nueva meta
  Future<void> agregarMeta(String titulo, double cantidadAhorrada,
      double cantidadObjetivo, String fechaLimite, String usuarioId) async {
    try {
      await _supabase.from('metas').insert({
        'titulo': titulo,
        'cantidad_ahorrada': cantidadAhorrada,
        'cantidad_objetivo': cantidadObjetivo,
        'fecha_limite': fechaLimite,
        'usuario_id': usuarioId,
      });
    } catch (e) {}
  }

  //Metodo para actualizar una meta existente
  Future<void> actualizarMeta(int id, String titulo, double cantidadAhorrada,
      double cantidadObjetivo, String fechaLimite, String usuarioId) async {
    await _supabase.from('metas').update({
      'titulo': titulo,
      'cantidad_ahorrada': cantidadAhorrada,
      'cantidad_objetivo': cantidadObjetivo,
      'fecha_limite': fechaLimite,
      'usuario_id': usuarioId,
    }).eq('id', id);
  }

  //Metodo para eliminar una meta
  Future<void> eliminarMeta(int id) async {
    try {
      await _supabase.from('metas').delete().eq('id', id);
    } catch (e) {}
  }
}
