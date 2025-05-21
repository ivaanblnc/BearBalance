import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/filtrar_movimientos.dart';
import 'package:tfg_ivandelllanoblanco/components/grafico_ahorro.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:tfg_ivandelllanoblanco/components/movimientos.dart';
import 'package:tfg_ivandelllanoblanco/components/resumen_saldo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Pantalla principal donde se muestra el rendimiento económico (Material Design)
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
  DateTime? _fechaFiltroActivo; // Para rastrear la fecha del filtro activo

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
      await _cargarAhorros(); // Carga todos los movimientos
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
        // Assuming fecha_registro from Supabase is a String in ISO 8601 format
        if (mov['fecha_registro'] is String) {
          fechaMovimiento = DateTime.parse(mov['fecha_registro'] as String);
        } else {
          // If fecha_registro is not a String, log or skip
          // print('Fecha_registro no es String: ${mov['fecha_registro']}');
          continue;
        }

        if (fechaMovimiento.year == ahora.year && fechaMovimiento.month == ahora.month) {
          if (mov['tipo'] == 'ingreso') {
            ingresosMesActual += (mov['cantidad'] as num).toDouble();
          } else if (mov['tipo'] == 'gasto') {
            gastosMesActual += (mov['cantidad'] as num).toDouble();
          }
        }
      } catch (e) {
        // Manejar el error de parseo, por ejemplo, imprimir un mensaje.
        // print('Error parseando fecha para cálculo mensual: ${mov['fecha_registro']} - $e');
        continue; // Saltar este movimiento si la fecha no se puede parsear
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rendimiento Económico",
          style: TextStyle(
              color: theme
                  .colorScheme.onSurface), // Adjusted for transparent AppBar
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
                _fechaFiltroActivo =
                    fechaSeleccionada; // Actualizar fecha de filtro activa
                carga = true;
              });
              try {
                if (_fechaFiltroActivo != null) {
                  listaAhorros =
                      await controlador.filtrarMovimientos(_fechaFiltroActivo!);
                } else {
                  // Si fechaSeleccionada es null (cancelado), cargamos todos los ahorros (limpia el filtro)
                  await _cargarAhorros();
                }
              } catch (e) {
                print('Error al procesar filtro de fecha: $e');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error al filtrar: ${e.toString()}')),
                  );
                  // Si hay error, asegurar que se cargan todos los datos y se limpia el filtro visual
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
                      : theme.colorScheme
                          .onSurface), // Color diferente si está activo y se puede limpiar
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
                  // New Top Structure: Row containing (Column for Cards) and (Chart)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.28, // Increased from 0.25
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to fill height
                      children: [
                        // Left side: Column for Saldo Total Card and SaldoResumen Carousel
                        Expanded(
                          flex: 5, // Adjust flex as needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Top-Left: Saldo Total Card
                              Expanded(
                                flex: 2, // Smaller portion for saldo total
                                child: Card(
                                  elevation: 1,
                                  margin: const EdgeInsets.only(bottom: 4.0), // Reduced bottom margin
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0), // Reduced padding
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Saldo total:",
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                        ),
                                        Text(
                                          "${saldoActual.toStringAsFixed(2)} €",
                                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom-Left: SaldoResumen Carousel Card
                              Expanded(
                                flex: 3, // Larger portion for the carousel
                                child: SaldoResumen(
                                  // saldoActual is no longer passed here
                                  totalIngresos: totalIngresos,
                                  totalGastos: totalGastos,
                                  ingresosMesActual: ingresosMesActual,
                                  gastosMesActual: gastosMesActual,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0), // Space between left column and right chart
                        // Right side: CompactFinanceChart
                        Expanded(
                          flex: 4, // Adjust flex as needed
                          child: CompactFinanceChart(
                            transacciones: listaAhorros.map((mov) {
                              return {
                                'fecha': mov['fecha_registro'],
                                'monto': mov['cantidad'],
                                'tipo': mov['tipo'],
                              };
                            }).toList(),
                            saldoTotal: saldoActual, // Added back: Pass saldoActual from AhorrosVista
                            ingresos: totalIngresos, 
                            gastos: totalGastos,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0), // Espacio antes de DetalleMovimientos
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
                color: Colors.black
                    .withOpacity(0.1), // Fondo semitransparente para el loader
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
