import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Clase para alternar el tema de la aplicacion
class CambiarTema extends ChangeNotifier {
  //variable para controlar el tema
  bool _modoOScuro = false;

//Constructor de la clase
  CambiarTema() {
    cargarTemaGuardado();
  }

//Metodo get para obtener el valor de la variable
  bool get modoOscuro => _modoOScuro;

//Metodo que recibe el valor bool del switch , lo asigna a la variable y lo guarda en shared preferences
  Future<void> switchModoOscuro(bool valor) async {
    _modoOScuro = valor;
    //Notifica a los listener (todos los widgets) que el valor ha cambiado
    notifyListeners();
    await guardarConfiguracion(valor);
  }

//Metodo paea cargar el valor guardado en shared preferences
  Future<void> cargarTemaGuardado() async {
    //Obtenemos la instancia
    final prefs = await SharedPreferences.getInstance();
    //Obtenemos el valor guardado en shared preferences, si no existe se asigna false por defecto
    _modoOScuro = prefs.getBool('modoOscuro') ?? false;
    //Notificamos a los listener (todos los widgets) que el valor ha cambiado
    notifyListeners();
  }

//Metodo para guardar el valor en shared preferences
  Future<void> guardarConfiguracion(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modoOscuro', valor);
  }
}
