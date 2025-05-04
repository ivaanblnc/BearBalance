import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tfg_ivandelllanoblanco/components/opciones_ahorro.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';
import 'package:tfg_ivandelllanoblanco/views/aniadirAhorros.dart';

class DetalleMovimientos extends StatelessWidget {
  const DetalleMovimientos({
    super.key,
    required this.ahorros,
    required this.cargarAhorros,
    required this.controlador,
  });

  final List<Map<String, dynamic>> ahorros;
  final Future<void> Function() cargarAhorros;
  final AhorrosControlador controlador;

  @override
  Widget build(BuildContext context) {
    final proveedorTema = Provider.of<CambiarTema>(context);
    final esModoOscuro = proveedorTema.modoOscuro;
    final colorTextoPrincipal =
        esModoOscuro ? CupertinoColors.white : Colors.indigoAccent;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: Row(
            children: [
              Text("Detalle de movimientos",
                  style: TextStyle(fontSize: 16, color: colorTextoPrincipal)),
              const Spacer(),
              CupertinoButton(
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    final resultado = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                const NuevoAhorroGastoVista()));
                    if (resultado != null) {
                      cargarAhorros();
                    }
                  }),
            ],
          ),
        ),
        _construirContenidoLista(context),
      ],
    );
  }

  Widget _construirContenidoLista(BuildContext context) {
    final proveedorTema = Provider.of<CambiarTema>(context);
    final esModoOscuro = proveedorTema.modoOscuro;
    final colorFondoLista =
        esModoOscuro ? CupertinoColors.black : CupertinoColors.white;
    final colorFilaLista =
        esModoOscuro ? const Color(0xFF1E1E1E) : CupertinoColors.systemGrey6;
    final colorTextoPrincipal =
        esModoOscuro ? CupertinoColors.white : CupertinoColors.black;
    final colorTextoSecundario = esModoOscuro
        ? CupertinoColors.lightBackgroundGray
        : CupertinoColors.black;

    if (ahorros.isEmpty) {
      return const Expanded(
        child: Center(child: Text("No hay datos disponibles")),
      );
    }

    return Flexible(
      child: SizedBox(
        height: 360,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: CupertinoListSection.insetGrouped(
              backgroundColor: colorFondoLista,
              children: ahorros.map((ahorro) {
                final tipoColor = ahorro['tipo'] == 'ingreso'
                    ? CupertinoColors.activeGreen
                    : CupertinoColors.systemRed;
                return CupertinoListTile(
                  backgroundColor: colorFilaLista,
                  leading: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: tipoColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    '${ahorro['tipo']} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(ahorro['fecha_registro']))}',
                    style: TextStyle(color: colorTextoPrincipal),
                  ),
                  additionalInfo: Text(
                    NumberFormat.currency(locale: 'es_ES', symbol: '€')
                        .format((ahorro['cantidad'] as num).toDouble()),
                    style: TextStyle(color: colorTextoSecundario),
                  ),
                  onTap: () => OpcionesAhorroDialog.mostrarOpcionesAhorro(
                    context,
                    ahorro,
                    controlador,
                    cargarAhorros,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
