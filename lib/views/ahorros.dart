import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/filtrar_movimientos.dart';
import 'package:tfg_ivandelllanoblanco/components/grafico_rendimiento.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:tfg_ivandelllanoblanco/components/movimientos.dart';
import 'package:tfg_ivandelllanoblanco/components/resumen_saldo.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rendimiento Económico",
          style: TextStyle(color: theme.colorScheme.onSurface), // Adjusted for transparent AppBar
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              _fechaFiltroActivo != null ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
              color: theme.colorScheme.onSurface
            ),
            tooltip: 'Filtrar por fecha',
            onPressed: () async {
              DateTime? fechaSeleccionada =
                  await SelectorFechaDialogo.mostrarDialogoFecha(
                context,
                controlador,
              );
              if (!mounted) return;
              setState(() {
                _fechaFiltroActivo = fechaSeleccionada; // Actualizar fecha de filtro activa
                carga = true;
              });
              try {
                if (_fechaFiltroActivo != null) {
                  listaAhorros = await controlador.filtrarMovimientos(_fechaFiltroActivo!);
                } else {
                  // Si fechaSeleccionada es null (cancelado), cargamos todos los ahorros (limpia el filtro)
                  await _cargarAhorros(); 
                }
              } catch (e) {
                print('Error al procesar filtro de fecha: $e');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al filtrar: ${e.toString()}')),
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
              icon: Icon(Icons.filter_alt_off_outlined, color: _fechaFiltroActivo != null ? theme.colorScheme.primary : theme.colorScheme.onSurface), // Color diferente si está activo y se puede limpiar
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Quitamos el SizedBox inicial, el AppBar ya da espacio.
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SaldoResumen(
                          saldoActual: saldoActual,
                          totalIngresos: totalIngresos,
                          totalGastos: totalGastos,
                        ),
                      ),
                      const SizedBox(width: 16.0), // Espacio entre SaldoResumen y GraficoRendimiento
                      Expanded(
                        child: CompactFinanceChart(
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
                color: Colors.black.withOpacity(0.1), // Fondo semitransparente para el loader
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
