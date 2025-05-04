import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/metascontrollador.dart';
import '../entitdades/informacionMetas.dart';

class ListaMetas extends StatelessWidget {
  final List<Map<String, dynamic>> metas;
  final MetasControlador controlador;
  final Function(Map<String, dynamic>)? onMetaTap;

  const ListaMetas({
    super.key,
    required this.metas,
    required this.controlador,
    this.onMetaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: metas.isEmpty ? 0 : 280,
        child: ListView.builder(
          itemCount: metas.length,
          itemBuilder: (context, index) {
            final meta = metas[index];
            return CupertinoListTile(
              title: _crearItemMeta(controlador.convertirMapaAMeta(meta)),
              onTap: onMetaTap != null ? () => onMetaTap!(meta) : null,
            );
          },
        ),
      ),
    );
  }

  Widget _crearItemMeta(Informacionmetas? meta) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meta?.nombre ?? 'Sin nombre',
          ),
          SizedBox(
            width: 250,
            child: LinearProgressIndicator(
              value:
                  (meta?.cantidadAhorrada ?? 0) / (meta?.cantidadObjetivo ?? 1),
              backgroundColor: Colors.grey[300],
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.indigoAccent),
            ),
          ),
          Row(
            children: [
              Text("Ahorrado: ${meta?.cantidadAhorrada ?? 0}€"),
              const SizedBox(width: 10),
              Text("Objetivo: ${meta?.cantidadObjetivo ?? 0}€"),
            ],
          ),
          Text("Fecha Objetivo: ${meta?.fecha ?? 'Sin fecha'}"),
        ],
      ),
    );
  }
}
