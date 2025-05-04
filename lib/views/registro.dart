import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';
import 'package:tfg_ivandelllanoblanco/controllers/registroUsuarios.dart';
import 'package:tfg_ivandelllanoblanco/views/InicioDeSesion.dart';

/// Vista para la pantalla de registro de un nuevo usuario.
class RegistroVista extends StatefulWidget {
  const RegistroVista({super.key});

  @override
  _RegistroVistaState createState() => _RegistroVistaState();
}

class _RegistroVistaState extends State<RegistroVista> {
  // Controladores de texto para los campos de entrada de datos del formulario.
  final RegistroControlador controlador = RegistroControlador();
  final TextEditingController controladorNombre = TextEditingController();
  final TextEditingController controladorApellidos = TextEditingController();
  final TextEditingController controladorCorreoElectronico =
      TextEditingController();
  final TextEditingController controladorNombreUsuario =
      TextEditingController();
  final TextEditingController controladorContrasena = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Obtenemos el estado del modo oscuro desde el proveedor CambiarTema.
    final proveedorTema = Provider.of<CambiarTema>(context);
    final esModoOscuro = proveedorTema.modoOscuro;

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: esModoOscuro ? Brightness.dark : Brightness.light,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 24.0,
              color: esModoOscuro ? CupertinoColors.white : Colors.indigoAccent,
            ),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (builder) {
                  return CupertinoAlertDialog(
                    title: Text(
                      "¿Estás seguro de que quieres salir?",
                      style: TextStyle(
                          color: esModoOscuro
                              ? CupertinoColors.white
                              : CupertinoColors.black),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text("No",
                            style: TextStyle(
                                color: esModoOscuro
                                    ? CupertinoColors.white
                                    : CupertinoColors.black)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoDialogAction(
                        child: Text("Si",
                            style: TextStyle(
                                color: CupertinoColors.destructiveRed)),
                        onPressed: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => InicioSesion(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          middle: Text("Registro",
              style: TextStyle(
                  color: esModoOscuro
                      ? CupertinoColors.white
                      : CupertinoColors.black)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Campo para ingresar el nombre del usuario.
              CupertinoTextField(
                controller: controladorNombre,
                placeholder: "Nombre",
                padding: EdgeInsets.all(12),
                style: TextStyle(
                    color: esModoOscuro
                        ? CupertinoColors.white
                        : CupertinoColors.black),
                placeholderStyle: TextStyle(color: CupertinoColors.systemGrey3),
                decoration: BoxDecoration(
                  color: esModoOscuro
                      ? const Color(0xFF1E1E1E)
                      : CupertinoColors.white,
                  border: Border.all(color: CupertinoColors.systemGrey4),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: 15),
              // Campo para ingresar los apellidos del usuario.
              CupertinoTextField(
                controller: controladorApellidos,
                placeholder: "Apellidos",
                padding: EdgeInsets.all(12),
                style: TextStyle(
                    color: esModoOscuro
                        ? CupertinoColors.white
                        : CupertinoColors.black),
                placeholderStyle: TextStyle(color: CupertinoColors.systemGrey3),
                decoration: BoxDecoration(
                  color: esModoOscuro
                      ? const Color(0xFF1E1E1E)
                      : CupertinoColors.white,
                  border: Border.all(color: CupertinoColors.systemGrey4),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: 15),
              // Campo para ingresar el correo electrónico del usuario.
              CupertinoTextField(
                controller: controladorCorreoElectronico,
                placeholder: "Correo electrónico",
                padding: EdgeInsets.all(12),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    color: esModoOscuro
                        ? CupertinoColors.white
                        : CupertinoColors.black),
                placeholderStyle: TextStyle(color: CupertinoColors.systemGrey3),
                decoration: BoxDecoration(
                  color: esModoOscuro
                      ? const Color(0xFF1E1E1E)
                      : CupertinoColors.white,
                  border: Border.all(color: CupertinoColors.systemGrey4),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: 15),
              // Campo para ingresar el nombre de usuario.
              CupertinoTextField(
                controller: controladorNombreUsuario,
                placeholder: "Nombre de usuario",
                padding: EdgeInsets.all(12),
                style: TextStyle(
                    color: esModoOscuro
                        ? CupertinoColors.white
                        : CupertinoColors.black),
                placeholderStyle: TextStyle(color: CupertinoColors.systemGrey3),
                decoration: BoxDecoration(
                  color: esModoOscuro
                      ? const Color(0xFF1E1E1E)
                      : CupertinoColors.white,
                  border: Border.all(color: CupertinoColors.systemGrey4),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: 15),
              // Campo para ingresar la contraseña.
              CupertinoTextField(
                controller: controladorContrasena,
                placeholder: "Contraseña",
                obscureText: true,
                padding: EdgeInsets.all(12),
                style: TextStyle(
                    color: esModoOscuro
                        ? CupertinoColors.white
                        : CupertinoColors.black),
                placeholderStyle: TextStyle(color: CupertinoColors.systemGrey3),
                decoration: BoxDecoration(
                  color: esModoOscuro
                      ? const Color(0xFF1E1E1E)
                      : CupertinoColors.white,
                  border: Border.all(color: CupertinoColors.systemGrey4),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: 30),
              // Botón para registrar al usuario
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () async {
                    await controlador.registrarUsuario(
                      controladorNombre.text,
                      controladorApellidos.text,
                      controladorCorreoElectronico.text,
                      controladorNombreUsuario.text,
                      controladorContrasena.text,
                      context,
                    );
                  },
                  child: Text("Registrarse"),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
