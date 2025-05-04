import 'package:supabase_flutter/supabase_flutter.dart';

/// Esta clase maneja la lógica de negocio relacionada con los ahorros
class AhorrosModelo {
  /// Instancia de SupabaseClient para interactuar con la base de datos
  final SupabaseClient supabase = Supabase.instance.client;

  // Metodo para obtener los ahorros del usuario actual
  Future<List<Map<String, dynamic>>> obtenerAhorros() async {
    try {
      final usuarioActual = supabase.auth.currentUser;
      if (usuarioActual == null) {
        throw Exception('Error al cargar los datos del usuario');
      }

      final respuesta = await supabase
          .from('ahorros')
          .select('*')
          .eq('usuario_id', usuarioActual.id);

      //Devolvemos la respuesta casteada a lista de mapas
      return (respuesta as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print("Error al obtener ahorros en el modelo: ${e.toString()}");
      return [];
    }
  }

  // Metodo para insertar un ahorro
  Future<void> agregarAhorro(Map<String, dynamic> ahorro) async {
    try {
      await supabase.from('ahorros').insert(ahorro);
    } catch (e) {
      rethrow;
    }
  }

  // Metodo para actualizar un ahorro por su ID
  Future<void> actualizarAhorro(int id, Map<String, dynamic> ahorro) async {
    try {
      await supabase.from('ahorros').update(ahorro).eq('id', id);
    } catch (e) {
      print('Error al actualizar ahorro: $e');
      rethrow;
    }
  }

  // Metodo para eliminar un ahorro por su ID
  Future<void> eliminarAhorro(int id) async {
    try {
      await supabase.from('ahorros').delete().eq('id', id);
    } catch (e) {
      rethrow;
    }
  }

  // Metodo para filtrar los ahorros por fecha
  Future<List<Map<String, dynamic>>> filtrarMovimiento(DateTime fecha) async {
    try {
      final fechaFormateada = fecha.toIso8601String();

      final respuesta = await supabase
          .from('ahorros')
          .select('*')
          .gte('fecha_registro', fechaFormateada);

      return respuesta;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
