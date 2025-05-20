import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';
import 'package:tfg_ivandelllanoblanco/controllers/perfilControlador.dart';
import 'package:tfg_ivandelllanoblanco/models/loginUsuario.dart';

class DetallesPerfil extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;
  final Future<void> Function(String columnaNombre, String nuevoValor)
      onCampoActualizado;

  const DetallesPerfil({
    super.key,
    required this.datosUsuario,
    required this.onCampoActualizado,
  });

  @override
  State<DetallesPerfil> createState() => _DetallesPerfilState();
}

class _DetallesPerfilState extends State<DetallesPerfil> {
  // final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  late Map<String, String?> _errores;
  late InicioSesionModelo _inicioSesionModelo;

  @override
  void initState() {
    super.initState();
    _inicioSesionModelo = InicioSesionModelo();
    _controllers = {
      'nombre': TextEditingController(text: widget.datosUsuario['nombre'] ?? ''),
      'apellidos':
          TextEditingController(text: widget.datosUsuario['apellidos'] ?? ''),
      'nombre_usuario': TextEditingController(
          text: widget.datosUsuario['nombre_usuario'] ?? ''),
      'email': TextEditingController(text: Supabase.instance.client.auth.currentUser?.email ?? widget.datosUsuario['email'] ?? ''), // Prioritize current auth email
      'contrasena': TextEditingController(), // Contraseña no se precarga
    };
    _errores = {};
  }

