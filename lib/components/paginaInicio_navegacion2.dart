import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/views/ahorros.dart';
import 'package:tfg_ivandelllanoblanco/views/metas.dart';
import 'package:tfg_ivandelllanoblanco/views/perfilUsuario.dart';

class PaginaInicioTabViews extends StatelessWidget {
  final int indiceActual;
  final Widget Function(BuildContext, List<Map<String, dynamic>>,
      List<Map<String, dynamic>>, Map<String, dynamic>?) paginaInicioBuilder;
  final Future<Map<String, dynamic>> Function() cargarDatos;

  const PaginaInicioTabViews({
    required this.indiceActual,
    required this.paginaInicioBuilder,
    required this.cargarDatos,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (indiceActual) {
      case 0:
        return _buildFutureDataView(context);
      case 1:
        return AhorrosVista();
      case 2:
        return MetasVista();
      case 3:
        return PerfilVista();
      default:
        return _buildFutureDataView(context);
    }
  }

  Widget _buildFutureDataView(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: cargarDatos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final metasData = snapshot.data?['metas'];
        final ahorrosData = snapshot.data?['ahorros'];
        final userData = snapshot.data?['userData'];

        final metas = metasData is List
            ? List<Map<String, dynamic>>.from(metasData)
            : <Map<String, dynamic>>[];

        final ahorros = ahorrosData is List
            ? List<Map<String, dynamic>>.from(ahorrosData)
            : <Map<String, dynamic>>[];

        return paginaInicioBuilder(context, metas, ahorros, userData);
      },
    );
  }
}
