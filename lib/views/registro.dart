import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';
import 'package:tfg_ivandelllanoblanco/controllers/registroUsuarios.dart';
import 'package:tfg_ivandelllanoblanco/views/InicioDeSesion.dart';

class RegistroVista extends StatefulWidget {
  const RegistroVista({super.key});

  @override
  State<RegistroVista> createState() => _RegistroVistaState();
}

class _RegistroVistaState extends State<RegistroVista> {
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
    final proveedorTema = Provider.of<CambiarTema>(context);
    final esModoOscuro = proveedorTema.modoOscuro;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: esModoOscuro ? Colors.white : Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text("¿Estás seguro de que quieres salir?"),
                  content: Text("Perderás los datos introducidos."),
                  actions: [
                    TextButton(
                      child: Text("No"),
                      onPressed: () => Navigator.of(dialogContext).pop(), 
                    ),
                    TextButton(
                      child: Text("Si", style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close dialog first
                        Navigator.pushReplacement( 
                          context,
                          MaterialPageRoute(
                            builder: (context) => InicioSesion(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: Text("Registro", style: TextStyle(color: const Color(0xFF007AFF), fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true, 
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: controladorNombre,
                style: TextStyle(color: esModoOscuro ? Colors.white : Colors.black),
                cursorColor: const Color(0xFF007AFF),
                decoration: InputDecoration(
                  labelText: "Nombre",
                  labelStyle: TextStyle(color: esModoOscuro ? Colors.grey[400] : Colors.grey[700]),
                  filled: true,
                  fillColor: esModoOscuro ? Colors.grey[800] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: controladorApellidos,
                style: TextStyle(color: esModoOscuro ? Colors.white : Colors.black),
                cursorColor: const Color(0xFF007AFF),
                decoration: InputDecoration(
                  labelText: "Apellidos",
                  labelStyle: TextStyle(color: esModoOscuro ? Colors.grey[400] : Colors.grey[700]),
                  filled: true,
                  fillColor: esModoOscuro ? Colors.grey[800] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: controladorCorreoElectronico,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: esModoOscuro ? Colors.white : Colors.black),
                cursorColor: const Color(0xFF007AFF),
                decoration: InputDecoration(
                  labelText: "Correo electrónico",
                  labelStyle: TextStyle(color: esModoOscuro ? Colors.grey[400] : Colors.grey[700]),
                  filled: true,
                  fillColor: esModoOscuro ? Colors.grey[800] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: controladorNombreUsuario,
                style: TextStyle(color: esModoOscuro ? Colors.white : Colors.black),
                cursorColor: const Color(0xFF007AFF),
                decoration: InputDecoration(
                  labelText: "Nombre de usuario",
                  labelStyle: TextStyle(color: esModoOscuro ? Colors.grey[400] : Colors.grey[700]),
                  filled: true,
                  fillColor: esModoOscuro ? Colors.grey[800] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: controladorContrasena,
                obscureText: true,
                style: TextStyle(color: esModoOscuro ? Colors.white : Colors.black),
                cursorColor: const Color(0xFF007AFF),
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  labelStyle: TextStyle(color: esModoOscuro ? Colors.grey[400] : Colors.grey[700]),
                  filled: true,
                  fillColor: esModoOscuro ? Colors.grey[800] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF), // Cupertino Blue
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
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
