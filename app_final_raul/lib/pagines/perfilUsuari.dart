import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/usuarisProvider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:flutter_loggin/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'editar_perfil.dart';

class PerfilUsuari extends StatefulWidget {
  const PerfilUsuari({super.key});

  @override
  _PerfilUsuariState createState() => _PerfilUsuariState();
}

class _PerfilUsuariState extends State<PerfilUsuari> {
  late Usuari? usuari;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usuari = ModalRoute.of(context)?.settings.arguments as Usuari?;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final usuarisProvider = Provider.of<UsuarisProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil d\'Usuari',
          style: TextStyle(color: Colors.black, fontFamily: 'RiverAdventurer'),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00C4B4),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (usuari != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditarPerfil(
                      usuari: usuari!,
                      onSave: (updatedUsuari) async {
                        await usuarisProvider.updateUsuari(
                            usuari!.id, updatedUsuari);
                        setState(() {
                          usuari = updatedUsuari;
                        });
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        color: themeProvider.isDarkMode ? Colors.black : Colors.white,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: CircleAvatar(
                  radius: 140,
                  backgroundImage: usuari?.imatgePerfil != null &&
                          usuari!.imatgePerfil.isNotEmpty
                      ? (usuari!.imatgePerfil.startsWith('http')
                          ? NetworkImage(usuari!.imatgePerfil)
                          : FileImage(File(usuari!.imatgePerfil))
                              as ImageProvider)
                      : const AssetImage('assets/exempleDefault.jpg'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text('Id: ${usuari?.id ?? 'Desconocido'}',
                    style: TextStyle(
                        fontSize: 18,
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black)),
              ),
              Text('Nom: ${usuari?.nom ?? 'Desconocido'}',
                  style: TextStyle(
                      fontSize: 18,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black)),
              Text(
                'Correu: ${usuari?.correu ?? 'Desconocido'}',
                style: TextStyle(
                    fontSize: 18,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                'Edat: ${usuari?.edat ?? 'Desconocida'}',
                style: TextStyle(
                  fontSize: 18,
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
