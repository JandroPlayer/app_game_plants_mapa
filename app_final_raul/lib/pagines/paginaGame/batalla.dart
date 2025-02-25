import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_loggin/rutes/rutes.dart';

class Batalla extends StatelessWidget {
  const Batalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: OrientationBuilder(
        builder: (context, orientation) {
          // Separa las imágenes solo en modo vertical
          double leftPosition =
              orientation == Orientation.portrait ? -20.0 : 50.0;
          double rightPosition =
              orientation == Orientation.portrait ? -20.0 : 50.0;

          return Stack(
            children: [
              // Fondo de la batalla
              Image.asset(
                'assets/fondoBatalla.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),

              // Barra de botones en la parte superior
              Positioned(
                top: 20, // Pegados arriba
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(context, 'LUCHAR', Colors.red),
                      _actionButton(context, 'MOCHILA', Colors.orange),
                      _actionButton(context, 'PLANTA', Colors.green),
                      _actionButton(context, 'HUIR', Colors.blue),
                    ],
                  ),
                ),
              ),

              // Pokémon en la parte inferior, más grandes
              Positioned(
                bottom: 30,
                left: leftPosition, // Se ajusta en vertical
                child: Image.asset(
                  'assets/galeriaPlantes/9.png',
                  width: 250, // Más grande
                ),
              ),
              Positioned(
                bottom: 20,
                right: rightPosition, // Se ajusta en vertical
                child: Image.asset(
                  'assets/galeriaPlantes/1.png',
                  width: 250, // Más grande
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _actionButton(BuildContext context, String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: () {
        if (text == 'HUIR') {
          Navigator.pop(context);
        } else {
          _showOptionsDialog(
              context, text); // Mostrar opciones para Luchar, Mochila, Planta
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Función para mostrar las 4 opciones cuando se presiona Luchar, Mochila, o Planta
  void _showOptionsDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecciona una acción de $action'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogOption(context, 'Opción 1', action),
              _dialogOption(context, 'Opción 2', action),
              _dialogOption(context, 'Opción 3', action),
              _dialogOption(context, 'Opción 4', action),
            ],
          ),
        );
      },
    );
  }

  // Opción individual dentro del diálogo
  Widget _dialogOption(BuildContext context, String option, String action) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      onPressed: () {
        Navigator.pop(context); // Cierra el diálogo
        _executeAction(context, option, action);
      },
      child: Text(
        option,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Lógica para manejar la acción seleccionada
  void _executeAction(BuildContext context, String option, String action) {
    // Aquí puedes agregar lo que quieres hacer según la acción y opción seleccionada
    print('Acción: $action,  $option');

    // Por ejemplo, puedes navegar a diferentes páginas o hacer alguna acción
    if (action == 'LUCHAR') {
      // Acción para Luchar
    } else if (action == 'MOCHILA') {
      // Acción para Mochila
    } else if (action == 'PLANTA') {
      // Acción para Planta
    }
  }
}
