import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/components/grafico_paginaInicial.dart';
import 'package:tfg_ivandelllanoblanco/components/mensaje_listametas_vacia.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';
import 'package:tfg_ivandelllanoblanco/controllers/metascontrollador.dart';
import 'package:tfg_ivandelllanoblanco/entidades/Ahorros.dart';
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

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                children: <TextSpan>[
                  TextSpan(text: 'Hola, '),
                  TextSpan(
                      text: nombreUsuario,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ),
          ),
        ),
        title: Text(''),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: onPerfilTap,
              child: CircleAvatar(
                backgroundImage: datosusuario != null &&
                        datosusuario?['imagen_perfil'] != null
                    ? NetworkImage(datosusuario!['imagen_perfil'])
                    : null,
                child: datosusuario == null ||
                        datosusuario?['imagen_perfil'] == null
                    ? const Icon(Icons.account_circle_outlined)
                    : null,
              ),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Saldo Actual: ${saldoActual.toStringAsFixed(2)} €",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GraficoPrincipal(ahorrosList: listaAhorros)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              if (metas.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MensajeVacioMetas(
                      mostrarIcono: false,
                      mostrarTextoSecundario: false,
                      mostrarBoton: false),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(Icons.flag_circle,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        "Metas",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    ],
                  ),
                ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListaMetas(
                  metas: metas,
                  controlador: controladorMetas,
                  isNested: true,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
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
