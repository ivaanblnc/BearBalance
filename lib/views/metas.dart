import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/dialogoMetas.dart';
import 'package:tfg_ivandelllanoblanco/components/eliminar_metas.dart';
import 'package:tfg_ivandelllanoblanco/components/mensaje_listametas_vacia.dart';
import 'package:tfg_ivandelllanoblanco/controllers/metascontrollador.dart';
import 'package:tfg_ivandelllanoblanco/components/lista_metas.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Metas"),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
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
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Text(
                  "Lista de Metas",
                  style: textTheme.titleLarge
                      ?.copyWith(color: colorScheme.onSurface),
                ),
              ),
              Expanded(
                child: ListaMetas(
                  metas: metas,
                  controlador: controlador,
                  onMetaTap: _mostrarOpcionesMeta,
                ),
              ),
              if (metas.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    color: colorScheme.surfaceContainerLowest,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "¿Quieres aprender a llegar a tus objetivos más rápido? Consulta estos cursos:",
                            style: textTheme.titleMedium
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => controlador.lanzarNavegador(),
                            child: const Text("Explorar Ahora"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarDialogoCrearModificarMeta(context),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarOpcionesMeta(Map<String, dynamic> meta) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading:
                    Icon(Icons.edit_note, color: theme.colorScheme.primary),
                title: Text('Actualizar Meta',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onSurface)),
                onTap: () {
                  Navigator.pop(context);
                  mostrarDialogoCrearModificarMeta(context, meta: meta);
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.delete_outline, color: theme.colorScheme.error),
                title: Text('Eliminar Meta',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.error)),
                onTap: () {
                  Navigator.pop(context);
                  eliminarItemMeta(meta['id']);
                },
              ),
              Divider(
                  height: 1,
                  color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
              ListTile(
                leading: Icon(Icons.cancel_outlined,
                    color: theme.colorScheme.onSurfaceVariant),
                title: Text('Cancelar',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void eliminarItemMeta(int id) {
    EliminarMetaDialog.eliminarItemMeta(context, id, controlador, _cargarMetas);
  }

  void mostrarDialogoCrearModificarMeta(BuildContext context,
      {Map<String, dynamic>? meta}) {
    showDialog(
      context: context,
      builder: (context) => DialogoMetas(
        controlador: controlador,
        onMetaGuardada: _cargarMetas,
        meta: meta,
      ),
    );
  }
}
