import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tfg_ivandelllanoblanco/controllers/metascontrollador.dart';

class DialogoMetas extends StatefulWidget {
  final MetasControlador controlador;
  final Function() onMetaGuardada;
  final Map<String, dynamic>? meta;

  const DialogoMetas({
    super.key,
    required this.controlador,
    required this.onMetaGuardada,
    this.meta,
  });

  @override
  State<DialogoMetas> createState() => _CrearModificarMetaDialogState();
}

class _CrearModificarMetaDialogState extends State<DialogoMetas> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _cantidadAhorradaController = TextEditingController();
  final _cantidadObjetivoController = TextEditingController();
  final _fechaLimiteController = TextEditingController();

  String? _tituloError;
  String? _cantidadAhorradaError;
  String? _cantidadObjetivoError;
  String? _fechaLimiteError;

  DateTime _fechaLimite = DateTime.now();

  @override
  void initState() {
    super.initState();
    final hoy = DateTime.now();
    final manana = DateTime(hoy.year, hoy.month, hoy.day + 1);

    if (widget.meta != null) {
      _tituloController.text = widget.meta!['titulo'] ?? '';
      _cantidadAhorradaController.text =
          widget.meta!['cantidad_ahorrada']?.toString() ?? '0.0';
      _cantidadObjetivoController.text =
          widget.meta!['cantidad_objetivo']?.toString() ?? '0.0';
      if (widget.meta!['fecha_limite'] != null &&
          widget.meta!['fecha_limite'].isNotEmpty) {
        _fechaLimite = DateTime.parse(widget.meta!['fecha_limite']);
        if (_fechaLimite.isBefore(manana)) {
          _fechaLimite = manana;
        }
        _fechaLimiteController.text =
            DateFormat('yyyy-MM-dd').format(_fechaLimite);
      } else {
        _fechaLimite = manana;
        _fechaLimiteController.text =
            DateFormat('yyyy-MM-dd').format(_fechaLimite);
      }
    } else {
      _fechaLimite = manana;
      _fechaLimiteController.text =
          DateFormat('yyyy-MM-dd').format(_fechaLimite);
    }
  }

  Future<void> _mostrarSelectorFecha(BuildContext context) async {
    final hoy = DateTime.now();
    final manana = DateTime(hoy.year, hoy.month, hoy.day + 1);

    DateTime pickerInitialDate = _fechaLimite;
    if (pickerInitialDate.isBefore(manana)) {
      pickerInitialDate = manana;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickerInitialDate,
      firstDate: manana,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fechaLimite) {
      setState(() {
        _fechaLimite = picked;
        _fechaLimiteController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _validarCampos() {
    setState(() {
      _tituloError = _validarTitulo(_tituloController.text);
      _cantidadAhorradaError =
          _validarCantidad(_cantidadAhorradaController.text);
      _cantidadObjetivoError =
          _validarCantidad(_cantidadObjetivoController.text);
      _fechaLimiteError = _validarFecha(_fechaLimiteController.text);
    });
  }

  String? _validarTitulo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "El nombre de la meta no puede estar vacío.";
    }
    return null;
  }

  String? _validarCantidad(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Este campo no puede estar vacío.";
    }
    final cantidad = double.tryParse(value);
    if (cantidad == null || cantidad < 0) {
      return "Debe ser un número positivo.";
    }
    return null;
  }

  String? _validarFecha(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "La fecha no puede estar vacía.";
    }
    DateTime fechaSeleccionada;
    try {
      fechaSeleccionada = DateFormat('yyyy-MM-dd').parseStrict(value);
    } catch (e) {
      return 'Formato de fecha inválido (YYYY-MM-DD).';
    }

    final hoy = DateTime.now();
    final hoyNormalizado = DateTime(hoy.year, hoy.month, hoy.day);

    if (!fechaSeleccionada.isAfter(hoyNormalizado)) {
      return "La fecha debe ser posterior al día de hoy.";
    }

    return null;
  }

  Future<void> _guardarMeta() async {
    _validarCampos();

    if (_tituloError == null &&
        _cantidadAhorradaError == null &&
        _cantidadObjetivoError == null &&
        _fechaLimiteError == null) {
      final titulo = _tituloController.text;
      final cantidadAhorrada = double.parse(_cantidadAhorradaController.text);
      final cantidadObjetivo = double.parse(_cantidadObjetivoController.text);
      final fechaLimite = _fechaLimiteController.text;

      if (cantidadAhorrada > cantidadObjetivo) {
        setState(() {
          _cantidadAhorradaError =
              "La cantidad ahorrada no puede ser mayor que la cantidad objetivo.";
        });
        return;
      }

      if (widget.meta == null) {
        await widget.controlador.agregarMeta(
          titulo,
          cantidadAhorrada,
          cantidadObjetivo,
          fechaLimite,
          widget.onMetaGuardada,
        );
      } else {
        await widget.controlador.actualizarMeta(
          widget.meta!['id'],
          titulo,
          cantidadAhorrada,
          cantidadObjetivo,
          fechaLimite,
          widget.onMetaGuardada,
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    InputDecoration inputDecoration(String label, String? errorText) {
      return InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: colorScheme.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: colorScheme.error, width: 2.0),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
      );
    }

    return AlertDialog(
      title: Text(widget.meta == null ? 'Crear Nueva Meta' : 'Modificar Meta'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: inputDecoration('Nombre de la meta', _tituloError),
                validator: _validarTitulo,
                onChanged: (value) => setState(() => _tituloError = null),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadAhorradaController,
                decoration: inputDecoration(
                    'Cantidad ahorrada (€)', _cantidadAhorradaError),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: _validarCantidad,
                onChanged: (value) =>
                    setState(() => _cantidadAhorradaError = null),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadObjetivoController,
                decoration: inputDecoration(
                    'Cantidad objetivo (€)', _cantidadObjetivoError),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: _validarCantidad,
                onChanged: (value) =>
                    setState(() => _cantidadObjetivoError = null),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaLimiteController,
                decoration: inputDecoration(
                    'Fecha Límite (YYYY-MM-DD)', _fechaLimiteError),
                readOnly: true,
                onTap: () => _mostrarSelectorFecha(context),
                validator: _validarFecha,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          onPressed: _guardarMeta,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('Guardar'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: colorScheme.surfaceContainerLowest,
    );
  }
}
