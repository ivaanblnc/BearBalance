import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';
import 'package:tfg_ivandelllanoblanco/models/loginUsuario.dart';

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
  late Map<String, TextEditingController> _controllers;
  late Map<String, String?> _errores;
  late InicioSesionModelo _inicioSesionModelo;
  bool _esUsuarioGoogle = false;

  @override
  void initState() {
    super.initState();
    _inicioSesionModelo = InicioSesionModelo();
    _esUsuarioGoogle = _inicioSesionModelo.esUsuarioGoogle();

    _controllers = {
      'nombre': TextEditingController(text: widget.datosUsuario['nombre'] ?? ''),
      'apellidos':
          TextEditingController(text: widget.datosUsuario['apellidos'] ?? ''),
      'nombre_usuario': TextEditingController(
          text: widget.datosUsuario['nombre_usuario'] ?? ''),
      'email': TextEditingController(text: Supabase.instance.client.auth.currentUser?.email ?? widget.datosUsuario['email'] ?? widget.datosUsuario['correo_electronico'] ?? ''),
      'contrasena': TextEditingController(),
    };
    _errores = {};
  }

  void _mostrarMensaje(BuildContext scaffoldContext, String mensaje, {bool esError = false}) {
    showCupertinoDialog(
      context: scaffoldContext,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: Text(esError ? 'Error' : 'Información'),
          content: Text(mensaje),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<String?> _validarCampo(String nombreCampo, String valor) async {
    if (nombreCampo == 'nombre' || nombreCampo == 'apellidos' || nombreCampo == 'nombre_usuario') {
      if (valor.isEmpty) return 'Este campo no puede estar vacío.';
      if (valor.length < 3) return 'Debe tener al menos 3 caracteres.';
    }
    if (nombreCampo == 'email') {
      if (valor.isEmpty) return 'El correo no puede estar vacío.';
      final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      if (!emailRegex.hasMatch(valor)) return 'Formato de correo inválido.';
    }
    if (nombreCampo == 'contrasena' && !_esUsuarioGoogle) {
      if (valor.isEmpty) {
        return 'La contraseña no puede estar vacía.';
      }
      if (valor.isNotEmpty && valor.length < 6) {
        return 'La contraseña debe tener al menos 6 caracteres.';
      }
    }
    return null;
  }

  Widget _buildEditableField(
    String etiqueta,
    String nombreCampo,
    TextEditingController valorController,
    CambiarTema proveedorTema,
  ) {
    final esModoOscuro = proveedorTema.modoOscuro;
    final bool esCampoSensibleGoogle = (nombreCampo == 'email' || nombreCampo == 'contrasena') && _esUsuarioGoogle;

    final Color colorFilaLista = esModoOscuro ? const Color(0xFF1E1E1E) : CupertinoColors.systemGrey6;
    final Color colorTextoTitulo = esModoOscuro ? CupertinoColors.white : CupertinoColors.black;
    final Color colorTextoValor = esModoOscuro ? CupertinoColors.lightBackgroundGray : CupertinoColors.black;

    return CupertinoListTile(
      backgroundColor: colorFilaLista,
      title: Text(
        etiqueta,
        style: TextStyle(color: colorTextoTitulo),
      ),
      additionalInfo: Text(
        nombreCampo == 'contrasena'
            ? (_esUsuarioGoogle ? "••••••••" : (valorController.text.isNotEmpty ? "••••••••" : "Establecer contraseña"))
            : valorController.text,
        style: TextStyle(color: colorTextoValor),
      ),
      trailing: null,
      onTap: esCampoSensibleGoogle
          ? () {
              _mostrarMensaje(
                widget.contexto,
                "Los usuarios de Google no pueden modificar su ${nombreCampo == 'email' ? 'correo electrónico' : 'contraseña'} directamente desde aquí.",
              );
            }
          : () {
              TextEditingController controladorDialog = TextEditingController(text: (nombreCampo == 'contrasena' ? '' : valorController.text));
              if (_errores.containsKey(nombreCampo)) {
                setState(() { _errores.remove(nombreCampo); });
              }

              showCupertinoDialog(
                context: widget.contexto,
                builder: (BuildContext contextoDialogoInterno) {
                  return StatefulBuilder(
                    builder: (context, setStateDialog) {
                      return CupertinoAlertDialog(
                        title: Text('Editar $etiqueta'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CupertinoTextField(
                              controller: controladorDialog,
                              placeholder: (nombreCampo == 'contrasena' ? 'Nueva contraseña' : 'Nuevo valor para $etiqueta'),
                              autofocus: true,
                              obscureText: nombreCampo == 'contrasena',
                              onChanged: (value) {
                                if (_errores[nombreCampo] != null) {
                                  setStateDialog(() { _errores.remove(nombreCampo); });
                                }
                              },
                            ),
                            if (_errores[nombreCampo] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _errores[nombreCampo]!,
                                  style: const TextStyle(color: CupertinoColors.destructiveRed, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text("Cancelar"),
                            onPressed: () => Navigator.pop(contextoDialogoInterno),
                          ),
                          CupertinoDialogAction(
                            child: const Text("Aceptar"),
                            onPressed: () async {
                              final nuevoValor = controladorDialog.text.trim();
                              String? errorMsg;
                              bool opSuccess = false;

                              final validationError = await _validarCampo(nombreCampo, nuevoValor);
                              if (validationError != null) {
                                errorMsg = validationError;
                              } else {
                                try {
                                  if (nombreCampo == 'email') {
                                    await _inicioSesionModelo.cambiarEmail(nuevoValor);
                                    if (mounted) setState(() { valorController.text = nuevoValor; });
                                    opSuccess = true;
                                  } else if (nombreCampo == 'contrasena') {
                                    await _inicioSesionModelo.cambiarContrasena(nuevoValor);
                                    if (mounted) setState(() { valorController.clear(); });
                                    opSuccess = true;
                                  } else {
                                    await widget.onCampoActualizado(nombreCampo, nuevoValor);
                                    if (mounted) setState(() { valorController.text = nuevoValor; });
                                    opSuccess = true;
                                  }
                                } catch (e) {
                                  errorMsg = e.toString().replaceFirst("Exception: ", "");
                                }
                              }

                              if (opSuccess) {
                                Navigator.pop(contextoDialogoInterno);
                                String successMessage = "$etiqueta actualizado correctamente.";
                                if (nombreCampo == 'email') {
                                  successMessage = "Solicitud de cambio de correo procesada. Revisa tu bandeja de entrada.";
                                } else if (nombreCampo == 'contrasena') {
                                  successMessage = "Contraseña actualizada correctamente.";
                                }
                                _mostrarMensaje(widget.contexto, successMessage);
                              } else if (errorMsg != null) {
                                setStateDialog(() { _errores[nombreCampo] = errorMsg; });
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    final proveedorTema = Provider.of<CambiarTema>(context);
    final esModoOscuro = proveedorTema.modoOscuro;

    final Color colorFondoSeccion = esModoOscuro ? CupertinoColors.black : CupertinoColors.white;
    final Color colorHeaderText = esModoOscuro ? CupertinoColors.white : CupertinoColors.black;

    return CupertinoListSection.insetGrouped(
      backgroundColor: colorFondoSeccion,
      header: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 8.0),
        child: Text(
          "Información del Perfil",
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorHeaderText,
          ),
        ),
      ),
      children: <Widget>[
        _buildEditableField('Nombre', 'nombre', _controllers['nombre']!, proveedorTema),
        _buildEditableField('Apellidos', 'apellidos', _controllers['apellidos']!, proveedorTema),
        _buildEditableField('Nombre de usuario', 'nombre_usuario', _controllers['nombre_usuario']!, proveedorTema),
        _buildEditableField('Email', 'email', _controllers['email']!, proveedorTema),
        _buildEditableField('Contraseña', 'contrasena', _controllers['contrasena']!, proveedorTema),
      ],
    );
  }
}
