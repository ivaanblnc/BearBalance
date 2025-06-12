import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';
import 'package:tfg_ivandelllanoblanco/models/loginUsuario.dart';

class DetallesPerfil extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;
  final Future<bool> Function(String columnaNombre, String nuevoValor)
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
      'nombre':
          TextEditingController(text: widget.datosUsuario['nombre'] ?? ''),
      'apellidos':
          TextEditingController(text: widget.datosUsuario['apellidos'] ?? ''),
      'nombre_usuario': TextEditingController(
          text: widget.datosUsuario['nombre_usuario'] ?? ''),
      'email': TextEditingController(
          text: Supabase.instance.client.auth.currentUser?.email ??
              widget.datosUsuario['email'] ??
              widget.datosUsuario['correo_electronico'] ??
              ''),
      'contrasena': TextEditingController(),
    };
    _errores = {};
  }

  void _mostrarMensaje(BuildContext scaffoldContext, String mensaje,
      {bool esError = false}) {
    showDialog(
      context: scaffoldContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(esError ? 'Error' : 'Información'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
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
    if (nombreCampo == 'nombre' ||
        nombreCampo == 'apellidos' ||
        nombreCampo == 'nombre_usuario') {
      if (valor.isEmpty) return 'Este campo no puede estar vacío.';
      if (valor.length < 3) return 'Debe tener al menos 3 caracteres.';
    }
    if (nombreCampo == 'email') {
      if (valor.isEmpty) return 'El correo no puede estar vacío.';
      final emailRegex = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
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
    final bool esCampoSensibleGoogle =
        (nombreCampo == 'email' || nombreCampo == 'contrasena') &&
            _esUsuarioGoogle;

    return ListTile(
      title: Text(
        etiqueta,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        nombreCampo == 'contrasena' &&
                !_esUsuarioGoogle &&
                valorController.text.isNotEmpty
            ? '********'
            : (nombreCampo == 'contrasena' && _esUsuarioGoogle
                ? 'Vinculado con Google'
                : valorController.text),
      ),
      trailing: esCampoSensibleGoogle
          ? Icon(Icons.lock, color: Theme.of(context).disabledColor)
          : Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary),
      onTap: esCampoSensibleGoogle
          ? null
          : () {
              _errores[nombreCampo] = null;
              showDialog(
                context: context,
                builder: (BuildContext contextoDialogoInterno) {
                  final controladorDialog = TextEditingController(
                      text: nombreCampo == 'contrasena'
                          ? ''
                          : valorController.text);
                  return StatefulBuilder(
                    builder:
                        (BuildContext context, StateSetter setStateDialog) {
                      return AlertDialog(
                        title: Text('Editar $etiqueta'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: controladorDialog,
                              decoration: InputDecoration(
                                labelText: 'Nuevo $etiqueta',
                                errorText: _errores[nombreCampo],
                              ),
                              obscureText: nombreCampo == 'contrasena',
                              autocorrect: nombreCampo != 'contrasena',
                              enableSuggestions: nombreCampo != 'contrasena',
                              keyboardType: nombreCampo == 'email'
                                  ? TextInputType.emailAddress
                                  : TextInputType.text,
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () =>
                                Navigator.pop(contextoDialogoInterno),
                          ),
                          TextButton(
                            child: const Text('Guardar'),
                            onPressed: () async {
                              final nuevoValor = controladorDialog.text.trim();
                              String? errorMsg;
                              bool opSuccess = false;

                              final validationError =
                                  await _validarCampo(nombreCampo, nuevoValor);
                              if (validationError != null) {
                                errorMsg = validationError;
                              } else {
                                try {
                                  if (nombreCampo == 'email') {
                                    await _inicioSesionModelo
                                        .cambiarEmail(nuevoValor);
                                    if (mounted) {
                                      setState(() {
                                        valorController.text = nuevoValor;
                                      });
                                    }
                                    opSuccess = true;
                                  } else if (nombreCampo == 'contrasena') {
                                    await _inicioSesionModelo
                                        .cambiarContrasena(nuevoValor);
                                    if (mounted) {
                                      setState(() {
                                        valorController.clear();
                                      });
                                    }
                                    opSuccess = true;
                                  } else {
                                    // Llamamos al método de actualización y esperamos su resultado
                                    bool actualizacionExitosa =
                                        await widget.onCampoActualizado(
                                            nombreCampo, nuevoValor);

                                    if (actualizacionExitosa) {
                                      if (mounted) {
                                        setState(() {
                                          valorController.text = nuevoValor;
                                        });
                                      }
                                      opSuccess = true;
                                    } else {
                                      // La actualización falló, mostramos un mensaje de error
                                      errorMsg =
                                          'No se pudo actualizar el $etiqueta';
                                      if (nombreCampo == 'nombre_usuario') {
                                        errorMsg =
                                            'El nombre de usuario ya existe';
                                      }
                                      opSuccess = false;
                                    }
                                  }
                                } catch (e) {
                                  errorMsg = e
                                      .toString()
                                      .replaceFirst("Exception: ", "");
                                }
                              }

                              if (opSuccess) {
                                Navigator.pop(contextoDialogoInterno);
                                String successMessage =
                                    "$etiqueta actualizado correctamente.";
                                if (nombreCampo == 'email') {
                                  successMessage =
                                      "Solicitud de cambio de correo procesada. Revisa tu bandeja de entrada.";
                                } else if (nombreCampo == 'contrasena') {
                                  successMessage =
                                      "Contraseña actualizada correctamente.";
                                }
                                _mostrarMensaje(
                                    widget.contexto, successMessage);
                              } else if (errorMsg != null) {
                                setStateDialog(() {
                                  _errores[nombreCampo] = errorMsg;
                                });
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
    // final esModoOscuro = proveedorTema.modoOscuro; // Keep for now if other logic depends on it, otherwise remove

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 2.0, // Optional: adds a subtle shadow
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
            child: Text(
              "Información del Perfil",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    // color: colorHeaderText, // Removed for Material default
                  ),
            ),
          ),
          _buildEditableField(
              'Nombre', 'nombre', _controllers['nombre']!, proveedorTema),
          _buildEditableField('Apellidos', 'apellidos',
              _controllers['apellidos']!, proveedorTema),
          _buildEditableField('Nombre de usuario', 'nombre_usuario',
              _controllers['nombre_usuario']!, proveedorTema),
          _buildEditableField(
              'Email', 'email', _controllers['email']!, proveedorTema),
          if (!_esUsuarioGoogle) // Only show password field if not a Google user
            _buildEditableField('Contraseña', 'contrasena',
                _controllers['contrasena']!, proveedorTema),
        ],
      ),
    );
  }
}
