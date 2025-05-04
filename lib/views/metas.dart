import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/crear_metas.dart';
import 'package:tfg_ivandelllanoblanco/components/eliminar_metas.dart';
import 'package:tfg_ivandelllanoblanco/components/mensaje_listametas_vacia.dart';
import 'package:tfg_ivandelllanoblanco/components/modificar_metas.dart';
import 'package:tfg_ivandelllanoblanco/components/opciones_metas.dart';
import 'package:tfg_ivandelllanoblanco/controllers/metascontrollador.dart';
import 'package:tfg_ivandelllanoblanco/components/lista_metas.dart';
import '../entitdades/informacionMetas.dart';

// Widget principal que gestiona la vista de las metas
class MetasVista extends StatefulWidget {
  // Constructor de la clase
  const MetasVista({super.key});

  @override
  MetasViewState createState() => MetasViewState();
}

class MetasViewState extends State<MetasVista> {
  // Instanciamos del controlador para gestionar las metas
  final MetasControlador controlador = MetasControlador();

  // Lista de metas obtenidas desde el controlador
  List<Map<String, dynamic>> metas = [];

  @override
  void initState() {
    super.initState();
    // Cargamos las metas cuando se inicia el widget
    _cargarMetas();
  }

  // Método para cargar las metas desde el controlador
  Future<void> _cargarMetas() async {
    final metasData = await controlador.obtenerMetas();
    // Actualizamos la lista de metas con las metas obtenidas
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
            // Si la lista de metas está vacía, mostramos un mensaje con la opción de añadir una nueva meta
            if (metas.isEmpty)
              Expanded(
                child: MensajeVacioMetas(
                  onAniadirMeta: () => mostrarCupertinoDialog(context),
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
                      onPressed: () => mostrarCupertinoDialog(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Lista de metas
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

  //diálogo con las opciones para una meta
  void _mostrarOpcionesMeta(Map<String, dynamic> meta) {
    OpcionesMetaDialog.mostrarOpcionesMeta(context, meta, this);
  }

  //  metodo para eliminar una meta de la lista
  void eliminarItemMeta(int id) {
    EliminarMetaDialog.eliminarItemMeta(
        context, id, this, controlador, _cargarMetas);
  }

  //Widget para crear una meta
  Widget crearItemMeta(Informacionmetas? meta) {
    return CrearItemMetaWidget.crearItemMeta(meta);
  }

  //Metodo para modificar una meta
  void mostrarCupertinoDialog(BuildContext context,
      {Map<String, dynamic>? meta}) {
    CupertinoMetaDialog.mostrarCupertinoDialog(
        context, this, controlador, _cargarMetas,
        meta: meta);
  }
}
