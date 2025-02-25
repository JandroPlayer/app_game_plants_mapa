import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/provider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:flutter_loggin/widgets/menu/drawer_menu.dart';
import 'package:flutter_loggin/widgets/menu/popupmenubutton.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario de los argumentos
    final Usuari? usuari =
        ModalRoute.of(context)?.settings.arguments as Usuari?;
    //final provider = Provider.of<CryptoProvider>(context);
    final usuarisProvider = Provider.of<UsuarisProvider>(context);

    // Acceso directo al ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black, fontFamily: 'RiverAdventurer'),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00C4B4),
        actions: [
          widgetPopupMenyButton(usuari: usuari, themeProvider: themeProvider)
        ],
      ),
      body: Column(
        children: [
          // Slider de imágenes (10% del espacio)
          SizedBox(
            height: 80, // Altura reducida para no ocupar mucho espacio
            child: _ImageSlider(),
          ),

          // Lista de usuarios (70%)
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: _TopUsersList(usuarisProvider: usuarisProvider),
            ),
          ),

          // Botones (20%)
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (usuari != null)
                  _buildButtonIndividual(
                      context, 'Individual', Icons.gamepad, usuari),
                _buildButtonOnline(context, 'Online', Icons.online_prediction),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: themeProvider.backgroundColor,
    );
  }

  // Widget para construir botones
  Widget _buildButtonIndividual(
      BuildContext context, String text, IconData icon, Usuari usuari) {
    return ElevatedButton.icon(
      onPressed: () {
        Rutes.naveegarGameTEST(context, usuari!);
      },
      icon: Icon(icon, size: 24),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

Widget _buildButtonOnline(BuildContext context, String text, IconData icon) {
  return ElevatedButton.icon(
    onPressed: () {
      Navigator.pushNamed(context, Rutes.batalla);
    },
    icon: Icon(icon, size: 24),
    label: Text(text),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

// Widget del Slider Automático
class _ImageSlider extends StatelessWidget {
  final List<String> imagePaths = [
    for (int i = 1; i <= 28; i++) 'assets/galeriaPlantes/$i.png'
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 70,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.4, // Ajuste para tamaño reducido
      ),
      items: imagePaths.map((path) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            path,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }
}

class _TopUsersList extends StatelessWidget {
  final UsuarisProvider usuarisProvider;

  const _TopUsersList({super.key, required this.usuarisProvider});

  @override
  Widget build(BuildContext context) {
    final topUsers = List<Usuari>.from(usuarisProvider.usuaris)
      ..sort((a, b) => (b.btc ?? 0).compareTo(a.btc ?? 0));
    final top20Users = topUsers.take(20).toList();

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Top 20 Usuarios con más BTC',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Column(
            children: top20Users.map((user) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: (() {
                    try {
                      if (user.imatgePerfil != null &&
                          File(user.imatgePerfil!).existsSync()) {
                        return FileImage(File(user.imatgePerfil!))
                            as ImageProvider<Object>?;
                      }
                    } catch (e) {
                      print("Error cargando la imagen de perfil: $e");
                    }
                    return const AssetImage('assets/default_avatar.png')
                        as ImageProvider<Object>?;
                  })(),
                ),
                title: Text(
                  user.nom ?? 'Usuario',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '${user.btc?.toStringAsFixed(2) ?? "0.00"} BTC',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
