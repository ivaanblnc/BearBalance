import 'package:flutter/material.dart'; // Primarily use Material Design components
import 'package:intl/intl.dart';
import 'package:tfg_ivandelllanoblanco/controllers/ahorroscontrolador.dart';

class NuevoAhorroGastoVista extends StatefulWidget {
  const NuevoAhorroGastoVista({super.key});

  @override
  NuevoAhorroGastoVistaState createState() => NuevoAhorroGastoVistaState();
}

class NuevoAhorroGastoVistaState extends State<NuevoAhorroGastoVista> {
  final AhorrosControlador controlador = AhorrosControlador();
  String _tipo = 'ingreso'; // 'ingreso' o 'gasto'
  double _cantidad = 0.0;
  // String? _categoria; // Eliminado, se usa _categoriaController.text directamente
  DateTime _fechaRegistro = DateTime.now();
  final _formKey = GlobalKey<FormState>(); // Para validación con Material Form
  String? _cantidadErrorText; // Para el error del TextField de cantidad
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8)),
      errorStyle: TextStyle(color: theme.colorScheme.error),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Movimiento'),
        elevation: 0.5, // Sutil elevación
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
                    ButtonSegment<String>(value: 'ingreso', label: Text('Ingreso'), icon: Icon(Icons.arrow_downward)),
                    ButtonSegment<String>(value: 'gasto', label: Text('Gasto'), icon: Icon(Icons.arrow_upward)),
                  ],
                  selected: <String>{_tipo},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _tipo = newSelection.first;
                      // Limpiar categoría si se cambia a ingreso
                      if (_tipo == 'ingreso') {
                        // _categoria = null; // _categoria ya no existe
                        _categoriaController.clear(); // Esto es correcto
                      }
                    });
                  },
                  style: SegmentedButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    selectedForegroundColor: theme.colorScheme.onPrimary,
                    selectedBackgroundColor: theme.colorScheme.primary,
                    // visualDensity: VisualDensity.compact, // Para hacerlo un poco más pequeño
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _cantidadController,
                  decoration: modernInputDecoration.copyWith(
                    labelText: 'Cantidad',
                    errorText: _cantidadErrorText,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                  onChanged: (value) {
                    setState(() {
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                        // El error se mostrará por el validador o por _cantidadErrorText
                      } else {
                        _cantidad = parsed;
                        _cantidadErrorText = null; // Limpiar error si es válido
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
                    _cantidad = parsed; // Actualizar _cantidad aquí también
                    _cantidadErrorText = null;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (_tipo == 'gasto')
                  TextFormField(
                    controller: _categoriaController,
                    decoration: modernInputDecoration.copyWith(labelText: 'Descripción (opcional)'),
                    // onChanged: (value) => _categoria = value, // Eliminado, el valor se toma del controller
                  ),
                if (_tipo == 'gasto') const SizedBox(height: 16),
                TextButton.icon(
                  icon: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                  label: Text(
                    'Fecha: ${DateFormat('dd/MM/yyyy').format(_fechaRegistro.toLocal())}',
                    style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
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
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12.0)),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Guardar'),
                  onPressed: () async {
                    // Actualizar _cantidad una última vez antes de validar
                    final currentCantidadText = _cantidadController.text;
                    final parsedCantidad = double.tryParse(currentCantidadText);
                    if (parsedCantidad != null) {
                      _cantidad = parsedCantidad;
                    } else {
                      _cantidad = 0; // o manejar el error de parseo
                    }

                    if (_formKey.currentState!.validate()) {
                      final String? categoriaParaGuardar = _tipo == 'ingreso' ? null : _categoriaController.text.trim();
                      final ahorro = {
                        'tipo': _tipo,
                        'cantidad': _cantidad,
                        'categoria': categoriaParaGuardar,
                        'fecha_registro': _fechaRegistro.toIso8601String(),
                      };
                      try {
                        await controlador.agregarAhorro(ahorro);
                        if (mounted) Navigator.pop(context, true); // Indicar que se guardó algo
                      } catch (e) {
                        if (mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al guardar: ${e.toString()}'))
                          );
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
  // _validarCantidad ya no es necesario, se usa _formKey.currentState!.validate()
}
