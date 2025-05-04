import 'package:flutter/cupertino.dart';
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
  String? _categoria;
  DateTime _fechaRegistro = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String? _cantidadError;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
            child: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
        middle: const Text('Nuevo Ingreso/Gasto'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CupertinoSlidingSegmentedControl(
                children: const {
                  'ingreso': Text('Ingreso'),
                  'gasto': Text('Gasto'),
                },
                onValueChanged: (value) {
                  setState(() {
                    _tipo = value!;
                  });
                },
                groupValue: _tipo,
              ),
              CupertinoTextField(
                placeholder: 'Cantidad',
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _cantidad = double.tryParse(value) ?? 0.0;
                    _cantidadError = null;
                  });
                },
              ),
              if (_cantidadError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _cantidadError!,
                    style:
                        const TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                ),
              if (_tipo == 'gasto')
                CupertinoTextField(
                  placeholder: 'Categoría (opcional)',
                  onChanged: (value) => _categoria = value,
                ),
              CupertinoButton(
                child: Text(
                    'Fecha: ${DateFormat('dd/MM/yyyy').format(_fechaRegistro)}'),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext builder) {
                      return Container(
                        height: MediaQuery.of(context).copyWith().size.height *
                            0.25,
                        color: CupertinoColors.white,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: _fechaRegistro,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              _fechaRegistro = newDate;
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              CupertinoButton(
                child: const Text('Guardar'),
                onPressed: () async {
                  if (_validarCantidad()) {
                    final ahorro = {
                      'tipo': _tipo,
                      'cantidad': _cantidad,
                      'categoria': _categoria,
                      'fecha_registro': _fechaRegistro.toIso8601String(),
                    };
                    await controlador.agregarAhorro(ahorro);
                    Navigator.pop(context, true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validarCantidad() {
    if (_cantidad == 0.0) {
      setState(() {
        _cantidadError = 'Por favor, ingresa la cantidad';
      });
      return false;
    }
    return true;
  }
}
