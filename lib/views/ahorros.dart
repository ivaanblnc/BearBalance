// Importaciones necesarias
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/filtrar_movimientos.dart';
import 'package:tfg_ivandelllanoblanco/components/grafico_rendimiento.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:tfg_ivandelllanoblanco/components/movimientos.dart';
import 'package:tfg_ivandelllanoblanco/components/resumen_saldo.dart';

// Pantalla principal donde se muestra el rendimiento económico
class AhorrosVista extends StatefulWidget {
  const AhorrosVista({super.key});

  @override
  AhorrosVistaState createState() => AhorrosVistaState();
}

class AhorrosVistaState extends State<AhorrosVista> {
  // Controlador que gestiona los datos de ahorros
  final AhorrosControlador controlador = AhorrosControlador();

  // Lista de movimientos
  List<Map<String, dynamic>> listaAhorros = [];

  // Variable para mostrar spinner de carga
  bool carga = false;

  // Carga inicial de los datos al iniciar la vista
  @override
  void initState() {
    super.initState();
    _cargarAhorros();
  }

  // Método que obtiene los ahorros desde el controlador
  Future<void> _cargarAhorros() async {
    setState(() {});
    try {
      listaAhorros = await controlador.obtenerAhorros();
    } finally {
      // Forzamos la actualización de la UI
      setState(() {
        listaAhorros = listaAhorros;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cálculos de totales usando el controlador
    final totalIngresos = controlador.calcularTotalIngresos(listaAhorros);
    final totalGastos = controlador.calcularTotalGastos(listaAhorros);
    final saldoActual = controlador.calcularSaldoActual(listaAhorros);

    // Ordenamos los movimientos por fecha descendente
    listaAhorros.sort((a, b) {
      DateTime fechaA = DateTime.parse(a['fecha_registro']);
      DateTime fechaB = DateTime.parse(b['fecha_registro']);
      return fechaB.compareTo(fechaA);
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 50),
            Text("Rendimiento Económico",
                style: TextStyle(color: CupertinoColors.activeBlue)),
            CupertinoButton(
              // Botón para seleccionar fecha y filtrar movimientos
              onPressed: () async {
                DateTime? fecha =
                    await SelectorFechaDialogo.mostrarDialogoFecha(
                  context,
                  controlador,
                );
                if (fecha != null) {
                  setState(() {
                    carga = true;
                  });
                  try {
                    listaAhorros = await controlador.filtrarMovimientos(fecha);
                  } finally {
                    setState(() {
                      carga = false;
                    });
                  }
                }
              },
              child: Icon(Icons.filter_alt),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                Row(
                  children: [
                    //Mostramos el componente saldo resumen
                    Expanded(
                      child: SaldoResumen(
                        saldoActual: saldoActual,
                        totalIngresos: totalIngresos,
                        totalGastos: totalGastos,
                      ),
                    ),
                    //Mostramos el componente grafico
                    Expanded(
                      child: GraficoRendimiento(
                        ahorros: listaAhorros,
                        saldoActual: saldoActual,
                      ),
                    ),
                  ],
                ),

                //Mostramos el componente detalles de movimientos
                Expanded(
                  child: DetalleMovimientos(
                    ahorros: listaAhorros,
                    cargarAhorros: _cargarAhorros,
                    controlador: controlador,
                  ),
                ),
              ],
            ),

            // Spinner de carga mientras se cargan los datos
            if (carga) Center(child: CupertinoActivityIndicator()),
          ],
        ),
      ),
    );
  }
}
