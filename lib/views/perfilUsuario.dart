import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/perfil_cerrarsesion.dart';
import 'package:tfg_ivandelllanoblanco/components/perfil_detalles.dart';
import 'package:tfg_ivandelllanoblanco/components/perfil_imagenPerfil.dart';
import 'package:tfg_ivandelllanoblanco/controllers/perfilControlador.dart';
import 'package:tfg_ivandelllanoblanco/views/configuracion.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Clase principal que representa la vista de perfil
class PerfilVista extends StatefulWidget {
  const PerfilVista({super.key});

  @override
  _PerfilVistaState createState() => _PerfilVistaState();
}

class _PerfilVistaState extends State<PerfilVista> {
  final PerfilControlador controlador = PerfilControlador();

  // Variables para almacenar los datos del usuario y la URL de la imagen del perfil
  Map<String, dynamic>? datosUsuario;
  String? imagenURL;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  //Metodo para cargar los datos del usuario
  Future<void> _cargarDatosUsuario() async {
    try {
      //Obtenemos los datos del usuario usando el controlador
      datosUsuario = await controlador.obtenerDatosUsuario();

      // Si los datos del usuario contienen una imagen de perfil, le asignamos la URL
      if (datosUsuario != null && datosUsuario!['imagen_perfil'] != null) {
        imagenURL = datosUsuario!['imagen_perfil'];
      }
    } catch (e) {
      // Si ocurre un error, imprimimos mensaje de error
      print(e.toString());
    }

    // Si el widget está activo, se actualiza el estado
    if (mounted) setState(() {});
  }

  // Metodo para actualizar un campo de los datos del usuario
  Future<bool> _actualizarCampo(String nombreColumna, String nuevoValor) async {
    // Mostramos un indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Llamamos al controlador para actualizar los datos del usuario
      final resultado = await controlador
          .actualizarDatosUsuario({nombreColumna: nuevoValor}, context);

      // Cerramos el indicador de carga
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Si la actualización fue exitosa y el widget está activo, se actualiza el estado
      if (resultado['success'] && mounted) {
        setState(() => datosUsuario = resultado['data']);
        return true;
      }

      return false;
    } catch (e) {
      // En caso de error, cerramos el indicador de carga
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mi Perfil",
          style: TextStyle(color: colorScheme.onSurface),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
        actions: [
          IconButton(
            icon:
                Icon(Icons.settings_outlined, color: theme.colorScheme.primary),
            tooltip: 'Configuración',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ConfiguracionPantalla(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: datosUsuario == null
            // Mostramos un indicador de carga si los datos del usuario aún no se han cargado
            ? Center(
                child: SpinKitFadingCube(
                  color: theme.colorScheme.primary,
                  size: 50.0,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // Widget para mostrar la imagen de perfil
                    PerfilImagen(
                      imageUrl: imagenURL,
                      onImageUpdated: (nuevaURL) =>
                          setState(() => imagenURL = nuevaURL),
                      onImageUpload: (context) =>
                          controlador.subirYActualizarImagen(
                        (nuevaURL) => setState(() => imagenURL = nuevaURL),
                        context,
                      ),
                      size: 150.0,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // Widget para mostrar y editar los detalles del perfil
                    DetallesPerfil(
                      datosUsuario: datosUsuario!,
                      onCampoActualizado: _actualizarCampo,
                      contexto: context,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    // Widget para cerrar sesión
                    PerfilCerrarSesion(
                      controlador: controlador,
                      context: context,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ],
                ),
              ),
      ),
    );
  }
}
