import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/provider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:flutter_loggin/widgets/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loggin extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController correuController = TextEditingController();
  final TextEditingController contrasenyaController = TextEditingController();

  Future<User?> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error en Google Sign-In: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final providerUsuaris =
        Provider.of<UsuarisProvider>(context, listen: false);
    final double screenHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/letreroMadera.webp', height: 80),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 105, 198, 130),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(70.0),
              child: Text(
                'Inicia sessió',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontFamily: 'RiverAdventurer',
                  fontSize: screenWidth * 0.10,
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.15,
              width: screenWidth * 0.85,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/planta1.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
              child: TextField(
                controller: correuController,
                style: TextStyle(color: themeProvider.textColor),
                decoration: InputDecoration(
                  labelText: 'Correu',
                  labelStyle: TextStyle(color: themeProvider.textColor),
                  hintText: 'Introdueix el teu correu',
                  hintStyle: TextStyle(color: themeProvider.textColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: contrasenyaController,
                style: TextStyle(color: themeProvider.textColor),
                decoration: InputDecoration(
                  labelText: 'Contrasenya',
                  labelStyle: TextStyle(color: themeProvider.textColor),
                  hintText: 'Introdueix la contrasenya',
                  hintStyle: TextStyle(color: themeProvider.textColor),
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: ElevatedButton(
                onPressed: () async {
                  String correu = correuController.text;
                  String contrasenya = contrasenyaController.text;
                  String? token =
                      await providerUsuaris.login(correu, contrasenya);
                  Usuari? usuariEncontrado =
                      await providerUsuaris.buscarUsuariPerCorreu(correu);
                  // se puede borrar era para comprobar que tenia errores ya solucionados
                  // print(token);
                  // print(usuariEncontrado);
                  // SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // String? tokenpreferen = prefs.getString('firebase_token');
                  // print(tokenpreferen);

                  if (token != null && usuariEncontrado != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Benvingut, ${correu}!')),
                    );
                    Rutes.navegarHome(context, usuariEncontrado);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Correu o contrasenya incorrectes.')),
                    );
                  }
                },
                child: const Text('Accedir'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = await _signInWithGoogle(context);
                if (user != null) {
                  final usuarisProvider =
                      Provider.of<UsuarisProvider>(context, listen: false);
                  await usuarisProvider.fetchUsuaris();
                  int nouId = (usuarisProvider.usuaris.isNotEmpty)
                      ? usuarisProvider.usuaris
                              .map((u) => u.id)
                              .reduce((a, b) => a > b ? a : b) +
                          1
                      : 1;

                  Usuari nouUsuari = Usuari(
                      id: nouId,
                      nom: user.displayName ?? '',
                      correu: user.email ?? '',
                      contrasenya: '',
                      edat: 0,
                      nacionalitat: '',
                      codiPostal: '',
                      imatgePerfil: user.photoURL ?? '',
                      btc: 0);

                  try {
                    await usuarisProvider.addUsuari(nouUsuari);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Benvingut, ${user.displayName}!')),
                    );
                    Rutes.navegarHome(context, nouUsuari);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear l\'usuari')),
                    );
                  }
                }
              },
              child: const Text('Iniciar sessió amb Google'),
            ),
          ],
        ),
      ),
      backgroundColor: themeProvider.backgroundColor,
    );
  }
}
