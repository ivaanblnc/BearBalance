import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/filtrar_movimientos.dart';
import 'package:tfg_ivandelllanoblanco/components/grafico_ahorro.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:tfg_ivandelllanoblanco/components/movimientos.dart';
import 'package:tfg_ivandelllanoblanco/components/resumen_saldo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  DateTime? _fechaFiltroActivo;

  // Carga inicial de los datos al iniciar la vista
  @override
  void initState() {
    super.initState();
    _cargarAhorros();
  }

  // Método para limpiar el filtro de fecha
  Future<void> _limpiarFiltro() async {
    setState(() {
      _fechaFiltroActivo = null;
      carga = true;
    });
    try {
      await _cargarAhorros();
    } catch (e) {
      print('Error al limpiar filtro: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al limpiar filtro: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          carga = false;
        });
      }
    }
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

    final theme = Theme.of(context);

    // Calcular ingresos y gastos del mes actual
    final ahora = DateTime.now();
    double ingresosMesActual = 0;
    double gastosMesActual = 0;

    for (var mov in listaAhorros) {
      DateTime fechaMovimiento;
      try {
        if (mov['fecha_registro'] is String) {
          fechaMovimiento = DateTime.parse(mov['fecha_registro'] as String);
        } else {
          continue;
        }

        if (fechaMovimiento.year == ahora.year &&
            fechaMovimiento.month == ahora.month) {
          if (mov['tipo'] == 'ingreso') {
            ingresosMesActual += (mov['cantidad'] as num).toDouble();
          } else if (mov['tipo'] == 'gasto') {
            gastosMesActual += (mov['cantidad'] as num).toDouble();
          }
        }
      } catch (e) {
        continue;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rendimiento Económico",
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
                _fechaFiltroActivo != null
                    ? Icons.filter_alt_rounded
                    : Icons.filter_alt_outlined,
                color: theme.colorScheme.onSurface),
            tooltip: 'Filtrar por fecha',
            onPressed: () async {
              DateTime? fechaSeleccionada =
                  await SelectorFechaDialogo.mostrarDialogoFecha(
                context,
                controlador,
              );
              if (!mounted) return;
              setState(() {
                _fechaFiltroActivo = fechaSeleccionada;
                carga = true;
              });
              try {
                if (_fechaFiltroActivo != null) {
                  listaAhorros =
                      await controlador.filtrarMovimientos(_fechaFiltroActivo!);
                } else {
                  await _cargarAhorros();
                }
              } catch (e) {
                print('Error al procesar filtro de fecha: $e');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error al filtrar: ${e.toString()}')),
                  );
                  await _limpiarFiltro();
                }
              } finally {
                if (mounted) {
                  setState(() {
                    carga = false;
                  });
                }
              }
            },
          ),
          if (_fechaFiltroActivo != null)
            IconButton(
              icon: Icon(Icons.filter_alt_off_outlined,
                  color: _fechaFiltroActivo != null
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface),
              tooltip: 'Limpiar filtro',
              onPressed: _limpiarFiltro,
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.28,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Card(
                                  elevation: 1,
                                  margin: const EdgeInsets.only(bottom: 4.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Saldo total:",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant),
                                        ),
                                        Text(
                                          "${saldoActual.toStringAsFixed(2)} €",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: SaldoResumen(
                                  totalIngresos: totalIngresos,
                                  totalGastos: totalGastos,
                                  ingresosMesActual: ingresosMesActual,
                                  gastosMesActual: gastosMesActual,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          flex: 4,
                          child: GraficoAhorros(
                            transacciones: listaAhorros.map((mov) {
                              return {
                                'fecha': mov['fecha_registro'],
                                'monto': mov['cantidad'],
                                'tipo': mov['tipo'],
                              };
                            }).toList(),
                            saldoTotal: saldoActual,
                            ingresos: totalIngresos,
                            gastos: totalGastos,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: DetalleMovimientos(
                      ahorros: listaAhorros,
                      cargarAhorros: _cargarAhorros,
                      controlador: controlador,
                    ),
                  ),
                ],
              ),
            ),
            if (carga)
              Container(
                color: Colors.black.withValues(alpha: 0.1),
                child: Center(
                  child: SpinKitFadingCube(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
