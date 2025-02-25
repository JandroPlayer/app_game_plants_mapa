// `DetailRowWidget` és un widget personalitzat per mostrar etiquetes i valors de manera alineada en una fila. Admet un color dinàmic per als valors de tipus percentatge, que canvia de verd o vermell segons si el percentatge és positiu o negatiu.

import 'package:flutter/material.dart';

class DetailRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isPercentage;

  const DetailRowWidget({
    Key? key,
    required this.label,
    required this.value,
    this.isPercentage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Logica per a colors dinamics
    final double? percentageChange =
        isPercentage ? double.tryParse(value.replaceAll('%', '').trim()) : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF00C4B4), fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            color: isPercentage
                ? (percentageChange != null
                    ? (percentageChange > 0 ? Colors.green : Colors.red)
                    : Colors.white)
                : Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
