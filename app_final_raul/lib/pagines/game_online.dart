import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/planta.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/serveis/plantaService.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:flutter_loggin/pagines/paginaGame/opcionsGame.dart';
import 'package:flutter_loggin/widgets/menu/popupmenubutton.dart';
import 'package:flutter_loggin/widgets/plantaDetall.dart';
import 'package:intl/intl.dart';
import 'package:flutter_loggin/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  final PlantaService _plantaService = PlantaService();
  final List<Planta> _plantes = [];

  @override
  void initState() {
    super.initState();
    _fetchPlantes();
  }

  // Método para cargar las plantas desde el servicio
  Future<void> _fetchPlantes() async {
    try {
      final plantes = await _plantaService.fetchPlantas();
      setState(() {
        _plantes.clear();
        _plantes.addAll(plantes);
      });
    } catch (error) {
      debugPrint('Error al cargar las plantas: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Usuari? usuari =
        ModalRoute.of(context)?.settings.arguments as Usuari?;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'TAMA PLANT',
              style: TextStyle(
                fontFamily: 'RiverAdventurer',
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF00C4B4),
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              // Menu desplegable a l'imatge d'usuari
              widgetPopupMenyButton(
                  usuari: usuari, themeProvider: themeProvider)
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/gor2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children: [
                const OpcionsGame(),
                Expanded(
                  flex: 17,
                  child: _buildPlantesList(usuari),
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFF181A20),
        );
      },
    );
  }

  // Método para crear una planta nueva
  void _crearPlanta(Usuari? usuari) {
    if (usuari == null) {
      debugPrint('Usuari no disponible. No es pot crear una planta.');
      return;
    }

    final List<String> tipusOpcions = [
      'Pantano',
      'Tierra',
      'Fuego',
      'Agua',
      'Aire'
    ];
    final List<String> raritatOpcions = [
      'Comú',
      'Rar',
      'Épic',
      'Llegendari',
      'Únic'
    ];

    final random = Random();
    final String tipus = tipusOpcions[random.nextInt(tipusOpcions.length)];
    final String raritat =
        raritatOpcions[random.nextInt(raritatOpcions.length)];
    final String imatge = 'assets/galeriaPlantes/${random.nextInt(24) + 1}.png';

    final planta = Planta(
      id: 0,
      usuariId: usuari.id,
      nom: 'Nova Planta',
      tipus: tipus,
      nivell: 0,
      atac: 0,
      defensa: 0,
      velocitat: 0,
      habilitatEspecial: 'No disponible',
      energia: 100,
      estat: 'Nou',
      raritat: raritat,
      ultimaActualitzacio: DateTime.now(),
      imatge: imatge,
    );

    _plantaService.addPlanta(planta).then((newPlanta) {
      setState(() {
        _plantes.add(newPlanta);
      });
    }).catchError((error) {
      debugPrint('Error al crear la planta: $error');
    });
  }

  // Construir la lista de plantas
  Widget _buildPlantesList(Usuari? usuari) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            ..._plantes
                .where((planta) => planta.usuariId == usuari?.id)
                .map((planta) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Plantadetall(planta: planta),
                    ),
                  );
                },
                child: _buildPlantaCard(planta),
              );
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _crearPlanta(usuari),
              child: const Text('Crear Planta'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Construir un card para la planta
  Widget _buildPlantaCard(Planta planta) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double size = constraints.maxWidth * 0.8;
        return Container(
          height: size * 1.05,
          width: size,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(size * 0.2),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Image.asset(
                  planta.imatge.isNotEmpty
                      ? planta.imatge
                      : 'assets/default.png',
                  height: size * 0.5,
                ),
              ),
              Text(
                'Tipus: ${planta.tipus}\nRareza: ${planta.raritat}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('Regar planta: ${planta.nom}');
                  },
                  child: const Text('Regar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Obtener el avatar del usuario
  Widget _getUserAvatar(Usuari? usuari) {
    if (usuari?.imatgePerfil != null && usuari!.imatgePerfil.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: usuari.imatgePerfil.startsWith('http')
            ? NetworkImage(usuari.imatgePerfil)
            : FileImage(File(usuari.imatgePerfil)) as ImageProvider,
        onBackgroundImageError: (_, __) {
          debugPrint('Error cargant l\'imatge.');
        },
      );
    }
    return const CircleAvatar(
      backgroundImage: AssetImage('assets/exempleDefault.jpg'),
    );
  }

  // Manejar las opciones del menú
  void _handleMenuOption(int value, BuildContext context, Usuari? usuari,
      ThemeProvider themeProvider) {
    switch (value) {
      case 0:
        if (usuari != null) Rutes.navegarPerfilUsuari(context, usuari);
        break;
      case 1:
        if (usuari != null) Rutes.navegarGame(context, usuari);
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        break;
      case 3:
        themeProvider.toggleTheme();
        break;
    }
  }
}
