import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';

// Pantalla de configuración donde se permite cambiar el tema de la app
class ConfiguracionPantalla extends StatelessWidget {
  const ConfiguracionPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el proveedor del tema para acceder al estado actual
    final themeProvider = Provider.of<CambiarTema>(context);

    return Scaffold(
      appBar: AppBar(
        // AppBar will automatically add a back button if appropriate.
        // If explicit control is needed, use: leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Configuración'),
        elevation: 0, // Optional: for a flatter look like CupertinoNavigationBar
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Optional: to match scaffold
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Modo Oscuro', style: TextStyle(fontSize: 17)),

                  // Interruptor para activar o desactivar el modo oscuro
                  Switch(
                    value: themeProvider.modoOscuro,
                    onChanged: (value) {
                      // Cambiamos el valor del modo oscuro cuando el usuario interactúa
                      themeProvider.switchModoOscuro(value);
                    },
                    activeColor: Theme.of(context).colorScheme.primary, // Optional: to style the switch
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
