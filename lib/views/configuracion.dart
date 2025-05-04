import 'package:flutter/cupertino.dart';
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

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        // Botón de retroceso para salir de la pantalla de configuración
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 24.0,
            color: Colors.indigoAccent,
          ),
          onPressed: () {
            // Navegamos hacia atrás
            Navigator.pop(context);
          },
        ),
        middle: Text('Configuración'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Modo Oscuro', style: TextStyle(fontSize: 17)),

                  // Interruptor para activar o desactivar el modo oscuro
                  CupertinoSwitch(
                    value: themeProvider.modoOscuro,
                    onChanged: (value) {
                      // Cambiamos el valor del modo oscuro cuando el usuario interactúa
                      themeProvider.switchModoOscuro(value);
                    },
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
