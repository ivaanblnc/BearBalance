import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/grafico_paginaInicial.dart';
import 'package:tfg_ivandelllanoblanco/components/mensaje_listametas_vacia.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:tfg_ivandelllanoblanco/controllers/metascontrollador.dart';
import 'package:tfg_ivandelllanoblanco/entitdades/Ahorros.dart';
import '../components/lista_metas.dart';

class PaginaInicioContenido extends StatelessWidget {
  final List<Map<String, dynamic>> metas;
  final List<Map<String, dynamic>> ahorros;
  final Map<String, dynamic>? datosusuario;
  final MetasControlador controladorMetas;
  final AhorrosControlador controladorAhorros;
  final String nombreUsuario;
  final Function() onPerfilTap;

  const PaginaInicioContenido({
    required this.metas,
    required this.ahorros,
    required this.datosusuario,
    required this.controladorMetas,
    required this.controladorAhorros,
    required this.nombreUsuario,
    required this.onPerfilTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final totalIngresos = controladorAhorros.calcularTotalIngresos(ahorros);
    final totalGastos = controladorAhorros.calcularTotalGastos(ahorros);
    final saldoActual = controladorAhorros.calcularSaldoActual(ahorros);

    List<Ahorros> listaAhorros = ahorros.map((item) {
      return Ahorros(
        fecha: DateTime.parse(item['fecha_registro']),
        ingresos: item['tipo'] == 'ingreso'
            ? (item['cantidad'] as num).toDouble()
            : 0.0,
        gastos: item['tipo'] == 'gasto'
            ? (item['cantidad'] as num).toDouble()
            : 0.0,
        saldo: 0.0,
      );
    }).toList();

    double currentSaldo = 0.0;
    for (var ahorro in listaAhorros) {
      currentSaldo += ahorro.ingresos - ahorro.gastos;
      ahorro.saldo = currentSaldo;
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido ',
              style: const TextStyle(color: CupertinoColors.black),
            ),
            Text(nombreUsuario,
                style: const TextStyle(color: CupertinoColors.link)),
          ],
        ),
        trailing: GestureDetector(
          onTap: onPerfilTap,
          child: CircleAvatar(
            backgroundImage:
                datosusuario != null && datosusuario?['imagen_perfil'] != null
                    ? NetworkImage(datosusuario?['imagen_perfil'])
                    : null,
            child:
                datosusuario == null || datosusuario?['imagen_perfil'] == null
                    ? const Icon(Icons.account_circle_outlined)
                    : null,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Saldo Actual: ${saldoActual.toStringAsFixed(2)} €",
                    style: TextStyle(color: CupertinoColors.activeBlue)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Rendimiento: ",
                  style: TextStyle(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Flexible(child: GraficoAhorros(ahorrosList: listaAhorros)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            if (metas.isEmpty)
              MensajeVacioMetas(
                  mostrarIcono: false,
                  mostrarTextoSecundario: false,
                  mostrarBoton: false)
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.flag_circle),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Metas",
                          style: TextStyle(fontSize: 18, color: Colors.blue)),
                    )
                  ],
                ),
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Flexible(
                child: ListaMetas(metas: metas, controlador: controladorMetas)),
          ],
        ),
      ),
    );
  }

  Future<ImageProvider?> _cargarImagen(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) {
      return null;
    }

    print('URL de la imagen: $imageUrl');

    try {
      return NetworkImage(imageUrl);
    } catch (e) {
      print('Error al cargar la imagen: $e');
      return null;
    }
  }
}
