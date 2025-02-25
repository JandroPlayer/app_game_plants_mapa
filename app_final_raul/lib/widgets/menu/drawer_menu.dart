import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/theme_provider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';

class DrawerMenu extends StatefulWidget {
  final Usuari? usuari;
  final ThemeProvider themeProvider;

  const DrawerMenu({super.key, required this.usuari, required this.themeProvider});

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool _isVisible = false;

  void _toggleDrawer() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _isVisible ? _toggleDrawer : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _isVisible ? 0.3 : 1.0,
            child: IgnorePointer(
              ignoring: _isVisible,
              child: CircleAvatar(
                backgroundImage: widget.usuari?.imatgePerfil != null && widget.usuari!.imatgePerfil.isNotEmpty
                    ? (widget.usuari!.imatgePerfil.startsWith('http')
                        ? NetworkImage(widget.usuari!.imatgePerfil)
                        : FileImage(File(widget.usuari!.imatgePerfil))) as ImageProvider
                    : const AssetImage('assets/exempleDefault.jpg'),
                child: InkWell(
                  onTap: _toggleDrawer,
                ),
              ),
            ),
          ),
        ),
        if (_isVisible)
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: Material(
              color: Colors.black.withOpacity(0.6),
              child: Container(
                width: 250,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Perfil'),
                      onTap: () => Rutes.navegarPerfilUsuari(context, widget.usuari!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.store),
                      title: const Text('Tenda'),
                      onTap: () => Rutes.navegarShop(context, widget.usuari!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.inventory),
                      title: const Text('Inventari'),
                      onTap: () => Rutes.navegarGame(context, widget.usuari!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.wb_sunny),
                      title: Text(widget.themeProvider.isDarkMode ? 'Mode dia' : 'Mode nit'),
                      onTap: () {
                        widget.themeProvider.toggleTheme();
                        _toggleDrawer();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Tancar sessió'),
                      onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}