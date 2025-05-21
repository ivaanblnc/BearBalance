import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';

class NuevoAhorroGastoVista extends StatefulWidget {
  const NuevoAhorroGastoVista({super.key});

  @override
  NuevoAhorroGastoVistaState createState() => NuevoAhorroGastoVistaState();
}

class NuevoAhorroGastoVistaState extends State<NuevoAhorroGastoVista> {
  final AhorrosControlador controlador = AhorrosControlador();
  String _tipo = 'ingreso';
  double _cantidad = 0.0;
  DateTime _fechaRegistro = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String? _cantidadErrorText;
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();

  @override
  void dispose() {
    _cantidadController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final InputDecoration modernInputDecoration = InputDecoration(
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      labelStyle:
          TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8)),
      errorStyle: TextStyle(color: theme.colorScheme.error),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Movimiento'),
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SegmentedButton<String>(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                        value: 'ingreso',
                        label: Text('Ingreso'),
                        icon: Icon(Icons.arrow_downward)),
                    ButtonSegment<String>(
                        value: 'gasto',
                        label: Text('Gasto'),
                        icon: Icon(Icons.arrow_upward)),
                  ],
                  selected: <String>{_tipo},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _tipo = newSelection.first;
                      if (_tipo == 'ingreso') {
                        _categoriaController.clear();
                      }
                    });
                  },
                  style: SegmentedButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    selectedForegroundColor: theme.colorScheme.onPrimary,
                    selectedBackgroundColor: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _cantidadController,
                  decoration: modernInputDecoration.copyWith(
                    labelText: 'Cantidad',
                    errorText: _cantidadErrorText,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  onChanged: (value) {
                    setState(() {
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                      } else {
                        _cantidad = parsed;
                        _cantidadErrorText = null;
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _cantidadErrorText = 'Introduce una cantidad.';
                      return _cantidadErrorText;
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null) {
                      _cantidadErrorText = 'Introduce un número válido.';
                      return _cantidadErrorText;
                    }
                    if (parsed <= 0) {
                      _cantidadErrorText = 'La cantidad debe ser mayor que 0.';
                      return _cantidadErrorText;
                    }
                    _cantidad = parsed;
                    _cantidadErrorText = null;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (_tipo == 'gasto')
                  TextFormField(
                    controller: _categoriaController,
                    decoration: modernInputDecoration.copyWith(
                        labelText: 'Descripción (opcional)'),
                  ),
                if (_tipo == 'gasto') const SizedBox(height: 16),
                TextButton.icon(
                  icon: Icon(Icons.calendar_today,
                      color: theme.colorScheme.primary),
                  label: Text(
                    'Fecha: ${DateFormat('dd/MM/yyyy').format(_fechaRegistro.toLocal())}',
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _fechaRegistro,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      helpText: 'SELECCIONAR FECHA',
                      cancelText: 'CANCELAR',
                      confirmText: 'ACEPTAR',
                      builder: (context, child) {
                        return Theme(
                          data: theme.copyWith(
                            colorScheme: theme.colorScheme.copyWith(
                              primary: theme.colorScheme.primary,
                              onPrimary: theme.colorScheme.onPrimary,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null && picked != _fechaRegistro) {
                      setState(() {
                        _fechaRegistro = picked;
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0)),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary),
                  ),
                  child: const Text('Guardar'),
                  onPressed: () async {
                    final currentCantidadText = _cantidadController.text;
                    final parsedCantidad = double.tryParse(currentCantidadText);
                    if (parsedCantidad != null) {
                      _cantidad = parsedCantidad;
                    } else {
                      _cantidad = 0;
                    }

                    if (_formKey.currentState!.validate()) {
                      final String? categoriaParaGuardar = _tipo == 'ingreso'
                          ? null
                          : _categoriaController.text.trim();
                      final ahorro = {
                        'tipo': _tipo,
                        'cantidad': _cantidad,
                        'categoria': categoriaParaGuardar,
                        'fecha_registro': _fechaRegistro.toIso8601String(),
                      };
                      try {
                        await controlador.agregarAhorro(ahorro);
                        if (mounted) Navigator.pop(context, true);
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Error al guardar: ${e.toString()}')));
                        }
                        print('Error al guardar: $e');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
