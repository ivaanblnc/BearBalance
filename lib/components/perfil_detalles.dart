import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';
import 'package:tfg_ivandelllanoblanco/controllers/perfilControlador.dart';
import 'package:tfg_ivandelllanoblanco/components/campo_error.dart';

class DetallesPerfil extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;
  final Future<void> Function(String columnaNombre, String nuevoValor)
      onCampoActualizado;
  final BuildContext contexto;

  const DetallesPerfil({
    super.key,
    required this.datosUsuario,
    required this.onCampoActualizado,
    required this.contexto,
  });

  @override
  State<DetallesPerfil> createState() => _DetallesPerfilState();
}

class _DetallesPerfilState extends State<DetallesPerfil> {
  final Map<String, String?> _errores = {
    'nombre': null,
    'apellidos': null,
    'nombre_usuario': null,
    'correo_electronico': null,
    'contrasena': null,
  };

  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _controllers['nombre'] =
        TextEditingController(text: widget.datosUsuario['nombre']);
    _controllers['apellidos'] =
        TextEditingController(text: widget.datosUsuario['apellidos']);
    _controllers['nombre_usuario'] =
        TextEditingController(text: widget.datosUsuario['nombre_usuario']);
    _controllers['correo_electronico'] =
        TextEditingController(text: widget.datosUsuario['correo_electronico']);
    _controllers['contrasena'] =
        TextEditingController(text: widget.datosUsuario['contrasena']);
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proveedorTema = Provider.of<CambiarTema>(context);
    final esModoOscuro = proveedorTema.modoOscuro;

    return CupertinoListSection.insetGrouped(
      backgroundColor:
          esModoOscuro ? CupertinoColors.black : CupertinoColors.white,
      header: const Text("Información del Perfil"),
      children: [
        _construirFilaLista("Nombre", 'nombre', widget.datosUsuario['nombre'],
            context, widget.onCampoActualizado, esModoOscuro),
        _construirFilaLista(
            "Apellidos",
            'apellidos',
            widget.datosUsuario['apellidos'],
            context,
            widget.onCampoActualizado,
            esModoOscuro),
        _construirFilaLista(
            "Nombre de usuario",
            'nombre_usuario',
            widget.datosUsuario['nombre_usuario'],
            context,
            widget.onCampoActualizado,
            esModoOscuro),
        _construirFilaLista(
            "Email",
            'correo_electronico',
            widget.datosUsuario['correo_electronico'],
            context,
            widget.onCampoActualizado,
            esModoOscuro),
        _construirFilaLista(
            "Contraseña",
            'contrasena',
            widget.datosUsuario['contrasena'],
            context,
            widget.onCampoActualizado,
            esModoOscuro),
      ],
    );
  }

  CupertinoListTile _construirFilaLista(
    String titulo,
    String nombreCampo,
    String valor,
    BuildContext contextoPadre,
    Future<void> Function(String columnaNombre, String nuevoValor)
        onCampoActualizado,
    bool esModoOscuro,
  ) {
    final colorFilaOscuro = const Color(0xFF1E1E1E);
    TextEditingController controlador = _controllers[nombreCampo]!;

    return CupertinoListTile(
      backgroundColor:
          esModoOscuro ? colorFilaOscuro : CupertinoColors.systemGrey6,
      title: Text(titulo,
          style: TextStyle(
              color: esModoOscuro
                  ? CupertinoColors.white
                  : CupertinoColors.black)),
      additionalInfo: Text(valor,
          style: TextStyle(
              color: esModoOscuro
                  ? CupertinoColors.lightBackgroundGray
                  : CupertinoColors.black)),
      onTap: () {
        showCupertinoDialog(
          context: contextoPadre,
          builder: (contextoDialogo) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return CupertinoAlertDialog(
                title: Text("Editar $titulo"),
                content: Column(
                  children: [
                    CupertinoTextField(
                      controller: controlador,
                      placeholder: titulo,
                      onChanged: (newValue) {
                        setStateDialog(() {
                          _errores[nombreCampo] = null;
                        });
                      },
                    ),
                    CampoError(mensaje: _errores[nombreCampo]),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.pop(contextoDialogo),
                    child: const Text("Cancelar"),
                  ),
                  CupertinoDialogAction(
                    onPressed: () async {
                      String nuevoValor = controlador.text;
                      String? error =
                          await _validarCampo(nombreCampo, nuevoValor);

                      if (error == null) {
                        String columnaNombre = titulo.toLowerCase();
                        if (columnaNombre == 'nombre de usuario') {
                          columnaNombre = 'nombre_usuario';
                        }
                        if (columnaNombre == 'contraseña') {
                          columnaNombre = 'contrasena';
                        } else if (columnaNombre == 'email') {
                          columnaNombre = 'correo_electronico';
                        }
                        await widget.onCampoActualizado(
                            columnaNombre, nuevoValor);
                        Navigator.pop(contextoDialogo);
                      } else {
                        setStateDialog(() {
                          _errores[nombreCampo] = error;
                        });
                        Future.delayed(
                            const Duration(milliseconds: 100), () {});
                      }
                    },
                    child: const Text("Aceptar"),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Método para validar cada campo
  Future<String?> _validarCampo(String nombreCampo, String valor) async {
    print(
        'Se está llamando a _validarCampo con nombreCampo: $nombreCampo y valor: $valor');

    switch (nombreCampo) {
      case 'nombre':
        if (valor.isEmpty) return 'El nombre no puede estar vacío.';
        break;
      case 'apellidos':
        if (valor.isEmpty) return 'Los apellidos no pueden estar vacíos.';
        break;
      case 'contrasena':
        if (valor.isEmpty) return 'La contraseña no puede estar vacía.';
        if (valor.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres.';
        }
        break;
      case 'nombre_usuario':
        if (valor.isEmpty) return 'El nombre de usuario no puede estar vacío.';
        final usuariosData = await PerfilControlador().obtenerNombresUsuario();
        final nombresUsuarioExistentes = usuariosData
            ?.map((map) => map['nombre_usuario'] as String)
            .toList();

        if (nombresUsuarioExistentes
                ?.map((name) => name.toLowerCase())
                .contains(valor.trim().toLowerCase()) ==
            true) {
          return 'Este nombre de usuario ya está en uso.';
        }

        break;
      case 'correo_electronico':
        if (valor.isEmpty) return 'El correo electrónico no puede estar vacío.';
        if (!valor.contains('@') || !valor.contains('.')) {
          return 'Formato de correo electrónico incorrecto.';
        }
        break;
    }
    return null;
  }
}
