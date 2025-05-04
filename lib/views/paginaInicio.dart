import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/paginaInicio_listaYEncabezado.dart';
import 'package:tfg_ivandelllanoblanco/components/paginaInicio_navegacion2.dart';
import 'package:tfg_ivandelllanoblanco/controllers/paginaInicioControlador.dart';
import 'package:tfg_ivandelllanoblanco/controllers/metascontrollador.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Widget principal de la vista de la página de inicio
class PaginaInicioVista extends StatefulWidget {
  final String nombreUsuario;

  // Constructor que recibe el nombre del usuario
  const PaginaInicioVista(this.nombreUsuario, {super.key});

  @override
  _PaginaInicioVistaState createState() => _PaginaInicioVistaState();
}

class _PaginaInicioVistaState extends State<PaginaInicioVista> {
  // Controladores para las metas, ahorros y datos de la página de inicio
  final MetasControlador controladorMetas = MetasControlador();
  final AhorrosControlador controladorAhorros = AhorrosControlador();
  late final PaginaInicioControlador controlador;

  // Variable para gestionar el índice de la pestaña activa
  int indiceActual = 0;

  @override
  void initState() {
    super.initState();
    // Inicializamos el controlador de la página de inicio con el nombre del usuario
    controlador = PaginaInicioControlador(widget.nombreUsuario);
  }

  // Método para cargar los datos necesarios para la página de inicio
  Future<Map<String, dynamic>> _cargarDatos() async {
    print("Iniciando carga de datos en _cargarDatos");

    try {
      //Obtenemos las metas desde el controlador de metas
      final metas = await controladorMetas.obtenerMetas();
      print("Metas obtenidas: $metas");

      //Obtenemos los ahorros desde el controlador de ahorros
      final ahorros = await controladorAhorros.obtenerAhorros();
      print("Ahorros obtenidos: $ahorros");

      //Obtenemos el ID del usuario
      final usuarioActual = Supabase.instance.client.auth.currentUser?.id;
      print("UserId en _cargarDatos: $usuarioActual");

      // Si el ID del usuario no es nulo, obtenemos los datos del usuario
      Map<String, dynamic>? datosUsuario;
      if (usuarioActual != null) {
        datosUsuario = await controlador.obtenerDatosUsuario(usuarioActual);
        print("Datos del usuario obtenidos: $datosUsuario");
      } else {
        datosUsuario = null;
      }

      // Retornamos un mapa con las metas, los ahorros y los datos del usuario
      return {
        'metas': metas,
        'ahorros': ahorros,
        'userData': datosUsuario,
      };
    } catch (e) {
      // Si ocurre un error, devolvemos un mapa vacío
      print("Error en _cargarDatos: ${e.toString()}");
      return {
        'metas': [],
        'ahorros': [],
        'userData': null,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: indiceActual,
        onTap: (index) {
          // Actualizamos el índice de la pestaña seleccionada
          setState(() {
            indiceActual = index;
          });
        },
        // Elementos de la barra de pestañas
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Render'),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add), label: 'Metas'),
          BottomNavigationBarItem(icon: Icon(Icons.face), label: 'Perfil'),
        ],
      ),
      // Constructor de la vista para cada pestaña
      tabBuilder: (BuildContext context, int index) {
        return PaginaInicioTabViews(
          indiceActual: index,
          paginaInicioBuilder: (context, metas, ahorros, datosusuario) =>
              PaginaInicioContenido(
            metas: metas,
            ahorros: ahorros,
            datosusuario: datosusuario,
            controladorMetas: controladorMetas,
            controladorAhorros: controladorAhorros,
            nombreUsuario: widget.nombreUsuario,
            onPerfilTap: () => controlador.navegarAPerfil(context),
          ),
          cargarDatos: _cargarDatos,
        );
      },
    );
  }
}