  void _mostrarMensaje(BuildContext scaffoldContext, String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? CupertinoColors.destructiveRed : CupertinoColors.activeGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
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
            context, (columna, nuevoValor) async {
              try {
                await widget.onCampoActualizado(columna, nuevoValor);
                if (mounted) {
                  setState(() {
                    _errores[columna] = null;
                    _controllers[columna]!.text = nuevoValor;
                  });
                }
                _mostrarMensaje(context, "Campo actualizado correctamente.");
              } catch (e) {
                _mostrarMensaje(context, "No se pudo actualizar el campo: \n${e.toString()}", esError: true);
              }
            }, esModoOscuro),
        _construirFilaLista(
            "Apellidos",
            'apellidos',
            widget.datosUsuario['apellidos'],
            context,
            (columna, nuevoValor) async {
              try {
                await widget.onCampoActualizado(columna, nuevoValor);
                if (mounted) {
                  setState(() {
                    _errores[columna] = null;
                    _controllers[columna]!.text = nuevoValor;
                  });
                }
                _mostrarMensaje(context, "Campo actualizado correctamente.");
              } catch (e) {
                _mostrarMensaje(context, "No se pudo actualizar el campo: \n${e.toString()}", esError: true);
              }
            }, esModoOscuro),
        _construirFilaLista(
            "Nombre de usuario",
            'nombre_usuario',
            widget.datosUsuario['nombre_usuario'],
            context,
            (columna, nuevoValor) async {
              try {
                await widget.onCampoActualizado(columna, nuevoValor);
                if (mounted) {
                  setState(() {
                    _errores[columna] = null;
                    _controllers[columna]!.text = nuevoValor;
                  });
                }
                _mostrarMensaje(context, "Campo actualizado correctamente.");
              } catch (e) {
                _mostrarMensaje(context, "No se pudo actualizar el campo: \n${e.toString()}", esError: true);
              }
            }, esModoOscuro),
        _construirFilaLista(
          "Email",
          'email',
          Supabase.instance.client.auth.currentUser?.email ?? '',
          context,
          (columna, nuevoEmail) async {
            final loginModelo = InicioSesionModelo();
            try {
              await loginModelo.cambiarEmail(nuevoEmail);
              if (mounted) {
                setState(() {}); 
              }
              _mostrarMensaje(context, "Solicitud de cambio de correo electrónico procesada. Si es necesario, revisa tu bandeja de entrada para confirmar el cambio.");
            } catch (e) {
              _mostrarMensaje(context, e.toString(), esError: true);
            }
          },
          esModoOscuro,
        ),
        _construirFilaLista(
          "Contraseña",
          'contrasena',
          '', // No se muestra la contraseña actual
          context,
          (columna, nuevaContrasena) async {
            final loginModelo = InicioSesionModelo();
            try {
              await loginModelo.cambiarContrasena(nuevaContrasena);
              if (mounted) {
                setState(() {
                  _errores['contrasena'] = null;
                  _controllers['contrasena']!.clear(); // Limpiar el campo después de cambiar
                });
              }
              _mostrarMensaje(context, "Contraseña actualizada correctamente.");
            } catch (e) {
              _mostrarMensaje(context, e.toString(), esError: true);
            }
          },
          esModoOscuro,
        ),
      ],
    );
  }

  CupertinoListTile _construirFilaLista(
    String titulo,
    String nombreCampo,
    String valorActual,
    BuildContext contextoPadre,
    Future<void> Function(String columnaNombre, String nuevoValor)
        onCampoActualizado,
    bool esModoOscuro,
  ) {
    return CupertinoListTile(
      backgroundColor:
          esModoOscuro ? CupertinoColors.systemGrey5 : CupertinoColors.systemGrey6,
      title: Text(titulo,
          style: TextStyle(
              color: esModoOscuro
                  ? CupertinoColors.white
                  : CupertinoColors.black)),
      subtitle: Text(valorActual,
          style: TextStyle(
              color: esModoOscuro
                  ? CupertinoColors.lightBackgroundGray
                  : CupertinoColors.darkBackgroundGray)),
      onTap: () {
        TextEditingController controladorDialog = TextEditingController(text: valorActual);
        // Asegurarse de que _errores se limpia para este campo específico o se maneja adecuadamente
        // antes de mostrar el diálogo para evitar mostrar errores antiguos.
        if (_errores.containsKey(nombreCampo)) {
          _errores.remove(nombreCampo); // Limpiar error previo para este campo
        }

        showCupertinoDialog(
          context: contextoPadre, // Usar el contexto del padre que tiene el Navigator
          builder: (BuildContext contextoDialogo) {
            // Usar StatefulBuilder para manejar el estado del mensaje de error dentro del diálogo
            return StatefulBuilder(
              builder: (contextoDialogoInterno, setStateDialog) {
                return CupertinoAlertDialog(
                  title: Text('Editar $titulo'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoTextField(
                        controller: controladorDialog,
                        placeholder: 'Nuevo $titulo',
                        autofocus: true,
                        obscureText: nombreCampo == 'contrasena',
                        onChanged: (value) {
                          // Limpiar el error cuando el usuario comienza a escribir
                          if (_errores[nombreCampo] != null) {
                            setStateDialog(() {
                              _errores.remove(nombreCampo);
                            });
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
                      onPressed: () => Navigator.pop(contextoDialogo),
                    ),
                    CupertinoDialogAction(
                      child: const Text("Aceptar"),
                      onPressed: () async {
                        final nuevoValor = controladorDialog.text.trim();
                        // Si el campo es email o contraseña, usar InicioSesionModelo
                        if (nombreCampo == 'email') {
                          try {
                            // La comprobación de proveedor de Google ahora está en InicioSesionModelo
                            await _inicioSesionModelo.cambiarEmail(nuevoValor); // Corregido: sin contextoPadre
                            Navigator.pop(contextoDialogo); // Cerrar diálogo primero
                            _mostrarMensaje(contextoPadre, "Solicitud de cambio de correo procesada. Revisa tu bandeja de entrada.");
                            onCampoActualizado(nombreCampo, nuevoValor); // Actualizar UI localmente si es necesario
                          } catch (e) {
                            setStateDialog(() {
                              _errores[nombreCampo] = e.toString().replaceFirst("Exception: ", "");
                            });
                          }
                        } else if (nombreCampo == 'contrasena') {
                          try {
                            // La comprobación de proveedor de Google ahora está en InicioSesionModelo
                            await _inicioSesionModelo.cambiarContrasena(nuevoValor); // Corregido: sin contextoPadre
                            Navigator.pop(contextoDialogo);
                            _mostrarMensaje(contextoPadre, "Contraseña actualizada correctamente.");
                            // No se llama a onCampoActualizado para la contraseña, ya que no se muestra
                          } catch (e) {
                            setStateDialog(() {
                              _errores[nombreCampo] = e.toString().replaceFirst("Exception: ", "");
                            });
                          }
                        } else {
                          // Para otros campos (nombre, apellidos, nombre_usuario)
                          final error = await _validarCampo(nombreCampo, nuevoValor);
                          if (error == null) {
                            await onCampoActualizado(nombreCampo, nuevoValor);
                            Navigator.pop(contextoDialogo);
                            _mostrarMensaje(contextoPadre, "$titulo actualizado correctamente.");
                          } else {
                            setStateDialog(() {
                              _errores[nombreCampo] = error;
                            });
                          }
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      }, // End of onTap
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
      case 'email':
        if (valor.isEmpty) return 'El correo electrónico no puede estar vacío.';
        if (!valor.contains('@') || !valor.contains('.')) {
          return 'Formato de correo electrónico incorrecto.';
        }
        break;
    }
    return null;
  }
}
