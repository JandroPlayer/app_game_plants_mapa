import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/theme_provider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';

class widgetPopupMenyButton extends StatelessWidget {
  const widgetPopupMenyButton({
    super.key,
    required this.usuari,
    required this.themeProvider,
  });

  final Usuari? usuari;
  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: usuari?.imatgePerfil != null && usuari!.imatgePerfil.isNotEmpty
          ? CircleAvatar(
              backgroundImage: usuari!.imatgePerfil.startsWith('http')
                  ? NetworkImage(usuari!.imatgePerfil)
                  : FileImage(File(usuari!.imatgePerfil)) as ImageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                print('Error cargando la imagen: $exception');
              },
            )
          : const CircleAvatar(
              backgroundImage: AssetImage('assets/exempleDefault.jpg'),
            ),
      onSelected: (int selectedValue) {
        if (selectedValue == 0) {
          Rutes.navegarPerfilUsuari(context, usuari!);
        } else if (selectedValue == 1) {
          Rutes.navegarShop(context, usuari!);
        } else if (selectedValue == 2) {
          Rutes.navegarGame(context, usuari!);
        } else if (selectedValue == 3) {
          themeProvider.toggleTheme();
        } else if (selectedValue == 4) {
          Rutes.navegarMapa(context, usuari!);
        } else if (selectedValue == 5) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 0,
          child: Text('Perfil'),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text('Tenda'),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text('Inventari'),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: Text(
            themeProvider.isDarkMode ? 'Mode dia' : 'Mode nit',
          ),
        ),
        const PopupMenuItem<int>(
          value: 4,
          child: Text('Mapa'),
        ),
        const PopupMenuItem<int>(
          value: 5,
          child: Text('Tancar sessió'),
        ),
      ],
    );
  }
}
