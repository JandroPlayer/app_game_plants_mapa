import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/planta.dart';
import 'package:flutter_loggin/widgets/detail_row_widget.dart';

class Plantadetall extends StatelessWidget {
  final Planta planta;

  const Plantadetall({Key? key, required this.planta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 88, 88, 88), // Fondo gris
      appBar: AppBar(
        title: Text(
          planta.nom,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF00C4B4),
      ),
      body: SingleChildScrollView(
        // Ajustar para evitar problemas de diseño fijo
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Center(
              child: Image.asset(
                planta.imatge.isNotEmpty ? planta.imatge : 'assets/default.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 70),

            // Barras de progreso con valores
            _buildProgressBar('Nivell', planta.nivell.toDouble(), Colors.blue),
            _buildProgressBar('Atac', planta.atac.toDouble(), Colors.red),
            _buildProgressBar(
                'Defensa', planta.defensa.toDouble(), Colors.green),
            _buildProgressBar(
                'Velocitat', planta.velocitat.toDouble(), Colors.orange),
            _buildProgressBar(
                'Energia', planta.energia.toDouble(), Colors.green),

            const SizedBox(height: 20),

            // Información detallada
            _buildDetailRow('Tipus', planta.tipus),
            _buildDetailRow('Rareza', planta.raritat),
            _buildDetailRow('Estat', planta.estat),
            _buildDetailRow(
                'Última Actualització', planta.ultimaActualitzacio.toString()),
            const SizedBox(height: 20),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => printMessage('Ataque'),
                    icon: const Icon(Icons.flash_on,
                        color: Colors.black), // Icono negro
                    label: const Text(''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00C4B4), // Color de fondo
                      side: BorderSide(
                          color: Colors.green, width: 3), // Borde verde
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => printMessage('Defensa'),
                    icon: const Icon(Icons.shield,
                        color: Colors.black), // Icono negro
                    label: const Text(''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00C4B4), // Color de fondo
                      side: BorderSide(
                          color: Colors.green, width: 3), // Borde verde
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => printMessage('Subir nivel'),
                    icon: const Icon(Icons.arrow_upward,
                        color: Colors.black), // Icono negro
                    label: const Text(''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00C4B4), // Color de fondo
                      side: BorderSide(
                          color: Colors.green, width: 3), // Borde verde
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => printMessage('Evolucionar'),
                    icon: const Icon(Icons.autorenew,
                        color: Colors.black), // Icono negro
                    label: const Text(''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00C4B4), // Color de fondo
                      side: BorderSide(
                          color: Colors.green, width: 3), // Borde verde
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void printMessage(String message) {
    print('Has pulsado: $message');
  }

  Widget _buildProgressBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailRowWidget(label: label, value: '${value.toDouble()}'),
        LinearProgressIndicator(
          value: value / 100.0, // Asume que los valores están entre 0 y 100
          backgroundColor: Colors.grey[600],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: DetailRowWidget(label: label, value: value),
    );
  }
}
