import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/crear_metas.dart';
import 'package:tfg_ivandelllanoblanco/components/dialogoMetas.dart';
import 'package:tfg_ivandelllanoblanco/components/eliminar_metas.dart';
import 'package:tfg_ivandelllanoblanco/components/mensaje_listametas_vacia.dart';
import 'package:tfg_ivandelllanoblanco/components/modificar_metas.dart';
import 'package:tfg_ivandelllanoblanco/components/opciones_metas.dart';
import 'package:tfg_ivandelllanoblanco/controllers/metascontrollador.dart';
import 'package:tfg_ivandelllanoblanco/components/lista_metas.dart';
import '../entitdades/informacionMetas.dart';

class MetasVista extends StatefulWidget {
  const MetasVista({super.key});

  @override
  MetasViewState createState() => MetasViewState();
}

class MetasViewState extends State<MetasVista> {
  final MetasControlador controlador = MetasControlador();
  List<Map<String, dynamic>> metas = [];

  @override
  void initState() {
    super.initState();
    _cargarMetas();
  }

  Future<void> _cargarMetas() async {
    final metasData = await controlador.obtenerMetas();
    setState(() {
      metas = metasData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle:
            Text("Metas", style: TextStyle(color: CupertinoColors.activeBlue)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (metas.isEmpty)
              Expanded(
                child: MensajeVacioMetas(
                  onAniadirMeta: () =>
                      mostrarDialogoCrearModificarMeta(context),
                ),
              )
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Lista de Metas",
                      style: TextStyle(
                        fontSize: 18,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(Icons.add),
                      onPressed: () =>
                          mostrarDialogoCrearModificarMeta(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                child: ListaMetas(
                  metas: metas,
                  controlador: controlador,
                  onMetaTap: _mostrarOpcionesMeta,
                ),
              ),
              Column(
                children: [
                  if (metas.isNotEmpty) ...[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: const Text(
                        "¿Quieres aprender a llegar a tus objetivos más rápido? Consulta estos cursos:",
                        style: TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    CupertinoButton.filled(
                      child: const Text("Explorar Ahora"),
                      onPressed: () => controlador.lanzarNavegador(),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _mostrarOpcionesMeta(Map<String, dynamic> meta) {
    OpcionesMetaDialog.mostrarOpcionesMeta(context, meta, this);
  }

  void eliminarItemMeta(int id) {
    EliminarMetaDialog.eliminarItemMeta(
        context, id, this, controlador, _cargarMetas);
  }

  void mostrarDialogoCrearModificarMeta(BuildContext context,
      {Map<String, dynamic>? meta}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => DialogoMetas(
        controlador: controlador,
        onMetaGuardada: _cargarMetas,
        meta: meta,
      ),
    );
  }
}
