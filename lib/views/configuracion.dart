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
        title: Text('Configuración'),
        elevation: 0,
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
                  Switch(
                    value: themeProvider.modoOscuro,
                    onChanged: (value) {
                      themeProvider.switchModoOscuro(value);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
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
