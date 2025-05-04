import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    if (widget.meta != null) {
      _tituloController.text = widget.meta!['titulo'] ?? '';
      _cantidadAhorradaController.text =
          widget.meta!['cantidad_ahorrada']?.toString() ?? '0.0';
      _cantidadObjetivoController.text =
          widget.meta!['cantidad_objetivo']?.toString() ?? '0.0';
      if (widget.meta!['fecha_limite'] != null &&
          widget.meta!['fecha_limite'].isNotEmpty) {
        _fechaLimite = DateTime.parse(widget.meta!['fecha_limite']);
        _fechaLimiteController.text = widget.meta!['fecha_limite'];
      } else {
        _fechaLimiteController.text =
            "${_fechaLimite.year}-${_fechaLimite.month.toString().padLeft(2, '0')}-${_fechaLimite.day.toString().padLeft(2, '0')}";
      }
    } else {
      _fechaLimiteController.text =
          "${_fechaLimite.year}-${_fechaLimite.month.toString().padLeft(2, '0')}-${_fechaLimite.day.toString().padLeft(2, '0')}";
    }
  }

  void _mostrarSelectorFecha(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.25,
          color: CupertinoColors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _fechaLimite,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _fechaLimite = newDate;
                _fechaLimiteController.text =
                    "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
              });
            },
          ),
        );
      },
    );
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

  String? _validarTitulo(String value) {
    if (value.trim().isEmpty) {
      return "El nombre de la meta no puede estar vacío.";
    }
    return null;
  }

  String? _validarCantidad(String value) {
    if (value.trim().isEmpty) {
      return "Este campo no puede estar vacío.";
    }
    final cantidad = double.tryParse(value);
    if (cantidad == null || cantidad < 0) {
      return "Debe ser un número positivo.";
    }
    return null;
  }

  String? _validarFecha(String value) {
    if (value.trim().isEmpty) {
      return "La fecha límite no puede estar vacía.";
    }
    try {
      final fechaLimiteDate = DateTime.parse(value);
      if (fechaLimiteDate.isBefore(DateTime.now())) {
        return "La fecha límite no puede ser anterior al día de hoy.";
      }
    } catch (e) {
      return "Formato de fecha inválido (AAAA-MM-DD).";
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
    return CupertinoAlertDialog(
      title: Text(widget.meta == null ? 'Crear Nueva Meta' : 'Modificar Meta'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoTextField(
              controller: _tituloController,
              placeholder: 'Nombre de la meta',
              onChanged: (value) => setState(() => _tituloError = null),
            ),
            if (_tituloError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(_tituloError!,
                    style:
                        const TextStyle(color: CupertinoColors.destructiveRed)),
              ),
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: _cantidadAhorradaController,
              placeholder: 'Cantidad ahorrada',
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: false),
              onChanged: (value) =>
                  setState(() => _cantidadAhorradaError = null),
            ),
            if (_cantidadAhorradaError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(_cantidadAhorradaError!,
                    style:
                        const TextStyle(color: CupertinoColors.destructiveRed)),
              ),
            const SizedBox(height: 10),
            CupertinoTextField(
              controller: _cantidadObjetivoController,
              placeholder: 'Cantidad objetivo',
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: false),
              onChanged: (value) =>
                  setState(() => _cantidadObjetivoError = null),
            ),
            if (_cantidadObjetivoError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(_cantidadObjetivoError!,
                    style:
                        const TextStyle(color: CupertinoColors.destructiveRed)),
              ),
            const SizedBox(height: 10),
            CupertinoButton(
              child: Text(
                _fechaLimiteController.text.isEmpty
                    ? 'Seleccionar Fecha Límite'
                    : 'Fecha Límite: ${_fechaLimiteController.text}',
              ),
              onPressed: () => _mostrarSelectorFecha(context),
            ),
            if (_fechaLimiteError != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(_fechaLimiteError!,
                    style:
                        const TextStyle(color: CupertinoColors.destructiveRed)),
              ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          onPressed: _guardarMeta,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
