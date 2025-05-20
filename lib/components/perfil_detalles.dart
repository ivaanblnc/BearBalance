import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_ivandelllanoblanco/models/loginUsuario.dart';

class DetallesPerfil extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;
  final Future<void> Function(String columnaNombre, String nuevoValor)
      onCampoActualizado;
  final BuildContext contexto; // Contexto de PerfilUsuario para ScaffoldMessenger

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
      'email': TextEditingController(text: Supabase.instance.client.auth.currentUser?.email ?? widget.datosUsuario['email'] ?? ''),
      'contrasena': TextEditingController(), 
    };
    _errores = {};
  }

  void _mostrarMensaje(BuildContext scaffoldContext, String mensaje, {bool esError = false}) {
    showCupertinoDialog(
      context: scaffoldContext, 
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(esError ? 'Error' : 'Información'),
          content: Text(mensaje),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); 
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
    if (nombreCampo == 'contrasena') {
        if (valor.isEmpty && !_inicioSesionModelo.esUsuarioGoogle()) return 'La contraseña no puede estar vacía.';
        if (valor.isNotEmpty && valor.length < 6 && !_inicioSesionModelo.esUsuarioGoogle()) return 'La contraseña debe tener al menos 6 caracteres.';
    }
    return null;
  }

  Widget _construirFormularioFila(
    String etiqueta, // e.g., "Nombre"
    String nombreCampo, // e.g., 'nombre'
    TextEditingController valorController, // Controller for current value
    BuildContext contextoDialogoSuperior, // Context from PerfilUsuario for dialogs
    Future<void> Function(String columnaNombre, String nuevoValor) onCampoActualizado,
  ) {
    final esModoOscuroLocal = CupertinoTheme.of(context).brightness == Brightness.dark;

    return CupertinoFormRow(
      prefix: Padding(
        padding: const EdgeInsets.only(right: 16.0), // Espacio entre etiqueta y valor
        child: Text(
          etiqueta,
          style: TextStyle(
            color: esModoOscuroLocal
                ? CupertinoColors.systemGrey
                : CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          TextEditingController controladorDialog = TextEditingController(text: (nombreCampo == 'contrasena' ? '' : valorController.text));
          if (_errores.containsKey(nombreCampo)) {
            _errores.remove(nombreCampo);
          }

          showCupertinoDialog(
            context: contextoDialogoSuperior, // Usar el contexto pasado desde PerfilUsuario
            builder: (BuildContext contextoDialogoInterno) {
              return StatefulBuilder( // Para actualizar el mensaje de error dentro del diálogo
                builder: (context, setStateDialog) {
                  return CupertinoAlertDialog(
                    title: Text('Editar $etiqueta'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoTextField(
                          controller: controladorDialog,
                          placeholder: (nombreCampo == 'contrasena' ? 'Nueva contraseña' : 'Nuevo $etiqueta'),
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
                                if (mounted) setState(() { valorController.clear(); }); // Clear password field
                                opSuccess = true;
                              } else {
                                await onCampoActualizado(nombreCampo, nuevoValor);
                                if (mounted) setState(() { valorController.text = nuevoValor; });
                                opSuccess = true;
                              }
                            } catch (e) {
                              errorMsg = e.toString().replaceFirst("Exception: ", "");
                            }
                          }

                          if (opSuccess) {
                            Navigator.pop(contextoDialogoInterno); // Cierra el diálogo de edición
                            if (nombreCampo == 'email') _mostrarMensaje(contextoDialogoSuperior, "Solicitud de cambio de correo procesada. Revisa tu bandeja de entrada.");
                            else if (nombreCampo == 'contrasena') _mostrarMensaje(contextoDialogoSuperior, "Contraseña actualizada correctamente.");
                            else _mostrarMensaje(contextoDialogoSuperior, "$etiqueta actualizado correctamente.");
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
        child: Container( // Contenedor para el valor, para padding y alineación
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12.0), // Ajusta según sea necesario
          alignment: Alignment.centerRight, // Alinea el texto del valor a la derecha
          child: Text(
            nombreCampo == 'contrasena'
                ? (valorController.text.isNotEmpty ? "••••••••" : "Establecer contraseña")
                : valorController.text,
            style: TextStyle(
              color: esModoOscuroLocal
                  ? CupertinoColors.white
                  : CupertinoColors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoFormSection.insetGrouped(
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        header: Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 20.0),
          child: Text(
            "Información del Perfil",
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          _construirFormularioFila(
              'Nombre',
              'nombre',
              _controllers['nombre']!,
              widget.contexto, 
              widget.onCampoActualizado,
          ),
          _construirFormularioFila(
              'Apellidos',
              'apellidos',
              _controllers['apellidos']!,
              widget.contexto,
              widget.onCampoActualizado,
          ),
          _construirFormularioFila(
              'Nombre de usuario',
              'nombre_usuario',
              _controllers['nombre_usuario']!,
              widget.contexto,
              widget.onCampoActualizado,
          ),
          _construirFormularioFila(
              'Email',
              'email',
              _controllers['email']!,
              widget.contexto,
              (columna, nuevoValor) async { /* Email/Pass se manejan en dialog */ },
          ),
          _construirFormularioFila(
              'Contraseña',
              'contrasena',
              _controllers['contrasena']!,
              widget.contexto,
              (columna, nuevoValor) async { /* Email/Pass se manejan en dialog */ },
          ),
        ],
      ),
    );
  }
}
