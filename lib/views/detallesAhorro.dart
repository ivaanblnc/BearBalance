import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';

// Pantalla que muestra los detalles de un ahorro o gasto específico
class DetalleAhorroVista extends StatelessWidget {
  // Datos del ahorro que se mostrarán en la vista
  final Map<String, dynamic> ahorro;

  const DetalleAhorroVista({super.key, required this.ahorro});

  @override
  Widget build(BuildContext context) {
    // Proveedor que maneja el estado del tema
    final proveedorTema = Provider.of<CambiarTema>(context);

    // Determinamos si estamos en modo oscuro o claro
    final esModoOscuro = proveedorTema.modoOscuro;

    // Colores de fondo y texto según el tema de la interfaz
    final colorFondo =
        esModoOscuro ? CupertinoColors.black : CupertinoColors.white;
    final colorTextoPrincipal =
        esModoOscuro ? CupertinoColors.white : CupertinoColors.black;

    // Formato para las fechas y la cantidad de dinero
    final formatoFecha = DateFormat('dd/MM/yyyy HH:mm');
    final formatoMoneda = NumberFormat.currency(locale: 'es_ES', symbol: '€');

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Detalles del Movimiento',
            style: TextStyle(color: CupertinoColors.activeBlue)),
        backgroundColor: colorFondo,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child:
              Icon(Icons.arrow_back_ios_new, color: CupertinoColors.activeBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Tipo:',
                  style: TextStyle(fontSize: 18, color: colorTextoPrincipal)),
              Text(ahorro['tipo'] == 'ingreso' ? 'Ingreso' : 'Gasto',
                  style: TextStyle(fontSize: 16, color: colorTextoPrincipal)),
              const SizedBox(height: 15),
              Text('Fecha:',
                  style: TextStyle(fontSize: 18, color: colorTextoPrincipal)),
              Text(
                  formatoFecha.format(
                      DateTime.parse(ahorro['fecha_registro']).toLocal()),
                  style: TextStyle(fontSize: 16, color: colorTextoPrincipal)),
              const SizedBox(height: 15),
              Text('Cantidad:',
                  style: TextStyle(fontSize: 18, color: colorTextoPrincipal)),
              Text(formatoMoneda.format((ahorro['cantidad'] as num).toDouble()),
                  style: TextStyle(fontSize: 16, color: colorTextoPrincipal)),
              if (ahorro['tipo'] == 'gasto' &&
                  ahorro['categoria'] != null &&
                  ahorro['categoria'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Categoría:',
                          style: TextStyle(
                              fontSize: 18, color: colorTextoPrincipal)),
                      Text(ahorro['categoria'],
                          style: TextStyle(
                              fontSize: 16, color: colorTextoPrincipal)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
