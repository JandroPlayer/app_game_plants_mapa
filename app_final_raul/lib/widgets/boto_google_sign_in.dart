import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/provider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:google_sign_in/google_sign_in.dart';

class BotoGoogleSigIn extends StatelessWidget {
  const BotoGoogleSigIn({
    super.key,
    required this.themeProvider,
    required GoogleSignIn googleSignIn,
    required this.providerUsuaris,
  }) : _googleSignIn = googleSignIn;

  final ThemeProvider themeProvider;
  final GoogleSignIn _googleSignIn;
  final UsuarisProvider providerUsuaris;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton.icon(
        icon: Image.asset(
          'assets/google_icon.png',
          height: 24,
          width: 24,
        ),
        label: const Text(
          'Accedir amb Google',
          style: TextStyle(fontFamily: 'RiverAdventurer'),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.backgroundColor, // Fondo dinámico
          foregroundColor: themeProvider.textColor, // Color de texto dinámico
        ),
        onPressed: () async {
          try {
            // Inicia la sessió amb Google
            final GoogleSignInAccount? account = await _googleSignIn.signIn();

            if (account != null) {
              // Obté informació bàsica de l'usuari de Google
              final String email = account.email;
              final String nom = account.displayName ?? "Creat per Google";

              // Comprova si l'usuari ja existeix
              Usuari? usuariExist =
                  await providerUsuaris.buscarUsuariPerCorreu(email);

              if (usuariExist == null) {
                // Si no existeix, crea un nou usuari amb informació predeterminada
                Usuari nouUsuari = Usuari(
                    id: DateTime.now()
                        .millisecondsSinceEpoch, // Genera un ID únic
                    nom: nom,
                    correu: email,
                    contrasenya:
                        "", // No hi ha contrasenya per a usuaris de Google
                    edat: 0, // Valors predeterminats
                    nacionalitat: "Desconeguda",
                    codiPostal: "00000",
                    imatgePerfil: account.photoUrl ?? "",
                    btc: 0);

                await providerUsuaris.addUsuari(nouUsuari);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Nou usuari creat: $nom!',
                    style: TextStyle(fontFamily: 'RiverAdventurer'),
                  ),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Benvingut de nou, ${usuariExist.nom}!',
                    style: TextStyle(fontFamily: 'RiverAdventurer'),
                  ),
                ));
              }

              // Navega a la pàgina principal
              var nouUsuari;
              Rutes.navegarHome(context, usuariExist ?? nouUsuari);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'Accés cancel·lat.',
                  style: TextStyle(fontFamily: 'RiverAdventurer'),
                ),
              ));
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Error en iniciar sessió amb Google: $e',
                style: TextStyle(fontFamily: 'RiverAdventurer'),
              ),
            ));
          }
        },
      ),
    );
  }
}
