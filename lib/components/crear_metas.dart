import 'package:flutter/material.dart';
import '../entidades/informacionMetas.dart';

class CrearItemMetaWidget {
  static Widget crearItemMeta(Informacionmetas? meta) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meta?.nombre ?? 'Sin nombre',
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
