import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tfg_ivandelllanoblanco/components/paginaInicio_listaYEncabezado.dart';
import 'package:tfg_ivandelllanoblanco/controllers/paginaInicioControlador.dart';
import 'package:tfg_ivandelllanoblanco/controllers/metascontrollador.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_ivandelllanoblanco/views/ahorros.dart';
import 'package:tfg_ivandelllanoblanco/views/metas.dart';
import 'package:tfg_ivandelllanoblanco/views/perfilUsuario.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PaginaInicioVista extends StatefulWidget {
  final String nombreUsuario;

  const PaginaInicioVista(this.nombreUsuario, {super.key});

  @override
  _PaginaInicioVistaState createState() => _PaginaInicioVistaState();
}

class _PaginaInicioVistaState extends State<PaginaInicioVista> {
  final MetasControlador controladorMetas = MetasControlador();
  final AhorrosControlador controladorAhorros = AhorrosControlador();
  late final PaginaInicioControlador controlador;

  int indiceActual = 0;

  @override
  void initState() {
    super.initState();
    controlador = PaginaInicioControlador(widget.nombreUsuario);
  }

  Future<Map<String, dynamic>> _cargarDatos() async {
    try {
      final metas = await controladorMetas.obtenerMetas();
      final ahorros = await controladorAhorros.obtenerAhorros();
      final usuarioActual = Supabase.instance.client.auth.currentUser?.id;
      Map<String, dynamic>? datosUsuario;
      if (usuarioActual != null) {
        datosUsuario = await controlador.obtenerDatosUsuario(usuarioActual);
      }
      return {
        'metas': metas,
        'ahorros': ahorros,
        'userData': datosUsuario,
      };
    } catch (e) {
      print("Error en _cargarDatos: ${e.toString()}");
      return {
        'metas': [],
        'ahorros': [],
        'userData': null,
      };
    }
  }

  List<Widget> _buildTabViews() {
    return [
      FutureBuilder<Map<String, dynamic>>(
        future: _cargarDatos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitFadingCube(
                color: Theme.of(context).colorScheme.primary,
                size: 50.0,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar datos: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No hay datos disponibles.'));
          }

          final metasData = snapshot.data!['metas'];
          final ahorrosData = snapshot.data!['ahorros'];
          final userData = snapshot.data!['userData'];

          final metas = metasData is List
              ? List<Map<String, dynamic>>.from(metasData)
              : <Map<String, dynamic>>[];
          final ahorros = ahorrosData is List
              ? List<Map<String, dynamic>>.from(ahorrosData)
              : <Map<String, dynamic>>[];

          return PaginaInicioContenido(
            metas: metas,
            ahorros: ahorros,
            datosusuario: userData as Map<String, dynamic>?,
            controladorMetas: controladorMetas,
            controladorAhorros: controladorAhorros,
            nombreUsuario: widget.nombreUsuario,
            onPerfilTap: () => controlador.navegarAPerfil(context),
          );
        },
      ),
      AhorrosVista(),
      MetasVista(),
      PerfilVista(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabViews = _buildTabViews();

    return Scaffold(
      body: IndexedStack(
        index: indiceActual,
        children: tabViews,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          child: BottomNavigationBar(
            currentIndex: indiceActual,
            onTap: (index) {
              setState(() {
                indiceActual = index;
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart), label: 'Ahorros'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_add), label: 'Metas'),
              BottomNavigationBarItem(icon: Icon(Icons.face), label: 'Perfil'),
            ],
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: CupertinoColors.inactiveGray,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
