import 'package:flutter/material.dart';
import 'package:flutter_loggin/provider/items_provider.dart';
import 'package:flutter_loggin/provider/provider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting(
      'ca', null); // Inicialitza la configuració per català
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarisProvider()),
        ChangeNotifierProvider(create: (_) => CryptoProvider()),
        ChangeNotifierProvider(create: (_) => PlantaProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ItemsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registre',
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: themeProvider.backgroundColor,
      ),
      initialRoute: Rutes.paginaPrincipal,
      routes: Rutes.obtenerRutas(),
    );
  }
}
