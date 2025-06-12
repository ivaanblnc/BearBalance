import 'package:supabase_flutter/supabase_flutter.dart';

//Clase para manejar la lógica de la página de inicio
class PaginaInicioModelo {
  // Método para realizar una consulta a la base de datos
  // Parámetros: tabla, select, columna y valor
  Future<dynamic> _realizarConsulta(
      String tabla, String select, String columna, String valor) async {
    try {
      final respuesta = await Supabase.instance.client
          .from(tabla)
          .select(select)
          .eq(columna, valor)
          .single();
      return respuesta;
    } catch (e) {
      return null;
    }
  }

  // Método para obtener el nombre de usuario
  Future<Map<String, dynamic>?> obtenerDatosUsuarioPorId(String userId) async {
    try {
      final respuestaConsulta = await Supabase.instance.client
          .from('usuarios')
          .select()
          .eq('id', userId)
          .maybeSingle();

      //Si no es null retorna la respuesta
      if (respuestaConsulta != null) {
        return respuestaConsulta;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
