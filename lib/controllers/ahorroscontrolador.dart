import 'package:tfg_ivandelllanoblanco/models/ahorros.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Clase para gestionar el acceso a la tabla ahorros de la base de datos
class AhorrosControlador {
  //Instancia de la clase modelo de ahorros
  final AhorrosModelo modelo = AhorrosModelo();

  //Método para obtener los ahorros del usuario autenticado
  Future<List<Map<String, dynamic>>> obtenerAhorros() async {
    return await modelo.obtenerAhorros();
  }

  //Método para agregar un ahorro a la base de datos
  Future<void> agregarAhorro(Map<String, dynamic> ahorro) async {
    try {
      //Obtenemos el usuario actual y comprobamos que no sea null
      final usuarioActual = Supabase.instance.client.auth.currentUser;
      if (usuarioActual == null) {
        throw Exception('Usuario no autenticado');
      }
      //Obtenemos el id del usuario actual
      final idUsuario = usuarioActual.id;

      //Mapemaos el ahorro con el id del usuario
      //y lo agregamos a la base de datos
      final ahorroConUsuario = {...ahorro, 'usuario_id': idUsuario};
      await modelo.agregarAhorro(ahorroConUsuario);
    } catch (e) {
      // ignore: avoid_print
      print('Error al agregar ahorro: $e');
      rethrow;
    }
  }

  //Método para actualizar un ahorro en la base de datos
  //Recibe el id del ahorro y un mapa con los nuevos datos
  Future<void> actualizarAhorro(int id, Map<String, dynamic> ahorro) async {
    try {
      await modelo.actualizarAhorro(id, ahorro);
    } catch (e) {
      rethrow;
    }
  }

  //Metodo para eliminar un ahorro de la base de datos
  Future<void> eliminarAhorro(int id) async {
    try {
      await modelo.eliminarAhorro(id);
    } catch (e) {
      rethrow;
    }
  }

  //Metodo para filtrar los ahorros por fecha
  Future<List<Map<String, dynamic>>> filtrarMovimientos(DateTime fecha) async {
    try {
      return modelo.filtrarMovimiento(fecha);
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //Método para calcular el total de ingresos , gastos y saldo actual
  double calcularTotalIngresos(List<Map<String, dynamic>> ahorros) {
    return ahorros.where((ahorro) => ahorro['tipo'] == 'ingreso').fold(
        0.0, (sum, ahorro) => sum + (ahorro['cantidad'] as num).toDouble());
  }

  double calcularTotalGastos(List<Map<String, dynamic>> ahorros) {
    return ahorros.where((ahorro) => ahorro['tipo'] == 'gasto').fold(
        0.0, (sum, ahorro) => sum + (ahorro['cantidad'] as num).toDouble());
  }

  double calcularSaldoActual(List<Map<String, dynamic>> ahorros) {
    return calcularTotalIngresos(ahorros) - calcularTotalGastos(ahorros);
  }
}
