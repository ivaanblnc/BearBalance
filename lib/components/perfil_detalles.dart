import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';

class DetallesPerfil extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final proveedorTema = Provider.of<CambiarTema>(context);
    final esModoOscuro = proveedorTema.modoOscuro;

    return CupertinoListSection.insetGrouped(
      backgroundColor:
          esModoOscuro ? CupertinoColors.black : CupertinoColors.white,
      header: const Text("Información del Perfil"),
      children: [
        _construirFilaLista("Nombre", datosUsuario['nombre'], contexto,
            onCampoActualizado, esModoOscuro),
        _construirFilaLista("Apellidos", datosUsuario['apellidos'], contexto,
            onCampoActualizado, esModoOscuro),
        _construirFilaLista("Nombre de usuario", datosUsuario['nombre_usuario'],
            contexto, onCampoActualizado, esModoOscuro),
        _construirFilaLista("Email", datosUsuario['correo_electronico'],
            contexto, onCampoActualizado, esModoOscuro),
        _construirFilaLista("Contraseña", datosUsuario['contrasena'], contexto,
            onCampoActualizado, esModoOscuro),
      ],
    );
  }

  CupertinoListTile _construirFilaLista(
    String titulo,
    String valor,
    BuildContext contexto,
    Future<void> Function(String columnaNombre, String nuevoValor)
        onCampoActualizado,
    bool esModoOscuro,
  ) {
    TextEditingController controlador = TextEditingController(text: valor);
    final colorFilaOscuro = const Color(0xFF1E1E1E);
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
          context: contexto,
          builder: (contextoDialogo) => CupertinoAlertDialog(
            title: Text("Editar $titulo"),
            content: CupertinoTextField(
              controller: controlador,
              placeholder: titulo,
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(contextoDialogo),
                child: const Text("Cancelar"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  String columnaNombre = titulo.toLowerCase();
                  if (columnaNombre == 'nombre de usuario') {
                    columnaNombre = 'nombre_usuario';
                  }
                  if (columnaNombre == 'contraseña') {
                    columnaNombre = 'contrasena';
                  } else if (columnaNombre == 'email') {
                    columnaNombre = 'correo_electronico';
                  }
                  onCampoActualizado(columnaNombre, controlador.text);
                  Navigator.pop(contextoDialogo);
                },
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );
      },
    );
  }
}
