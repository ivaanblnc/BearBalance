import 'package:flutter/material.dart';

class SaldoResumen extends StatelessWidget {
  const SaldoResumen({
    super.key,
    required this.saldoActual,
    required this.totalIngresos,
    required this.totalGastos,
  });

  final double saldoActual;
  final double totalIngresos;
  final double totalGastos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSaldoText(
                    "Saldo total: ${saldoActual.toStringAsFixed(2)} €",
                    Colors.indigoAccent),
                _buildSaldoText(
                    "Ingresos: ${totalIngresos.toStringAsFixed(2)} €",
                    Colors.green),
                _buildSaldoText(
                    "Gastos: ${totalGastos.toStringAsFixed(2)} €", Colors.red),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildSaldoText(String text, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
