import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/theme_provider.dart';
import 'package:flutter_loggin/provider/usuarisProvider.dart';
import 'package:provider/provider.dart';

class EditarPerfil extends StatefulWidget {
  final Usuari usuari;
  final Function(Usuari) onSave;

  const EditarPerfil({super.key, required this.usuari, required this.onSave});

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  late TextEditingController _nomController;
  late TextEditingController _edatController;

  @override
  void initState() {
    super.initState();
    // Inicialitzar els controllers amb els valors del widget.usuari
    _nomController = TextEditingController(text: widget.usuari.nom);
    _edatController =
        TextEditingController(text: widget.usuari.edat.toString());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final usuarisProvider =
        Provider.of<UsuarisProvider>(context, listen: false);

    final Color textColor =
        themeProvider.isDarkMode ? Colors.white : Colors.black;
    final Color backgroundColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Perfil',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            color: textColor,
            onPressed: () async {
              final Usuari usuariActualitzat = Usuari(
                id: widget.usuari.id,
                nom: _nomController.text.isNotEmpty
                    ? _nomController.text
                    : widget.usuari.nom,
                correu: widget.usuari.correu,
                contrasenya: widget.usuari.contrasenya,
                edat: int.tryParse(_edatController.text) ?? widget.usuari.edat,
                nacionalitat: widget.usuari.nacionalitat,
                codiPostal: widget.usuari.codiPostal,
                imatgePerfil: widget.usuari.imatgePerfil,
                btc: widget.usuari.btc,
              );

              try {
                // Actualitzar el usuari utilitzant el provider
                await usuarisProvider.updateUsuari(
                    widget.usuari.id, usuariActualitzat);
                widget.onSave(usuariActualitzat);
                Navigator.pop(context);
                //                Rutes.navegarPerfilUsuari(context, usuariActualitzat);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al actualitzar: $e')),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: InputDecoration(
                labelText: 'Nom',
                labelStyle: TextStyle(color: textColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _edatController,
              decoration: InputDecoration(
                labelText: 'Edat',
                labelStyle: TextStyle(color: textColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Descartar els controllers quan es disposi del widget
    _nomController.dispose();
    _edatController.dispose();
    super.dispose();
  }
}
